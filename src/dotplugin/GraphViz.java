/*******************************************************************************
 * Copyright (c) 2007 EclipseGraphviz contributors.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     abstratt technologies
 *     Scott Bronson
 *     Bert Lisser   (bertl@cwi.nl)
 *******************************************************************************/
package dotplugin;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.MultiStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.swt.SWTException;

import dotplugin.editors.LogUtils;
import dotplugin.editors.ProcessController;
import dotplugin.editors.SvgBrowser;

/**
 * The entry point to the Graphviz support API.
 */
public class GraphViz {
	private static final String DOT_EXTENSION = ".dot"; //$NON-NLS-1$
	private static final String TMP_FILE_PREFIX = "graphviz"; //$NON-NLS-1$
	

	private static File execute(final InputStream input, String format)
			throws CoreException {
		MultiStatus status = new MultiStatus(Activator.ID, 0,
				"Errors occurred while running Graphviz", null);
		// we keep the input in memory so we can include it in error messages
		ByteArrayOutputStream dotContents = new ByteArrayOutputStream();
		File dotInput = null, dotOutput = null;
		try {
			// determine the temp input and output locations
			dotInput = File.createTempFile(TMP_FILE_PREFIX, DOT_EXTENSION);
			dotOutput = File.createTempFile(TMP_FILE_PREFIX, "." + format);
			dotInput.deleteOnExit();
			dotOutput.deleteOnExit();
			FileOutputStream tmpDotInputStream = null;
			try {

				IOUtils.copy(input, dotContents);
				tmpDotInputStream = new FileOutputStream(dotInput);
				IOUtils.copy(
						new ByteArrayInputStream(dotContents.toByteArray()),
						tmpDotInputStream);
			} finally {

				IOUtils.closeQuietly(tmpDotInputStream);
			}

			IStatus result = runDot(format, dotInput, dotOutput);
			status.add(result);
			// status.add(logInput(dotContents));
			if (!result.isOK())
				LogUtils.log(status);
			return dotOutput;
		} catch (SWTException e) {
			status.add(new Status(IStatus.ERROR, Activator.ID, "", e));
		} catch (IOException e) {
			status.add(new Status(IStatus.ERROR, Activator.ID, "", e));
		}
		throw new CoreException(status);
	}

	public static void createDotFile(final InputStream input, IFile dotOutput) {
		File output = null;
		try {
			output = execute(input, "svg");
			Filter.exec(output, dotOutput);
			LogUtils.logInfo("finished >"+dotOutput.getName(), null);
		} catch (CoreException e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(input);
		}

	}

	public static void browse(final InputStream input, IFile dotOutput) {
		MultiStatus status = new MultiStatus(Activator.ID, 0,
				"Errors occurred while running Graphviz", null);
		try {
			createDotFile(input, dotOutput);
			URL url = dotOutput.getRawLocationURI().toURL();
			SvgBrowser.browse(url);
		} catch (SWTException e) {
			status.add(new Status(IStatus.ERROR, Activator.ID, "", e));
		} catch (MalformedURLException e) {
			e.printStackTrace();
		}
	}

	private static IStatus runDot(String format, File dotInput, File dotOutput) {
		// build the command line
		// double dpi = 96;
		// double widthInInches = -1;
		// double heightInInches = -1;

		List<String> cmd = new ArrayList<String>();
		try {
			cmd.add("-o" + dotOutput.getCanonicalPath());
			cmd.add("-T" + format);
				String commandLineExtension = Pref.getCommandLineExtension();
				// System.err.println("runDot:" + commandLineExtension);
				if (commandLineExtension != null) {
					String[] tokens = commandLineExtension.split(" ");
					cmd.addAll(Arrays.asList(tokens));
				}	
			// System.err.println("runDot:" + dotInput.getAbsolutePath());
			cmd.add(dotInput.getAbsolutePath());
			return runDot(cmd.toArray(new String[cmd.size()]));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}

	@SuppressWarnings("unused")
	private static IStatus logInput(ByteArrayOutputStream dotContents) {
		return new Status(IStatus.INFO, Activator.ID, "dot input was:\n"
				+ dotContents, null);
	}

	/**
	 * Bare bones API for launching dot. Command line options are passed to
	 * Graphviz as specified in the options parameter. The location for dot is
	 * obtained from the user preferences.
	 * 
	 * @param options
	 *            command line options for dot
	 * @return a non-zero integer if errors happened
	 * @throws IOException
	 */
	public static IStatus runDot(String... options) {
		
		// IPath dotFullPath = activator.getDotLocation();
		IPath dotFullPath = Pref.getDotLocation();
		LogUtils.logInfo("Start "+dotFullPath, null);
		if (dotFullPath == null || dotFullPath.isEmpty())
			return new Status(
					IStatus.ERROR,
					Activator.ID,
					"dot.exe/dot not found in PATH. Please install it from graphviz.org, update the PATH or specify the absolute path in the preferences.");
		if (!dotFullPath.toFile().isFile())
			return new Status(IStatus.ERROR, Activator.ID,
					"Could not find Graphviz dot at \"" + dotFullPath + "\"");
		List<String> cmd = new ArrayList<String>();
		cmd.add(dotFullPath.toOSString());
		// insert user custom options
		/*
		String commandLineExtension = Activator.getInstance()
				.getCommandLineExtension();
		if (commandLineExtension != null) {
			String[] tokens = commandLineExtension.split(" ");
			cmd.addAll(Arrays.asList(tokens));
		}
		*/
		cmd.addAll(Arrays.asList(options));
		ByteArrayOutputStream errorOutput = new ByteArrayOutputStream();
		try {
			final ProcessController controller = new ProcessController(60000,
					cmd.toArray(new String[cmd.size()]), null, dotFullPath
							.removeLastSegments(1).toFile());
			controller.forwardErrorOutput(errorOutput);
			controller.forwardOutput(System.out);
			controller.forwardInput(System.in);
			int exitCode = controller.execute();
			if (exitCode != 0)
				return new Status(IStatus.WARNING, Activator.ID,
						"Graphviz exit code: " + exitCode + "."
								+ createContentMessage(errorOutput));
			if (errorOutput.size() > 0)
				return new Status(IStatus.WARNING, Activator.ID,
						createContentMessage(errorOutput));
			return Status.OK_STATUS;
		} catch (ProcessController.TimeOutException e) {
			return new Status(IStatus.ERROR, Activator.ID,
					"Graphviz process did not finish in a timely way."
							+ createContentMessage(errorOutput));
		} catch (InterruptedException e) {
			return new Status(IStatus.ERROR, Activator.ID,
					"Unexpected exception executing Graphviz."
							+ createContentMessage(errorOutput), e);
		} catch (IOException e) {
			return new Status(IStatus.ERROR, Activator.ID,
					"Unexpected exception executing Graphviz."
							+ createContentMessage(errorOutput), e);
		}
	}

	private static String createContentMessage(ByteArrayOutputStream errorOutput) {
		if (errorOutput.size() == 0)
			return "";
		return " dot produced the following error output: \n" + errorOutput;
	}
}

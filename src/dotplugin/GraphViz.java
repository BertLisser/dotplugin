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
import java.net.URI;
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
import org.eclipse.core.runtime.Platform;
import org.eclipse.core.runtime.Status;
import org.eclipse.swt.SWTException;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.graphics.ImageData;
import org.eclipse.swt.graphics.ImageLoader;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.widgets.Display;
import dotplugin.editors.LogUtils;
import dotplugin.editors.ProcessController;
import dotplugin.editors.ProcessController.TimeOutException;
import dotplugin.editors.SvgBrowser;

/**
 * The entry point to the Graphviz support API.
 */
// TODO generate and load have a lot in common, refactor
// TODO we should just pass the input stream directly (or buffered) to Graphviz,
// instead of creating a temporary file
public class GraphViz {
	private static final String DOT_EXTENSION = ".dot"; //$NON-NLS-1$
	private static final String TMP_FILE_PREFIX = "graphviz"; //$NON-NLS-1$

	private static IFile execute(final InputStream input, String format,
			IFile dotOutput) throws CoreException {
		MultiStatus status = new MultiStatus(Activator.ID, 0,
				"Errors occurred while running Graphviz", null);
		// File dotInput = null;
		// we keep the input in memory so we can include it in error messages
		ByteArrayOutputStream dotContents = new ByteArrayOutputStream();
		File dotInput = null;
		try {
			// determine the temp input and output locations
			dotInput = File.createTempFile(TMP_FILE_PREFIX, DOT_EXTENSION);
			// if (dotOutput==null) dotOutput =
			// File.createTempFile(TMP_FILE_PREFIX, "." + format);
			// we created the output file just so we would know an output
			// location to pass to dot
			// dotOutput.delete();
			// dump the contents from the input stream into the temporary file
			// to be submitted to dot
			FileOutputStream tmpDotOutputStream = null;
			try {
				IOUtils.copy(input, dotContents);
				tmpDotOutputStream = new FileOutputStream(dotInput);
				IOUtils.copy(
						new ByteArrayInputStream(dotContents.toByteArray()),
						tmpDotOutputStream);
			} finally {
				
				IOUtils.closeQuietly(tmpDotOutputStream);
			}
			System.err.println("runDot:" + dotOutput);

			IStatus result = runDot(format, dotInput, dotOutput);
			
			status.add(result);
			// status.add(logInput(dotContents));
			// System.err.println("runDot:" + status);	
			if (!result.isOK())
				LogUtils.log(status);
			return dotOutput;
		} catch (SWTException e) {
			status.add(new Status(IStatus.ERROR, Activator.ID, "", e));
		} catch (IOException e) {
			status.add(new Status(IStatus.ERROR, Activator.ID, "", e));
		} finally {
			IOUtils.closeQuietly(input);
			dotInput.delete();
		}
		throw new CoreException(status);
	}

	/**
	 * Higher-level API for launching a GraphViz transformation.
	 * 
	 * @param dotOutput
	 *            TODO
	 * 
	 * @return the resulting image, never <code>null</code>
	 * @throws CoreException
	 *             if any error occurs
	 */

	public static void browse(final InputStream input, IFile dotOutput) {
		MultiStatus status = new MultiStatus(Activator.ID, 0,
				"Errors occurred while running Graphviz", null);
		try {
			System.err.println("dotOutput:"+dotOutput.getRawLocation().toOSString());
			dotOutput = execute(input, "svg", dotOutput);
			URL url = dotOutput.getRawLocationURI().toURL();
			System.err.println("dotOutput:"+url);
			SvgBrowser.browse(url);
		} catch (SWTException e) {
			status.add(new Status(IStatus.ERROR, Activator.ID, "", e));
		} catch (CoreException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			// if (dotOutput!=null) dotOutput.delete();
			IOUtils.closeQuietly(input);
		}
	}

	private static IStatus runDot(String format, File dotInput, IFile dotOutput) {
		// build the command line
		// double dpi = 96;
//		double widthInInches = -1;
//		double heightInInches = -1;

		List<String> cmd = new ArrayList<String>();
		cmd.add("-o" + dotOutput.getRawLocation().toOSString());
		cmd.add("-T" + format);
		// if (widthInInches > 0 && heightInInches > 0)
		// cmd.add("-Gsize=" + widthInInches + ',' + heightInInches);
		// if (widthInInches > 0 && heightInInches > 0)
		// cmd.add("-Gviewport=" + dimension.x + ',' + dimension.y+','+"1");
		cmd.add(dotInput.getAbsolutePath());
		return runDot(cmd.toArray(new String[cmd.size()]));
	}

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
		IPath dotFullPath = Activator.getInstance().getDotLocation();
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
		String commandLineExtension = Activator.getInstance()
				.getCommandLineExtension();
		if (commandLineExtension != null) {
			String[] tokens = commandLineExtension.split(" ");
			cmd.addAll(Arrays.asList(tokens));
		}
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

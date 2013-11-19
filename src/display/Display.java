package display;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.MalformedURLException;
import java.net.URI;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Path;
import org.eclipse.imp.pdb.facts.ISourceLocation;
import org.eclipse.imp.pdb.facts.IString;
import org.eclipse.imp.pdb.facts.IValueFactory;
import org.eclipse.ui.IEditorRegistry;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.part.FileEditorInput;
import org.rascalmpl.interpreter.IEvaluatorContext;
import org.apache.commons.io.IOUtils;

import dotplugin.Activator;
import dotplugin.GraphViz;
import dotplugin.editors.SvgBrowser;

@SuppressWarnings("unused")
public class Display {

	private static final String DOT_EXTENSION = ".dot"; //$NON-NLS-1$
	private static final String TMP_FILE_PREFIX = "graphviz"; //$NON-NLS-1$

	private final IValueFactory values;

	public Display(IValueFactory values) {
		super();
		this.values = values;
	}

	private IFile dotOutput;

	Runnable runnable = new Runnable() {

		@Override
		public void run() {
			/* try {
				PlatformUI
						.getWorkbench()
						.getActiveWorkbenchWindow()
						.getActivePage()
						.openEditor(
								new FileEditorInput(dotOutput),
								IEditorRegistry.SYSTEM_EXTERNAL_EDITOR_ID);							
			} catch (PartInitException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			*/
			
			try {
				SvgBrowser.browse(dotOutput.getLocationURI().toURL());
			} catch (MalformedURLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	

		} 		
				
	};

	private void dotDisplay(String projName, String outName, String input,
			IEvaluatorContext ctx) {
		try {
			File dotInput = File.createTempFile(TMP_FILE_PREFIX, DOT_EXTENSION);
			dotInput.deleteOnExit();
			OutputStream dotStream = new FileOutputStream(dotInput);
			IOUtils.copy(IOUtils.toInputStream(input), dotStream);
			IOUtils.closeQuietly(dotStream);
			URI uri = dotInput.toURI();
			dotDisplay(projName, outName, uri, ctx);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void htmlDisplay(String projName, String outName, String input,
			IEvaluatorContext ctx) {
		try {
			dotOutput = getHtmlOutputLoc(projName, outName);	
			InputStream is = IOUtils.toInputStream(input);
			if (dotOutput.exists())
				dotOutput.delete(true, null);
			if (dotOutput.getParent().getType()==IResource.FOLDER) {
				IFolder f = (IFolder) dotOutput.getParent();
				if (!f.exists()) {
					f.create(true, false, null);
				}
			}
			dotOutput.create(is, true, null);
			PlatformUI.getWorkbench().getDisplay().asyncExec(runnable);
		} catch (CoreException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void htmlDisplay(ISourceLocation loc , String input,
			IEvaluatorContext ctx) throws IOException {
		try {
			dotOutput = getHtmlOutputLoc(loc);	
			InputStream is = IOUtils.toInputStream(input);
			if (dotOutput.exists())
				dotOutput.delete(true, null);
			if (dotOutput.getParent().getType()==IResource.FOLDER) {
				IFolder f = (IFolder) dotOutput.getParent();
				if (!f.exists()) {
					f.create(true, false, null);
				}
			}
			dotOutput.create(is, true, null);
			PlatformUI.getWorkbench().getDisplay().asyncExec(runnable);
		} catch (CoreException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private IFile getSvgOutputLoc(String projName, String outName, URI uri)
			throws IOException {
		IFile dotOutput = null;
		if ("project".equals(uri.getScheme())) {
			IProject p = ResourcesPlugin.getWorkspace().getRoot()
					.getProject(uri.getAuthority());
			IPath path = p.getFile(uri.getPath()).getProjectRelativePath();
			dotOutput = p.getFile(path.removeFileExtension().addFileExtension(
					"svg"));
		} else if ("file".equals(uri.getScheme())) {
			IPath path = new Path(uri.getPath());
			IProject p = ResourcesPlugin.getWorkspace().getRoot()
					.getProject(projName == null ? Activator.ID : projName);
			if (outName == null)
				path = new Path(path.removeFileExtension().lastSegment())
						.addFileExtension("svg");
			else
				path = new Path(outName).addFileExtension("svg");
			dotOutput = p.getFile(new Path("src").append(path));
		}
		if (dotOutput == null)
			throw new IOException("Invalid uri:+uri");
		return dotOutput;
	}

	private IFile getHtmlOutputLoc(String projName, String outName) {
		IFile dotOutput = null;
		IProject p = ResourcesPlugin.getWorkspace().getRoot()
				.getProject(projName);
		IPath path = new Path(outName).addFileExtension("html");
		dotOutput = p.getFile(new Path("src").append(path));
		return dotOutput;
	}
	
	private IFile getHtmlOutputLoc(ISourceLocation loc) throws IOException {
		IFile dotOutput = null;
		if (loc.getURI().getScheme().equals("project")) {
			IPath path = new Path(loc.getURI().getPath());
			String projName = loc.getURI().getAuthority();
			IProject p = ResourcesPlugin.getWorkspace().getRoot()
					.getProject(projName);
			dotOutput = p.getFile(path);			 
		}
		if (dotOutput == null)
			throw new IOException("Invalid uri:"+loc.getURI());
		return dotOutput;
	}

	/* ------------------------------------------------------------------ */

	public void dotDisplay(IString projName, IString outName,
			ISourceLocation sloc, IEvaluatorContext ctx) {
		URI uri = sloc.getURI();
		dotDisplay(projName.getValue(), outName.getValue(), uri, ctx);
	}

	public void dotDisplay(ISourceLocation sloc, IEvaluatorContext ctx) {
		URI uri = sloc.getURI();
		dotDisplay(null, null, uri, ctx);
	}

	private void dotDisplay(String projName, String outName, URI uri,
			IEvaluatorContext ctx) {
		try {
			InputStream input = ctx.getResolverRegistry().getInputStream(uri);
			dotOutput = getSvgOutputLoc(projName, outName, uri);
			GraphViz.createDotFile(input, dotOutput);
			PlatformUI.getWorkbench().getDisplay().asyncExec(runnable);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void dotDisplay(IString projName, IString out, IString input,
			IEvaluatorContext ctx) {
		String s = input.getValue();
		dotDisplay(projName.getValue(), out.getValue(), s, ctx);
	}

	public void dotDisplay(IString input, IEvaluatorContext ctx) {
		String s = input.getValue();
		dotDisplay(null, null, s, ctx);
	}

	/* -------------------------------------------------------------------- */

	public IString dotToSvg(IString input, IEvaluatorContext ctx) {
		String s = input.getValue();
		return values
				.string(GraphViz.createDotString(IOUtils.toInputStream(s)));
	}

	public void htmlDisplay(IString projName, IString out, IString input,
			IEvaluatorContext ctx) {
		String s = input.getValue();
		htmlDisplay(projName.getValue(), out.getValue(), s, ctx);
	}
	
	public void htmlDisplay(ISourceLocation loc, IString input,
			IEvaluatorContext ctx) throws IOException {
		String s = input.getValue();
		htmlDisplay(loc , s, ctx);
	}

}

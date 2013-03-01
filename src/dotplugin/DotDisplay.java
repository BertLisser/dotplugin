package dotplugin;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.URI;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.ResourcesPlugin;
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

@SuppressWarnings("unused")
public class DotDisplay {

	private static final String DOT_EXTENSION = ".dot"; //$NON-NLS-1$
	private static final String TMP_FILE_PREFIX = "graphviz"; //$NON-NLS-1$

	private final IValueFactory values;

	public DotDisplay(IValueFactory values) {
		super();
		this.values = values;
	}

	private IFile dotOutput;

	Runnable runnable = new Runnable() {

		@Override
		public void run() {
			try {
				PlatformUI
						.getWorkbench()
						.getActiveWorkbenchWindow()
						.getActivePage()
						.openEditor(new FileEditorInput(dotOutput),
								IEditorRegistry.SYSTEM_EXTERNAL_EDITOR_ID);
			} catch (PartInitException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
	};
	
	public void dotDisplay(IString input, IEvaluatorContext ctx) {
		String  s = input.getValue();
		dotDisplay(s, ctx);       
	}

	private void dotDisplay(String input, IEvaluatorContext ctx) {
		try {
			File dotInput = File.createTempFile(TMP_FILE_PREFIX, DOT_EXTENSION);
			dotInput.deleteOnExit();
			OutputStream dotStream = new FileOutputStream(dotInput);
			IOUtils.copy(IOUtils.toInputStream(input), dotStream);
			IOUtils.closeQuietly(dotStream);
			URI uri = dotInput.toURI();
			dotDisplay(uri, ctx);  
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void dotDisplay(ISourceLocation sloc, IEvaluatorContext ctx) {
		URI uri = sloc.getURI();
		dotDisplay(uri, ctx);       
	}

	private void dotDisplay(URI  uri, IEvaluatorContext ctx) {
		try {
			InputStream input = ctx.getResolverRegistry().getInputStream(uri);
			if ("project".equals(uri.getScheme())) {
				IProject p = ResourcesPlugin.getWorkspace().getRoot()
						.getProject(uri.getAuthority());
				IPath path = p.getFile(uri.getPath()).getProjectRelativePath();
				dotOutput = p.getFile(path.removeFileExtension()
						.addFileExtension("svg"));

			} else if ("file".equals(uri.getScheme())) {
				IPath path = new Path(uri.getPath());
				IProject p = ResourcesPlugin.getWorkspace().getRoot()
						.getProject(Activator.ID);
				path = new Path(path.removeFileExtension().lastSegment())
						.addFileExtension("svg");
				dotOutput = p.getFile(new Path("src").append(path));
			}
			if (dotOutput == null)
				throw new IOException("Invalid uri:+uri");
			GraphViz.createDotFile(input, dotOutput);
			PlatformUI.getWorkbench().getDisplay().asyncExec(runnable);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}

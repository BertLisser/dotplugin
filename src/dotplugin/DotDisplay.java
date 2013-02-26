package dotplugin;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;

import org.eclipse.core.internal.resources.Resource;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.IPath;
import org.eclipse.imp.pdb.facts.ISourceLocation;
import org.eclipse.imp.pdb.facts.IValueFactory;
import org.eclipse.ui.IEditorRegistry;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.part.FileEditorInput;
import org.rascalmpl.interpreter.IEvaluatorContext;

public class DotDisplay {

	private final IValueFactory values;

	public DotDisplay(IValueFactory values) {
		super();
		this.values = values;
	}

	public void dotDisplay(ISourceLocation sloc, IEvaluatorContext ctx) {
		URI uri = sloc.getURI();
		if ("project".equals(uri.getScheme())) {
			IProject p = ResourcesPlugin.getWorkspace().getRoot()
					.getProject(uri.getAuthority());
			IPath path = p.getFile(uri.getPath()).getProjectRelativePath();
			IFile dotOutput = p.getFile(path.removeFileExtension()
					.addFileExtension("svg"));
			try {
				InputStream input = ctx.getResolverRegistry().getInputStream(
						uri);
				GraphViz.createDotFile(input, dotOutput);
				PlatformUI
						.getWorkbench()
						.getActiveWorkbenchWindow()
						.getActivePage()
						.openEditor(new FileEditorInput(dotOutput),
								IEditorRegistry.SYSTEM_EXTERNAL_EDITOR_ID);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (PartInitException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

}

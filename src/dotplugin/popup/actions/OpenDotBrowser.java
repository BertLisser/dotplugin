package dotplugin.popup.actions;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.jface.action.IAction;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.ui.IActionDelegate;
import org.eclipse.ui.IObjectActionDelegate;
import org.eclipse.ui.IWorkbenchPart;

import dotplugin.GraphViz;

public class OpenDotBrowser implements IObjectActionDelegate {

	
	private IFile file;

	/**
	 * Constructor for Action1.
	 */
	public OpenDotBrowser() {
		super();
	}


	/**
	 * @see IActionDelegate#run(IAction)
	 */
	public void run(IAction action) {
		if (file != null) {
			try {
				IPath path = file.getProjectRelativePath().removeFileExtension()
						.addFileExtension("svg");
			    IFile dotOutput = file.getProject().getFile(path);
				GraphViz.browse(file.getContents(), dotOutput);
			} catch (CoreException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
		}

	}

	/**
	 * @see IActionDelegate#selectionChanged(IAction, ISelection)
	 */
	public void selectionChanged(IAction action, ISelection selection) {
		IStructuredSelection sel = (IStructuredSelection) selection;
		if (!sel.isEmpty()) {
			file = (IFile) sel.getFirstElement();
		}
	}



	@Override
	public void setActivePart(IAction action, IWorkbenchPart targetPart) {
		// TODO Auto-generated method stub
		
	}

}

package dotplugin.popup.actions;

import java.io.File;
import java.io.IOException;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.jface.action.IAction;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.IObjectActionDelegate;
import org.eclipse.ui.IWorkbenchPart;

import dotplugin.GraphViz;

public class OpenDotBrowser implements IObjectActionDelegate {

	private Shell shell;

	private IFile file;

	/**
	 * Constructor for Action1.
	 */
	public OpenDotBrowser() {
		super();
	}

	/**
	 * @see IObjectActionDelegate#setActivePart(IAction, IWorkbenchPart)
	 */
	public void setActivePart(IAction action, IWorkbenchPart targetPart) {
		shell = targetPart.getSite().getShell();
	}

	/**
	 * @see IActionDelegate#run(IAction)
	 */
	public void run(IAction action) {
		// MessageDialog.openInformation(
		// shell,
		// "Dotplugin",
		// "New Action was executed.");
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

}

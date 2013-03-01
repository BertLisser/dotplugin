package dotplugin.popup.actions;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.jface.action.IAction;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.ui.IActionDelegate;
import org.eclipse.ui.IEditorRegistry;
import org.eclipse.ui.IObjectActionDelegate;
import org.eclipse.ui.IWorkbenchPart;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.part.FileEditorInput;

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
				IPath path = file.getProjectRelativePath()
						.removeFileExtension().addFileExtension("svg");
				IFile dotOutput = file.getProject().getFile(path);
				GraphViz.createDotFile(file.getContents(), dotOutput);
				PlatformUI
						.getWorkbench()
						.getActiveWorkbenchWindow()
						.getActivePage()
						.openEditor(new FileEditorInput(dotOutput),
								IEditorRegistry.SYSTEM_EXTERNAL_EDITOR_ID);
			} catch (PartInitException e) {
				e.printStackTrace();
			} catch (CoreException e) {
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

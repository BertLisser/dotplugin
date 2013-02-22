package dotplugin.popup.actions;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.jface.action.IAction;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.ui.IObjectActionDelegate;
import org.eclipse.ui.IWorkbenchPart;

import dotplugin.editors.SvgBrowser;

public class OpenSvgBrowser implements IObjectActionDelegate {

	private IFile file;

	@Override
	public void run(IAction action) {
		if (file != null) {
			try {
				SvgBrowser.browse(file.getLocationURI().toURL());
			} catch (MalformedURLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

	}

	@Override
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

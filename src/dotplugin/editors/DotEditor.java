/*******************************************************************************
 * Copyright (c) 2009-2011 CWI
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *   Bert Lisser    - Bert.Lisser@cwi.nl
 *******************************************************************************/
package dotplugin.editors;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.IEditorSite;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.IWorkbenchWindow;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.part.EditorPart;
import org.eclipse.ui.part.FileEditorInput;

import dotplugin.GraphViz;

/**
 * A view that wraps a {@link DotViewer}.
 */

public class DotEditor extends EditorPart {
	static final private boolean test = false;

	protected static final String editorId = "dotplugin.editors.DotEditor";

	private IFile selectedFile;

	
	/**
	 * The constructor.
	 */
	public DotEditor() {
		//
	}

	/**
	 * This is a callback that will allow us to create the viewer and initialize
	 * it.
	 */
	@Override
	public void createPartControl(Composite parent) {
		System.err.println("createPartControl");
		try {
			IPath path = selectedFile.getProjectRelativePath().removeFileExtension()
					.addFileExtension("svg").removeFirstSegments(1);
		    IFile dotOutput = selectedFile.getProject().getFile(path);
			GraphViz.browse(selectedFile.getContents(), dotOutput);
		} catch (CoreException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public IFile getSelectedFile() {
		return selectedFile;
	}

	@Override
	public void doSave(IProgressMonitor monitor) {
		// TODO Auto-generated method stub

	}

	@Override
	public void doSaveAs() {
		// TODO Auto-generated method stub

	}

	@Override
	public void init(IEditorSite site, IEditorInput input)
			throws PartInitException {
		setSite(site);
		setInput(input);
		// System.err.println(""+this.getClass()+" init:"+input);
		selectedFile = ((FileEditorInput) getEditorInput()).getFile();
		setPartName(selectedFile.getName());
	}

	@Override
	public boolean isDirty() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean isSaveAsAllowed() {
		// TODO Auto-generated method stub
		return false;
	}

	public static void open(final FileEditorInput file) {
		IWorkbench wb = PlatformUI.getWorkbench();
		IWorkbenchWindow win = wb.getActiveWorkbenchWindow();
		if (win == null && wb.getWorkbenchWindowCount() != 0) {
			win = wb.getWorkbenchWindows()[0];
		}
		if (win != null) {
			final IWorkbenchPage page = win.getActivePage();
			if (page != null) {
				Display.getDefault().asyncExec(new Runnable() {
					public void run() {
						// IEditorReference[] findEditors =
						// page.findEditors(file, editorId,
						// IWorkbenchPage.MATCH_INPUT);
						// for (IEditorReference e:findEditors)
						// System.err.println("Found:"+e.getFactoryId()+" "+e.getId());
						try {
							int matchFlags = IWorkbenchPage.MATCH_INPUT
									| IWorkbenchPage.MATCH_ID;
							page.openEditor(file, editorId, true, matchFlags);

						} catch (PartInitException e) {
							e.printStackTrace();
						}
					}
				});
			}
		}
	}

	@Override
	public void setFocus() {
		// TODO Auto-generated method stub
		
	}

}

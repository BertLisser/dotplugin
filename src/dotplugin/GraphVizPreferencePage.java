/*******************************************************************************
 * Copyright (c) 2007 EclipseGraphviz contributors.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Scott Bronson
 *******************************************************************************/
package dotplugin;

import java.io.File;

import org.eclipse.jface.dialogs.IMessageProvider;
import org.eclipse.jface.preference.PreferencePage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.IWorkbenchPreferencePage;


public class GraphVizPreferencePage extends PreferencePage implements IWorkbenchPreferencePage {
	/**
	 * Utility method that creates a radio button instance and sets the default
	 * layout data.
	 * 
	 * @param parent
	 *            the parent for the new button
	 * @param label
	 *            the label for the new button
	 * @return the newly-created button
	 */

	protected static Button createRadioButton(Composite parent, String label) {
		Button button = new Button(parent, SWT.RADIO | SWT.LEFT);
		button.setText(label);
		return button;
	}
	
	protected static Button createCheckButton(Composite parent, String label) {
		Button button = new Button(parent, SWT.CHECK | SWT.LEFT);
		button.setText(label);
		return button;
	}

	private Button automaticDotButton;
	private Button autodetectDotButton;
	private Button specifyDotButton;
	
	private FileBrowserField dotBrowser;
	private Text commandLineText; 

	/**
	 * Creates the mildly complex radio buttons that the prefs dialog uses.
	 * 
	 * @param group
	 *            The group to add the button to.
	 * @param label
	 *            The text for the button's label
	 * @param location
	 *            String to append to the label, null to append nothing and
	 *            disable the button.
	 * @param method
	 *            If this matches the current method, the button is
	 *            automatically selected.
	 * @return The new button.
	 */
	private Button createButton(Group group, String label, boolean enabled, Pref.DotMethod method) {
		Button button;

		button = createRadioButton(group, label);
		button.setSelection(getCurrentDotMethod() == method);
		button.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				boolean enabled = specifyDotButton.getSelection();
				dotBrowser.setEnabled(enabled);
				dotBrowserChanged(null);
			}
		});
		button.setEnabled(enabled);
		return button;
	}

	/**
	 * Creates the composite which will contain all the preference controls for
	 * this page.
	 * 
	 * @param parent
	 *            the parent composite
	 * @return the composite for this page
	 */
	protected Composite createComposite(Composite parent) {
		Composite composite = new Composite(parent, SWT.NONE);
		GridLayout layout = new GridLayout();
		layout.marginWidth = 0;
		layout.marginHeight = 0;
		composite.setLayout(layout);
		composite.setLayoutData(new GridData(GridData.VERTICAL_ALIGN_FILL | GridData.HORIZONTAL_ALIGN_FILL));
		return composite;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.eclipse.jface.preference.PreferencePage
	 */
	@Override
	protected Control createContents(Composite parent) {
		Composite composite = createComposite(parent);
		createOpenModeGroup(composite);
		createCommandLineExtension(composite);
		applyDialogFont(composite);
		return composite;
	}

	/**
	 * Creates widgets for editing the command-line extension string.
	 *  
	 * @param composite
	 */
	private void createCommandLineExtension(Composite composite) {
		Group group = new Group(composite, SWT.LEFT);
		GridLayout layout = new GridLayout();
		group.setLayout(layout);
		GridData data = new GridData(GridData.HORIZONTAL_ALIGN_FILL | GridData.GRAB_HORIZONTAL);
		group.setLayoutData(data);
		group.setText("Additional command line options (prepended to options automatically generated");
		commandLineText = new Text(group, SWT.SINGLE | SWT.BORDER);
		
		
		String existing = Pref.getCommandLineExtension();
		commandLineText.setText(existing == null ? "" : existing);

		data = new GridData();
		data.horizontalIndent = 20;
		data.horizontalAlignment = GridData.FILL;
		data.grabExcessHorizontalSpace = true;
		commandLineText.setLayoutData(data);
	}

	protected void createOpenModeGroup(Composite composite) {
		Group buttonComposite = new Group(composite, SWT.LEFT);
		GridLayout layout = new GridLayout();
		buttonComposite.setLayout(layout);
		GridData data = new GridData(GridData.HORIZONTAL_ALIGN_FILL | GridData.GRAB_HORIZONTAL);
		buttonComposite.setLayoutData(data);
		buttonComposite.setText("Dot executable to use");

		automaticDotButton = createButton(buttonComposite, "Choose Automatically", true, Pref.DotMethod.AUTO);
		
		String detectedDotLocation = Pref.autodetectDots();
		final boolean dotDetected = detectedDotLocation != null;
		String detectLabel = "Detected: " + (dotDetected ? detectedDotLocation : "(none)");
		autodetectDotButton = createButton(buttonComposite, detectLabel, dotDetected, Pref.DotMethod.DETECT);
		specifyDotButton = createButton(buttonComposite, "Specify Manually:", true, Pref.DotMethod.MANUAL);
		

		dotBrowser = new FileBrowserField(buttonComposite) {
			@Override
			public void valueChanged() {
				dotBrowserChanged(getText());
			}
		};
		dotBrowser.setText(Pref.getManualDotPath());
		dotBrowser.setEnabled(getCurrentDotMethod() == Pref.DotMethod.MANUAL);

		data = new GridData();
		data.horizontalIndent = 20;
		data.horizontalAlignment = GridData.FILL;
		data.grabExcessHorizontalSpace = true;
		dotBrowser.setLayoutData(data);
	}

	public void dotBrowserChanged(String newText) {
		setErrorMessage(null);
		setMessage(null);
		if (newText == null) {
			newText = dotBrowser.getText();
		}
		if (specifyDotButton.getSelection()) {
			if (newText.length() == 0) {
				setErrorMessage("Please enter a path.");
				setValid(false);
				return;
			}
			File dotFile = new File(newText);
			String fileName = dotFile.getName();
			int extensionPos;
			while ((extensionPos = fileName.lastIndexOf('.')) > 0)
				fileName = fileName.substring(0, extensionPos);
			if (!dotFile.exists()) {
				setErrorMessage(newText + " doesn't exist");
				setValid(false);
				return;
			} else if (dotFile.isDirectory()) {
				setErrorMessage(newText + " is a directory");
				setValid(false);
				return;
			} else if (!Pref.isExecutable(dotFile))
				setMessage(newText + " is not executable!", IMessageProvider.WARNING);
			else if (!Pref.DOT_FILE_NAME.equalsIgnoreCase(fileName))
				setMessage("The file name should be " + Pref.DOT_FILE_NAME , IMessageProvider.WARNING);
		}
		setValid(true);
	}

	/** Returns the Dot search method that is currently in effect */
	Pref.DotMethod getCurrentDotMethod() {
		return Pref.getDotSearchMethod();
	}

	/**
	 * Scans the radio buttons and returns the dot method that the user has
	 * selected.
	 */
	Pref.DotMethod getNewDotMethod() {
		return autodetectDotButton.getSelection()
						? Pref.DotMethod.DETECT : specifyDotButton.getSelection() ? Pref.DotMethod.MANUAL : Pref.DotMethod.AUTO;
	}

	/**
	 * @see IWorkbenchPreferencePage
	 */
	public void init(IWorkbench workbench) {
	}

	/**
	 * The default button has been pressed.
	 */
	@Override
	protected void performDefaults() {
		Pref.DotMethod dotMethod = Pref.DotMethod.AUTO;
		automaticDotButton.setSelection(dotMethod == Pref.DotMethod.AUTO);
		autodetectDotButton.setSelection(dotMethod == Pref.DotMethod.DETECT);
		specifyDotButton.setSelection(dotMethod == Pref.DotMethod.MANUAL);
		dotBrowser.setText("");
		commandLineText.setText("");
		super.performDefaults();
	}

	/**
	 * The user has pressed OK or Apply. Store this page's values.
	 */
	@Override
	public boolean performOk() {
		Pref.setDotSearchMethod(getNewDotMethod());
		Pref.setManualDotPath(dotBrowser.getText());
		Pref.setCommandLineExtension(commandLineText.getText());
		return true;
	}
}

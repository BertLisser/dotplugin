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
 *     Bert Lisser - Bert.Lisser@cwi.nl (CWI)
 *******************************************************************************/
package dotplugin;

import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.osgi.framework.BundleContext;

import dotplugin.editors.LogUtils;


public class Activator extends AbstractUIPlugin  {

	
	public static final String ID = "dotplugin"; 

	private static Activator plugin;

	public static Activator getDefault() {
		return plugin;
	}

	
	public static void logUnexpected(String message, Exception e) {
		LogUtils.logError(message, e);
	}


	public Activator() {
		// System.err.println(this.hashCode());
	}


	public void start(BundleContext context) throws Exception {
		super.start(context);
		plugin = this;
		LogUtils.logInfo("Activator START:"+Activator.ID, null);
		
	}

	public void stop(BundleContext context) throws Exception {
		// nothing to do 
		super.stop(context);
	}
	
		
}

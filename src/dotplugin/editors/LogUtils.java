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
 *     Bert Lisser    - Bert.Lisser@cwi.nl
 *******************************************************************************/

package dotplugin.editors;

import org.eclipse.core.runtime.Assert;
import org.eclipse.core.runtime.ILogListener;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Platform;
import org.eclipse.core.runtime.Status;
import org.osgi.framework.Bundle;

import dotplugin.Activator;

public class LogUtils {
	public static void log(int severity, String pluginId, String message, Throwable exception) {
		log(new Status(severity, pluginId, message, exception));
	}

	public static void log(IStatus status) {
		if (!Platform.isRunning()) {
			System.err.println(status.getMessage());
			if (status.getException() != null)
				status.getException().printStackTrace();
			if (status.isMultiStatus())
				for (IStatus child : status.getChildren())
					log(child);
			return;
		}
		Bundle bundle = Platform.getBundle(status.getPlugin());
		Assert.isNotNull(bundle);
		Platform.getLog(bundle).log(status);
	}
	
	public static void logError(String message, Throwable e) {
		log(IStatus.ERROR, Activator.ID, message, e);
	}

	public static void logWarning(String message, Throwable e) {
		log(IStatus.WARNING, Activator.ID, message, e);
	}
	
	public static void logInfo(String message, Throwable e) {
		log(IStatus.INFO, Activator.ID, message, e);
	}
	
	public static void debug(String pluginId, String message) {
		if (Boolean.getBoolean(pluginId + ".debug"))
			log(IStatus.INFO, Activator.ID, message, null);
	}
	
	public static void addLogListener(ILogListener iLogListener) {
		Platform.addLogListener(iLogListener);
	}

}

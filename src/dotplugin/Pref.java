package dotplugin;

import java.io.File;
import java.io.FileFilter;

import org.eclipse.core.filesystem.EFS;
import org.eclipse.core.filesystem.IFileStore;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.Path;
import org.eclipse.core.runtime.Platform;
import org.eclipse.core.runtime.preferences.IEclipsePreferences;
import org.eclipse.core.runtime.preferences.InstanceScope;
import org.osgi.service.prefs.BackingStoreException;
import org.osgi.service.prefs.Preferences;

import dotplugin.editors.LogUtils;


public class Pref {
	
	public static final String DOT_SEARCH_METHOD = "dotSearchMethod";
	// The manual path is entered by the user. It should never be changed or
	// deleted except by the user.
	public static final String DOT_MANUAL_PATH = "dotManualPath";
	
	public static final String DOT_FILE_NAME = "dot";
	
	public static final String COMMAND_LINE = "commandLineExtension";
	
	

	
	/**
	 * Path to autodetected dot or null if it can't be found. See
	 * autodetectDots().
	 */
	static private String autodetectedDotLocation;
	
	static {
		autodetectDots();
		if (autodetectedDotLocation == null && getDotSearchMethod() == DotMethod.DETECT) {
			setDotSearchMethod(DotMethod.AUTO);
			LogUtils.logWarning("Could not find a suitable dot executable.  Please specify one using Window -> Preferences -> Graphviz.", null);
		}
		}

	
	/**
	 * DotLocation keeps track of how the user wants to select the dot
	 * executable. We include strings for each term so that the settings files
	 * remain human readable.
	 */
	public enum DotMethod {
		AUTO, BUNDLE, DETECT, MANUAL;

		/**
		 * Given a string, looks up the corresponding DotMethod. If no match,
		 * returns the default AUTO.
		 */
		static public DotMethod find(String term) {
			for (DotMethod p : DotMethod.values()) {
				if (p.name().equals(term)) {
					return p;
				}
			}
			return AUTO;
		}
	}
	
	/** Returns the preference with the given name */
	static public String getPreference(String preference_name) {
		Preferences node =
						Platform.getPreferencesService().getRootNode().node(InstanceScope.SCOPE).node(
										Activator.ID);
		return node.get(preference_name, null);
	}
	
	static public String getManualDotPath() {
		return getPreference(DOT_MANUAL_PATH);
	}
	
	static public void setDotSearchMethod(DotMethod dotMethod) {
		setPreference(DOT_SEARCH_METHOD, dotMethod.name());
	}

	static public void setManualDotPath(String newLocation) {
		setPreference(DOT_MANUAL_PATH, newLocation);
	}

	/** Sets the given preference to the given value */
	static public void setPreference(String preferenceName, String value) {
		IEclipsePreferences root = Platform.getPreferencesService().getRootNode();
		Preferences node = root.node(InstanceScope.SCOPE).node(Activator.ID);
		node.put(preferenceName, value);
		try {
			node.flush();
		} catch (BackingStoreException e) {
			LogUtils.logError("Error updating preferences.", e);
		}
	}
	
	/**
	 * Returns whether the given file is executable. Depending on the platform
	 * we might not get this right.
	 * 
	 * TODO find a better home for this function
	 */
	public static boolean isExecutable(File file) {
		if (!file.isFile())
			return false;
		if (Platform.getOS().equals(Platform.OS_WIN32))
			// executable attribute is a *ix thing, on Windows all files are
			// executable
			return true;
		IFileStore store = EFS.getLocalFileSystem().fromLocalFile(file);
		if (store == null)
			return false;
		return store.fetchInfo().getAttribute(EFS.ATTRIBUTE_EXECUTABLE);
	}

	
	private static class ExecutableFinder implements FileFilter {
		private String nameToMatch;
		
		public ExecutableFinder(String nameToMatch) {
			this.nameToMatch = nameToMatch;
		}

		public boolean accept(File candidate) {
			if (!isExecutable(candidate))
				return false;
			return candidate.getName().equalsIgnoreCase(nameToMatch)
							|| candidate.getName().startsWith(nameToMatch + '.');
		}
	}
	
	/**
	 * This routine browses through the user's PATH looking for dot executables.
	 * 
	 * @return the absolute path if a suitable dot is found, null if not. This
	 *         is normally called once at plugin startup but it can also be
	 *         called while the plugin is running (in case user has installed
	 *         dot without restarting Eclipse).
	 */
	static public String autodetectDots() {
		autodetectedDotLocation = null;
		String paths = System.getenv("PATH");
		for (String path : paths.split(File.pathSeparator)) {
			File directory = new File(path);
			File[] matchingFiles = directory.listFiles(new ExecutableFinder(DOT_FILE_NAME));
			if (matchingFiles != null && matchingFiles.length > 0) {
				File found = matchingFiles[0];
				autodetectedDotLocation = found.getAbsolutePath();
				break;
			}
		}
		return autodetectedDotLocation;
	}
	
	/**
	 * Gets the path to the dot executable. It takes user's preferences into
	 * account so it should always do the right thing.
	 */
	static public IPath getDotLocation() {
		final String manualLocation = getManualDotPath();
		switch (getDotSearchMethod()) {
		case AUTO:
			if (autodetectedDotLocation != null)
				return new Path(autodetectedDotLocation);
			return manualLocation != null ? new Path(manualLocation) : null;

		case DETECT:
			return autodetectedDotLocation != null ? new Path(autodetectedDotLocation) : null;

		case MANUAL:
			return manualLocation != null ? new Path(manualLocation) : null;
		}

		// Someone must have edited the prefs file manually... just reset the
		// value.
		setDotSearchMethod(DotMethod.AUTO);
		return null;
	}

	static public DotMethod getDotSearchMethod() {
		String value = getPreference(DOT_SEARCH_METHOD);
		return value != null ? DotMethod.find(value) : DotMethod.AUTO;
	}

	static public File getGraphVizDirectory() {
		IPath dotLocation = getDotLocation();
		return dotLocation == null ? null : dotLocation.removeLastSegments(1).toFile();
	}
	
	static public String getCommandLineExtension() {
		return getPreference(COMMAND_LINE);
	}
	
	static public void setCommandLineExtension(String commandLineExtension) {
		setPreference(COMMAND_LINE, commandLineExtension);
	}



}

package dotplugin;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;

/* Deletes dimensions after <sgg */

public class Filter {
	
	private static final String TMP_FILE_PREFIX = "graphviz"; //$NON-NLS-1$

	public static void exec(File f, IFile dotOutput) {
		try {
			if (dotOutput.exists())
				dotOutput.delete(true, null);
			BufferedReader s = new BufferedReader(new FileReader(
					f));
			Pattern p = Pattern.compile("<svg");
			File output = File.createTempFile(TMP_FILE_PREFIX, "." + "svg");
			output.deleteOnExit();
			PrintStream os = new PrintStream(output);
			while (s.ready()) {
				String q = s.readLine();
				if (q == null)
					break;
				Matcher m = p.matcher(q);
				if (m.find())
					os.println("<svg");
				else
					os.println(q);			
			}
			os.close();
			FileInputStream is = new FileInputStream(output);
			if (dotOutput.exists()) dotOutput.delete(true, null);
			dotOutput.create(is, true, null);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (CoreException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}


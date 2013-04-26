package dotplugin;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.IOUtils;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;

/* Deletes dimensions after <sgg */

public class Filter {

	private static final String TMP_FILE_PREFIX = "graphviz"; //$NON-NLS-1$

	public static String exec(File f) {
		try {
			BufferedReader s = new BufferedReader(new FileReader(f));
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
			BufferedReader is = new BufferedReader(new InputStreamReader(
					new FileInputStream(output)));
			StringBuffer b = new StringBuffer();
			while (is.ready()) {
				b.append(is.readLine());
				b.append("\n");
			}
			return b.toString();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}
	
	public static void exec(File f, IFile dotOutput) {
		try {
			if (dotOutput.exists())
				dotOutput.delete(true, null);
			String s = exec(f);
			InputStream is = IOUtils.toInputStream(s);
			dotOutput.create(is, true, null);
		}  catch (CoreException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}

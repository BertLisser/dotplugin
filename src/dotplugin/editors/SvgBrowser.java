package dotplugin.editors;

import java.net.URL;

import org.eclipse.swt.SWT;
import org.eclipse.swt.SWTError;
import org.eclipse.swt.browser.Browser;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.browser.IWebBrowser;
import org.eclipse.ui.browser.IWorkbenchBrowserSupport;


public class SvgBrowser {

	public static void browse(URL loc) {
		// try {
		// PlatformUI.getWorkbench().getBrowserSupport().getExternalBrowser()
		// .openURL(new URL(loc));
		IWebBrowser browser;
		try {
			IWorkbenchBrowserSupport browserSupport = PlatformUI.getWorkbench()
					.getBrowserSupport();
			browser = browserSupport.createBrowser(
					IWorkbenchBrowserSupport.LOCATION_BAR, "dotplugin.editors.DotEditor",
					loc.getFile(), null);
			browser.openURL(loc);
			// browser.close();
		} catch (PartInitException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void browse(String loc, Point size) {
		Display display = PlatformUI.getWorkbench().getDisplay();
		Shell shell = new Shell(display);
		shell.setLayout(new FillLayout());
		shell.setText(loc);
		final Browser browser;
		try {
			browser = new Browser(shell, SWT.MOZILLA);
			browser.setSize(size);
		} catch (SWTError e) {
			System.out.println("Could not instantiate Browser: "
					+ e.getMessage());
			display.dispose();
			return;
		}
		shell.open();
		browser.setUrl(loc);
		while (!shell.isDisposed()) {
			if (!display.readAndDispatch())
				display.sleep();
		}
		// display.dispose();
	}

}

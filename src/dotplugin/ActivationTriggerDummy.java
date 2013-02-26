package dotplugin;
import org.eclipse.ui.IStartup;


public class ActivationTriggerDummy implements IStartup {

        @Override
        public void earlyStartup() {
                // new Activator();
        	System.err.println("Hello");
        }

}

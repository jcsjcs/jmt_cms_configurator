import org.jruby.embed.ScriptingContainer;

public class Launcher {
  public static void main(String[] args) {
    ScriptingContainer container = new ScriptingContainer();
    container.setArgv(args);
    container.runScriptlet("require 'jmt_cms_configurator'" );
  }
}

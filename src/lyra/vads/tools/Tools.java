package lyra.vads.tools;

import java.io.File;
import java.io.IOException;
import java.util.logging.ConsoleHandler;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.Properties;
import java.util.Set;

public class Tools {
    static private FileHandler fileTxt;
    static private SimpleFormatter formatterTxt;

    static public void setupLogger() throws IOException {
        // get the global logger to configure it
        Logger logger = Logger.getLogger(Logger.GLOBAL_LOGGER_NAME);

        // suppress the logging output to the console
        Logger rootLogger = Logger.getLogger("");
        java.util.logging.Handler[] handlers = rootLogger.getHandlers();
        try {
            if (handlers[0] instanceof ConsoleHandler) {
                rootLogger.removeHandler(handlers[0]);
            }
        }catch( ArrayIndexOutOfBoundsException e) {
            System.out.println(e.getStackTrace());
        }

        logger.setLevel(Level.INFO);
        
        // check if logs dir exists
         File logDir = new File("./logs/"); 
         if( !(logDir.exists()) )
             logDir.mkdir();
                 
        fileTxt = new FileHandler("logs/vads_" + "log.txt");

        // create a TXT formatter
        formatterTxt = new SimpleFormatter();
        fileTxt.setFormatter(formatterTxt);
        logger.addHandler(fileTxt);
    }
    
    public static String getConfigProperty(String param) {
        Properties prop=new Properties();
        try {
            FileInputStream ip= new FileInputStream("D:\\Developpement\\workspace-plugins\\example\\java-payment-form-examples\\src\\lyra\\vads\\config\\config.properties");
            prop.load(ip);
            return prop.getProperty(param);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return "";
        } catch (IOException e) {
            e.printStackTrace();
            return "";
        }
    }
    
    public static Set<Object> getAllKeys(){
        Properties prop=new Properties();
        try {
            FileInputStream ip= new FileInputStream("D:\\Developpement\\workspace-plugins\\example\\java-payment-form-examples\\src\\lyra\\vads\\config\\config.properties");
            prop.load(ip);
            Set<Object> keys = prop.keySet();
            return keys;
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return null;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public static void main(String[] args) {
        System.out.println(Tools.getConfigProperty("site_id"));
        System.out.println(System.getProperty("user.dir") + "/src/lyra/vads/config/config.properties");
    }
}

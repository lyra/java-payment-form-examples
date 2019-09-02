package lyra.vads.tools;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;
import java.util.Set;

public class ReadPropertyFile {

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
        System.out.println(ReadPropertyFile.getConfigProperty("site_id"));
        System.out.println(System.getProperty("user.dir") + "/src/lyra/vads/config/config.properties");
    }

}

package com.lyra.vads.tools;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.logging.ConsoleHandler;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

import javax.servlet.http.HttpServletRequest;

import com.lyra.vads.sdk.Api;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.Properties;
import java.util.Set;
import java.util.TreeMap;

public class Tools {
    static final String CONF_PATH = "";
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
            FileInputStream ip= new FileInputStream(CONF_PATH);
            prop.load(ip);
            return prop.getProperty(param).trim();
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
            FileInputStream ip= new FileInputStream(CONF_PATH);
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
    
    
    public static boolean isAuthentified(TreeMap<String, String> formParameters) {
        
        String secretKey = (Tools.getConfigProperty("ctx_mode") == "PRODUCTION") ? Tools.getConfigProperty("key_prod") : Tools.getConfigProperty("key_test");; 
        String signAlgo = Tools.getConfigProperty("sign_algo");
        String receivedSignature = formParameters.get("signature");
        try {
            String calculatedSignature = Api.buildSignature(formParameters, secretKey, signAlgo);
            if(calculatedSignature.equals(receivedSignature)) return true;
        } catch (InvalidKeyException | NoSuchAlgorithmException | UnsupportedEncodingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return false;
        }
        return false;
    }
    
    public static boolean isAuthentified(HttpServletRequest request) {
        String secretKey = (Tools.getConfigProperty("ctx_mode") == "PRODUCTION") ? Tools.getConfigProperty("key_prod") : Tools.getConfigProperty("key_test");
        String signAlgo = Tools.getConfigProperty("sign_algo");
        String receivedSignature = request.getParameter("signature"); 
        String calculatedSignature = Api.buildSignature(request, secretKey, signAlgo);
        if(calculatedSignature.equals(receivedSignature)) return true;
        return false; 
    }
}

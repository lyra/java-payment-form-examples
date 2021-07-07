package com.lyra.examples.form.utils;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.ConsoleHandler;
import java.util.logging.FileHandler;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

public class AppUtils {
    private static final String CONF_PATH = "config.properties";
    private static final Properties CONF_PROPERTIES = new Properties();

    private static final Logger LOGGER = Logger.getLogger(AppUtils.class.getName());

    private AppUtils() {
        setupLogger(LOGGER);
    }

    public static void setupLogger(Logger logger) {
        // Suppress the logging output to the console.
        Logger rootLogger = Logger.getLogger("");
        Handler[] handlers = rootLogger.getHandlers();
        if (handlers != null && handlers.length > 0 && handlers[0] instanceof ConsoleHandler) {
            rootLogger.removeHandler(handlers[0]);
        }

        logger.setLevel(Level.INFO);

        try {
            // Check if logs directory exists.
            File logDir = new File("./logs/");
            if (!logDir.exists()) {
                logDir.mkdir();
            }

            FileHandler file = new FileHandler("logs/vads_" + "log.log");

            // Set a text formatter.
            file.setFormatter(new SimpleFormatter());

            logger.addHandler(file);
        } catch (IOException e) {
            logger.log(Level.WARNING, "Unable to add new file handker to the logger.", e);
        }
    }

    public static String getConfigProperty(String param) {
        if (CONF_PROPERTIES.isEmpty()) {
            // Properties not loaded yet.
            loadProperties();
        }

        String prop = CONF_PROPERTIES.getProperty(param);
        return prop != null ? prop.trim() : null;
    }

    public static void loadProperties() {
        ClassLoader classLoader = AppUtils.class.getClassLoader();

        try (InputStream is = classLoader.getResourceAsStream(CONF_PATH)) {
            CONF_PROPERTIES.load(is);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Unable to load the configuration file.", e);
        }
    }
}

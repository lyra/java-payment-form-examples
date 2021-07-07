package com.lyra.examples.form.utils;

import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Random;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.logging.Logger;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;

public class GatewayUtils {
    private GatewayUtils() {
    }

    private static final String ALGO_SHA_1 = "SHA-1";
    private static final String ALGO_SHA_256 = "SHA-256";
    private static final Charset ENCODING = StandardCharsets.UTF_8;

    private static final Logger logger = Logger.getLogger(Logger.GLOBAL_LOGGER_NAME);

    /**
     * Returns an array of languages accepted by the payment gateway.
     *
     * @return Map<String, String>
     */
    public static Map<String, String> getSupportedLanguages() {
        Map<String, String> languages = new HashMap<>();
        languages.put("de", "German");
        languages.put("en", "English");
        languages.put("zh", "Chinese");
        languages.put("es", "Spanish");
        languages.put("fr", "French");
        languages.put("it", "Italian");
        languages.put("ja", "Japanese");
        languages.put("nl", "Dutch");
        languages.put("pl", "Polish");
        languages.put("pt", "Portuguese");
        languages.put("ru", "Russian");
        languages.put("sv", "Swedish");
        languages.put("tr", "Turkish");
        return languages;
    }

    /**
     * Returns true if the entered language (ISO code) is supported.
     *
     * @param String lang
     * @return boolean
     */
    public static boolean isSupportedLanguage(String lang) {
        return getSupportedLanguages().containsKey(lang);
    }

    /**
     * Generate a random transaction ID from 1 to 899999.
     *
     * @return int the generated transaction ID
     */
    public static String generateTransId() {
        Random r = new SecureRandom();
        return String.format("%06d", r.ints(1, 899999 + 1).findFirst().getAsInt());
    }

    public static boolean isAuthentified(HttpServletRequest request) {
        String secretKey = "PRODUCTION".equals(AppUtils.getConfigProperty("ctx_mode"))
                ? AppUtils.getConfigProperty("key_prod")
                : AppUtils.getConfigProperty("key_test");

        String signAlgo = AppUtils.getConfigProperty("sign_algo");

        String receivedSignature = request.getParameter("signature");
        String calculatedSignature = buildSignature(request, secretKey, signAlgo);

        return calculatedSignature != null && calculatedSignature.equalsIgnoreCase(receivedSignature);
    }

    /**
     * Build signature from provided parameters and secret key. Parameters must be
     * encoded in UTF-8.
     *
     * @param TreeMap<String, String> formParameters payment gateway
     *                        request/response parameters
     * @param String          secretKey shop key
     * @param String          signAlgo signature algorithm
     * @return String
     */
    public static String buildSignature(SortedMap<String, String> formParameters, String secretKey, String signAlgo) {
        // Build message from parameters.
        for (Entry<String, String> entry : formParameters.entrySet()) {
            if (!entry.getKey().startsWith("vads_")) {
                formParameters.remove(entry.getKey());
            }
        }

        String message = String.join("+", formParameters.values());
        message += "+" + secretKey;

        // Sign
        switch (signAlgo) {
        case ALGO_SHA_1:
            try {
                return sha1Hex(message);
            } catch (NoSuchAlgorithmException e) {
                logger.severe("SHA-1 algorithm is not avilable: " + e.getMessage());
            }

            break;

        case ALGO_SHA_256:
            try {
                return hmacSha256Base64(message, secretKey);
            } catch (InvalidKeyException | NoSuchAlgorithmException e) {
                logger.severe("An error occurred when trying to sign with HMAC-SHA-256: " + e.getMessage());
            }

            break;

        default:
            throw new IllegalArgumentException("Algorithm " + signAlgo + " is not supported.");
        }

        return null;
    }

    /**
     * Build signature from provided parameters and secret key. Parameters must be
     * encoded in UTF-8.
     *
     * @param HttpServletRequest request payment gateway request/response parameters
     * @param String             secretKey shop key
     * @param String             signAlgo signature algorithm
     * @return String
     */
    public static String buildSignature(HttpServletRequest request, String secretKey, String signAlgo) {
        SortedSet<String> vadsFields = new TreeSet<>();
        Enumeration<String> paramNames = request.getParameterNames();

        // Collect and sort field names starting with vads_ in alphabetical order.
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            if (paramName.startsWith("vads_")) {
                vadsFields.add(paramName);
            }
        }

        // Calculate the signature
        StringBuilder sb = new StringBuilder();
        for (String vadsParamName : vadsFields) {
            String vadsParamValue = request.getParameter(vadsParamName);
            if (vadsParamValue != null) {
                sb.append(vadsParamValue);
            }

            sb.append("+");
        }

        sb.append(secretKey);
        String message = sb.toString();

        switch (signAlgo) {
        case ALGO_SHA_1:
            try {
                return sha1Hex(message);
            } catch (NoSuchAlgorithmException e) {
                logger.severe("SHA-1 algorithm is not avilable: " + e.getMessage());
            }

            break;

        case ALGO_SHA_256:
            try {
                return hmacSha256Base64(message, secretKey);
            } catch (InvalidKeyException | NoSuchAlgorithmException e) {
                logger.severe("An error occurred when trying to sign with HMAC-SHA-256: " + e.getMessage());
            }

            break;

        default:
            throw new IllegalArgumentException("Algorithm " + signAlgo + " is not supported.");
        }

        return null;
    }

    /**
     * Compute signature using HMAC-SHA-256 algorithm.
     *
     * @param String message provided parameters
     * @param String secretKey shop key
     * @return String
     */
    public static String hmacSha256Base64(String message, String secretKey)
            throws NoSuchAlgorithmException, InvalidKeyException {
        // Prepare HMAC-SHA-256 cipher algorithm with provided secretKey.
        Mac hmacSha256;
        try {
            hmacSha256 = Mac.getInstance("HmacSHA256");
        } catch (NoSuchAlgorithmException nsae) {
            hmacSha256 = Mac.getInstance("HMAC-SHA-256");
        }

        SecretKeySpec secretKeySpec = new SecretKeySpec(secretKey.getBytes(ENCODING), "HmacSHA256");
        hmacSha256.init(secretKeySpec);

        // Build and return signature.
        return Base64.getEncoder().encodeToString(hmacSha256.doFinal(message.getBytes(ENCODING)));
    }

    /**
     * Compute signature using SHA-1 algorithm.
     *
     * @param String the provided message
     * @return String
     * @throws NoSuchAlgorithmException
     */
    private static String sha1Hex(String src) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance(ALGO_SHA_1);

        byte[] bytes = src.getBytes(ENCODING);
        md.update(bytes, 0, bytes.length);

        return convertToHex(md.digest());
    }

    private static String convertToHex(byte[] sha1Hash) {
        StringBuilder builder = new StringBuilder();

        for (int i = 0; i < sha1Hash.length; i++) {
            byte c = sha1Hash[i];
            addHex(builder, c >> 4 & 0xf);
            addHex(builder, c & 0xf);
        }

        return builder.toString();
    }

    private static void addHex(StringBuilder builder, int c) {
        if (c < 10) {
            builder.append((char) (c + '0'));
        } else {
            builder.append((char) (c + 'a' - 10));
        }
    }
}

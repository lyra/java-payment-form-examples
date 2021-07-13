package com.lyra.examples.form.utils;

import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Enumeration;
import java.util.Map.Entry;
import java.util.Random;
import java.util.SortedMap;
import java.util.TreeMap;
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

    private static final String EXAMPLE_NAME = "Java_Form_Examples";
    private static final String EXAMPLE_VERSION = "1.0.0";

    private static final Random RANDOM = new SecureRandom();

    private static final Logger LOGGER = Logger.getLogger("UTILS");

    /**
     * Generate a random transaction ID from 1 to 899999.
     *
     * @return int the generated transaction ID
     */
    public static String generateTransId() {
        return String.format("%06d", RANDOM.ints(1, 899999 + 1).findFirst().getAsInt());
    }

    /**
     * Get example description to send as vads_contrib parameter in payment requests.
     *
     * @return a string
     */
    public static String contribParam() {
        return EXAMPLE_NAME + "_" + EXAMPLE_VERSION;
    }

    /**
     * Return true if the HTTP request parameters return a valid signature.
     *
     * @param request
     * @return true if the request in authentified
     */
    public static boolean isAuthentified(HttpServletRequest request) {
        String secretKey = "PRODUCTION".equals(AppUtils.getConfigProperty("ctx_mode")) ? AppUtils.getConfigProperty("key_prod")
                : AppUtils.getConfigProperty("key_test");

        String signAlgo = AppUtils.getConfigProperty("sign_algo");

        String receivedSignature = request.getParameter("signature");
        String calculatedSignature = buildSignature(request, secretKey, signAlgo);

        return calculatedSignature != null && calculatedSignature.equalsIgnoreCase(receivedSignature);
    }

    /**
     * Build signature from provided parameters and secret key. Parameters must be encoded in UTF-8.
     *
     * @param TreeMap<String, String> formParameters payment gateway request/response parameters
     * @param String secretKey shop key
     * @param String signAlgo signature algorithm
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

        // Sign.
        switch (signAlgo) {
            case ALGO_SHA_1:
                try {
                    return sha1Hex(message);
                } catch (NoSuchAlgorithmException e) {
                    LOGGER.severe("SHA-1 algorithm is not avilable: " + e.getMessage());
                }

                break;

            case ALGO_SHA_256:
                try {
                    return hmacSha256Base64(message, secretKey);
                } catch (InvalidKeyException | NoSuchAlgorithmException e) {
                    LOGGER.severe("An error occurred when trying to sign with HMAC-SHA-256: " + e.getMessage());
                }

                break;

            default:
                throw new IllegalArgumentException("Algorithm " + signAlgo + " is not supported.");
        }

        return null;
    }

    /**
     * Build signature from provided parameters and secret key. Parameters must be encoded in UTF-8.
     *
     * @param HttpServletRequest payment gateway parameters
     * @param String secretKey shop key
     * @param String signAlgo signature algorithm
     * @return String
     */
    public static String buildSignature(HttpServletRequest request, String secretKey, String signAlgo) {
        SortedMap<String, String> recievedFields = new TreeMap<>();

        // Collect and sort field names starting with vads_ in alphabetical order.
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            if (paramName.startsWith("vads_")) {
                recievedFields.put(paramName, request.getParameter(paramName));
            }
        }

        return buildSignature(recievedFields, secretKey, signAlgo);
    }

    /**
     * Compute signature using HMAC-SHA-256 algorithm.
     *
     * @param String message provided parameters
     * @param String secretKey shop key
     * @return String
     */
    public static String hmacSha256Base64(String message, String secretKey) throws NoSuchAlgorithmException, InvalidKeyException {
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

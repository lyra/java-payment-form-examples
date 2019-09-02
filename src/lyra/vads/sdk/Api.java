package lyra.vads.sdk;
import java.util.Base64;
import java.util.Hashtable;
import java.util.Random;

import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Enumeration;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.Map.Entry;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;

import java.io.UnsupportedEncodingException;
import java.util.TreeMap;

public class Api {
    String ALGO_SHA1 = "SHA-1";
    String ALGO_SHA256 = "SHA-256";

    public String[] SUPPORTED_ALGOS = {this.ALGO_SHA1, this.ALGO_SHA256};

    /**
     * The list of encodings supported by the API.
     *
     * @var array[string]
     */
    public static String[] SUPPORTED_ENCODINGS = {
        "UTF-8",
        "ASCII",
        "Windows-1252",
        "ISO-8859-15",
        "ISO-8859-1",
        "ISO-8859-6",
        "CP1256"
    };

    /**
     * Returns an array of languages accepted by the payment gateway.
     *
     * @return array[string][string]
     */
    public Hashtable<String, String> getSupportedLanguages()
    {
        Hashtable<String, String> languages = new Hashtable<String, String>();
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
     * @param string $lang
     * @return boolean
     */
    public boolean isSupportedLanguage(String lang)
    {
        return this.getSupportedLanguages().containsKey(lang);
    }

    /**
     * Generate a trans_id.
     * To be independent from shared/persistent counters, we use the number of 1/10 seconds since midnight
     * which has the appropriatee format (000000-899999) and has great chances to be unique.
     *
     * @param int $timestamp
     * @return string the generated trans_id
     */
    public int generateTransId()
    {
        //return UUID.randomUUID().toString();
        Random r = new Random();
        int id = r.ints(1, (899999 + 1)).findFirst().getAsInt();
        return id;
    }

    /**
     * Compute the signature. Parameters must be in UTF-8.
     *
     * @param array[string][string] $parameters payment gateway request/response parameters
     * @param string $key shop certificate
     * @param string $algo signature algorithm
     * @param boolean $hashed set to false to get the unhashed signature
     * @return string
     */
    /**
     * Build signature (HMAC SHA-256 version) from provided parameters and secret key.
     * Parameters are provided as a TreeMap (with sorted keys).
     */
    public static String buildSignature(TreeMap<String, String> formParameters, String
     secretKey, String signAlgo) throws NoSuchAlgorithmException, InvalidKeyException, UnsupportedEncodingException {
      // Build message from parameters
      for (Entry<String, String> entry : formParameters.entrySet()) {
          if(!entry.getKey().startsWith("vads_"))
            System.out.println("Key: " + entry.getKey() + ". Value: " + entry.getValue());
      }
      String message = String.join("+", formParameters.values());
      message += "+" + secretKey;
      // Sign
      if(signAlgo.matches("SHA-1")) {
          return encode(message);
      }else return hmacSha256Base64(message, secretKey);
     }

    public static String buildSignature(HttpServletRequest request, String secretKey, String signAlgo) {
        SortedSet<String> vadsFields = new TreeSet<String>();
        Enumeration<String> paramNames = request.getParameterNames();
        // Recupere et trie les noms des champs vads_* par ordre alphabetique
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            if (paramName.startsWith("vads_")) {
                vadsFields.add(paramName);
            }else {
                vadsFields.add("vads_" + paramName);
            }
        }
        // Calcule la signature
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
        if(signAlgo.matches("SHA-1")) {
            return encode(message);
        } else
            try {
                return hmacSha256Base64(message, secretKey);
            } catch (InvalidKeyException e) {
                e.printStackTrace();
                return "";
            } catch (NoSuchAlgorithmException e) {
                e.printStackTrace();
                return "";
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
                return "";
            }
    }
       /**
       * Actual signing operation.
       */
    public static String hmacSha256Base64(String message, String secretKey) throws
     NoSuchAlgorithmException, InvalidKeyException, UnsupportedEncodingException {
      // Prepare hmac sha256 cipher algorithm with provided secretKey
      Mac hmacSha256;
      try {
       hmacSha256 = Mac.getInstance("HmacSHA256");
      } catch (NoSuchAlgorithmException nsae) {
       hmacSha256 = Mac.getInstance("HMAC-SHA-256");
      }
      SecretKeySpec secretKeySpec = new SecretKeySpec(secretKey.getBytes("UTF-8"), "HmacSHA256");
      hmacSha256.init(secretKeySpec);
      // Build and return signature
      return Base64.getEncoder().encodeToString(hmacSha256.doFinal(message.getBytes("UTF-8")));
     }
    
    private static String encode(String src) {
        try {
            MessageDigest md;
            md = MessageDigest.getInstance("SHA-1");
            byte bytes[] = src.getBytes("UTF-8");
            md.update(bytes, 0, bytes.length);
            byte[] sha1hash = md.digest();
            return convertToHex(sha1hash);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private static String convertToHex(byte[] sha1hash) {
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < sha1hash.length; i++) {
            byte c = sha1hash[i];
            addHex(builder, (c >> 4) & 0xf);
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
    
    public static String hmacsha256(String stringToSign , String key ){
        try {
        byte[] bytes = encode256 ( key .getBytes( "UTF-8" ), stringToSign .getBytes( "UTF-8" ));
        return Base64.getEncoder().encodeToString( bytes );
        } catch (Exception e ){
        throw new RuntimeException( e );
        }
    }
    
    private static byte[] encode256(byte[]keyBytes, byte[] text ) throws
        NoSuchAlgorithmException, InvalidKeyException {
        Mac hmacSha1 ;
        try {
            hmacSha1 = Mac.getInstance ( "HmacSHA256" );
        } catch (NoSuchAlgorithmException nsae ){
            hmacSha1 = Mac.getInstance ( "HMAC-SHA-256" );
        }
        SecretKeySpec macKey = new SecretKeySpec( keyBytes, "RAW" );
        hmacSha1.init( macKey );
        return hmacSha1 .doFinal( text );
    }
    
    public static boolean isAuthentified() {
        return false;
        
    }
}

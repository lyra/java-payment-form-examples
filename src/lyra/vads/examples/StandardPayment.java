package lyra.vads.examples;

import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeMap;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lyra.vads.sdk.Api;
import lyra.vads.tools.MyLogger;
import lyra.vads.tools.ReadPropertyFile;

/**
 * Servlet implementation class StandardPayment
 */
@WebServlet("/StandardPayment")
public class StandardPayment extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(Logger.GLOBAL_LOGGER_NAME);
    private String key ;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StandardPayment() {
        super();
        try {
            MyLogger.setup();
            key = (ReadPropertyFile.getConfigProperty("ctx_mode") == "PRODUCTION") ? ReadPropertyFile.getConfigProperty("key_prod") : ReadPropertyFile.getConfigProperty("key_test");
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        TreeMap<String, String> requestData = new TreeMap<String, String>();
        //Prepare config parameters
        requestData.put("vads_site_id", ReadPropertyFile.getConfigProperty("site_id"));
        requestData.put("vads_ctx_mode", ReadPropertyFile.getConfigProperty("ctx_mode"));
        requestData.put("vads_return_mode", ReadPropertyFile.getConfigProperty("return_mode"));
        requestData.put("vads_url_return", ReadPropertyFile.getConfigProperty("url_return"));
        requestData.put("vads_action_mode", ReadPropertyFile.getConfigProperty("action_mode"));
        
        requestData.put("vads_version", "V2");
        requestData.put("vads_page_action", "PAYMENT");
        requestData.put("vads_payment_config", "SINGLE");
        requestData.put("vads_capture_delay", "0");
        
        ////Prepare orderinfo
        Map requestParameters = request.getParameterMap();
        Set s = requestParameters.entrySet();
        Iterator it = s.iterator();
        while(it.hasNext()){
            Map.Entry<String,String[]> entry = (Map.Entry<String,String[]>)it.next();
            String key = entry.getKey();
            String[] valuetab = entry.getValue();

            if(valuetab.length==1){
                String value = valuetab[0].toString();
                requestData.put(key, value);
            }
        }
        
        DateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
        Date dateobj = new Date();
        requestData.put("vads_trans_date", df.format(dateobj));
        requestData.put("vads_trans_id", "123459");

        // TODO Auto-generated method stub
        logger.info("Info Log");
        try {
            request.setAttribute("signature", Api.buildSignature(requestData, this.key, 
                    ReadPropertyFile.getConfigProperty("sign_algo")));
        } catch (InvalidKeyException | NoSuchAlgorithmException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        /* Création ou récupération de la session */
        request.setAttribute("parameters", requestData);
        request.setAttribute("url", ReadPropertyFile.getConfigProperty("platform_url"));
        
        for (Entry<String, String> entry : requestData.entrySet()) {
            System.out.println("Key: " + entry.getKey() + ". Value: " + entry.getValue());
        }
        
        this.getServletContext().getRequestDispatcher("/WEB-INF/form.jsp").forward(request, response);
    }
}

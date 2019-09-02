package lyra.vads.examples;

import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.Map.Entry;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lyra.vads.sdk.Api;
import lyra.vads.tools.Tools;

/**
 * Servlet implementation class MultiPayment
 */
@WebServlet("/MultiPayment")
public class MultiPayment extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(Logger.GLOBAL_LOGGER_NAME);
    private String key ;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MultiPayment() {
        super();
        try {
            Tools.setupLogger();
            key = (Tools.getConfigProperty("ctx_mode") == "PRODUCTION") ? Tools.getConfigProperty("key_prod") : Tools.getConfigProperty("key_test");
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
        requestData.put("vads_site_id", Tools.getConfigProperty("site_id"));
        requestData.put("vads_ctx_mode", Tools.getConfigProperty("ctx_mode"));
        requestData.put("vads_return_mode", Tools.getConfigProperty("return_mode"));
        requestData.put("vads_url_return", Tools.getConfigProperty("url_return"));
        requestData.put("vads_action_mode", Tools.getConfigProperty("action_mode"));
        
        requestData.put("vads_version", "V2");
        requestData.put("vads_page_action", "PAYMENT");
        requestData.put("vads_payment_config", "SINGLE");
        requestData.put("vads_capture_delay", "0");
        
        Integer total_in_cents = Integer.valueOf(request.getParameter("vads_amount"));
        Integer first = 50;
        Integer count = 2;
        Integer period = 30;
        // Set value to payment_config.
        String first_in_cents = String.valueOf(Math.round(total_in_cents / count));
        
        requestData.put("vads_payment_config", "MULTI:first=" + first_in_cents + ";count=" + String.valueOf(count) + ";period=" + String.valueOf(period));
        
        ////Prepare orderinfo
        Map requestParameters = request.getParameterMap();
        Set s = requestParameters.entrySet();
        Iterator it = s.iterator();
        while(it.hasNext()){
            Map.Entry<String,String[]> entry = (Map.Entry<String,String[]>)it.next();
            String key = entry.getKey();
            String[] valuetab = entry.getValue();

            if(valuetab.length==1 && (key.indexOf("vads_") == 0)){
                String value = valuetab[0].toString();
                requestData.put(key, value);
            }
        }
        
        DateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
        Date dateobj = new Date();
        requestData.put("vads_trans_date", df.format(dateobj));
        requestData.put("vads_trans_id", "123459");

        //iframe mode
        if (Tools.getConfigProperty("action_mode") == "IFRAME") {
            // hide logos below payment fields
            requestData.put("vads_theme_config", "3DS_LOGOS=false;");

            // enable automatic redirection
            requestData.put("vads_redirect_enabled", "1");
            requestData.put("vads_redirect_success_timeout", "0");
            requestData.put("vads_redirect_error_timeout", "0");

            String return_url = (String) requestData.get("url_return");
            String sep = (return_url.indexOf("?") < 0) ? "?" : "&";
            requestData.put("vads_url_return", return_url + sep + "content_only=1");
        }

        // TODO Auto-generated method stub
        logger.info("Info Log");
        try {
            request.setAttribute("signature", Api.buildSignature(requestData, this.key, 
                    Tools.getConfigProperty("sign_algo")));
        } catch (InvalidKeyException | NoSuchAlgorithmException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        /* Création ou récupération de la session */
        request.setAttribute("parameters", requestData);
        request.setAttribute("url", Tools.getConfigProperty("platform_url"));
        
        for (Entry<String, String> entry : requestData.entrySet()) {
            System.out.println("Key: " + entry.getKey() + ". Value: " + entry.getValue());
        }
        
        this.getServletContext().getRequestDispatcher("/WEB-INF/form.jsp").forward(request, response);
    }

}

package com.lyra.examples.form.servlet;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map.Entry;
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lyra.examples.form.error.PaymentException;
import com.lyra.examples.form.utils.AppUtils;
import com.lyra.examples.form.utils.GatewayUtils;

public class AbstractPayment extends HttpServlet {
    private static final long serialVersionUID = 3001397242282228346L;

    protected static final Logger LOGGER = Logger.getLogger("PAYMENT");

    /**
     * @see HttpServlet#HttpServlet()
     */
    public AbstractPayment() {
        super();

        AppUtils.setupLogger(LOGGER);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        TreeMap<String, String> data = null;

        try {
            data = fillForm(request);
        } catch (PaymentException e) {
            // Manage exception here with a clean error page.
            LOGGER.log(Level.SEVERE, "Error when trying to fill form data.", e);
            return;
        }

        String key = "PRODUCTION".equals(AppUtils.getConfigProperty("ctx_mode")) ? AppUtils.getConfigProperty("key_prod")
                : AppUtils.getConfigProperty("key_test");

        String signature = GatewayUtils.buildSignature(data, key, AppUtils.getConfigProperty("sign_algo"));
        if (signature == null) {
            // Manage exception here with a clean error page.
            LOGGER.severe("Unable to compute the request signature.");
            return;
        }

        request.setAttribute("signature", signature);

        request.setAttribute("parameters", data);
        request.setAttribute("url", AppUtils.getConfigProperty("gateway_url"));

        for (Entry<String, String> entry : data.entrySet()) {
            LOGGER.info("Key: " + entry.getKey() + ", value: " + entry.getValue());
        }

        try {
            this.getServletContext().getRequestDispatcher("/WEB-INF/form.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            // Manage exception here with a clean error page.
            LOGGER.log(Level.SEVERE, "Unable to load redirection form.", e);
        }
    }

    protected TreeMap<String, String> fillForm(HttpServletRequest request) {
        TreeMap<String, String> data = new TreeMap<>();

        // Prepare config parameters
        data.put("vads_site_id", AppUtils.getConfigProperty("site_id"));
        data.put("vads_ctx_mode", AppUtils.getConfigProperty("ctx_mode"));
        data.put("vads_return_mode", AppUtils.getConfigProperty("return_mode"));
        data.put("vads_url_cancel", AppUtils.getConfigProperty("url_cancel"));
        data.put("vads_url_return", AppUtils.getConfigProperty("url_return"));
        data.put("vads_action_mode", AppUtils.getConfigProperty("action_mode"));

        data.put("vads_version", "V2");
        data.put("vads_page_action", "PAYMENT");
        data.put("vads_capture_delay", "0"); // Number of days.
        data.put("vads_validation_mode", ""); // Blank: default Back Office value, 0: automatic, 1: manual.

        // Prepare payment information.
        for (Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            String key = entry.getKey();
            String[] values = entry.getValue();

            if (values.length == 1 && key.indexOf("vads_") == 0) {
                data.put(key, values[0]);
            }
        }

        DateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
        data.put("vads_trans_date", df.format(new Date()));
        data.put("vads_trans_id", GatewayUtils.generateTransId());

        // Iframe mode.
        if ("IFRAME".equals(AppUtils.getConfigProperty("action_mode"))) {
            // Hide logos below payment fields.
            data.put("vads_theme_config", "3DS_LOGOS=false;");

            // Enable automatic redirection.
            data.put("vads_redirect_success_timeout", "0");
            data.put("vads_redirect_error_timeout", "0");
        }

        data.put("vads_contrib", GatewayUtils.contribParam());

        return data;
    }
}

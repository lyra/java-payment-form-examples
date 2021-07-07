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
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lyra.examples.form.utils.AppUtils;
import com.lyra.examples.form.utils.GatewayUtils;

/**
 * Servlet implementation class for payments in installments.
 */
@WebServlet("/MultiPayment")
public class MultiPayment extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final Logger LOGGER = Logger.getLogger(MultiPayment.class.getName());

    /**
     * @see HttpServlet#HttpServlet()
     */
    public MultiPayment() {
        super();

        AppUtils.setupLogger(LOGGER);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     *      response)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        TreeMap<String, String> requestData = new TreeMap<>();

        // Prepare config parameters
        requestData.put("vads_site_id", AppUtils.getConfigProperty("site_id"));
        requestData.put("vads_ctx_mode", AppUtils.getConfigProperty("ctx_mode"));
        requestData.put("vads_return_mode", AppUtils.getConfigProperty("return_mode"));
        requestData.put("vads_url_return", AppUtils.getConfigProperty("url_return"));
        requestData.put("vads_action_mode", AppUtils.getConfigProperty("action_mode"));

        requestData.put("vads_version", "V2");
        requestData.put("vads_page_action", "PAYMENT");
        requestData.put("vads_payment_config", "SINGLE");
        requestData.put("vads_capture_delay", "0");

        double totalInCents = 0;
        try {
            totalInCents = Integer.valueOf(request.getParameter("vads_amount"));
        } catch (NumberFormatException e) {
            // Manage error here.
            LOGGER.log(Level.SEVERE, e, () -> "Invalid received amount: " + request.getParameter("vads_amount"));
        }

        // You can manage payment options here.
        double first = 50; // 50% from the total amount.
        int count = 3; // Total number of payments.
        int period = 30; // Number of days between payments.

        long firstInCents = Math.round(first / 100 * totalInCents);

        // Set value to payment_config.
        requestData.put("vads_payment_config", "MULTI:first=" + firstInCents + ";count=" + count + ";period=" + period);

        // Prepare payment information.
        for (Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            String key = entry.getKey();
            String[] values = entry.getValue();

            if (values.length == 1 && key.indexOf("vads_") == 0) {
                requestData.put(key, values[0]);
            }
        }

        DateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
        String date = df.format(new Date());
        requestData.put("vads_trans_date", date);
        requestData.put("vads_trans_id", GatewayUtils.generateTransId());

        // Iframe mode.
        if ("IFRAME".equals(AppUtils.getConfigProperty("action_mode"))) {
            // Hide logos below payment fields.
            requestData.put("vads_theme_config", "3DS_LOGOS=false;");

            // Enable automatic redirection.
            requestData.put("vads_redirect_success_timeout", "0");
            requestData.put("vads_redirect_error_timeout", "0");
        }

        String key = "PRODUCTION".equals(AppUtils.getConfigProperty("ctx_mode"))
                ? AppUtils.getConfigProperty("key_prod")
                : AppUtils.getConfigProperty("key_test");

        String signature = GatewayUtils.buildSignature(requestData, key, AppUtils.getConfigProperty("sign_algo"));
        if (signature == null) {
            // Manage error here.
            LOGGER.severe("Unable to compute request signature.");
        }

        request.setAttribute("signature", signature);

        request.setAttribute("parameters", requestData);
        request.setAttribute("url", AppUtils.getConfigProperty("gateway_url"));

        for (Entry<String, String> entry : requestData.entrySet()) {
            LOGGER.info("Key: " + entry.getKey() + ", value: " + entry.getValue());
        }

        try {
            this.getServletContext().getRequestDispatcher("/WEB-INF/form.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            // Manage error here.
            LOGGER.log(Level.SEVERE, "Unable to load redirection form.", e);
        }
    }
}

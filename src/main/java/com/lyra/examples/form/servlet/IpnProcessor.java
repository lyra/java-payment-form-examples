package com.lyra.examples.form.servlet;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Enumeration;
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
 * Servlet implementation class to manage payment IPN calls.
 */
@WebServlet("/ipn-processor")
public class IpnProcessor extends HttpServlet {
    private static final long serialVersionUID = 2450928985914849143L;

    protected static final Logger LOGGER = Logger.getLogger("IPN");

    /**
     * @see HttpServlet#HttpServlet()
     */
    public IpnProcessor() {
        super();

        AppUtils.setupLogger(LOGGER);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // We receive UTF-8 from gateway.
            request.setCharacterEncoding("UTF-8");
        } catch (UnsupportedEncodingException e) {
            // Manage exception here with a clean error page.
            LOGGER.log(Level.SEVERE, "Unsupported enconding set to request.", e);
            return;
        }

        // Log all received parameters.
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            LOGGER.info(() -> "Key: " + paramName + ", value: " + request.getParameter(paramName));
        }

        // Check signature.
        if (GatewayUtils.isAuthentified(request)) {
            // Response is autheticated.
            // Manage the order according to the payment result.

            // The write something about the status of the order processing.
            try {
                response.getWriter().append("Order successfully processed.");
            } catch (IOException e) {
                // Manage exception here with a clean error page.
                LOGGER.log(Level.SEVERE, "Unable to write to response.", e);
            }
        } else {
            // Log and ignore the response.
            LOGGER.log(Level.WARNING, "Invalid signature received.");
        }
    }
}

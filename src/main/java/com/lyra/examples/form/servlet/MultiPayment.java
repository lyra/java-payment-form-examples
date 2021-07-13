package com.lyra.examples.form.servlet;

import java.util.TreeMap;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

import com.lyra.examples.form.error.PaymentException;

/**
 * Servlet implementation class for payments in installments.
 */
@WebServlet("/MultiPayment")
public class MultiPayment extends AbstractPayment {
    private static final long serialVersionUID = 7489239157000662431L;

    @Override
    protected TreeMap<String, String> fillForm(HttpServletRequest request) {
        TreeMap<String, String> data = super.fillForm(request);

        double totalInCents = 0;
        try {
            // The already set total amount.
            totalInCents = Integer.valueOf(data.get("vads_amount"));
        } catch (NumberFormatException e) {
            throw new PaymentException("Invalid received amount: " + data.get("vads_amount"), e);
        }

        // Manage here custom payment options.
        double first = 50; // In percentage of the total amount.
        int period = 30; // Number of days between payments.
        int count = "multi4".equals(request.getParameter("payment_method")) ? 4 : 3; // Total number of payments.

        long firstInCents = Math.round(first / 100 * totalInCents);

        // Set value to payment_config.
        data.put("vads_payment_config", "MULTI:first=" + firstInCents + ";count=" + count + ";period=" + period);

        return data;
    }
}

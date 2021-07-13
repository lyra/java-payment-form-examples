package com.lyra.examples.form.servlet;

import java.util.TreeMap;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

/**
 * Servlet implementation class for standard payments.
 */
@WebServlet("/StandardPayment")
public class StandardPayment extends AbstractPayment {
    private static final long serialVersionUID = -7791685372845073413L;

    @Override
    protected TreeMap<String, String> fillForm(HttpServletRequest request) {
        TreeMap<String, String> data = super.fillForm(request);

        data.put("vads_payment_config", "SINGLE");

        return data;
    }
}

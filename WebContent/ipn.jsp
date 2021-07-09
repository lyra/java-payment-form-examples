<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.util.Map" %>
<%@page import="com.lyra.examples.form.utils.GatewayUtils"%>

<%
Map<String, String[]> parameters = request.getParameterMap();
for (String parameter : parameters.keySet()) {
    String[] values = parameters.get(parameter);

    // Log the rerponse parameters.
    System.out.println("--> Key [" + parameter + "] has for value [" + values[0] + "]");
}

boolean authentified = GatewayUtils.isAuthentified(request);
if (authentified) {
    // Response is autheticated. Manage the order according to the payment result.
} else {
    // Log and ignore the response.
}

%>
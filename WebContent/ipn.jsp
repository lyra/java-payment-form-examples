<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.util.Map" %>

<%
Map<String, String[]> parameters = request.getParameterMap();
for (String parameter : parameters.keySet()) {
    String[] values = parameters.get(parameter);
    System.out.println("--> Key [" + parameter + "] has for value [" + values[0] + "]");
}
%>
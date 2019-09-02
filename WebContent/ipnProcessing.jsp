<%@ page import = "java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
Map<String, String[]> parameters = request.getParameterMap();
for(String parameter : parameters.keySet()) {
    String[] values = parameters.get(parameter);
    System.out.println("--> La clée [" + parameter + "] a pour la valeur [" + values[0] + "]");
}
%>
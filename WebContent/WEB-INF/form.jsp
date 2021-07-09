<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.lyra.examples.form.utils.AppUtils" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="lang" value="${not empty parameters.vads_language ? parameters.vads_language : 'en'}" scope="session" />

<fmt:requestEncoding value="UTF-8" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="i18n/messages"/>

<%
String debug = AppUtils.getConfigProperty("debug");
%>

<!DOCTYPE html>
<html lang="${lang}">
<head>
    <title><fmt:message key="form_page_title" /></title>

    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

    <!-- Custom styles -->
    <link href="assets/css/style.css" rel="stylesheet" type="text/css" />
</head>
<body style="padding: 10%; padding-top: 0%;">
    <% if (debug.equals("true")) { %><h1 style="text-align: center;"><fmt:message key="payment_form_title" /></h1><% } %>

    <div class="panel">
        <form name="paymentForm" id="paymentForm" action="${url}" method="post">
            <% if (debug.equals("false")) { %>
                <c:forEach var="p" items="${parameters}">
                    <input name="${p.key}" value="${p.value}" type="hidden" />
                </c:forEach>

                <input name="signature" value="${signature}" type="hidden" />

                <label style="text-align: center;"><fmt:message key="gateway_redirect_message" /></label>
            <% } else { %>
                <div class="col-md-12 row">
                    <c:forEach var="p" items="${parameters}">
                        <div class="col-sm-6 form-group">
	                        <label for="${p.key}">${p.key}</label>
	                        <input class="form-control" name="${p.key}" value="${p.value}" type="text" readonly />
                        </div>
                    </c:forEach>

                    <div class="col-sm-6 form-group">
                        <label for="signature">signature</label>
                        <input class="form-control" name="signature" value="${signature}" type="text" readonly />
                    </div>
                </div>

                <div class="col-md-12 text-center">
                    <input class="btn btn-primary mb-2" type="submit" value="<fmt:message key="button_submit_form" />" />
                </div>
            <% } %>
        </form>
    </div>

    <% if (debug.equals("false")) { %>
        <script>
            window.onload = function() {
                document.paymentForm.submit();
            };
        </script>
    <% } %>
</body>
</html>
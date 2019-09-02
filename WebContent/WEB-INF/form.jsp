<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="lyra.vads.tools.Tools" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="lang" value="${not empty parameters.vads_language ? parameters.vads_language : 'en'}" scope="session" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages"/>

<% String debug = Tools.getConfigProperty("debug");%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title style="align"><fmt:message key="label.paymentform" /></title>
<link href="assets/css/style.css" rel="stylesheet" type="text/css"/>
</head>
<body style="padding: 10%; padding-top: 0%">
    <h1 style="text-align: center;"><fmt:message key="label.paymentform" /></h1>
    <form name="paymentForm" id="paymentForm" action="${url}" method="post">

        <c:forEach var="p" items="${parameters}">
            <label style="width:50%" for="${p.key}">${p.key}</label>
            <input style="width:100%" class="forminput" name="${p.key}" value="${p.value}" type="text" />
            <br>
        </c:forEach>
        <label style="width:50%" for="signature">signature</label>
        <input style="width:100%" class="forminput" name="signature" value="${signature}" type="text" />
        
        <input class="forminput" type="submit" value="<fmt:message key="label.sendform" />"/>
    </form>
    
    <c:if test="${debug=='false'}">
        <script type="text/javascript">window.onload = function(){document.paymentForm.submit();};</script>
    </c:if>
</body>
</html>
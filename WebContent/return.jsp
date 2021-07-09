<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import = "java.util.Map" %>
<%@page import="com.lyra.examples.form.utils.GatewayUtils"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>

<c:set var="lang" value="${not empty request.vads_language ? request.vads_language : not empty lang  ? lang : pageContext.request.locale}" scope="session" />

<fmt:requestEncoding value="UTF-8" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="i18n/messages"/>

<%
Map<String, String[]> parameters = request.getParameterMap();

boolean authentified = GatewayUtils.isAuthentified(request);
if (authentified) {
%>
    <c:set var="authStatus" value="sign_auth_valid" scope="request" />
    <c:set var="transStatus" value="trans_status_${(not empty param.vads_trans_status) ? fn:toLowerCase(param.vads_trans_status) : 'none'}" scope="request" />
    <c:set var="result" value="result_${(not empty param.vads_result) ? param.vads_result : 'none'}" scope="request" />
    <c:set var="authResult" value="auth_result_${(not empty param.vads_auth_result) ? param.vads_auth_result : 'none'}" scope="request" />
    <c:set var="paymentConfig" value="${(not empty param.vads_payment_config && fn:contains(param.vads_payment_config, 'MULTI')) ? 'payment_config_multi' : 'payment_config_single'}" scope="request" />
    <c:set var="warrantyResult" value="warranty_result_${(not empty param.vads_warranty_result) ? fn:toLowerCase(param.vads_warranty_result) : 'none'}" scope="request" />
    <c:set var="threedsStatus" value="threeds_status_${(not empty param.vads_threeds_status) ? fn:toLowerCase(param.vads_threeds_status) : 'none'}" scope="request" />
    <c:set var="captureDelay" value="${(not empty param.vads_capture_delay) ? param.vads_capture_delay : ''}" scope="request" />
    <c:set var="validationMode" value="validation_mode_${(not empty param.vads_validation_mode) ? fn:toLowerCase(param.vads_validation_mode) : 'none'}" scope="request" />
<% } else { %>
    <c:set var="authStatus" value="sign_auth_invalid" scope="request" />
<% } %>
<!DOCTYPE html>
<html lang="${lang}">
<head>
    <title><fmt:message key="return_page_title" /></title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <script defer src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script defer src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
    <script defer src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>

    <!-- Custom styles -->
    <link href="assets/css/style.css" rel="stylesheet" type="text/css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
  <a class="navbar-brand" href="">Lyra</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item show">
        <a class="nav-link" target="_blank" href="https://github.com/lyra">Github</a>
      </li>
    </ul>

    <ul class="navbar-nav">
      <li class="nav-item dropdown show ">
          <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
            <fmt:message key="lang_${lang}" />
          </a>
          <div class="dropdown-menu dropdown-menu-right">
            <a class="dropdown-item" href="?lang=en"><fmt:message key="lang_en" /></a>
            <a class="dropdown-item" href="?lang=fr"><fmt:message key="lang_fr" /></a>
            <a class="dropdown-item" href="?lang=de"><fmt:message key="lang_de" /></a>
            <a class="dropdown-item" href="?lang=es"><fmt:message key="lang_es" /></a>
          </div>
      </li>
    </ul>
  </div>
</nav>

<!-- Page content -->
<div class="container">
    <div class="row">
        <div class="col-lg-12">
            <h1><fmt:message key="payment_response_title" /></h1>

            <button type="button" class="accordion"><fmt:message key="sign_auth_title" /></button>
            <div class="panel" style="display: block;">
                <label style="width: 20%; text-align: right;"><fmt:message key="sign_auth_label" />: </label>
                <label style="vertical-align: middle;"><fmt:message key="${authStatus}" /></label>
            </div>

            <% if (authentified) { %>
            <button type="button" class="accordion"><fmt:message key="response_analysis_title" /></button>
            <div class="panel" style="display: block;">
                <label style="width: 20%; text-align: right;" for="vads_trans_status">vads_trans_status: </label>
                <input class="forminput" type="text" id="vads_trans_status" name="vads_trans_status" value="<%=request.getParameter("vads_trans_status")%>"  readonly>
                <label style="width: 55%; vertical-align: middle;" for="vads_trans_status"><fmt:message key="trans_status_label" />: <fmt:message key="${transStatus}" /></label><br />

                <label style="width: 20%; text-align: right;" for="vads_result">vads_result: </label>
                <input class="forminput" type="text" id="vads_result" name="vads_result" value="<%=request.getParameter("vads_result")%>"  readonly>
                <label style="width: 55%; vertical-align: middle;" for="vads_result"><fmt:message key="result_label" />: <fmt:message key="${result}" /></label><br />

                <label style="width: 20%; text-align: right;" for="vads_trans_id">vads_trans_id: </label>
                <input class="forminput" type="text" id="vads_trans_id" name="vads_trans_id" value="<%=request.getParameter("vads_trans_id")%>"  readonly>
                <label style="width: 55%; vertical-align: middle;" for="vads_trans_id"><fmt:message key="trans_id_label" /></label><br />

                <label style="width: 20%; text-align: right;" for="vads_amount">vads_amount: </label>
                <input class="forminput" type="text" id="vads_amount" name="vads_amount" value="<%=request.getParameter("vads_amount")%>" readonly>
                <label style="width: 55%; vertical-align: middle;" for="vads_amount"><fmt:message key="amount_label" /></label><br />

                <label style="width: 20%; text-align: right;" for="vads_effective_amount">vads_effective_amount: </label>
                <input class="forminput" type="text" id="vads_effective_amount" name="vads_effective_amount" value="<%=request.getParameter("vads_effective_amount")%>" readonly>
                <label style="width: 55%; vertical-align: middle;" for="vads_effective_amount"><fmt:message key="effective_amount_label" />: <fmt:message key="effective_amount_desc" /></label><br />

                <label style="width: 20%; text-align: right;" for="vads_payment_config">vads_payment_config: </label>
                <input class="forminput" type="text" id="vads_payment_config" name="vads_payment_config" value="<%=request.getParameter("vads_payment_config")%>" readonly>
                <label style="width: 55%; vertical-align: middle;" for="vads_payment_config"><fmt:message key="payment_config_label" />: <fmt:message key="${paymentConfig}" /></label><br />

                <label style="width: 20%; text-align: right;" for="vads_sequence_number">vads_sequence_number: </label>
                <input class="forminput" type="text" id="vads_sequence_number" name="vads_sequence_number" value="<%=request.getParameter("vads_sequence_number")%>" readonly>
                <label style="width: 55%; vertical-align: middle;" for="vads_sequence_number"><fmt:message key="sequence_number_label" /></label><br />

                <label style="width: 20%; text-align: right;" for="vads_auth_result">vads_auth_result: </label>
                <input class="forminput" type="text" id="vads_auth_result" name="vads_auth_result" value="<%=request.getParameter("vads_auth_result")%>" readonly>
                <label style="width: 55%; vertical-align: middle;" for="vads_auth_result"><fmt:message key="auth_result_label" />: <fmt:message key="${authResult}" /></label><br />

                <label style="width: 20%; text-align: right;" for="vads_warranty_result">vads_warranty_result: </label>
                <input class="forminput" type="text" id="vads_warranty_result" name="vads_warranty_result" value="<%=request.getParameter("vads_warranty_result")%>" readonly>
                <label style="width: 55%; vertical-align: middle;" for="vads_warranty_result"><fmt:message key="warranty_result_label" />: <fmt:message key="${warrantyResult}" /></label><br />

                <label style="width: 20%; text-align: right;" for="vads_threeds_status">vads_threeds_status: </label>
                <input class="forminput" type="text" id="vads_threeds_status" name="vads_threeds_status" value="<%=request.getParameter("vads_threeds_status")%>" readonly>
                <label style="width: 55%; vertical-align: middle;" for="vads_threeds_status"><fmt:message key="threeds_status_label" />: <fmt:message key="${threedsStatus}" /></label><br />

                <label style="width: 20%; text-align: right;" for="vads_capture_delay">vads_capture_delay: </label>
                <input class="forminput" type="text" id="vads_capture_delay" name="vads_capture_delay" value="<%=request.getParameter("vads_capture_delay")%>" readonly>
                <label style="width: 55%; vertical-align: middle;" for="vads_capture_delay"><fmt:message key="capture_delay_label" />: ${captureDelay} <fmt:message key="days_label" /></label><br />

                <label style="width: 20%; text-align: right;" for="vads_validation_mode">vads_validation_mode: </label>
                <input class="forminput" type="text" id="vads_validation_mode" name="vads_validation_mode" value="<%=request.getParameter("vads_validation_mode")%>" readonly>
                <label style="width: 55%; vertical-align: middle;" for="vads_validation_mode"><fmt:message key="validation_mode_label" />: <fmt:message key="${validationMode}" /></label><br />
            </div>

            <button type="button" class="accordion"><fmt:message key="response_params_title" /></button>
            <div class="panel" style="display: block;">
                <%for (String parameter : parameters.keySet()) { String[] values = parameters.get(parameter); %>
                    <label style="width: 30%; text-align: right; vertical-align: top;"><%=parameter%> : </label>
                    <label style="width: 65%; vertical-align: top;"><%=values[0]%></label>
                    <br />
                <%}%>
            </div>
            <% }%>

            <hr />
            <h2><fmt:message key="payment_analysis_title" /></h2>
            <div id="info">
                <strong><fmt:message key="ipn_subtitle" /></strong><br />
                <p><fmt:message key="ipn_paragraph" /></p>

                <strong><fmt:message key="return_url_subtitle" /></strong><br />
                <p><fmt:message key="return_url_paragraph" /></p>
                <p><fmt:message key="return_url_paragraph2" /></p>

                <strong><fmt:message key="find_help_subtitle" /></strong><br />
                <p><fmt:message key="find_help_paragraph" /></p>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" src="assets/js/script.js"></script>
</body>
</html>
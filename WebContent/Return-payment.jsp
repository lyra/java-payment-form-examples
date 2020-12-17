<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.util.Map" %>
<%@ page import = "com.lyra.vads.sdk.Api" %>
<%@ page import = "com.lyra.vads.tools.Tools" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>

<c:set var="lang" value="${not empty request.vads_language ? request.vads_language : not empty lang  ? lang :
                        pageContext.request.locale}" scope="session" />
<fmt:requestEncoding value="UTF-8" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages"/>

<% Map<String, String[]> parameters = request.getParameterMap();%>
<% boolean authentified = Tools.isAuthentified(request);%>
<% if(authentified==true){%>
    <c:set var="authStatus" value="label.validsign" scope="session" />
    <c:set var="transStatus" value="label.${(not empty param.vads_trans_status) ? fn:toLowerCase(param.vads_trans_status) : 'none'}" scope="session" />
    <c:set var="authResult" value="label.vads_auth_result_${(not empty param.vads_auth_result) ? param.vads_auth_result : 'none'}" scope="session" />
    <c:set var="result" value="label.${(not empty param.vads_result) ? param.vads_result : 'none'}" scope="session" />
    
    <c:set var="paymentConfig" value="${(fn:contains(param.vads_payment_config,'SINGLE') && not empty param.vads_payment_config) ? 'label.standard' : (fn:contains(param.vads_payment_config,'MULTI')) ? 'label.multi' : '' }" scope="session" />
    
    <c:set var="warrantyResult" value="label.vads_warranty_result_${(not empty param.vads_warranty_result) ? fn:toLowerCase(param.vads_warranty_result) : 'x'}" scope="session" />
    <c:set var="threedsStatus" value="label.vads_threeds_status_${(not empty param.vads_threeds_status) ? fn:toLowerCase(param.vads_threeds_status) : 'x'}" scope="session" />
    <c:set var="captureDelay" value="${(not empty param.vads_capture_delay) ? param.vads_capture_delay : ''}" scope="session" />
    <c:set var="validationMode" value="label.vads_validation_mode_${(not empty param.vads_validation_mode) ? fn:toLowerCase(param.vads_validation_mode) : 'x'}" scope="session" />
<% }else{%>
    <c:set var="authStatus" value="label.invalidsigndesc" scope="session" />
<% }%>
<!DOCTYPE html>
<html lang="${lang}">
<head>
    <meta charset="utf-8" />
    <title>Lyra - VADS PAYMENT JAVA</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <script defer src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script defer src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
    <script defer src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"></script>
    <!-- Custom CSS -->
    <link rel="stylesheet" type="text/css" href="assets/css/style.css">
</head>
<body>
<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
  <a class="navbar-brand" href="#">Lyra</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <ul class="navbar-nav mr-auto">
      <li class="nav-item dropdown show">
          <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
            <fmt:message key="label.contactus" />
          </a>
          <div class="dropdown-menu">
              <a class="dropdown-item" target="_blank" href="https://payzen.io/en-EN/support/">English</a>
              <a class="dropdown-item" target="_blank" href="https://payzen.io/fr-FR/support/">French</a>
              <a class="dropdown-item" target="_blank" href="https://payzen.io/de-DE/support/">German</a>
              <a class="dropdown-item" target="_blank" href="https://payzen.io/pt-BR/support/">Portugese</a>
              <a class="dropdown-item" target="_blank" href="https://payzen.io/es-CL/support/">Spanish</a>
          </div>
      </li>
      <li class="nav-item">
        <a class="nav-link" target="_blank" href="https://github.com/lyra">Github</a>
      </li>
    </ul>
    
    <div class="navbar-nav">
        <li class="nav-item">
            <a class="nav-link" href="#">${lang}</a>
        </li>
    </div>
    
    
  </div>
</nav>

<!-- Page Content -->
<div class="container">

    <div class="row">
        <div class="col-lg-12">
            <h1><fmt:message key="label.formexampleresponse" /> </h1>
            <button type="button" class="accordion">Check Authentification</button>
            <div class="panel">
            <table class="table">
                <tr>
                    <td> <fmt:message key="label.auth" /> </td>
                    <td> <fmt:message key="${authStatus}" /> </td>
                </tr>
            </table>
            </div>
            <% if(authentified==true){%>
            <button type="button" class="accordion"><fmt:message key="label.responsessettings" /></button>
            <div class="panel">
                    <label style="width: 20%" for="vads_trans_status">vads_trans_status</label>
                    <input class="forminput" type="text" id="vads_trans_status" name="vads_trans_status" value="<%=request.getParameter("vads_trans_status")%>"  readonly>
                    <label style="width: 55%; vertical-align: middle;" for="vads_trans_status"><fmt:message key="label.vads_trans_status" />  : <fmt:message key="${transStatus}" />  </label><br>
                    
                    <label style="width: 20%" for="vads_result">vads_result</label>
                    <input class="forminput" type="text" id="vads_result" name="vads_result" value="<%=request.getParameter("vads_result")%>"  readonly>
                    <label style="width: 55%; vertical-align: middle;" for="vads_result"><fmt:message key="label.result" />  : <fmt:message key="${result}" /> </label><br>

                    <label style="width: 20%" for="vads_trans_id">vads_trans_id</label>
                    <input class="forminput" type="text" id="vads_trans_id" name="vads_trans_id" value="<%=request.getParameter("vads_trans_id")%>"  readonly>
                    <label style="width: 55%; vertical-align: middle;" for="vads_trans_id"><fmt:message key="label.vads_trans_id" /></label><br>

                    <label style="width: 20%" for="vads_amount">vads_amount</label>
                    <input class="forminput" type="text" id="vads_amount" name="vads_amount" value="<%=request.getParameter("vads_amount")%>" readonly>
                    <label style="width: 55%; vertical-align: middle;" for="vads_amount"><fmt:message key="label.vads_amount" /> </label><br>

                    <label style="width: 20%" for="vads_effective_amount">vads_effective_amount</label>
                    <input class="forminput" type="text" id="vads_effective_amount" name="vads_effective_amount" value="<%=request.getParameter("vads_effective_amount")%>" readonly>
                    <label style="width: 55%; vertical-align: middle;" for="vads_effective_amount"><fmt:message key="label.vads_effective_amount" /> <fmt:message key="label.vads_effective_amount_desc" /></label><br>

                    <label style="width: 20%" for="vads_payment_config">vads_payment_config</label>
                    <input class="forminput" type="text" id="vads_payment_config" name="vads_payment_config" value="<%=request.getParameter("vads_payment_config")%>" readonly>
                    <label style="width: 55%; vertical-align: middle;" for="vads_payment_config"><fmt:message key="label.vads_payment_config" />  : <fmt:message key="${paymentConfig}" /> </label><br>

                    <label style="width: 20%" for="vads_sequence_number">vads_sequence_number</label>
                    <input class="forminput" type="text" id="vads_sequence_number" name="vads_sequence_number" value="<%=request.getParameter("vads_sequence_number")%>" readonly>
                    <label style="width: 55%; vertical-align: middle;" for="vads_sequence_number"><fmt:message key="label.vads_sequence_number" /></label><br>

                    <label style="width: 20%" for="vads_auth_result">vads_auth_result</label>
                    <input class="forminput" type="text" id="vads_auth_result" name="vads_auth_result" value="<%=request.getParameter("vads_auth_result")%>" readonly>
                    <label style="width: 55%; vertical-align: middle;" for="vads_auth_result"><fmt:message key="label.vads_auth_result" />  : <fmt:message key="${authResult}" /></label><br>

                    <label style="width: 20%" for="vads_warranty_result">vads_warranty_result</label>
                    <input class="forminput" type="text" id="vads_warranty_result" name="vads_warranty_result" value="<%=request.getParameter("vads_warranty_result")%>" readonly>
                    <label style="width: 55%; vertical-align: middle;" for="vads_warranty_result"><fmt:message key="label.vads_warranty_result" />  : <fmt:message key="${warrantyResult}" /></label><br>

                    <label style="width: 20%" for="vads_threeds_status">vads_threeds_status</label>
                    <input class="forminput" type="text" id="vads_threeds_status" name="vads_threeds_status" value="<%=request.getParameter("vads_threeds_status")%>" readonly>
                    <label style="width: 55%; vertical-align: middle;" for="vads_threeds_status"><fmt:message key="label.vads_threeds_status" />  : <fmt:message key="${threedsStatus}" /></label><br>

                    <label style="width: 20%" for="vads_capture_delay">vads_capture_delay</label>
                    <input class="forminput" type="text" id="vads_capture_delay" name="vads_capture_delay" value="<%=request.getParameter("vads_capture_delay")%>" readonly>
                    <label style="width: 55%; vertical-align: middle;" for="vads_capture_delay"><fmt:message key="label.vads_capture_delay" />  : ${captureDelay} <fmt:message key="label.days" /> </label><br>

                    <label style="width: 20%" for="vads_validation_mode">vads_validation_mode</label>
                    <input class="forminput" type="text" id="vads_validation_mode" name="vads_validation_mode" value="<%=request.getParameter("vads_validation_mode")%>" readonly>
                    <label style="width: 55%; vertical-align: middle;" for="vads_validation_mode"><fmt:message key="label.vads_validation_mode" />  : <fmt:message key="${validationMode}" /></label><br>
            </div>
            <button type="button" class="accordion"><fmt:message key="label.allReceivedData" /></button>
            <div class="panel">
                <%for(String parameter : parameters.keySet()) {String[] values = parameters.get(parameter);%>
                    <label style="width: 20%" for="<%=parameter%>"><%=parameter%></label>
                    <input class="forminput" style="width:70%" class="forminput" name="<%=parameter%>" value="<%=values[0]%>" type="text" />
                    <br>
                <%}%>
            </div>
            <% }%>
            <br />
            <h1><fmt:message key="label.paymentresponseanalysis" /> </h1>
            <div id="Info">
                    <strong><fmt:message key="label.ipn" /> </strong><br />
                    <p><fmt:message key="label.ipndesc" /> </p>

                    <strong><fmt:message key="label.returnurl" /> </strong><br />
                    <p><fmt:message key="label.clientcomesback" /> </p>
                    <p><fmt:message key="label.formreturndesc" /> </p>
            </div>

            <h2><fmt:message key="label.findhelp" /> </h2>
            <p><strong><fmt:message key="label.supportrecommends" /> </strong> <a href="https://payzen.io" target="_blank"> payzen.io</a></p>
        </div>
    </div>
</div>

<script type="text/javascript" src="assets/js/script.js"></script>

</body>
</html>
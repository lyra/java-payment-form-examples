<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.Date" %>
<%@ page import="com.lyra.examples.form.utils.AppUtils" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="lang" value="${not empty param.lang ? param.lang : not empty lang ? lang : pageContext.request.locale}" scope="session" />

<fmt:requestEncoding value="UTF-8" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="i18n/messages" />

<%
String target = "";
boolean iframe = false;

String mode = AppUtils.getConfigProperty("action_mode").trim();
if (mode.equals("IFRAME")) {
    target = " target=\"payframe\" ";
    iframe = true;
}
%>
<!DOCTYPE html>
<html lang="${lang}">
<head>
    <title><fmt:message key="order_page_title" /></title>

    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js" defer></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" defer></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js" defer></script>

    <!-- Custom styles -->
    <link href="assets/css/style.css" rel="stylesheet" type="text/css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
  <a class="navbar-brand" href="order.jsp">Lyra</a>
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

<!-- Page Content -->
<div class="container">
    <div class="row">
        <div class="col-lg-12">
            <h1><fmt:message key="solution_title" /> </h1>
            <p class="lead"><fmt:message key="solution_description" /> </p>
            <h2><fmt:message key="requirements" />:</h2>
            <ul>
                <li><fmt:message key="servlet_container"><fmt:param value="Tomcat 9" /></fmt:message></li>
                <li><fmt:message key="java_compiler"><fmt:param value="1.8" /></fmt:message></li>
                <li><fmt:message key="maven_version"><fmt:param value="3.9" /></fmt:message></li>
                <li><fmt:message key="in_config"><fmt:param value="<code>config.properties</code>" /></fmt:message>:
                <ul>
                    <li><fmt:message key="shop_id" /></li>
                    <li><fmt:message key="sha_key" /></li>
                    <li><fmt:message key="ctx_mode" /></li>
                    <li><fmt:message key="gateway_url" /></li>
                    <li><fmt:message key="debug_mode_desc" /></li>
                    </ul>
                </li>
            </ul>

            <hr />
            <h2><fmt:message key="form_example_title" /></h2>
            <h2 style="text-align: center;"><fmt:message key="checkout_title" /></h2>
            <form class="form-horizontal" role="form" action="StandardPayment" method="post" id="checkout_form" onsubmit="return checkmode();" <%=target %>>
                <button type="button" class="accordion"><fmt:message key="order_details" /></button>
                <div class="panel" style="display: block;">
                    <div class="col-md-12">
                        <table class="table" aria-label="">
                            <tr>
                                <th class="left" scope="col"><fmt:message key="item_title" /></th>
                                <th scope="col"><fmt:message key="amount_title" /></th>
                            </tr>
                            <tr>
                                <td>
                                    1. <fmt:message key="item1_label" />
                                </td>
                                <td>
                                    <fmt:message key="item1_amount" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    2. <fmt:message key="item2_label" />
                                </td>
                                <td>
                                    <fmt:message key="item2_amount" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    3. ...
                                </td>
                                <td>
                                    ...
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <h3><fmt:message key="total_label" /></h3>
                                </td>
                                <td>
                                    <input class="" style="color:green; text-align: center;" type="number" name="vads_amount" id="vads_amount" value="1000" required min="0">
                                    <select class="" name="vads_currency" id="vads_currency">
                                        <option value="978" selected>EUR</option>
                                        <option value="840">USD</option>
                                    </select>
                                    <label for="vads_amount"><fmt:message key="order_amount_desc" /></label>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

                <button type="button" class="accordion"><fmt:message key="customer_data" /></button>
                <div class="panel" style="display: block;">
                    <input type="hidden" id="vads_language" name="vads_language" value="${lang}">

                    <div class="col-md-12">
                        <div class="form-group row">
                            <label for="vads_order_id" class="col-sm-3 col-form-label">vads_order_id</label>
                            <div class="col-sm-9">
                              <input type="text" class="form-control" id="vads_order_id" name="vads_order_id" value="123456">
                              <small class="form-text text-muted"><fmt:message key="order_id_desc" /></small>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="vads_cust_id" class="col-sm-3 col-form-label">vads_cust_id</label>
                            <div class="col-sm-9">
                              <input type="text" class="form-control" id="vads_cust_id" name="vads_cust_id" value="2380">
                              <small class="form-text text-muted"><fmt:message key="customer_id_desc" /></small>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="vads_cust_email" class="col-sm-3 col-form-label">vads_cust_email</label>
                            <div class="col-sm-9">
                              <input type="text" class="form-control" id="vads_cust_email" name="vads_cust_email" value="henri@gmail.com">
                              <small class="form-text text-muted"><fmt:message key="customer_email_desc" /></small>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="vads_cust_first_name" class="col-sm-3 col-form-label">vads_cust_first_name</label>
                            <div class="col-sm-9">
                              <input type="text" class="form-control" id="vads_cust_first_name" name="vads_cust_first_name" value="Henri">
                              <small class="form-text text-muted"><fmt:message key="customer_firstname_desc" /></small>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="vads_cust_last_name" class="col-sm-3 col-form-label">vads_cust_last_name</label>
                            <div class="col-sm-9">
                              <input type="text" class="form-control" id="vads_cust_last_name" name="vads_cust_last_name" value="Durand">
                              <small class="form-text text-muted"><fmt:message key="customer_lastname_desc" /></small>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="vads_cust_address" class="col-sm-3 col-form-label">vads_cust_address</label>
                            <div class="col-sm-9">
                              <input type="text" class="form-control" id="vads_cust_address" name="vads_cust_address" value="23 Bd Paul Picot">
                              <small class="form-text text-muted"><fmt:message key="customer_address_desc" /></small>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="vads_cust_city" class="col-sm-3 col-form-label">vads_cust_city</label>
                            <div class="col-sm-9">
                              <input type="text" class="form-control" id="vads_cust_city" name="vads_cust_city" value="Toulon">
                              <small class="form-text text-muted"><fmt:message key="customer_city_desc" /></small>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="vads_cust_zip" class="col-sm-3 col-form-label">vads_cust_zip</label>
                            <div class="col-sm-9">
                              <input type="text" class="form-control" id="vads_cust_zip" name="vads_cust_zip" value="83200">
                              <small class="form-text text-muted"><fmt:message key="customer_zip_desc" /></small>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="vads_cust_country" class="col-sm-3 col-form-label">vads_cust_country</label>
                            <div class="col-sm-9">
                              <input type="text" class="form-control" id="vads_cust_country" name="vads_cust_country" value="FR">
                              <small class="form-text text-muted"><fmt:message key="customer_country_desc" /></small>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="vads_cust_phone" class="col-sm-3 col-form-label">vads_cust_phone</label>
                            <div class="col-sm-9">
                              <input type="text" class="form-control" id="vads_cust_phone" name="vads_cust_phone" value="06002822672">
                              <small class="form-text text-muted"><fmt:message key="customer_phone_desc" /></small>
                            </div>
                        </div>
                    </div>
                </div>

                <button type="button" class="accordion"><fmt:message key="payment_title" /></button>
                <div class="panel" style="display: block;">
                    <label><input type="radio" id="payment_method_std" name="payment_method" value="standard" checked> <fmt:message key="standard_payment_title" /></label><br />
                    <label><input type="radio" id="payment_method_multi3" name="payment_method" value="multi3"> <fmt:message key="multi_3x_payment_title" /></label><br />
                    <label><input type="radio" id="payment_method_multi4" name="payment_method" value="multi4"> <fmt:message key="multi_4x_payment_title" /></label>
                    <br />
                </div>

                <% if (iframe) { %> <div id="iframeHolder"></div> <% } %>
                
                <div class="col-md-12 text-center">
                    <button class="btn btn-primary mb-2" id="submitButton" type="submit" form="checkout_form" value="Submit"><fmt:message key="button_submit_form" /></button>
                </div>

                <script>
                    function checkmode() {
                        var paymentMethod = $('input:radio[name="payment_method"]:checked').val();
                        var actionFile = '';

                        switch (paymentMethod) {
                          case 'multi3':
                          case 'multi4':
                            actionFile = 'MultiPayment';
                            break;

                          case 'standard':
                          default:
                            actionFile = 'StandardPayment';
                            break;
                        }

                        document.getElementById('checkout_form').action = actionFile;
                        <% if (iframe) { %>
                            enableSubmitButton(); // Disable the submit button.
                            $('#iframeHolder').html('<iframe name="payframe" src="' + actionFile + '" width="50%" height="550" scrolling="yes" /><div style="float: right;"><button class="close" type="button" onclick="removeIframe();">X</button></div>');
                        <% } %>
                    }

                    <% if (iframe) { %>
                        function removeIframe() {
                            $('#iframeHolder').html('');
                            enableSubmitButton(); // Disable the submit button.
                        }

                        function diableSubmitButton() {
                            $('#iframeHolder').html('');
                            $("#submitButton").attr("disabled", true); // Enable the submit button.
                        }

                        function enableSubmitButton() {
                            $('#iframeHolder').html('');
                            $("#submitButton").attr("disabled", false); // Enable the submit button.
                        }
                    <% } %>
                </script>
            </form>

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
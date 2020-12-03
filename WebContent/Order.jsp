<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<%@ page import="com.lyra.vads.tools.Tools"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="lang" value="${not empty param.lang ? param.lang : not empty lang  ? lang :
                        pageContext.request.locale}" scope="session" />
                        <fmt:requestEncoding value="UTF-8" />
<fmt:requestEncoding value="UTF-8" />
<fmt:setLocale value="${lang}" />
<fmt:setBundle basename="messages"/>

<% String target = "";%>
<% boolean iframe = false;%>

<% String mode = Tools.getConfigProperty("action_mode").trim();
   if(mode.equals("IFRAME")){
	   target = " target=\"payframe\" ";
	   iframe = true;
   }
%>

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
	        <fmt:message key="label.contactus"/>
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
      <li class="nav-item dropdown show ">
          <a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
            ${lang}
          </a>
          <div class="dropdown-menu dropdown-menu-right">
              <a class="dropdown-item" href="?lang=en"><fmt:message key="label.en" /></a>
              <a class="dropdown-item" href="?lang=fr"><fmt:message key="label.fr" /></a>
              <a class="dropdown-item" href="?lang=de"><fmt:message key="label.de" /></a>
              <a class="dropdown-item" href="?lang=es"><fmt:message key="label.es" /></a>
          </div>
      </li>
    </div>
    
    
  </div>
</nav>

<!-- Page Content -->
<div class="container">

    <div class="row">
        <div class="col-lg-12">
            <h1><fmt:message key="label.lyrasolution" /> </h1>
            <p class="lead"><fmt:message key="label.starterkit" /> </p>
            <h2><fmt:message key="label.requirements" /> :</h2>
            <ul>
                <li>PHP (5.4 +)</li>
                <li><fmt:message key="label.in" /> <code>config.properties :</code>
                <ul>
                    <li><fmt:message key="label.shopid" /> </li>
                    <li><fmt:message key="label.certtestprod" /> </li>
                    <li><fmt:message key="label.modetestprod" /> </li>
                    <li><fmt:message key="label.platformurl" /> </li>
                    <li><fmt:message key="label.debugdesc" /></li>
                    </ul>
                </li>
            </ul>
            
            <h2><fmt:message key="label.formexamples" /> </h2>
            <h2 style="text-align: center;"><fmt:message key="label.checkouttitle" /></h2>
            <form class="form-horizontal" role="form" action="standardpayment" method="post" id="checkout_form" onsubmit="return checkmode();" <%=target %>>
            <button type="button" class="accordion"><fmt:message key="label.orderdetails" /></button>
                <div class="panel">
                    <div class="col-md-9">
                        <table class="table table-striped">
                          <tr>
                              <td>
                                  <ul>
                                        <li><fmt:message key="label.item1" /></li>
                                        <li><fmt:message key="label.item2" /></li>
                                        <li>...</li>
                                  </ul>
                                </td>
                                <td>
                                <ul>
                                        <li><fmt:message key="label.amount1" /></li>
                                        <li><fmt:message key="label.amount2" /></li>
                                        <li>...</li>
                                </ul>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="col-md-3">
                      <div style="text-align: center;">
                          <h3><fmt:message key="label.total" /></h3>
                          <input class="forminput" style="color:green; text-align: center;" type="number" name="vads_amount" id="vads_amount" value="1000" required="true" min="0">
                          <label for="vads_amount"><fmt:message key="label.amountdesc" /></label>
                          <select class="forminput" name="vads_currency" id="vads_currency">
                              <option value="978" selected>EUR</option>
                              <option value="840">USD</option>
                          </select>
                      </div>
                    </div>
                </div>

                <button type="button" class="accordion"><fmt:message key="label.clientssettings" /></button>
                <div class="panel">
                    <input type="hidden" id="vads_language" name="vads_language" value="${lang}">
                    <label style="width: 15%" for="order_id">order_id</label>
                    <input class="forminput" type="text" id="vads_order_id" name="vads_order_id" value="123456">
                    <label style="width: 55%; vertical-align: middle;"  for="vads_order_id"><fmt:message key="label.orderdesc" /></label><br>

                    <label style="width: 15%" for="vads_cust_id">cust_id</label>
                    <input class="forminput" type="text" id="vads_cust_id" name="vads_cust_id" value="2380">
                    <label style="width: 55%; vertical-align: middle;"  for="vads_cust_id"><fmt:message key="label.custid" /></label><br>


                    <label style="width: 15%" for="vads_cust_email">cust_email</label>
                    <input class="forminput" type="text" id="vads_cust_email" name="vads_cust_email" value="henri@gmail.com">
                    <label style="width: 55%; vertical-align: middle;"  for="vads_cust_email"><fmt:message key="label.custemail" /></label><br>

                    <label style="width: 15%" for="vads_cust_first_name">vads_cust_first_name</label>
                    <input class="forminput" type="text" id="vads_cust_first_name" name="vads_cust_first_name" value="Henri">
                    <label style="width: 55%; vertical-align: middle;"  for="vads_cust_first_name"><fmt:message key="label.custfirstname" /></label><br>

                    <label style="width: 15%" for="vads_cust_last_name">vads_cust_last_name</label>
                    <input class="forminput" type="text" id="vads_cust_last_name" name="vads_cust_last_name" value="Durand">
                    <label style="width: 55%; vertical-align: middle;"  for="vads_cust_last_name"><fmt:message key="label.custlastname" /></label><br>

                    <label style="width: 15%" for="vads_cust_address">vads_cust_address</label>
                    <input class="forminput" type="text" id="vads_cust_address" name="vads_cust_address" value="Bd Paul Pïcot">
                    <label style="width: 55%; vertical-align: middle;"  for="vads_cust_address"><fmt:message key="label.custaddress" /></label><br>

                    <label style="width: 15%" for="vads_cust_city">vads_cust_city</label>
                    <input class="forminput" type="text" id="vads_cust_city" name="vads_cust_city" value="TOULON">
                    <label style="width: 55%; vertical-align: middle;"  for="vads_cust_city"><fmt:message key="label.custcity" /></label><br>

                    <label style="width: 15%" for="vads_cust_zip">vads_cust_zip</label>
                    <input class="forminput" type="text" id="vads_cust_zip" name="vads_cust_zip" value="83200">
                    <label style="width: 55%; vertical-align: middle;"  for="vads_cust_zip"><fmt:message key="label.custzip" /></label><br>

                    <label style="width: 15%" for="vads_cust_country">vads_cust_country</label>
                    <input class="forminput" type="text" id="vads_cust_country" name="vads_cust_country" value="FR">
                    <label style="width: 55%; vertical-align: middle;"  for="vads_cust_country"><fmt:message key="label.custcountry" /></label><br>

                    <label style="width: 15%" for="vads_cust_phone">vads_cust_phone</label>
                    <input class="forminput" type="text" id="vads_cust_phone" name="vads_cust_phone" value="06002822672">
                    <label style="width: 55%; vertical-align: middle;"  for="vads_cust_phone"><fmt:message key="label.custphone" /></label><br>

                </div>

                <button type="button" class="accordion"><fmt:message key="label.payment" /></button>
                <div>
                      <input type="radio" id="paymentmethod" name="paymentmethod" value="standard" checked> <fmt:message key="label.stdpayment" /><br>
                      <input type="radio" id="paymentmethod" name="paymentmethod" value="multi2"> <fmt:message key="label.x2payment" /><br>
                </div>

                <% if (iframe){%> <div id="iframeHolder"></div> <% }%>
                <button class="forminput" id="submitButton" type="submit" form="checkout_form" value="Submit"><fmt:message key="label.sendform" /></button>

                <script type="text/javascript">
                    function checkmode() {
                        var paymentmethod = $('input:radio[name="paymentmethod"]:checked').val();
                        var actionfile = '';
                        switch (paymentmethod) {
                          case 'standard':
                            actionfile = "StandardPayment";
                            break;
                          case 'multi2':
                            actionfile = "MultiPayment";
                            break;
                          default:
                            actionfile = "StandardPayment";
                        }
                        document.getElementById("checkout_form").action = actionfile;
                        <% if (iframe){%>
                            //disable the submit button
                            enableSubmitButton();
                            $('#iframeHolder').html('<iframe name="payframe" src="' + actionfile + '" width="50%" height="550" scrolling="yes" /> <div style="float:right;"><button class="close" type="button" onclick="removeIframe();">X</button></div>');
                        <% }%>
                    }

                    <% if (iframe){%>
                        function removeIframe() {
                            $('#iframeHolder').html('');
                            //disable the submit button
                             enableSubmitButton();
                         }

                         function diableSubmitButton() {
                            $('#iframeHolder').html('');
                            //enable the submit button
                             $("#submitButton").attr("disabled", true);
                         }

                         function enableSubmitButton() {
                            $('#iframeHolder').html('');
                            //enable the submit button
                             $("#submitButton").attr("disabled", false);
                         }
                     <% }%>
                </script>
            </form>
            
            <h2><fmt:message key="label.paymentanalysis" /> </h2>
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
    <!-- /.row -->

</div>

</body>

<script type="text/javascript" src="assets/js/script.js"></script>

</html>
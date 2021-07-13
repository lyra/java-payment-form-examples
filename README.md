# Java payment form examples

## Introduction

The code presented here is a demonstration of the implementation of the payment form integration in JAVA. It aims to ease its use and learning.

## Contents

The Java packages contain these resources:
* `src/main/resources/config.properties`: Contains a centralized configuration and initialisation file.
* `src/main/resources/i18n`: Contains the different translation files for French, English, German and Spanish languages.
* `src/main/java/com/lyra/examples/form/utils`: Contains a gateway utilitary class (for signature calculation, transaction ID generation and more) and an application utilitary class (for logger initialization and properties reading).
* `src/main/java/com/lyra/examples/form/servlet`: This package contains the logic implementation of the payment examples.

## Pages

* `WebContent/order.jsp`: This file simulates a payment form to be sent to the gateway.
* `WebContent/WEB-INF/form.jsp`: This is an intermediate redirection page. It displays the generated form for debug purposes.
* `WebContent/return.jsp`: This is the return file at the end of the payment.

## The first use

1. Fill the `src/main/resources/config.properties` by your actual values from your gateway Back Office and replace the cancel and return URL host by your web server host.
2. Generate a war and deploy it to your JSP/Servlet web server.
3. Access the `order.jsp` page from your browser.
4. Follow the indications to perform a payment.

## License

Each source file included in this distribution is licensed under the GNU GENERAL PUBLIC LICENSE (GPL 3.0). Please see LICENSE.txt for the full text of the GPL 3.0 license. It is also available through the world-wide-web at this URL: http://www.gnu.org/licenses/gpl.html.
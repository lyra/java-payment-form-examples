# PayZen VADS payment exemple - JAVA

## Introduction
The code presented here is a demonstration of the implementation of the VADS PayZen payment system in JAVA, aimed to ease its use and learning.

## Contents
*  `src/lyra/vads/config`, contains a centralized configuration and initialisation file.
*  `src/main/resources`, contains the different translation files in French, English, German and Spanish each file.
*  `src/lyra/vads/sdk`, Lyra SDK files.
*  `src/lyra/vads/tools`, defining an utility class containing mainly methods to access modeule properties, initiate the logger and check authentification.

## Example
* `src/lyra/vads/examples`, this folder contains payment methods implimentation example files.
* `WEB-INF/form.jsp`, the file contains the payment form to be sent to the platform.
* `return-payment.php`, the return file after payment.

## The first use
1. Place the files on the same directory, under the root of your web-server
2. In `src/lyra/vads/config/config.properties`, fill the properties by the actual values of your PayZen account
3. Access `Order.jsp` from your browser.
4. Follow the PayZen indications to perform the payment.

## Note
* The documentation used to write this code was [Guide d'implementation formulaire de paiement, v3.4](https://payzen.io).
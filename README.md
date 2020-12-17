# PayZen VADS payment exemple - JAVA

## Introduction
The code presented here is a demonstration of the implementation of the VADS PayZen payment system in JAVA, aimed to ease its use and learning.

## Contents
*  `src/com/lyra/vads/config`, contains a centralized configuration and initialisation file.
*  `src/main/resources`, contains the different translation files in French, English, German and Spanish each file.
*  `src/com/lyra/vads/sdk`, Lyra SDK files.
*  `src/com/lyra/vads/tools`, defining an utility class containing mainly methods to access modeule properties, initiate the logger and check authentification.

## Example
* `src/com/lyra/vads/examples`, this folder contains payment methods implimentation example files.
* `WebContent/WEB-INF/form.jsp`, the file contains the payment form to be sent to the platform.
* `WebContent/Return-payment.jsp`, the return file after payment.

## The first use
1. Place the files on the same directory, under the root of your web-server
2. In `src/com/lyra/vads/config/config.properties`, fill the properties by the actual values of your PayZen account
3. In `/src/com/lyra/vads/tools/Tools.java`, fill the constant `CONF_PATH` which is the absolute path to the `config.properties` filled in step 2.
4. Access `Order.jsp` from your browser.
5. Follow the PayZen indications to perform the payment.

## Note
* The documentation used to write this code was [Guide d'implementation formulaire de paiement, v3.4](https://payzen.io).
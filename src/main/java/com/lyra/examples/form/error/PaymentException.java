package com.lyra.examples.form.error;

public class PaymentException extends RuntimeException {
    private static final long serialVersionUID = -3898362610973801889L;

    public PaymentException(String message) {
        this(message, null);
    }

    public PaymentException(String message, Throwable cause) {
        super(message, cause);
    }
}

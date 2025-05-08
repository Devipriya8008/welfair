package com.welfair.util;

import javax.mail.MessagingException;

public class EmailTest {
    public static void main(String[] args) throws MessagingException, MessagingException {
        EmailUtil.sendPasswordResetEmail("devipriya8008@gmail.com", "http://valid-reset-link");
    }
}
package com.welfair.util;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.*;
import javax.mail.internet.*;
import javax.sql.DataSource;
import java.io.File;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.SQLFeatureNotSupportedException;
import java.util.Properties;
import java.util.logging.Logger;

public class EmailUtil {

    private static final String SMTP_HOST;
    private static final String SMTP_PORT;
    private static final String EMAIL_USERNAME;
    private static final String EMAIL_PASSWORD;

    static {
        Properties emailProps = new Properties();
        try (InputStream input = EmailUtil.class.getClassLoader().getResourceAsStream("email.properties")) {
            if (input == null) throw new RuntimeException("email.properties not found!");
            emailProps.load(input);

            // Read from properties file
            SMTP_HOST = emailProps.getProperty("smtp.host");
            SMTP_PORT = emailProps.getProperty("smtp.port");
            EMAIL_USERNAME = emailProps.getProperty("email.username");
            EMAIL_PASSWORD = emailProps.getProperty("email.password");
        } catch (Exception e) {
            throw new RuntimeException("Failed to load email config", e);
        }
    }
    public static void sendPasswordResetEmail(String recipientEmail, String resetLink)
            throws MessagingException {
        System.out.println("Preparing to send email...");
        System.out.println("Reset Link: " + resetLink);

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.trust", SMTP_HOST);
        props.put("mail.debug", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Password Reset Request - Welfair NGO");

            String content = "<p>Hello,</p>"
                    + "<p>You have requested to reset your password.</p>"
                    + "<p>Click the link below to reset your password:</p>"
                    + "<p><a href=\"" + resetLink + "\">Reset Password</a></p>"
                    + "<p>This link will expire in 24 hours.</p>";

            message.setContent(content, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Email sent successfully to " + recipientEmail);
        } catch (MessagingException e) {
            System.err.println("Failed to send email: " + e.getMessage());
            throw e;
        }
    }

    // In EmailUtil.java - update the sendDonationReceipt method
    public static void sendDonationReceipt(String toEmail, String subject, String body, String attachmentPath)
            throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.trust", SMTP_HOST);
        props.put("mail.debug", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject(subject);

            // Create the message part
            MimeBodyPart messageBodyPart = new MimeBodyPart();
            messageBodyPart.setContent(body, "text/html");

            // Create the PDF attachment part
            MimeBodyPart attachmentPart = new MimeBodyPart();
            DataSource source = new DataSource() {
                @Override
                public <T> T unwrap(Class<T> iface) throws SQLException {
                    return null;
                }

                @Override
                public boolean isWrapperFor(Class<?> iface) throws SQLException {
                    return false;
                }

                @Override
                public Connection getConnection() throws SQLException {
                    return null;
                }

                @Override
                public Connection getConnection(String username, String password) throws SQLException {
                    return null;
                }

                @Override
                public PrintWriter getLogWriter() throws SQLException {
                    return null;
                }

                @Override
                public void setLogWriter(PrintWriter out) throws SQLException {

                }

                @Override
                public void setLoginTimeout(int seconds) throws SQLException {

                }

                @Override
                public int getLoginTimeout() throws SQLException {
                    return 0;
                }

                @Override
                public Logger getParentLogger() throws SQLFeatureNotSupportedException {
                    return null;
                }
            };
            attachmentPart.setDataHandler(new DataHandler((javax.activation.DataSource) source));
            attachmentPart.setFileName("DonationReceipt.pdf");

            // Create the multi-part
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);
            multipart.addBodyPart(attachmentPart);

            // Set the complete message parts
            message.setContent(multipart);

            // Send message
            Transport.send(message);

            // Delete the temporary PDF file
            new File(attachmentPath).delete();
        } catch (Exception e) {
            throw new MessagingException("Failed to send donation receipt", e);
        }
    }
}

package com.welfair.util;

import jakarta.activation.DataHandler;
import jakarta.activation.FileDataSource;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.mail.util.ByteArrayDataSource;
import com.welfair.model.Event;
import com.welfair.model.User;
import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Properties;

public class EmailUtil {
    private static final String SMTP_HOST; ;
    private static final String EMAIL_PASSWORD;
    private static final String EMAIL_USERNAME;
    private static final String SMTP_PORT;
    private static final Properties emailProps = new Properties();
    // ... [static properties loading remains same]
    static {
        Properties emailProps = new Properties();
        try (InputStream input = EmailUtil.class.getClassLoader().getResourceAsStream("email.properties")) {
            if (input == null) throw new RuntimeException("email.properties not found!");
            emailProps.load(input);

            SMTP_HOST = emailProps.getProperty("smtp.host");
            SMTP_PORT = emailProps.getProperty("smtp.port");
            EMAIL_USERNAME = emailProps.getProperty("email.username");
            EMAIL_PASSWORD = emailProps.getProperty("email.password");
        } catch (Exception e) {
            throw new RuntimeException("Failed to load email config", e);
        }
    }
    private static Session createSession() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.ssl.trust", SMTP_HOST);
        props.put("mail.debug", emailProps.getProperty("mail.debug", "false"));

        return Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
            }
        });
    }

    public static void sendPasswordResetEmail(String recipientEmail, String resetLink) throws MessagingException {
        Session session = createSession();
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(EMAIL_USERNAME));
        message.setRecipients(Message.RecipientType.TO, recipientEmail);
        message.setSubject("Password Reset Request - Welfair NGO");

        String content = String.format("""
            <html>
                <body>
                    <p>Hello,</p>
                    <p>You requested a password reset. Click below to continue:</p>
                    <p><a href="%s">Reset Password</a></p>
                    <p><em>Link expires in 24 hours.</em></p>
                </body>
            </html>""", resetLink);

        message.setContent(content, "text/html; charset=utf-8");
        Transport.send(message);
    }

    public static void sendDonationReceipt(String toEmail, String subject, String body, String attachmentPath)
            throws MessagingException {
        Session session = createSession();
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(EMAIL_USERNAME));
        message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
        message.setSubject(subject);

        MimeMultipart multipart = new MimeMultipart();

        // Text part
        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setContent(body, "text/html");
        multipart.addBodyPart(textPart);

        // Attachment
        MimeBodyPart attachment = new MimeBodyPart();
        attachment.setDataHandler(new DataHandler(new FileDataSource(attachmentPath)));
        attachment.setFileName("Donation_Receipt.pdf");
        multipart.addBodyPart(attachment);

        message.setContent(multipart);
        Transport.send(message);

        // Safe file cleanup
        try {
            Files.deleteIfExists(Paths.get(attachmentPath));
        } catch (Exception e) {
            System.err.println("Failed to delete receipt: " + e.getMessage());
        }
    }

    public static void sendEventConfirmation(User user, Event event, byte[] pdfBytes)
            throws MessagingException {
        Session session = createSession();
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(EMAIL_USERNAME));
        message.addRecipient(Message.RecipientType.TO, new InternetAddress(user.getEmail()));
        message.setSubject("Event Confirmation: " + event.getName());

        MimeMultipart multipart = new MimeMultipart();

        // HTML Content
        String htmlContent = String.format("""
            <h3>Thank you, %s!</h3>
            <p>Your registration for <strong>%s</strong> is confirmed.</p>
            <p>See attached PDF for event details.</p>
            <p>Welfair Team</p>""",
                user.getUsername(), event.getName());

        MimeBodyPart textPart = new MimeBodyPart();
        textPart.setContent(htmlContent, "text/html; charset=utf-8");
        multipart.addBodyPart(textPart);

        // PDF Attachment
        MimeBodyPart pdfAttachment = new MimeBodyPart();
        ByteArrayDataSource source = new ByteArrayDataSource(pdfBytes, "application/pdf");
        pdfAttachment.setDataHandler(new DataHandler(source));
        pdfAttachment.setFileName("Event_Details.pdf");
        multipart.addBodyPart(pdfAttachment);

        message.setContent(multipart);
        Transport.send(message);
    }
}
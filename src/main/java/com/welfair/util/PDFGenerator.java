package com.welfair.util;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;
import com.welfair.model.Donation;
import com.welfair.model.Event;
import com.welfair.model.User;

import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;

public class PDFGenerator {

    // Method to generate donation receipt PDF and return the file path
    public static String generateDonationReceipt(Donation donation) throws Exception {
        String fileName = "receipt_" + donation.getDonationId() + "_" + System.currentTimeMillis() + ".pdf";
        String filePath = System.getProperty("java.io.tmpdir") + fileName;

        Document document = new Document();
        PdfWriter.getInstance(document, new FileOutputStream(filePath));
        document.open();

        addLogo(document);

        // Title
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
        Paragraph title = new Paragraph("DONATION RECEIPT", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        // NGO info
        Paragraph orgInfo = new Paragraph();
        orgInfo.add(new Chunk("Welfair NGO\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12)));
        orgInfo.add("123 Charity Street\nCity, Country\nTax ID: 123-456-789\n\n");
        orgInfo.setAlignment(Element.ALIGN_CENTER);
        document.add(orgInfo);

        // Receipt details
        SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy");
        Paragraph receiptDetails = new Paragraph();
        receiptDetails.add(new Chunk("Receipt Number: ", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        receiptDetails.add(donation.getDonationId() + "\n");
        receiptDetails.add(new Chunk("Date: ", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        receiptDetails.add(sdf.format(donation.getDate()) + "\n\n");
        receiptDetails.add(new Chunk("Received from: ", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        receiptDetails.add(donation.getDonorName() + "\n");
        receiptDetails.add(new Chunk("Email: ", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        receiptDetails.add(donation.getDonorEmail() + "\n\n");

        receiptDetails.add(new Chunk("Donation Details\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14)));
        receiptDetails.add(new Chunk("Project: ", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        receiptDetails.add(donation.getProjectTitle() + "\n");
        receiptDetails.add(new Chunk("Amount: ", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        receiptDetails.add("$" + donation.getAmount() + "\n");
        receiptDetails.add(new Chunk("Payment Method: ", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        receiptDetails.add(donation.getMode() + "\n\n");

        document.add(receiptDetails);

        Paragraph thanks = new Paragraph(
                "Thank you for your generous donation. Your contribution helps us continue our mission.\n\n" +
                        "This receipt may be used for tax purposes in accordance with local laws.",
                FontFactory.getFont(FontFactory.HELVETICA, 10)
        );
        thanks.setAlignment(Element.ALIGN_CENTER);
        document.add(thanks);

        document.close();
        return filePath;
    }

    // Method to generate event registration confirmation PDF as byte[]
    public static byte[] generateEventPDF(User user, Event event) throws Exception {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        Document document = new Document();
        PdfWriter.getInstance(document, outputStream);
        document.open();

        addLogo(document);

        // Title
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
        Paragraph title = new Paragraph("EVENT REGISTRATION CONFIRMATION", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        // User info
        Paragraph userInfo = new Paragraph();
        userInfo.add(new Chunk("Participant Details:\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14)));
        userInfo.add("Name: " + user.getUsername() + "\n");
        userInfo.add("Email: " + user.getEmail() + "\n\n");
        document.add(userInfo);

        // Event info
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");

        Paragraph eventDetails = new Paragraph();
        eventDetails.add(new Chunk("Event Details:\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14)));
        eventDetails.add("Event Name: " + event.getName() + "\n");
        eventDetails.add("Date: " + dateFormat.format(event.getDate()) + "\n");
        eventDetails.add("Time: " + timeFormat.format(event.getTime()) + "\n");
        eventDetails.add("Location: " + event.getLocation() + "\n\n");
        eventDetails.add("Description: " + event.getShortDescription() + "\n");
        document.add(eventDetails);

        // Footer
        Paragraph footer = new Paragraph(
                "Thank you for volunteering with Welfair!\n" +
                        "Please arrive 15 minutes before the event start time.\n" +
                        "For any queries, contact us at support@welfair.org",
                FontFactory.getFont(FontFactory.HELVETICA, 10)
        );
        footer.setAlignment(Element.ALIGN_CENTER);
        document.add(footer);

        document.close();
        return outputStream.toByteArray();
    }

    // Helper method to load and add logo
    private static void addLogo(Document document) {
        try {
            // Replace with a real path or use ClassLoader to load from resources
            Image logo = Image.getInstance("path/to/your/logo.png");
            logo.scaleToFit(100, 100);
            logo.setAlignment(Element.ALIGN_CENTER);
            document.add(logo);
        } catch (Exception e) {
            System.err.println("Logo image could not be added: " + e.getMessage());
        }
    }
}

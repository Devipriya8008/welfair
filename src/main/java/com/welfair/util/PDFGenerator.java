package com.welfair.util;

import com.welfair.model.Donation;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PDFGenerator {
    public static String generateDonationReceipt(Donation donation) throws Exception {
        String fileName = "receipt_" + donation.getDonationId() + "_" + System.currentTimeMillis() + ".pdf";
        String filePath = System.getProperty("java.io.tmpdir") + fileName;

        Document document = new Document();
        PdfWriter.getInstance(document, new FileOutputStream(filePath));

        document.open();

        // Add logo
        Image logo = Image.getInstance("path/to/your/logo.png");
        logo.scaleToFit(100, 100);
        logo.setAlignment(Element.ALIGN_CENTER);
        document.add(logo);

        // Add title
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
        Paragraph title = new Paragraph("DONATION RECEIPT", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        // Organization info
        Paragraph orgInfo = new Paragraph();
        orgInfo.add(new Chunk("Welfair NGO\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12)));
        orgInfo.add("123 Charity Street\n");
        orgInfo.add("City, Country\n");
        orgInfo.add("Tax ID: 123-456-789\n\n");
        orgInfo.setAlignment(Element.ALIGN_CENTER);
        document.add(orgInfo);

        // Receipt details
        SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy");
        Paragraph receiptDetails = new Paragraph();
        receiptDetails.add(new Chunk("Receipt Number: ", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        receiptDetails.add(donation.getDonationId() + "\n");
        receiptDetails.add(new Chunk("Date: ", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        receiptDetails.add(sdf.format(donation.getDate()) + "\n\n");

        // Donor info
        receiptDetails.add(new Chunk("Received from: ", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        receiptDetails.add(donation.getDonorName() + "\n");
        receiptDetails.add(new Chunk("Email: ", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        receiptDetails.add(donation.getDonorEmail() + "\n\n");

        // Donation info
        receiptDetails.add(new Chunk("Donation Details\n", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14)));
        receiptDetails.add(new Chunk("Project: ", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        receiptDetails.add(donation.getProjectTitle() + "\n");
        receiptDetails.add(new Chunk("Amount: ", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        receiptDetails.add("$" + donation.getAmount() + "\n");
        receiptDetails.add(new Chunk("Payment Method: ", FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
        receiptDetails.add(donation.getMode() + "\n\n");

        // Thank you message
        Paragraph thanks = new Paragraph(
                "Thank you for your generous donation. Your contribution helps us continue our mission.\n\n" +
                        "This receipt may be used for tax purposes in accordance with local laws.",
                FontFactory.getFont(FontFactory.HELVETICA, 10)
        );
        thanks.setAlignment(Element.ALIGN_CENTER);

        document.add(receiptDetails);
        document.add(thanks);

        document.close();
        return filePath;
    }
}
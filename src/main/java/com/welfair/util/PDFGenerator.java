package com.welfair.util;

import com.welfair.model.Donation;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PDFGenerator {
    public static String generateDonationReceipt(Donation donation) throws Exception {
        String fileName = "receipt_" + donation.getDonationId() + ".pdf";
        String filePath = "/tmp/" + fileName;
        
        Document document = new Document();
        PdfWriter.getInstance(document, new FileOutputStream(filePath));
        
        document.open();
        
        // Add content
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
        Paragraph title = new Paragraph("Donation Receipt", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        
        document.add(Chunk.NEWLINE);
        
        // Donation details
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        document.add(new Paragraph("Date: " + sdf.format(new Date())));
        document.add(new Paragraph("Donation ID: " + donation.getDonationId()));
        document.add(new Paragraph("Amount: $" + donation.getAmount()));
        document.add(new Paragraph("Project: " + donation.getProjectTitle()));
        document.add(new Paragraph("Payment Method: " + donation.getMode()));
        
        document.close();
        return filePath;
    }
}
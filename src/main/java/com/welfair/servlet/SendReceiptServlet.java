package com.welfair.servlet;

import com.welfair.dao.DonationDAO;
import com.welfair.model.Donation;
import com.welfair.util.EmailUtil;
import com.welfair.util.PDFGenerator;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/send-receipt")
public class SendReceiptServlet extends HttpServlet {
    private DonationDAO donationDAO = new DonationDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int donationId = Integer.parseInt(request.getParameter("donationId"));
        
        try {
            // Get donation details
            Donation donation = donationDAO.getDonationForReceipt(donationId);
            if (donation == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Donation not found");
                return;
            }

            // Generate PDF receipt
            String pdfPath = PDFGenerator.generateDonationReceipt(donation);
            
            // Prepare email content
            String subject = "Your Donation Receipt - Welfair NGO";
            String body = String.format("""
                <h2>Thank you for your donation!</h2>
                <p>Dear Donor,</p>
                <p>Please find attached the receipt for your donation of $%s to %s.</p>
                <p>Donation Date: %s</p>
                <p>Transaction ID: %d</p>
                <p>If you have any questions, please contact us.</p>
                <p>Warm regards,<br>The Welfair Team</p>
                """, 
                donation.getAmount(), 
                donation.getProjectTitle(),
                donation.getDate(),
                donation.getDonationId());

            // Send email with PDF attachment
            EmailUtil.sendDonationReceipt(
                donation.getDonorEmail(),
                subject,
                body,
                pdfPath
            );

            response.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error sending receipt");
        }
    }
}
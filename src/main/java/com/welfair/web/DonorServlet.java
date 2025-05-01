package com.welfair.web;

import com.welfair.dao.DonorDAO;
import com.welfair.model.Donor;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "DonorServlet", urlPatterns = {
        "/donors",
        "/donors/new",
        "/donors/create",
        "/donors/edit",
        "/donors/update",
        "/donors/delete"
})
public class DonorServlet extends HttpServlet {
    private DonorDAO donorDAO;

    @Override
    public void init() {
        donorDAO = new DonorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        try {
            switch (action) {
                case "/donors/new":
                    showNewForm(request, response);
                    break;
                case "/donors/edit":
                    showEditForm(request, response);
                    break;
                case "/donors/delete":
                    deleteDonor(request, response);
                    break;
                default:
                    listDonors(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        try {
            switch (action) {
                case "/donors/create":
                    createDonor(request, response);
                    break;
                case "/donors/update":
                    updateDonor(request, response);
                    break;
                default:
                    response.sendRedirect("donors");
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listDonors(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        request.setAttribute("donors", donorDAO.getAllDonors());
        request.getRequestDispatcher("/WEB-INF/views/donors/list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/WEB-INF/views/donors/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Donor existingDonor = donorDAO.getDonorById(id);
        request.setAttribute("donor", existingDonor);
        request.getRequestDispatcher("/WEB-INF/views/donors/form.jsp").forward(request, response);
    }

    private void createDonor(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        Donor donor = new Donor(
                request.getParameter("name"),
                request.getParameter("email"),
                request.getParameter("phone"),
                request.getParameter("address")
        );
        donorDAO.createDonor(donor);
        response.sendRedirect("donors");
    }

    private void updateDonor(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Donor donor = new Donor(
                id,
                request.getParameter("name"),
                request.getParameter("email"),
                request.getParameter("phone"),
                request.getParameter("address")
        );
        donorDAO.updateDonor(donor);
        response.sendRedirect("donors");
    }

    private void deleteDonor(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        donorDAO.deleteDonor(id);
        response.sendRedirect("donors");
    }
}
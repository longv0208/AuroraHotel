package controller;

import dao.BookingDAO;
import dao.CustomerDAO;
import model.Booking;
import model.Customer;
import model.User;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.time.LocalDate;
import java.util.List;

/**
 * Servlet for Customer management operations
 * Handles list, view, create, edit, delete, booking history
 * 
 * @author Aurora Hotel Team
 */
@WebServlet(name = "CustomerServlet", urlPatterns = {"/customer"})
public class CustomerServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is Admin (customer management is Admin-only)
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/aurora?error=unauthorized");
            return;
        }

        String view = request.getParameter("view");

        if (view == null || view.equals("list")) {
            // List customers with pagination
            showCustomerList(request, response);
            
        } else if (view.equals("details")) {
            // View customer details
            showCustomerDetails(request, response);
            
        } else if (view.equals("booking-history")) {
            // View customer's booking history
            showBookingHistory(request, response);
            
        } else if (view.equals("create")) {
            // Create new customer form
            request.getRequestDispatcher("/WEB-INF/customer/create.jsp").forward(request, response);
            
        } else if (view.equals("edit")) {
            // Edit customer form
            showEditForm(request, response);
            
        } else if (view.equals("delete")) {
            // Delete customer confirmation
            showDeleteConfirmation(request, response);
            
        } else {
            response.sendRedirect(request.getContextPath() + "/customer?view=list");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is Admin
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/aurora?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/customer?view=list");
            return;
        }

        switch (action) {
            case "create":
                createCustomer(request, response);
                break;
                
            case "edit":
                editCustomer(request, response);
                break;
                
            case "delete":
                deleteCustomer(request, response);
                break;
                
            case "search":
                searchCustomers(request, response);
                break;
                
            default:
                response.sendRedirect(request.getContextPath() + "/customer?view=list");
                break;
        }
    }

    /**
     * Show customer list with pagination
     */
    private void showCustomerList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ex) {
                System.err.println("Invalid page parameter");
            }
        }

        CustomerDAO customerDAO = new CustomerDAO();
        List<Customer> customers = customerDAO.getCustomerList(page);

        int totalRows = customerDAO.getTotalRows();
        int totalPages = (int) Math.ceil((double) totalRows / 10);

        request.setAttribute("customers", customers);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalRows", totalRows);
        request.getRequestDispatcher("/WEB-INF/customer/list.jsp").forward(request, response);
    }

    /**
     * Show customer details
     */
    private void showCustomerDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer?view=list");
            return;
        }

        try {
            int customerID = Integer.parseInt(idStr);
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getCustomerById(customerID);

            System.out.println("Looking for customer ID: " + customerID);
            
            if (customer == null) {
                System.err.println("Customer not found with ID: " + customerID);
                request.setAttribute("errorMessage", "Không tìm thấy khách hàng với ID: " + customerID);
                response.sendRedirect(request.getContextPath() + "/customer?view=list&error=notfound");
                return;
            }

            System.out.println("Found customer: " + customer.getFullName());
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/WEB-INF/customer/details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("Invalid customer ID format: " + idStr);
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer?view=list&error=invalid");
        } catch (Exception e) {
            System.err.println("Error showing customer details: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer?view=list&error=system");
        }
    }

    /**
     * Show customer's booking history
     */
    private void showBookingHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer?view=list");
            return;
        }

        try {
            int customerID = Integer.parseInt(idStr);
            
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getCustomerById(customerID);
            
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/customer?view=list&error=notfound");
                return;
            }

            BookingDAO bookingDAO = new BookingDAO();
            List<Booking> bookings = bookingDAO.getBookingsByCustomer(customerID);

            request.setAttribute("customer", customer);
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/WEB-INF/customer/booking-history.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing booking history: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer?view=list");
        }
    }

    /**
     * Show edit form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer?view=list");
            return;
        }

        try {
            int customerID = Integer.parseInt(idStr);
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getCustomerById(customerID);

            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/customer?view=list&error=notfound");
                return;
            }

            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/WEB-INF/customer/edit.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing edit form: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer?view=list");
        }
    }

    /**
     * Show delete confirmation
     */
    private void showDeleteConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer?view=list");
            return;
        }

        try {
            int customerID = Integer.parseInt(idStr);
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getCustomerById(customerID);

            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/customer?view=list&error=notfound");
                return;
            }

            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/WEB-INF/customer/delete.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing delete confirmation: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer?view=list");
        }
    }

    /**
     * Create new customer
     */
    private void createCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String fullName = request.getParameter("fullName");
            String idCard = request.getParameter("idCard");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String dateOfBirthStr = request.getParameter("dateOfBirth");
            String nationality = request.getParameter("nationality");
            String notes = request.getParameter("notes");

            // Validate required fields
            if (fullName == null || fullName.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tên và số điện thoại");
                request.getRequestDispatcher("/WEB-INF/customer/create.jsp").forward(request, response);
                return;
            }

            Customer customer = new Customer();
            customer.setFullName(fullName.trim());
            customer.setIdCard(idCard);
            customer.setPhone(phone.trim());
            customer.setEmail(email);
            customer.setAddress(address);
            
            if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                customer.setDateOfBirth(LocalDate.parse(dateOfBirthStr));
            }
            
            customer.setNationality(nationality != null ? nationality : "Việt Nam");
            customer.setNotes(notes);

            CustomerDAO customerDAO = new CustomerDAO();
            int customerID = customerDAO.createCustomer(customer);

            if (customerID > 0) {
                response.sendRedirect(request.getContextPath() + "/customer?view=details&id=" + customerID + "&success=1");
            } else {
                request.setAttribute("errorMessage", "Không thể tạo khách hàng");
                request.getRequestDispatcher("/WEB-INF/customer/create.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error creating customer: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/customer/create.jsp").forward(request, response);
        }
    }

    /**
     * Edit customer
     */
    private void editCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int customerID = Integer.parseInt(request.getParameter("customerID"));
            String fullName = request.getParameter("fullName");
            String idCard = request.getParameter("idCard");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String dateOfBirthStr = request.getParameter("dateOfBirth");
            String nationality = request.getParameter("nationality");
            String notes = request.getParameter("notes");

            Customer customer = new Customer();
            customer.setCustomerID(customerID);
            customer.setFullName(fullName);
            customer.setIdCard(idCard);
            customer.setPhone(phone);
            customer.setEmail(email);
            customer.setAddress(address);
            
            if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                customer.setDateOfBirth(LocalDate.parse(dateOfBirthStr));
            }
            
            customer.setNationality(nationality);
            customer.setNotes(notes);

            CustomerDAO customerDAO = new CustomerDAO();
            boolean result = customerDAO.updateCustomer(customer);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/customer?view=details&id=" + customerID + "&updated=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer?view=edit&id=" + customerID + "&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error editing customer: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer?view=list&error=1");
        }
    }

    /**
     * Delete customer
     */
    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int customerID = Integer.parseInt(request.getParameter("id"));

            CustomerDAO customerDAO = new CustomerDAO();
            boolean result = customerDAO.deleteCustomer(customerID);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/customer?view=list&deleted=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer?view=delete&id=" + customerID + "&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error deleting customer: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer?view=list&error=1");
        }
    }

    /**
     * Search customers
     */
    private void searchCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String searchTerm = request.getParameter("searchTerm");

        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer?view=list");
            return;
        }

        try {
            CustomerDAO customerDAO = new CustomerDAO();
            List<Customer> customers = customerDAO.searchCustomers(searchTerm.trim());

            request.setAttribute("customers", customers);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("totalRows", customers.size());
            request.getRequestDispatcher("/WEB-INF/customer/list.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error searching customers: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer?view=list&error=1");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Customer Servlet - Manages customer CRUD operations and booking history";
    }
}


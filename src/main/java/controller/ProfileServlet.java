package controller;

import model.User;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet for handling user profile operations
 * Allows users to view and edit their profile information
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        // Check if user is logged in
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || action.equals("view")) {
            viewProfile(request, response, loggedInUser);
        } else if (action.equals("edit")) {
            showEditForm(request, response, loggedInUser);
        } else {
            viewProfile(request, response, loggedInUser);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        // Check if user is logged in
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action != null && action.equals("update")) {
            updateProfile(request, response, loggedInUser);
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }

    /**
     * Display user profile information
     */
    private void viewProfile(HttpServletRequest request, HttpServletResponse response, User loggedInUser)
            throws ServletException, IOException {
        
        // Get fresh user data from database
        User user = userDAO.getUserById(loggedInUser.getUserID());
        
        if (user != null) {
            request.setAttribute("user", user);
        } else {
            request.setAttribute("user", loggedInUser);
        }
        
        request.getRequestDispatcher("/WEB-INF/hotel/profile.jsp").forward(request, response);
    }

    /**
     * Show edit profile form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response, User loggedInUser)
            throws ServletException, IOException {
        
        // Get fresh user data from database
        User user = userDAO.getUserById(loggedInUser.getUserID());
        
        if (user != null) {
            request.setAttribute("user", user);
        } else {
            request.setAttribute("user", loggedInUser);
        }
        
        request.setAttribute("editMode", true);
        request.getRequestDispatcher("/WEB-INF/hotel/profile.jsp").forward(request, response);
    }

    /**
     * Update user profile information
     */
    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User loggedInUser)
            throws ServletException, IOException {
        
        try {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            
            // Validate input
            if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty()) {
                
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
                showEditForm(request, response, loggedInUser);
                return;
            }
            
            // Update user object
            loggedInUser.setFullName(fullName.trim());
            loggedInUser.setEmail(email.trim());
            loggedInUser.setPhone(phone.trim());
            
            // Update in database
            if (userDAO.updateUser(loggedInUser)) {
                // Update session
                request.getSession().setAttribute("loggedInUser", loggedInUser);
                request.setAttribute("success", "Cập nhật thông tin thành công");
                viewProfile(request, response, loggedInUser);
            } else {
                request.setAttribute("error", "Cập nhật thông tin thất bại");
                showEditForm(request, response, loggedInUser);
            }
            
        } catch (Exception e) {
            System.err.println("Error updating profile: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            showEditForm(request, response, loggedInUser);
        }
    }

    @Override
    public String getServletInfo() {
        return "Profile Servlet for user profile management";
    }
}


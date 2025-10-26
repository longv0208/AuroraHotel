package controller;

import dao.CustomerDAO;
import dao.UserDAO;
import model.User;
import util.MD5Util;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet for user registration
 * Automatically creates linked Customer record when user registers
 *
 * @author Aurora Hotel Team
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    /**
     * Display registration form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in, redirect to home
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
    }

    /**
     * Process registration
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form parameters
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            // Validation
            if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty()) {

                request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
                return;
            }

            // Check password match
            if (!password.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
                return;
            }

            UserDAO userDAO = new UserDAO();

            // Check if username already exists
            if (userDAO.getUserByUsername(username) != null) {
                request.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
                return;
            }

            // Check if phone already exists
            if (userDAO.getUserByPhone(phone) != null) {
                request.setAttribute("errorMessage", "Số điện thoại đã được đăng ký");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
                return;
            }

            // Hash password using MD5 (same as login system)
            String passwordHash = MD5Util.hashPassword(password);

            // Create User account
            User newUser = new User();
            newUser.setUsername(username.trim());
            newUser.setPasswordHash(passwordHash);
            newUser.setFullName(fullName.trim());
            newUser.setEmail(email != null ? email.trim() : null);
            newUser.setPhone(phone.trim());
            newUser.setRole("User"); // Default role
            newUser.setActive(true);

            int userID = userDAO.createUser(newUser);

            if (userID > 0) {
                // Set the userID to the created user object
                newUser.setUserID(userID);

                // Automatically create linked Customer record
                CustomerDAO customerDAO = new CustomerDAO();
                int customerID = customerDAO.createCustomerFromUser(newUser);

                if (customerID > 0) {
                    // Registration successful
                    request.setAttribute("successMessage",
                        "Đăng ký thành công! Vui lòng đăng nhập.");
                    request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
                } else {
                    // User created but customer creation failed
                    // Still allow user to login, customer will be created later if needed
                    System.err.println("Warning: User created but Customer creation failed for userID: " + userID);
                    request.setAttribute("successMessage",
                        "Đăng ký thành công! Vui lòng đăng nhập.");
                    request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Đăng ký thất bại. Vui lòng thử lại.");
                request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error during registration: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/auth/register.jsp").forward(request, response);
        }
    }
}

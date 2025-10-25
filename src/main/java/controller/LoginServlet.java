/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for handling user login
 *
 * ⚠️ SECURITY WARNING: This servlet uses MD5 for password hashing which is NOT
 * secure!
 * For production systems, migrate to BCrypt or Argon2id immediately.
 *
 * @author Aurora Hotel Team
 */
@WebServlet(name = "LoginServlet", urlPatterns = { "/login" })
public class LoginServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
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

        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            // Already logged in, redirect to home
            response.sendRedirect(request.getContextPath() + "/aurora");
            return;
        }

        // Forward to login page
        request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
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

        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        // Validate input
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập tên đăng nhập và mật khẩu");
            request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
            return;
        }

        // Authenticate user
        UserDAO userDAO = new UserDAO();
        User user = userDAO.validateLogin(username.trim(), password);

        if (user != null) {
            // Login successful

            // Update last login timestamp
            userDAO.updateLastLogin(user.getUserID());

            // Get existing session or create new one
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                // Invalidate old session to prevent session fixation attack
                oldSession.invalidate();
            }

            // Create new session (regenerate session ID for security)
            HttpSession newSession = request.getSession(true);

            // Store user in session
            newSession.setAttribute("loggedInUser", user);
            newSession.setAttribute("userID", user.getUserID());
            newSession.setAttribute("username", user.getUsername());
            newSession.setAttribute("fullName", user.getFullName());
            newSession.setAttribute("role", user.getRole());

            // Set session timeout (30 minutes)
            newSession.setMaxInactiveInterval(30 * 60);

            // Handle "Remember Me" functionality
            if ("on".equals(rememberMe)) {
                // Create cookie for username (NOT password!)
                Cookie usernameCookie = new Cookie("rememberedUsername", username);
                usernameCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                usernameCookie.setPath(request.getContextPath());
                usernameCookie.setHttpOnly(true); // Prevent XSS attacks
                response.addCookie(usernameCookie);
            }

            // Redirect to home page or requested page
            String redirectURL = request.getParameter("redirect");
            if (redirectURL != null && !redirectURL.isEmpty() && !redirectURL.contains("login")) {
                response.sendRedirect(redirectURL);
            } else {
                response.sendRedirect(request.getContextPath() + "/aurora");
            }

        } else {
            // Login failed
            request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng");
            request.setAttribute("username", username); // Preserve username for convenience
            request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Login Servlet - Handles user authentication with MD5 password hashing";
    }// </editor-fold>

}

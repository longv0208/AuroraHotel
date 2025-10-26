package controller;

import dao.SystemLogDAO;
import model.SystemLog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * Servlet for viewing system logs
 * Handles audit trail and system activity logging
 */
@WebServlet(name = "SystemLogServlet", urlPatterns = {"/systemLog"})
public class SystemLogServlet extends HttpServlet {
    
    private SystemLogDAO systemLogDAO;
    private static final int RECORDS_PER_PAGE = 20;
    
    @Override
    public void init() throws ServletException {
        super.init();
        systemLogDAO = new SystemLogDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/aurora?error=unauthorized");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "byUser":
                    showLogsByUser(request, response);
                    break;
                case "byTable":
                    showLogsByTable(request, response);
                    break;
                case "byDate":
                    showLogsByDate(request, response);
                    break;
                default:
                    listAllLogs(request, response);
            }
        } catch (Exception e) {
            System.err.println("Error in SystemLogServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/admin/system-log-list.jsp").forward(request, response);
        }
    }
    
    /**
     * List all system logs with pagination
     */
    private void listAllLogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pageStr = request.getParameter("page");
        int page = 1;
        
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        List<SystemLog> logs = systemLogDAO.getAllLogs(page);
        int totalLogs = systemLogDAO.getTotalLogs();
        int totalPages = (totalLogs + RECORDS_PER_PAGE - 1) / RECORDS_PER_PAGE;
        
        request.setAttribute("logs", logs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalLogs", totalLogs);
        request.getRequestDispatcher("/WEB-INF/admin/system-log-list.jsp").forward(request, response);
    }
    
    /**
     * Show logs by user
     */
    private void showLogsByUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        String pageStr = request.getParameter("page");
        
        if (userIdStr == null || userIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/systemLog");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            int page = 1;
            
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            List<SystemLog> logs = systemLogDAO.getLogsByUser(userId, page);
            
            request.setAttribute("logs", logs);
            request.setAttribute("userId", userId);
            request.setAttribute("currentPage", page);
            request.setAttribute("filterType", "user");
            request.getRequestDispatcher("/WEB-INF/admin/system-log-list.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/systemLog");
        }
    }
    
    /**
     * Show logs by table
     */
    private void showLogsByTable(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String tableName = request.getParameter("tableName");
        String pageStr = request.getParameter("page");
        
        if (tableName == null || tableName.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/systemLog");
            return;
        }
        
        try {
            int page = 1;
            
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            List<SystemLog> logs = systemLogDAO.getLogsByTable(tableName, page);
            
            request.setAttribute("logs", logs);
            request.setAttribute("tableName", tableName);
            request.setAttribute("currentPage", page);
            request.setAttribute("filterType", "table");
            request.getRequestDispatcher("/WEB-INF/admin/system-log-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/systemLog");
        }
    }
    
    /**
     * Show logs by date range
     */
    private void showLogsByDate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");
        
        if (fromDateStr == null || fromDateStr.isEmpty() || toDateStr == null || toDateStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/systemLog");
            return;
        }
        
        try {
            LocalDate fromDate = LocalDate.parse(fromDateStr);
            LocalDate toDate = LocalDate.parse(toDateStr);
            
            List<SystemLog> logs = systemLogDAO.getLogsByDateRange(fromDate, toDate);
            
            request.setAttribute("logs", logs);
            request.setAttribute("fromDate", fromDateStr);
            request.setAttribute("toDate", toDateStr);
            request.setAttribute("filterType", "date");
            request.getRequestDispatcher("/WEB-INF/admin/system-log-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error parsing dates: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/systemLog");
        }
    }
}


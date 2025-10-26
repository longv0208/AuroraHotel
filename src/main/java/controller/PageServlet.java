package controller;

import dao.PageDAO;
import model.Page;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;
import java.util.List;

/**
 * Servlet for managing pages (CMS)
 * Handles CRUD operations for pages
 */
@WebServlet(name = "PageServlet", urlPatterns = {"/page"})
public class PageServlet extends HttpServlet {
    
    private PageDAO pageDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        pageDAO = new PageDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "view":
                    viewPage(request, response);
                    break;
                case "edit":
                    editPage(request, response);
                    break;
                case "delete":
                    deletePage(request, response);
                    break;
                default:
                    listPages(request, response);
            }
        } catch (Exception e) {
            System.err.println("Error in PageServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/admin/page-list.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
        
        try {
            if ("add".equals(action)) {
                addPage(request, response);
            } else if ("update".equals(action)) {
                updatePage(request, response);
            }
        } catch (Exception e) {
            System.err.println("Error in PageServlet POST: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/page");
        }
    }
    
    /**
     * List all pages
     */
    private void listPages(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Page> pages = pageDAO.getAll();
        request.setAttribute("pages", pages);
        request.getRequestDispatcher("/WEB-INF/admin/page-list.jsp").forward(request, response);
    }
    
    /**
     * View page details
     */
    private void viewPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pageUrlParam = request.getParameter("url");
        if (pageUrlParam == null || pageUrlParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/page");
            return;
        }
        
        Page page = pageDAO.getByURL(pageUrlParam);
        if (page != null) {
            request.setAttribute("page", page);
            request.getRequestDispatcher("/WEB-INF/page/view.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/page");
        }
    }
    
    /**
     * Show edit page form
     */
    private void editPage(HttpServletRequest request, HttpServletResponse response)
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
        
        String pageIdStr = request.getParameter("pageId");
        if (pageIdStr == null || pageIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/page");
            return;
        }
        
        try {
            int pageId = Integer.parseInt(pageIdStr);
            Page page = pageDAO.getById(pageId);
            
            if (page != null) {
                request.setAttribute("page", page);
                request.getRequestDispatcher("/WEB-INF/admin/page-edit.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/page");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/page");
        }
    }
    
    /**
     * Add new page
     */
    private void addPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Page page = new Page();
            page.setPageName(request.getParameter("pageName"));
            page.setPageURL(request.getParameter("pageUrl"));
            page.setTitle(request.getParameter("title"));
            page.setContent(request.getParameter("content"));
            page.setMetaDescription(request.getParameter("metaDescription"));
            page.setActive(request.getParameter("isActive") != null);
            page.setDisplayOrder(Integer.parseInt(request.getParameter("displayOrder")));
            
            if (pageDAO.create(page)) {
                request.setAttribute("success", "Page created successfully");
            } else {
                request.setAttribute("error", "Failed to create page");
            }
            
            response.sendRedirect(request.getContextPath() + "/page");
            
        } catch (Exception e) {
            System.err.println("Error adding page: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error adding page: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/page");
        }
    }
    
    /**
     * Update page
     */
    private void updatePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int pageId = Integer.parseInt(request.getParameter("pageId"));
            Page page = pageDAO.getById(pageId);
            
            if (page != null) {
                page.setPageName(request.getParameter("pageName"));
                page.setPageURL(request.getParameter("pageUrl"));
                page.setTitle(request.getParameter("title"));
                page.setContent(request.getParameter("content"));
                page.setMetaDescription(request.getParameter("metaDescription"));
                page.setActive(request.getParameter("isActive") != null);
                page.setDisplayOrder(Integer.parseInt(request.getParameter("displayOrder")));
                
                if (pageDAO.update(page)) {
                    request.setAttribute("success", "Page updated successfully");
                } else {
                    request.setAttribute("error", "Failed to update page");
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/page");
            
        } catch (Exception e) {
            System.err.println("Error updating page: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error updating page: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/page");
        }
    }
    
    /**
     * Delete page
     */
    private void deletePage(HttpServletRequest request, HttpServletResponse response)
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
        
        try {
            int pageId = Integer.parseInt(request.getParameter("pageId"));
            
            if (pageDAO.delete(pageId)) {
                request.setAttribute("success", "Page deleted successfully");
            } else {
                request.setAttribute("error", "Failed to delete page");
            }
            
            response.sendRedirect(request.getContextPath() + "/page");
            
        } catch (Exception e) {
            System.err.println("Error deleting page: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error deleting page: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/page");
        }
    }
}


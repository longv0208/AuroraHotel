package controller;

import dao.ServiceDAO;
import model.Service;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;

/**
 * Servlet for Service CRUD operations
 * Handles hotel services management (food, laundry, spa, etc.)
 * 
 * @author Aurora Hotel Team
 */
@WebServlet(name = "ServiceServlet", urlPatterns = { "/service" })
public class ServiceServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     * Processes view parameter: list, create, edit, delete, showcase
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String view = request.getParameter("view");

        // User-facing showcase (no role check)
        if (view == null || view.equals("showcase")) {
            showShowcase(request, response);
            return;
        }

        // Admin views (require admin role)
        User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null || !loggedInUser.getRole().equals("Admin")) {
            response.sendRedirect(request.getContextPath() + "/service?view=showcase");
            return;
        }

        if (view.equals("list")) {
            showList(request, response);
        } else if (view.equals("create")) {
            showCreateForm(request, response);
        } else if (view.equals("edit")) {
            showEditForm(request, response);
        } else if (view.equals("delete")) {
            showDeleteConfirmation(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/service?view=list");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * Processes action parameter: create, edit, delete
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/service?view=list");
            return;
        }

        switch (action) {
            case "create":
                processCreate(request, response);
                break;
            case "edit":
                processEdit(request, response);
                break;
            case "delete":
                processDelete(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/service?view=list");
        }
    }

    /**
     * Show list of services with pagination
     */
    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1)
                    page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        ServiceDAO dao = new ServiceDAO();
        List<Service> services = dao.getAllServices(page);
        int totalRows = dao.getTotalRows();
        int totalPages = (int) Math.ceil((double) totalRows / 10);

        request.setAttribute("services", services);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRows", totalRows);

        request.getRequestDispatcher("/WEB-INF/service/list.jsp").forward(request, response);
    }

    /**
     * Show create service form
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/service/create.jsp").forward(request, response);
    }

    /**
     * Show edit service form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ServiceDAO dao = new ServiceDAO();
            Service service = dao.getServiceById(id);

            if (service != null) {
                request.setAttribute("service", service);
                request.getRequestDispatcher("/WEB-INF/service/edit.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/service?view=list&error=notfound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/service?view=list&error=invalid");
        }
    }

    /**
     * Show delete confirmation page
     */
    private void showDeleteConfirmation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ServiceDAO dao = new ServiceDAO();
            Service service = dao.getServiceById(id);

            if (service != null) {
                request.setAttribute("service", service);
                request.getRequestDispatcher("/WEB-INF/service/delete.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/service?view=list&error=notfound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/service?view=list&error=invalid");
        }
    }

    /**
     * Process create service
     */
    private void processCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String serviceName = request.getParameter("serviceName");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String unit = request.getParameter("unit");
            String category = request.getParameter("category");

            // Validation
            if (serviceName == null || serviceName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Tên dịch vụ không được để trống");
                showCreateForm(request, response);
                return;
            }

            if (priceStr == null || priceStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Giá không được để trống");
                showCreateForm(request, response);
                return;
            }

            BigDecimal price = new BigDecimal(priceStr);
            if (price.compareTo(BigDecimal.ZERO) < 0) {
                request.setAttribute("errorMessage", "Giá phải lớn hơn hoặc bằng 0");
                showCreateForm(request, response);
                return;
            }

            // Create service object
            Service service = new Service();
            service.setServiceName(serviceName.trim());
            service.setDescription(description != null ? description.trim() : "");
            service.setPrice(price);
            service.setUnit(unit != null ? unit.trim() : "");
            service.setCategory(category != null ? category.trim() : "Khác");
            service.setActive(true);

            // Save to database
            ServiceDAO dao = new ServiceDAO();
            int serviceId = dao.createService(service);

            if (serviceId > 0) {
                response.sendRedirect(request.getContextPath() + "/service?view=list&created=1");
            } else {
                request.setAttribute("errorMessage", "Không thể tạo dịch vụ");
                showCreateForm(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Giá không hợp lệ");
            showCreateForm(request, response);
        } catch (Exception e) {
            System.err.println("Error creating service: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            showCreateForm(request, response);
        }
    }

    /**
     * Process edit service
     */
    private void processEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String serviceName = request.getParameter("serviceName");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String unit = request.getParameter("unit");
            String category = request.getParameter("category");
            String isActiveStr = request.getParameter("isActive");

            // Validation
            if (serviceName == null || serviceName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Tên dịch vụ không được để trống");
                showEditForm(request, response);
                return;
            }

            BigDecimal price = new BigDecimal(priceStr);
            boolean isActive = "on".equals(isActiveStr) || "true".equals(isActiveStr);

            // Create service object
            Service service = new Service();
            service.setServiceID(serviceId);
            service.setServiceName(serviceName.trim());
            service.setDescription(description != null ? description.trim() : "");
            service.setPrice(price);
            service.setUnit(unit != null ? unit.trim() : "");
            service.setCategory(category != null ? category.trim() : "Khác");
            service.setActive(isActive);

            // Update in database
            ServiceDAO dao = new ServiceDAO();
            boolean result = dao.updateService(service);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/service?view=list&updated=1");
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật dịch vụ");
                showEditForm(request, response);
            }

        } catch (Exception e) {
            System.err.println("Error updating service: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/service?view=list&error=1");
        }
    }

    /**
     * Process delete service
     */
    private void processDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));

            ServiceDAO dao = new ServiceDAO();
            boolean result = dao.deleteService(serviceId);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/service?view=list&deleted=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/service?view=list&error=1");
            }

        } catch (Exception e) {
            System.err.println("Error deleting service: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/service?view=list&error=1");
        }
    }

    /**
     * Show user-facing service showcase
     */
    private void showShowcase(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String category = request.getParameter("category");

            ServiceDAO dao = new ServiceDAO();
            List<Service> services;
            List<String> categories = dao.getDistinctCategories();

            if (category != null && !category.isEmpty()) {
                services = dao.getServicesByCategory(category);
            } else {
                services = dao.getAllActiveServices();
            }

            request.setAttribute("services", services);
            request.setAttribute("categories", categories);
            request.setAttribute("selectedCategory", category);
            request.getRequestDispatcher("/WEB-INF/hotel/service-showcase.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error showing service showcase: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading services");
            request.getRequestDispatcher("/WEB-INF/hotel/home.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Service Management Servlet - Handles CRUD operations for hotel services";
    }
}

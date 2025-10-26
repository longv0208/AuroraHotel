package controller;

import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet cho Admin Dashboard Đây là trung tâm quản trị chính cho tất cả các
 * tính năng quản lý của Admin.
 *
 * @author Aurora Hotel Team
 */
@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

    /**
     * Xử lý các yêu cầu GET đến trang Admin Dashboard.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy session hiện tại (false để không tạo session mới nếu chưa có)
        HttpSession session = request.getSession(false);

        // Kiểm tra nếu chưa đăng nhập thì chuyển về trang login
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy thông tin user từ session
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        // Kiểm tra quyền hạn — chỉ cho phép Admin truy cập
        if (!"Admin".equals(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Nếu là Admin thì chuyển đến giao diện dashboard
        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
    }
}

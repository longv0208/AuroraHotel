/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.RoomDAO;
import dao.RoomTypeDAO;
import model.Room;
import model.RoomType;
import model.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 * Servlet for Room CRUD operations
 *
 * Follows the ArtistServlet pattern:
 * - doGet handles view parameter: list, create, edit, delete
 * - doPost handles action parameter: create, edit, delete
 *
 * @author Aurora Hotel Team
 */
@WebServlet(name = "RoomManagementServlet", urlPatterns = { "/roomManagement" })
public class RoomManagementServlet extends HttpServlet {

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {

            // Check if user is Admin
            User loggedInUser = (User) session.getAttribute("loggedInUser");
            if (!"Admin".equals(loggedInUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            String view = request.getParameter("view");

            if (view == null || view.equals("list")) {
                // List view with pagination
                int page = 1;
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.isEmpty()) {
                    try {
                        page = Integer.parseInt(pageStr);
                        if (page < 1) {
                            page = 1;
                        }
                    } catch (NumberFormatException ex) {
                        System.err.println("Invalid page parameter");
                    }
                }

                RoomDAO dao = new RoomDAO();
                List<Room> list = dao.getRoomList(page);

                int rowCount = dao.getTotalRows();
                int totalPages = (int) Math.ceil((double) rowCount / 10);

                request.setAttribute("rooms", list);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalRows", rowCount);
                request.getRequestDispatcher("/WEB-INF/room/list.jsp").forward(request, response);

            } else if (view.equals("create")) {
                // Create view
                RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
                List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
                request.setAttribute("roomTypes", roomTypes);
                request.getRequestDispatcher("/WEB-INF/room/create.jsp").forward(request, response);

            } else if (view.equals("edit")) {
                // Edit view
                RoomDAO dao = new RoomDAO();
                int id = Integer.parseInt(request.getParameter("id"));
                Room room = dao.getById(id);

                RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
                List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();

                request.setAttribute("room", room);
                request.setAttribute("roomTypes", roomTypes);
                request.getRequestDispatcher("/WEB-INF/room/edit.jsp").forward(request, response);

            } else if (view.equals("delete")) {
                // Delete view
                RoomDAO dao = new RoomDAO();
                int id = Integer.parseInt(request.getParameter("id"));
                Room room = dao.getById(id);
                request.setAttribute("room", room);
                request.getRequestDispatcher("/WEB-INF/room/delete.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
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
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");

        if (action.equals("edit")) {
            // Edit action
            String idpr = request.getParameter("roomID");
            int id = Integer.parseInt(idpr);
            String roomNumber = request.getParameter("roomNumber");
            int roomTypeID = Integer.parseInt(request.getParameter("roomTypeID"));
            int floor = Integer.parseInt(request.getParameter("floor"));
            String status = request.getParameter("status");
            String description = request.getParameter("description");
            boolean isActive = "1".equals(request.getParameter("isActive"));

            RoomDAO roomDAO = new RoomDAO();
            RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

            // Validate room number is not empty
            if (roomNumber == null || roomNumber.trim().isEmpty()) {
                request.setAttribute("error", "Số phòng không được để trống");
                Room room = roomDAO.getById(id);
                List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
                request.setAttribute("room", room);
                request.setAttribute("roomTypes", roomTypes);
                request.getRequestDispatcher("/WEB-INF/room/edit.jsp").forward(request, response);
                return;
            }

            // Check if room number already exists for another room
            if (roomDAO.isRoomNumberExistsForOtherRoom(roomNumber.trim(), id)) {
                request.setAttribute("error", "Số phòng '" + roomNumber + "' đã tồn tại. Vui lòng chọn số phòng khác.");
                Room room = roomDAO.getById(id);
                List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
                request.setAttribute("room", room);
                request.setAttribute("roomTypes", roomTypes);
                request.getRequestDispatcher("/WEB-INF/room/edit.jsp").forward(request, response);
                return;
            }

            Room room = new Room(id, roomNumber, roomTypeID, floor, status, description, isActive);
            boolean result = roomDAO.update(room);

            if (result) {
                request.setAttribute("success", "Cập nhật phòng thành công");
                response.sendRedirect(request.getContextPath() + "/roomManagement?view=list");
            } else {
                request.setAttribute("error", "Không thể cập nhật phòng. Vui lòng thử lại.");
                List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
                request.setAttribute("room", room);
                request.setAttribute("roomTypes", roomTypes);
                request.getRequestDispatcher("/WEB-INF/room/edit.jsp").forward(request, response);
            }

        } else if (action.equals("create")) {
            // Create action
            String roomNumber = request.getParameter("roomNumber");
            int roomTypeID = Integer.parseInt(request.getParameter("roomTypeID"));
            int floor = Integer.parseInt(request.getParameter("floor"));
            String status = request.getParameter("status");
            String description = request.getParameter("description");

            RoomDAO roomDAO = new RoomDAO();
            RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

            // Validate room number is not empty
            if (roomNumber == null || roomNumber.trim().isEmpty()) {
                request.setAttribute("error", "Số phòng không được để trống");
                List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
                request.setAttribute("roomTypes", roomTypes);
                request.getRequestDispatcher("/WEB-INF/room/create.jsp").forward(request, response);
                return;
            }

            // Check if room number already exists
            if (roomDAO.isRoomNumberExists(roomNumber.trim())) {
                request.setAttribute("error", "Số phòng '" + roomNumber + "' đã tồn tại. Vui lòng chọn số phòng khác.");
                request.setAttribute("roomNumber", roomNumber);
                request.setAttribute("roomTypeID", roomTypeID);
                request.setAttribute("floor", floor);
                request.setAttribute("status", status);
                request.setAttribute("description", description);
                List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
                request.setAttribute("roomTypes", roomTypes);
                request.getRequestDispatcher("/WEB-INF/room/create.jsp").forward(request, response);
                return;
            }

            Room room = new Room(roomNumber, roomTypeID, floor, status, description);
            boolean result = roomDAO.create(room);

            if (result) {
                request.setAttribute("success", "Tạo phòng thành công");
                response.sendRedirect(request.getContextPath() + "/roomManagement?view=list");
            } else {
                request.setAttribute("error", "Không thể tạo phòng. Vui lòng thử lại.");
                List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
                request.setAttribute("roomTypes", roomTypes);
                request.setAttribute("roomNumber", roomNumber);
                request.setAttribute("roomTypeID", roomTypeID);
                request.setAttribute("floor", floor);
                request.setAttribute("status", status);
                request.setAttribute("description", description);
                request.getRequestDispatcher("/WEB-INF/room/create.jsp").forward(request, response);
            }

        } else if (action.equals("delete")) {
            // Delete action
            String idRaw = request.getParameter("id");
            int id = Integer.parseInt(idRaw);

            RoomDAO roomDAO = new RoomDAO();
            boolean result = roomDAO.delete(id);

            if (result) {
                response.sendRedirect(request.getContextPath() + "/roomManagement?view=list");
            } else {
                response.sendRedirect(request.getContextPath() + "/roomManagement?view=delete&id=" + id);
            }
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Room Management Servlet - CRUD operations for rooms";
    }// </editor-fold>

}

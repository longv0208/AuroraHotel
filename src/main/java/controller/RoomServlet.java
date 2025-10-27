package controller;

import dao.RoomDAO;
import dao.RoomImageDAO;
import dao.RoomTypeDAO;
import model.Room;
import model.RoomImage;
import model.RoomType;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet for User-Facing Room Viewing
 * Handles room list with filters and room detail pages
 * 
 * @author Aurora Hotel Team
 */
@WebServlet(name = "RoomServlet", urlPatterns = {"/room"})
public class RoomServlet extends HttpServlet {

    /**
     * Handles GET requests for room list and details
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String view = request.getParameter("view");

        if (view == null || view.equals("list")) {
            showRoomList(request, response);
        } else if (view.equals("detail")) {
            showRoomDetails(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/room?view=list");
        }
    }

    /**
     * Show room list with filters and pagination
     */
    private void showRoomList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get pagination parameter
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            // Build filter map
            Map<String, String> filters = new HashMap<>();
            
            String roomTypeId = request.getParameter("roomTypeId");
            if (roomTypeId != null && !roomTypeId.isEmpty()) {
                filters.put("roomTypeId", roomTypeId);
            }
            
            String priceMin = request.getParameter("priceMin");
            if (priceMin != null && !priceMin.isEmpty()) {
                filters.put("priceMin", priceMin);
            }
            
            String priceMax = request.getParameter("priceMax");
            if (priceMax != null && !priceMax.isEmpty()) {
                filters.put("priceMax", priceMax);
            }
            
            String floor = request.getParameter("floor");
            if (floor != null && !floor.isEmpty()) {
                filters.put("floor", floor);
            }
            
            String capacity = request.getParameter("capacity");
            if (capacity != null && !capacity.isEmpty()) {
                filters.put("capacity", capacity);
            }
            
            String sortBy = request.getParameter("sortBy");
            if (sortBy == null || sortBy.isEmpty()) {
                sortBy = "roomNumber";
            }
            filters.put("sortBy", sortBy);
            
            // Get room list
            RoomDAO roomDAO = new RoomDAO();
            List<Room> rooms = roomDAO.getAvailableRooms(page, filters);
            int totalRows = roomDAO.getTotalAvailableRooms(filters);
            int totalPages = (int) Math.ceil((double) totalRows / 12);
            
            // Get room types for filter dropdown
            RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
            List<RoomType> roomTypes = roomTypeDAO.getAllRoomTypes();
            
            // Load primary images for each room
            RoomImageDAO roomImageDAO = new RoomImageDAO();
            for (Room room : rooms) {
                RoomImage primaryImage = roomImageDAO.getPrimaryImageByRoomId(room.getRoomID());
                room.setPrimaryImage(primaryImage);
            }
            
            // Set attributes
            request.setAttribute("rooms", rooms);
            request.setAttribute("roomTypes", roomTypes);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRows", totalRows);
            request.setAttribute("filters", filters);
            
            request.getRequestDispatcher("/WEB-INF/hotel/room-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in RoomServlet.showRoomList: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading rooms: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/hotel/home.jsp").forward(request, response);
        }
    }

    /**
     * Show room details with images and reviews
     */
    private void showRoomDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/room?view=list");
                return;
            }
            
            int roomId = Integer.parseInt(idParam);
            
            RoomDAO roomDAO = new RoomDAO();
            Room room = roomDAO.getRoomDetail(roomId);
            
            if (room == null) {
                response.sendRedirect(request.getContextPath() + "/room?view=list");
                return;
            }
            
            // Load room images
            RoomImageDAO roomImageDAO = new RoomImageDAO();
            List<RoomImage> roomImages = roomImageDAO.getByRoomId(roomId);
            
            request.setAttribute("room", room);
            request.setAttribute("roomImages", roomImages);
            request.getRequestDispatcher("/WEB-INF/hotel/room-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/room?view=list");
        } catch (Exception e) {
            System.err.println("Error in RoomServlet.showRoomDetails: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading room details: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/hotel/home.jsp").forward(request, response);
        }
    }
}


package controller;

import dao.RoomImageDAO;
import model.RoomImage;
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
 * Servlet for managing room images
 * Handles CRUD operations for room images
 */
@WebServlet(name = "RoomImageServlet", urlPatterns = {"/roomImage"})
public class RoomImageServlet extends HttpServlet {
    
    private RoomImageDAO roomImageDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        roomImageDAO = new RoomImageDAO();
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
                case "view":
                    viewImages(request, response);
                    break;
                case "edit":
                    editImage(request, response);
                    break;
                case "delete":
                    deleteImage(request, response);
                    break;
                case "setPrimary":
                    setPrimaryImage(request, response);
                    break;
                default:
                    listImages(request, response);
            }
        } catch (Exception e) {
            System.err.println("Error in RoomImageServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/admin/room-image-list.jsp").forward(request, response);
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
                addImage(request, response);
            } else if ("update".equals(action)) {
                updateImage(request, response);
            }
        } catch (Exception e) {
            System.err.println("Error in RoomImageServlet POST: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/roomImage");
        }
    }
    
    /**
     * List all room images
     */
    private void listImages(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/WEB-INF/admin/room-image-list.jsp").forward(request, response);
    }
    
    /**
     * View images for a specific room
     */
    private void viewImages(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String roomIdStr = request.getParameter("roomId");
        if (roomIdStr == null || roomIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/roomImage");
            return;
        }
        
        try {
            int roomId = Integer.parseInt(roomIdStr);
            List<RoomImage> images = roomImageDAO.getByRoomId(roomId);
            
            request.setAttribute("roomId", roomId);
            request.setAttribute("images", images);
            request.getRequestDispatcher("/WEB-INF/admin/room-image-view.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/roomImage");
        }
    }
    
    /**
     * Add new room image
     */
    private void addImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            RoomImage image = new RoomImage();
            
            String roomIdStr = request.getParameter("roomId");
            String roomTypeIdStr = request.getParameter("roomTypeId");
            String imageUrl = request.getParameter("imageUrl");
            String imageTitle = request.getParameter("imageTitle");
            String description = request.getParameter("description");
            String displayOrderStr = request.getParameter("displayOrder");
            String uploadedByStr = request.getParameter("uploadedBy");
            
            if (roomIdStr != null && !roomIdStr.isEmpty()) {
                image.setRoomID(Integer.parseInt(roomIdStr));
            }
            if (roomTypeIdStr != null && !roomTypeIdStr.isEmpty()) {
                image.setRoomTypeID(Integer.parseInt(roomTypeIdStr));
            }
            
            image.setImageURL(imageUrl);
            image.setImageTitle(imageTitle);
            image.setDescription(description);
            image.setDisplayOrder(displayOrderStr != null ? Integer.parseInt(displayOrderStr) : 0);
            image.setUploadedBy(Integer.parseInt(uploadedByStr));
            image.setActive(true);
            
            if (roomImageDAO.create(image)) {
                request.setAttribute("success", "Image added successfully");
            } else {
                request.setAttribute("error", "Failed to add image");
            }
            
            response.sendRedirect(request.getContextPath() + "/roomImage");
            
        } catch (Exception e) {
            System.err.println("Error adding image: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error adding image: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/roomImage");
        }
    }
    
    /**
     * Edit room image
     */
    private void editImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String imageIdStr = request.getParameter("imageId");
        if (imageIdStr == null || imageIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/roomImage");
            return;
        }
        
        try {
            int imageId = Integer.parseInt(imageIdStr);
            RoomImage image = roomImageDAO.getById(imageId);
            
            if (image != null) {
                request.setAttribute("image", image);
                request.getRequestDispatcher("/WEB-INF/admin/room-image-edit.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/roomImage");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/roomImage");
        }
    }
    
    /**
     * Update room image
     */
    private void updateImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int imageId = Integer.parseInt(request.getParameter("imageId"));
            RoomImage image = roomImageDAO.getById(imageId);
            
            if (image != null) {
                image.setImageURL(request.getParameter("imageUrl"));
                image.setImageTitle(request.getParameter("imageTitle"));
                image.setDescription(request.getParameter("description"));
                image.setDisplayOrder(Integer.parseInt(request.getParameter("displayOrder")));
                
                if (roomImageDAO.update(image)) {
                    request.setAttribute("success", "Image updated successfully");
                } else {
                    request.setAttribute("error", "Failed to update image");
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/roomImage");
            
        } catch (Exception e) {
            System.err.println("Error updating image: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error updating image: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/roomImage");
        }
    }
    
    /**
     * Delete room image
     */
    private void deleteImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int imageId = Integer.parseInt(request.getParameter("imageId"));
            
            if (roomImageDAO.delete(imageId)) {
                request.setAttribute("success", "Image deleted successfully");
            } else {
                request.setAttribute("error", "Failed to delete image");
            }
            
            response.sendRedirect(request.getContextPath() + "/roomImage");
            
        } catch (Exception e) {
            System.err.println("Error deleting image: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error deleting image: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/roomImage");
        }
    }
    
    /**
     * Set image as primary for a room
     */
    private void setPrimaryImage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int imageId = Integer.parseInt(request.getParameter("imageId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            
            if (roomImageDAO.setPrimary(imageId, roomId)) {
                request.setAttribute("success", "Primary image set successfully");
            } else {
                request.setAttribute("error", "Failed to set primary image");
            }
            
            response.sendRedirect(request.getContextPath() + "/roomImage?action=view&roomId=" + roomId);
            
        } catch (Exception e) {
            System.err.println("Error setting primary image: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error setting primary image: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/roomImage");
        }
    }
}


//package filter;
//
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//
///**
// * Authentication Filter
// * Checks if user is logged in before accessing protected resources
// *
// * Protected URLs: All URLs except login, public pages, and static resources
// */
//@WebFilter(filterName = "AuthenticationFilter", urlPatterns = { "/*" })
//public class AuthenticationFilter implements Filter {
//
//    /**
//     * Initialize filter
//     */
//    @Override
//    public void init(FilterConfig filterConfig) throws ServletException {
//        System.out.println("AuthenticationFilter initialized");
//    }
//
//    /**
//     * Filter requests - check authentication
//     */
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//
//        HttpServletRequest httpRequest = (HttpServletRequest) request;
//        HttpServletResponse httpResponse = (HttpServletResponse) response;
//
//        String requestURI = httpRequest.getRequestURI();
//        String contextPath = httpRequest.getContextPath();
//
//        // Remove context path to get the actual path
//        String path = requestURI.substring(contextPath.length());
//
//        // Check if this is a public resource (no authentication required)
//        if (isPublicResource(path)) {
//            // Allow access to public resources
//            chain.doFilter(request, response);
//            return;
//        }
//
//        // Check if user is logged in
//        HttpSession session = httpRequest.getSession(false);
//        boolean isLoggedIn = (session != null && session.getAttribute("loggedInUser") != null);
//
//        if (isLoggedIn) {
//            // User is logged in, allow access
//            chain.doFilter(request, response);
//        } else {
//            // User is not logged in, redirect to login page
//            // Save the requested URL to redirect back after login
//            String requestedURL = httpRequest.getRequestURI();
//            String queryString = httpRequest.getQueryString();
//
//            if (queryString != null) {
//                requestedURL += "?" + queryString;
//            }
//
//            // Redirect to login with the requested URL as parameter
//            httpResponse.sendRedirect(contextPath + "/login?redirect=" +
//                    java.net.URLEncoder.encode(requestedURL, "UTF-8"));
//        }
//    }
//
//    /**
//     * Check if the requested resource is public (doesn't require authentication)
//     *
//     * @param path Request path (without context path)
//     * @return true if resource is public, false otherwise
//     */
//    private boolean isPublicResource(String path) {
//        // Login and logout pages
//        if (path.equals("/login") || path.equals("/logout")) {
//            return true;
//        }
//
//        // Public pages (home, about, rooms, services, feedback)
//        if (path.equals("/") || path.equals("/aurora") || path.equals("/home") ||
//                path.equals("/about") || path.equals("/room") ||
//                path.equals("/service") || path.equals("/feedback")) {
//            return true;
//        }
//
//        // Static resources (CSS, JS, images, fonts)
//        if (path.startsWith("/assets/") ||
//                path.startsWith("/css/") ||
//                path.startsWith("/js/") ||
//                path.startsWith("/images/") ||
//                path.startsWith("/img/") ||
//                path.startsWith("/fonts/") ||
//                path.startsWith("/resources/") ||
//                path.startsWith("/static/")) {
//            return true;
//        }
//
//        // Favicon
//        if (path.equals("/favicon.ico")) {
//            return true;
//        }
//
//        // File extensions that are always public
//        if (path.endsWith(".css") || path.endsWith(".js") ||
//                path.endsWith(".png") || path.endsWith(".jpg") ||
//                path.endsWith(".jpeg") || path.endsWith(".gif") ||
//                path.endsWith(".svg") || path.endsWith(".ico") ||
//                path.endsWith(".woff") || path.endsWith(".woff2") ||
//                path.endsWith(".ttf") || path.endsWith(".eot")) {
//            return true;
//        }
//
//        // All other resources require authentication
//        return false;
//    }
//
//    /**
//     * Destroy filter
//     */
//    @Override
//    public void destroy() {
//        System.out.println("AuthenticationFilter destroyed");
//    }
//}

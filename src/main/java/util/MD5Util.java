package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utility class for MD5 password hashing
 * 
 * ⚠️ CRITICAL SECURITY WARNING ⚠️
 * MD5 is cryptographically broken and unsuitable for password hashing (as of 2025).
 * It is vulnerable to:
 * - Rainbow table attacks
 * - Collision attacks
 * - Brute-force attacks (due to fast computation)
 * 
 * RECOMMENDED ALTERNATIVES:
 * - BCrypt (with cost factor 12 or higher)
 * - Argon2id (winner of Password Hashing Competition)
 * - SCrypt
 * 
 * This implementation is provided only because it was explicitly requested.
 * For production systems, please migrate to BCrypt or Argon2id immediately.
 * 
 * MITIGATION (if MD5 must be used):
 * - Implement rate limiting on login attempts
 * - Implement account lockout after failed attempts
 * - Use HTTPS for all authentication traffic
 * - Consider adding a salt (though this class doesn't implement it)
 */
public class MD5Util {
    
    /**
     * Hash a password using MD5 algorithm
     * 
     * @param password Plain text password to hash
     * @return MD5 hash as hexadecimal string, or null if hashing fails
     * 
     * ⚠️ WARNING: MD5 is NOT secure for password hashing!
     * Use BCrypt or Argon2id instead for production systems.
     */
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) {
            return null;
        }
        
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(password.getBytes());
            
            // Convert byte array to hexadecimal string
            StringBuilder hexString = new StringBuilder();
            for (byte b : messageDigest) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            
            return hexString.toString();
            
        } catch (NoSuchAlgorithmException e) {
            System.err.println("MD5 algorithm not found: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Verify a plain text password against a stored MD5 hash
     * 
     * @param plainPassword Plain text password to verify
     * @param hashedPassword Stored MD5 hash to compare against
     * @return true if passwords match, false otherwise
     * 
     * ⚠️ WARNING: MD5 is NOT secure for password hashing!
     * Use BCrypt or Argon2id instead for production systems.
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        
        String hashedInput = hashPassword(plainPassword);
        return hashedPassword.equals(hashedInput);
    }
    
    /**
     * Test method to demonstrate MD5 hashing
     * 
     * Example usage:
     * String password = "myPassword123";
     * String hashed = MD5Util.hashPassword(password);
     * boolean isValid = MD5Util.verifyPassword("myPassword123", hashed); // true
     * boolean isInvalid = MD5Util.verifyPassword("wrongPassword", hashed); // false
     */
    public static void main(String[] args) {
        // Example usage
        String password = "admin123";
        String hashed = hashPassword(password);
        
        System.out.println("Original password: " + password);
        System.out.println("MD5 hash: " + hashed);
        System.out.println("Verification (correct): " + verifyPassword("admin123", hashed));
        System.out.println("Verification (incorrect): " + verifyPassword("wrongpass", hashed));
        
        System.out.println("\n⚠️ SECURITY WARNING: MD5 is NOT secure for password hashing!");
        System.out.println("Please use BCrypt or Argon2id for production systems.");
    }
}


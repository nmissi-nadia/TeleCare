package org.example.projet.util;

import org.mindrot.jbcrypt.BCrypt;

public class SecurityUtil {
    public static String hashPassword(String plain) {
        return BCrypt.hashpw(plain, BCrypt.gensalt(12));
    }
    public static boolean verify(String plain, String hashed) {
        return BCrypt.checkpw(plain, hashed);
    }
}

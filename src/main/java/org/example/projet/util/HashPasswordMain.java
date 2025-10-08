package org.example.projet.util;
public class HashPasswordMain {
    public static void main(String[] args) {
        String pass = "admin123";
        System.out.println(SecurityUtil.hashPassword(pass));
    }
}

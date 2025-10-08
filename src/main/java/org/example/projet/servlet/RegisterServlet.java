package org.example.projet.servlet;

import org.example.projet.dao.UserDAO;
import org.example.projet.model.Infirmier;
import org.example.projet.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String nom = req.getParameter("nom");
        String prenom = req.getParameter("prenom");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        Infirmier inf = new Infirmier();

        inf.setPrenom(prenom.length() > 0 ? prenom : "");
        inf.setNom(nom.length() > 1 ? nom : "");

        inf.setLogin(email);
        inf.setMotDePasse(SecurityUtil.hashPassword(password));
        inf.setRole("INFIRMIER");

        userDAO.save(inf);

        resp.sendRedirect(req.getContextPath() + "/jsp/login.jsp");
    }
}

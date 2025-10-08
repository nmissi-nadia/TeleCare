package org.example.projet.servlet;

import org.example.projet.dao.UserDAO;
import org.example.projet.model.User;
import org.example.projet.util.SecurityUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String login = req.getParameter("login");
        String pass = req.getParameter("password");
        User u = userDAO.findByLogin(login);
        if (u != null && SecurityUtil.verify(pass, u.getMotDePasse())) {
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", u);
            session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());
            resp.sendRedirect(req.getContextPath() + "/app/patient");
        } else {
            req.setAttribute("error", "Login ou mot de passe incorrect");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
        }
    }
}

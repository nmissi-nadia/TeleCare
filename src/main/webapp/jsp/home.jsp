<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>TeleCare - Accueil</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 20px;
        }

        .container {
            max-width: 100%;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }

        .logo {
            font-size: 36px;
            color: #007bff;
            margin-bottom: 20px;
        }

        h1 {
            color: #333;
            margin-bottom: 20px;
        }

        .user-info {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 30px;
        }

        .btn {
            background: #007bff;
            color: white;
            padding: 15px 30px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            margin: 10px;
            display: inline-block;
        }

        .btn:hover {
            background: #0056b3;
        }

        .btn-danger {
            background: #dc3545;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .btn-success {
            background: #28a745;
        }

        .btn-success:hover {
            background: #218838;
        }

        .footer {
            margin-top: 30px;
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>TeleCare</h1>

        <div class="user-info">
            <h3>Connecté: ${sessionScope.currentUser.prenom} ${sessionScope.currentUser.nom}</h3>
            <p><strong>Rôle:</strong> ${sessionScope.currentUser.role}</p>
        </div>

        <div>
            <c:choose>
                <c:when test="${sessionScope.currentUser.role == 'INFIRMIER'}">
                    <a href="${pageContext.request.contextPath}/app/infirmier/dashboard" class="btn btn-success">
                      Dashboard Infirmier
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/app/medecin/dashboard" class="btn">
                        Dashboard Médecin
                    </a>
                </c:otherwise>
            </c:choose>

            <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">
                 Déconnexion
            </a>
        </div>

    </div>
</body>
</html>
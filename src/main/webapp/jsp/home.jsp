<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>TeleCare - Accueil</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 600px;
            width: 90%;
        }

        .logo {
            font-size: 48px;
            color: #667eea;
            margin-bottom: 20px;
        }

        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 32px;
        }

        .subtitle {
            color: #666;
            margin-bottom: 40px;
            font-size: 18px;
        }

        .user-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border-left: 4px solid #667eea;
        }

        .user-name {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }

        .user-role {
            color: #667eea;
            font-size: 16px;
            text-transform: uppercase;
            font-weight: bold;
        }

        .role-selection {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .role-card {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 15px;
            padding: 30px 20px;
            transition: all 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
        }

        .role-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            border-color: #667eea;
        }

        .role-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .infirmier .role-icon {
            color: #28a745;
        }

        .medecin .role-icon {
            color: #007bff;
        }

        .role-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #333;
        }

        .role-description {
            color: #666;
            font-size: 14px;
            line-height: 1.5;
        }

        .logout-btn {
            background: #dc3545;
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: background 0.3s ease;
        }

        .logout-btn:hover {
            background: #c82333;
        }

        .footer {
            margin-top: 30px;
            color: #999;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">🏥</div>
        <h1>TeleCare</h1>
        <p class="subtitle">Système de Télémédecine Expert</p>

        <div class="user-info">
            <div class="user-name">Connecté en tant que: ${sessionScope.currentUser.prenom} ${sessionScope.currentUser.nom}</div>
            <div class="user-role">${sessionScope.currentUser.role}</div>
        </div>

        <div class="role-selection">
            <a href="${pageContext.request.contextPath}/app/infirmier/dashboard" class="role-card infirmier">
                <div class="role-icon">👩‍⚕️</div>
                <div class="role-title">Infirmier</div>
                <div class="role-description">
                    Enregistrer les patients, prendre les constantes,
                    suivre les statuts en temps réel
                </div>
            </a>

            <a href="${pageContext.request.contextPath}/app/medecin/dashboard" class="role-card medecin">
                <div class="role-icon">👨‍⚕️</div>
                <div class="role-title">Médecin Généraliste</div>
                <div class="role-description">
                    Consulter les patients en attente,
                    créer des consultations, ajouter des actes
                </div>
            </a>
        </div>

        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
            Se Déconnecter
        </a>

        <div class="footer">
            <p>© 2024 TeleCare - Système de Télémédecine</p>
        </div>
    </div>
</body>
</html>

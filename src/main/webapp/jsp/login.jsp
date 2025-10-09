<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>TeleCare - Connexion</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 350px;
        }

        .logo {
            text-align: center;
            font-size: 32px;
            color: #667eea;
            margin-bottom: 10px;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }

        input:focus {
            outline: none;
            border-color: #667eea;
        }

        .btn {
            width: 100%;
            background: #667eea;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }

        .btn:hover {
            background: #5a67d8;
        }

        .error-message {
            background: #fee;
            color: #c33;
            padding: 8px;
            border-radius: 4px;
            margin-bottom: 15px;
            border-left: 3px solid #c33;
            font-size: 14px;
        }

        .register-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        .register-link a {
            color: #667eea;
            text-decoration: none;
        }

        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">🏥</div>
        <h2>Connexion à TeleCare</h2>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label>Nom d'utilisateur :</label>
                <input name="login" placeholder="Votre nom d'utilisateur" required/>
            </div>

            <div class="form-group">
                <label>Mot de passe :</label>
                <input name="password" type="password" placeholder="Votre mot de passe" required/>
            </div>

            <button type="submit" class="btn">Se Connecter</button>
        </form>

        <div class="register-link">
            <p>Pas encore de compte ? <a href="${pageContext.request.contextPath}/jsp/register.jsp">Créer un compte</a></p>
        </div>
    </div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Inscription - TeleCare</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .register-container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 450px;
        }

        .logo {
            text-align: center;
            font-size: 36px;
            color: #667eea;
            margin-bottom: 10px;
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
        }

        h2 {
            color: #667eea;
            margin: 25px 0 15px 0;
            font-size: 18px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 5px;
        }

        .form-section {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin: 10px 0 5px 0;
            color: #555;
            font-weight: 500;
        }

        input, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
        }

        .role-selection {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 10px;
            margin: 10px 0;
        }

        .role-option {
            border: 2px solid #ddd;
            border-radius: 8px;
            padding: 15px 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .role-option:hover {
            border-color: #667eea;
            background: #e3f2fd;
        }

        .role-option.selected {
            border-color: #667eea;
            background: #667eea;
            color: white;
        }

        .role-icon {
            font-size: 24px;
            margin-bottom: 8px;
        }

        .role-label {
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
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
            margin-top: 15px;
        }

        .btn:hover {
            background: #5a67d8;
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
        }

        .back-link a:hover {
            text-decoration: underline;
        }

        small {
            color: #666;
            font-size: 12px;
        }

        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            border-left: 3px solid #c62828;
            font-size: 14px;
        }

        .required {
            color: #e53935;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="logo">🏥</div>
        <h1>Créer votre compte TeleCare</h1>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <form action="<%= request.getContextPath() %>/register" method="post">
            <!-- Section Informations personnelles -->
            <h2>Informations personnelles</h2>
            <div class="form-section">
                <label>Nom <span class="required">*</span> :</label>
                <input type="text" name="nom" required>
            </div>

            <div class="form-section">
                <label>Prénom <span class="required">*</span> :</label>
                <input type="text" name="prenom" required>
            </div>

            <!-- Section Rôle -->
            <h2>Choisir votre rôle</h2>
            <div class="form-section">
                <label>Votre fonction médicale <span class="required">*</span> :</label>
                <input type="hidden" name="role" id="selectedRole" required>

                <div class="role-selection">
                    <div class="role-option" onclick="selectRole('INFIRMIER')">
                        <div class="role-icon">👩‍⚕️</div>
                        <div class="role-label">Infirmier</div>
                    </div>

                    <div class="role-option" onclick="selectRole('MEDECIN_GENERALISTE')">
                        <div class="role-icon">👨‍⚕️</div>
                        <div class="role-label">Médecin Généraliste</div>
                    </div>

                    <div class="role-option" onclick="selectRole('MEDECIN_SPECIALISTE')">
                        <div class="role-icon">🩺</div>
                        <div class="role-label">Médecin Spécialiste</div>
                    </div>
                </div>
            </div>

            <!-- Section Authentification -->
            <h2>Informations de connexion</h2>
            <div class="form-section">
                <label>Email <span class="required">*</span> :</label>
                <input type="email" name="email" required>
            </div>

            <div class="form-section">
                <label>Mot de passe <span class="required">*</span> :</label>
                <input type="password" name="password"
                       title="8 caractères minimum, avec majuscule et chiffre"
                       required>
                <small>8 caractères minimum, avec majuscule et chiffre</small>
            </div>

            <button type="submit" class="btn">Créer mon compte</button>

            <div class="back-link">
                <a href="${pageContext.request.contextPath}/jsp/login.jsp">← Retour à la connexion</a>
            </div>
        </form>
    </div>

    <script>
        function selectRole(role) {
            // Retirer la sélection de tous les rôles
            document.querySelectorAll('.role-option').forEach(option => {
                option.classList.remove('selected');
            });

            // Sélectionner le rôle choisi
            event.target.classList.add('selected');

            // Mettre à jour le champ caché
            document.getElementById('selectedRole').value = role;
        }
    </script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Inscription</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f6f7fb;
            margin: 40px;
        }
        form {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            width: 400px;
            margin: auto;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1, h2 { text-align: center; }
        label { display: block; margin: 10px 0; }
        input[type="text"], input[type="email"], input[type="password"], input[type="date"] {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            width: 100%;
            cursor: pointer;
        }
        button:hover { background-color: #0056b3; }
        .error { color: red; font-size: 0.9em; }
        small { color: #555; }
    </style>
</head>
<body>

<h1>Créer un compte</h1>

<form action="<%= request.getContextPath() %>/register" method="post">
    <!-- Section Informations personnelles -->
    <h2>Informations personnelles</h2>
    <label>Nom* :
        <input type="text" name="nom" required>
    </label>
    <label>Prénom* :
        <input type="text" name="prenom" required>
    </label>

    <!-- Section Authentification -->
    <h2>Authentification</h2>
    <label>Email* :
        <input type="email" name="email" required>
    </label>
    <label>Mot de passe* :
        <input type="password" name="password"
               title="8 caractères minimum, avec majuscule et chiffre"
               required>
    </label>
    <small>8 caractères minimum, avec majuscule et chiffre</small><br><br>

    <br><br>
    <button type="submit">S'inscrire</button>
</form>

</body>
</html>

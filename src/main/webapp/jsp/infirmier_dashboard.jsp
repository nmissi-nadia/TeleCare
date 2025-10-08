<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>Dashboard Infirmier - TeleCare</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }

        .header {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 20px 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .header .container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .main-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 30px 20px;
        }

        .welcome-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-top: 4px solid;
        }

        .stat-card.en-attente {
            border-top-color: #ffc107;
        }

        .stat-card.en-cours {
            border-top-color: #17a2b8;
        }

        .stat-card.termine {
            border-top-color: #28a745;
        }

        .stat-card.urgent {
            border-top-color: #dc3545;
        }

        .stat-number {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .stat-label {
            color: #666;
            font-size: 14px;
            text-transform: uppercase;
        }

        .stat-card.en-attente .stat-number {
            color: #856404;
        }

        .stat-card.en-cours .stat-number {
            color: #0c5460;
        }

        .stat-card.termine .stat-number {
            color: #155724;
        }

        .stat-card.urgent .stat-number {
            color: #721c24;
        }

        .actions-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }

        .action-btn {
            display: flex;
            align-items: center;
            padding: 20px;
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s ease;
        }

        .action-btn:hover {
            background: #28a745;
            color: white;
            border-color: #28a745;
            transform: translateY(-2px);
        }

        .btn-icon {
            font-size: 24px;
            margin-right: 15px;
        }

        .btn-text h3 {
            margin-bottom: 5px;
        }

        .btn-text p {
            font-size: 14px;
            opacity: 0.8;
        }

        .patients-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }

        th {
            background-color: #f8f9fa;
            font-weight: bold;
        }

        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .status-EN_ATTENTE {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-EN_COURS {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .status-TERMINE {
            background-color: #d4edda;
            color: #155724;
        }

        .status-URGENT {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="logo">🏥 TeleCare - Infirmier</div>
            <div class="user-info">
                <span>👩‍⚕️ ${currentUser.prenom} ${currentUser.nom}</span>
                <a href="${pageContext.request.contextPath}/jsp/home.jsp" style="color: white; text-decoration: none; margin-left: 15px;">⬅️ Accueil</a>
            </div>
        </div>
    </header>

    <main class="main-content">
        <div class="welcome-section">
            <h1>Bonjour ${currentUser.prenom} !</h1>
            <p>Voici votre tableau de bord infirmier pour aujourd'hui</p>
        </div>

        <div class="stats-grid">
            <div class="stat-card en-attente">
                <div class="stat-number">${stats[0]}</div>
                <div class="stat-label">En Attente</div>
            </div>
            <div class="stat-card en-cours">
                <div class="stat-number">${stats[1]}</div>
                <div class="stat-label">En Cours</div>
            </div>
            <div class="stat-card termine">
                <div class="stat-number">${stats[2]}</div>
                <div class="stat-label">Terminé</div>
            </div>
            <div class="stat-card urgent">
                <div class="stat-number">${stats[3]}</div>
                <div class="stat-label">Urgent</div>
            </div>
        </div>

        <div class="actions-section">
            <h2>Actions Rapides</h2>
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/jsp/patient_form.jsp" class="action-btn">
                    <div class="btn-icon">📋</div>
                    <div class="btn-text">
                        <h3>Nouveau Patient</h3>
                        <p>Enregistrer un nouveau patient avec ses constantes</p>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/app/patient" class="action-btn">
                    <div class="btn-icon">📊</div>
                    <div class="btn-text">
                        <h3>Voir Tous les Patients</h3>
                        <p>Consulter la liste complète des patients du jour</p>
                    </div>
                </a>
            </div>
        </div>

        <div class="patients-section">
            <div class="section-header">
                <h2>Patients du Jour (${patients.size()})</h2>
                <a href="${pageContext.request.contextPath}/app/patient" class="btn" style="background: #6c757d;">Voir Tout</a>
            </div>

            <c:choose>
                <c:when test="${empty patients}">
                    <p style="text-align: center; color: #666; padding: 40px;">Aucun patient enregistré aujourd'hui</p>
                </c:when>
                <c:otherwise>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient</th>
                                    <th>Heure d'arrivée</th>
                                    <th>Statut</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${patients}">
                                    <tr>
                                        <td>#${p.id}</td>
                                        <td>
                                            <strong>${p.nom} ${p.prenom}</strong>
                                            <c:if test="${not empty p.tension || not empty p.frequenceCardiaque}">
                                                <br><small style="color: #666;">
                                                    <c:if test="${not empty p.tension}">Tension: ${p.tension}</c:if>
                                                    <c:if test="${not empty p.frequenceCardiaque}"> | FC: ${p.frequenceCardiaque} bpm</c:if>
                                                </small>
                                            </c:if>
                                        </td>
                                        <td><fmt:formatDate value="${p.heureArrivee}" pattern="HH:mm" /></td>
                                        <td><span class="status-badge status-${p.statut}">${p.statut}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.statut == 'EN_ATTENTE'}">
                                                    <a href="${pageContext.request.contextPath}/app/consultation?patientId=${p.id}"
                                                       style="color: #28a745; text-decoration: none; font-size: 12px;">
                                                        🔄 Prendre en charge
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #6c757d; font-size: 12px;">En cours</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</body>
</html>

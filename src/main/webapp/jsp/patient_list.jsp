<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
%>

<html>
<head>
    <title>Liste des Patients - TeleCare</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        :root {
            --primary-blue: #2196F3;
            --primary-green: #4CAF50;
            --primary-purple: #9C27B0;
            --accent-orange: #FF9800;
            --neutral-gray: #757575;
            --light-gray: #F5F5F5;
            --white: #FFFFFF;
            --dark-gray: #424242;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--light-gray); color: var(--dark-gray); }

        .layout { display: flex; min-height: 100vh; }
        .sidebar {
            width: 280px; background: linear-gradient(135deg, var(--primary-blue) 0%, var(--primary-purple) 100%);
            color: var(--white); position: fixed; height: 100vh; box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        .sidebar-header { padding: 25px 20px; text-align: center; }
        .sidebar-nav a { display: flex; align-items: center; padding: 15px 25px; color: var(--white); text-decoration: none; }
        .sidebar-nav a:hover { background: rgba(255,255,255,0.1); }

        .main-content { flex: 1; margin-left: 280px; padding: 30px; }
        .content-header { background: var(--white); padding: 25px; border-radius: 12px; margin-bottom: 30px; }

        .btn { padding: 12px 24px; border: none; border-radius: 8px; text-decoration: none; font-weight: 600; cursor: pointer; }
        .btn-primary { background: var(--primary-blue); color: var(--white); }
        .btn-success { background: var(--primary-green); color: var(--white); }
        .btn-danger { background: #F44336; color: var(--white); }
        .btn-secondary { background: var(--neutral-gray); color: var(--white); }

        .data-table { background: var(--white); border-radius: 12px; overflow: hidden; }
        .data-table table { width: 100%; border-collapse: collapse; }
        .data-table th { background: var(--light-gray); padding: 18px 15px; text-align: left; font-weight: 600; }
        .data-table td { padding: 15px; border-bottom: 1px solid #f0f0f0; }

        .status { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-EN_ATTENTE { background: var(--accent-orange); color: var(--white); }
        .status-EN_COURS { background: var(--primary-blue); color: var(--white); }
        .status-TERMINE { background: var(--primary-green); color: var(--white); }
        .status-URGENT { background: #F44336; color: var(--white); }

        .patient-info { margin-bottom: 5px; }
        .vital-signs { font-size: 12px; color: var(--neutral-gray); margin-top: 2px; }
        .no-patients { text-align: center; color: var(--neutral-gray); padding: 40px; }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .main-content { margin-left: 0; }
        }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-header">
            <h1>TeleCare</h1>
            <div style="font-size: 14px; opacity: 0.8;">Gestion Patients</div>
        </div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/app/patient">📋 Liste Patients</a>
            <a href="${pageContext.request.contextPath}/jsp/patient_form.jsp">➕ Nouveau Patient</a>
            <a href="${pageContext.request.contextPath}/app/infirmier/dashboard">🏠 Dashboard</a>
            <a href="${pageContext.request.contextPath}/jsp/home.jsp">⬅️ Accueil</a>
            <a href="${pageContext.request.contextPath}/logout">🚪 Déconnexion</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="content-header">
            <h2>Liste des Patients du Jour</h2>
            <div style="display: flex; align-items: center; justify-content: space-between;">
                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/jsp/patient_form.jsp" class="btn btn-success">➕ Nouveau Patient</a>
                    <a href="${pageContext.request.contextPath}/app/infirmier/dashboard" class="btn btn-primary">🏠 Dashboard</a>
                </div>
                <div style="font-size: 14px; color: var(--neutral-gray);">
                    Total: <strong>${patients.size()} patient(s)</strong>
                </div>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty patients}">
                <div style="background: var(--white); padding: 60px; border-radius: 12px; text-align: center;">
                    <h3 style="color: var(--neutral-gray); margin-bottom: 20px;">Aucun patient enregistré aujourd'hui</h3>
                    <p style="margin-bottom: 30px;">Commencez par ajouter un nouveau patient.</p>
                    <a href="${pageContext.request.contextPath}/jsp/patient_form.jsp" class="btn btn-success">➕ Ajouter le premier patient</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="data-table">
                    <table>
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Informations personnelles</th>
                            <th>Signes vitaux</th>
                            <th>Heure d'arrivée</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="p" items="${patients}">
                            <tr>
                                <td><strong>#${p.id}</strong></td>

                                <td>
                                    <div class="patient-info">
                                        <strong>${p.nom} ${p.prenom}</strong>
                                    </div>
                                    <div class="patient-info">
                                        <small>📅 Né(e) le :
                                            <c:if test="${not empty p.dateNaissance}">
                                                <%= ((java.time.LocalDate) ((org.example.projet.model.Patient) pageContext.findAttribute("p")).getDateNaissance()).format(dateFormatter) %>
                                            </c:if>
                                        </small>
                                    </div>
                                    <div class="patient-info">
                                        <small>🏥 N° Sécu: ${p.numSecuriteSociale}</small>
                                    </div>
                                </td>

                                <td>
                                    <div class="vital-signs">
                                        <c:if test="${not empty p.tension}">
                                            <span>🩺 Tension: ${p.tension}</span><br>
                                        </c:if>
                                        <c:if test="${not empty p.frequenceCardiaque}">
                                            <span>❤️ Fréquence: ${p.frequenceCardiaque} bpm</span><br>
                                        </c:if>
                                        <c:if test="${not empty p.temperature}">
                                            <span>🌡️ Température: ${p.temperature}°C</span><br>
                                        </c:if>
                                        <c:if test="${not empty p.frequenceRespiratoire}">
                                            <span>🫁 Respiration: ${p.frequenceRespiratoire}/min</span>
                                        </c:if>
                                    </div>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.heureArrivee}">
                                            <div>
                                                <strong><%= ((java.time.LocalDateTime) ((org.example.projet.model.Patient) pageContext.findAttribute("p")).getHeureArrivee()).format(timeFormatter) %></strong>
                                            </div>
                                            <small style="color: var(--neutral-gray);">
                                                <%= ((java.time.LocalDateTime) ((org.example.projet.model.Patient) pageContext.findAttribute("p")).getHeureArrivee()).format(dateFormatter) %>
                                            </small>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--neutral-gray);">Non définie</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <span class="status status-${p.statut}">${p.statut}</span>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${p.statut == 'EN_ATTENTE'}">
                                            <a href="${pageContext.request.contextPath}/app/consultation?patientId=${p.id}" class="btn btn-success">
                                                🚀 Commencer
                                            </a>
                                        </c:when>
                                        <c:when test="${p.statut == 'EN_COURS'}">
                                            <a href="${pageContext.request.contextPath}/app/consultation?patientId=${p.id}" class="btn btn-primary">
                                                ⏳ Continuer
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--neutral-gray);">✅ Terminée</span>
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
    </main>
</body>
</html>
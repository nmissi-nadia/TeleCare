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
            --primary-green: #4CAF50;
            --dark-green: #388E3C;
            --soft-beige: #F7F3EE;
            --light-beige: #FAF9F7;
            --white: #FFFFFF;
            --text-gray: #3E3E3E;
            --neutral-gray: #A0A0A0;
            --accent-beige: #E9E4DA;
            --accent-cream: #F3EED9;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--light-beige); color: var(--text-gray); }

        /* 🌿 Sidebar */
        .layout { display: flex; min-height: 100vh; }
        .sidebar {
            width: 280px;
            background: linear-gradient(135deg, var(--primary-green) 0%, var(--dark-green) 100%);
            color: var(--white);
            position: fixed; height: 100vh;
            box-shadow: 2px 0 12px rgba(0,0,0,0.1);
        }
        .sidebar-header {
            padding: 30px 20px;
            text-align: center;
            background: rgba(255,255,255,0.1);
            border-bottom: 1px solid rgba(255,255,255,0.15);
        }
        .sidebar-header h1 {
            font-size: 1.8rem;
            margin-bottom: 6px;
            font-weight: bold;
            letter-spacing: 1px;
        }
        .sidebar-nav a {
            display: flex; align-items: center;
            padding: 15px 25px;
            color: var(--white);
            text-decoration: none;
            font-weight: 500;
            transition: background 0.3s ease;
        }
        .sidebar-nav a:hover {
            background: rgba(255,255,255,0.15);
            border-left: 4px solid var(--accent-cream);
        }

        /* 🩺 Main content */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 30px;
            background: var(--soft-beige);
            min-height: 100vh;
        }

        .content-header {
            background: var(--white);
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn-success { background: var(--primary-green); color: var(--white); }
        .btn-primary { background: var(--accent-beige); color: var(--text-gray); }
        .btn-danger { background: #C62828; color: var(--white); }
        .btn-secondary { background: var(--neutral-gray); color: var(--white); }
        .btn:hover { opacity: 0.9; transform: translateY(-2px); }

        /* 🧾 Table */
        .data-table {
            background: var(--white);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .data-table table {
            width: 100%;
            border-collapse: collapse;
        }
        .data-table th {
            background: var(--accent-cream);
            padding: 18px 15px;
            text-align: left;
            font-weight: 600;
            color: var(--text-gray);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .data-table td {
            padding: 15px;
            border-bottom: 1px solid var(--accent-beige);
            background: var(--white);
        }

        /* 🩸 Statuts */
        .status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-EN_ATTENTE { background: var(--accent-cream); color: var(--dark-green); }
        .status-EN_COURS { background: var(--accent-beige); color: var(--dark-green); }
        .status-TERMINE { background: var(--primary-green); color: var(--white); }
        .status-URGENT { background: #C62828; color: var(--white); }

        .patient-info { margin-bottom: 5px; }
        .vital-signs { font-size: 12px; color: var(--neutral-gray); margin-top: 2px; }

        /* 📱 Responsive */
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
            <h2 style="color: var(--dark-green);">Liste des Patients du Jour</h2>
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
                <div style="background: var(--white); padding: 60px; border-radius: 12px; text-align: center; box-shadow: 0 2px 10px rgba(0,0,0,0.05);">
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
                                    <div class="patient-info"><strong>${p.nom} ${p.prenom}</strong></div>
                                    <div class="patient-info"><small>📅 Né(e) le : 
                                        <c:if test="${not empty p.dateNaissance}">
                                            <%= ((java.time.LocalDate) ((org.example.projet.model.Patient) pageContext.findAttribute("p")).getDateNaissance()).format(dateFormatter) %>
                                        </c:if>
                                    </small></div>
                                    <div class="patient-info"><small>🏥 N° Sécu: ${p.numSecuriteSociale}</small></div>
                                </td>

                                <td>
                                    <div class="vital-signs">
                                        <c:if test="${not empty p.tension}">🩺 Tension: ${p.tension}<br></c:if>
                                        <c:if test="${not empty p.frequenceCardiaque}">❤️ Fréquence: ${p.frequenceCardiaque} bpm<br></c:if>
                                        <c:if test="${not empty p.temperature}">🌡️ Température: ${p.temperature}°C<br></c:if>
                                        <c:if test="${not empty p.frequenceRespiratoire}">🫁 Respiration: ${p.frequenceRespiratoire}/min</c:if>
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
                                            <a href="${pageContext.request.contextPath}/app/consultation?patientId=${p.id}" class="btn btn-success">🚀 Commencer</a>
                                        </c:when>
                                        <c:when test="${p.statut == 'EN_COURS'}">
                                            <a href="${pageContext.request.contextPath}/app/consultation?patientId=${p.id}" class="btn btn-primary">⏳ Continuer</a>
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

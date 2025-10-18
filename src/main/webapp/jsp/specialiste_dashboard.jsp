<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<html>
<head>
    <title>Dashboard Spécialiste - TeleCare</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        :root {
            --primary-blue: #4CAF50;
            --primary-green: #4CAF50;
            --primary-purple: #4CAF50;
            --accent-orange: #4CAF50;
            --neutral-gray: #757575;
            --light-gray: #F5F5F5;
            --white: #FFFFFF;
            --dark-gray: #424242;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--light-gray); color: var(--dark-gray); }

        .layout { display: flex; min-height: 100vh; }
        .sidebar {
            width: 280px; background: linear-gradient(135deg, var(--primary-purple) 0%, var(--primary-blue) 100%);
            color: var(--white); position: fixed; height: 100vh; box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        .sidebar-header { padding: 25px 20px; text-align: center; }
        .sidebar-nav a { display: flex; align-items: center; padding: 15px 25px; color: var(--white); text-decoration: none; }
        .sidebar-nav a:hover { background: rgba(255,255,255,0.1); }

        .main-content { flex: 1; margin-left: 280px; padding: 30px; }
        .content-header { background: var(--white); padding: 25px; border-radius: 12px; margin-bottom: 30px; }

        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: var(--white); padding: 25px; border-radius: 12px; text-align: center; }
        .stat-number { font-size: 36px; font-weight: 700; color: var(--primary-purple); margin-bottom: 8px; }
        .stat-label { color: var(--neutral-gray); font-size: 14px; font-weight: 500; }

        .btn { padding: 10px 18px; border: none; border-radius: 8px; text-decoration: none; font-weight: 600; cursor: pointer; }
        .btn-primary { background: var(--primary-purple); color: var(--white); }
        .btn-success { background: var(--primary-green); color: var(--white); }
        .btn-danger { background: #E53935; color: var(--white); }

        .data-table { background: var(--white); border-radius: 12px; overflow: hidden; margin-bottom: 20px; }
        .data-table table { width: 100%; border-collapse: collapse; }
        .data-table th { background: var(--light-gray); padding: 18px 15px; text-align: left; font-weight: 600; }
        .data-table td { padding: 15px; border-bottom: 1px solid #f0f0f0; }

        .status-badge { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-en-attente { background: var(--accent-orange); color: var(--white); }
        .status-acceptee { background: var(--primary-blue); color: var(--white); }
        .status-terminee { background: var(--primary-green); color: var(--white); }
        .status-refusee { background: #e53935; color: var(--white); }

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
            <div style="font-size: 14px; opacity: 0.8;">Spécialiste</div>
        </div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/app/specialiste/dashboard" class="active">Dashboard</a>
            <a href="${pageContext.request.contextPath}/jsp/home.jsp">Accueil</a>
            <a href="${pageContext.request.contextPath}/app/specialiste/profil" class="btn btn-success">Configurer mon profil</a>
            <!-- lien vers la page des demandes -->
            <a href="${pageContext.request.contextPath}/app/specialiste/demandes">Demandes</a>
            <a href="${pageContext.request.contextPath}/logout">Déconnexion</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="content-header">
            <h2>Dashboard Spécialiste</h2>
            <div style="display: flex; align-items: center;">
                <div style="width: 40px; height: 40px; border-radius: 50%; background: var(--primary-purple); display: flex; align-items: center; justify-content: center; color: var(--white); font-weight: bold; margin-right: 12px;">
                    ${currentUser.prenom.charAt(0)}${currentUser.nom.charAt(0)}
                </div>
                <div>
                    <strong>${currentUser.prenom} ${currentUser.nom}</strong><br>
                    <small style="color: var(--neutral-gray);">Spécialité : ${currentUser.specialite}</small>
                </div>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">${stats[0]}</div>
                <div class="stat-label">Total Expertises</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${stats[1]}</div>
                <div class="stat-label">En Attente</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${stats[2]}</div>
                <div class="stat-label">Terminées</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${revenus} DH</div>
                <div class="stat-label">Revenus Totaux</div>
            </div>
        </div>

        <!-- Demandes en attente -->
        <div class="data-table">
            <h3 style="padding: 20px 20px 0; margin: 0;">Demandes en Attente</h3>
            <c:choose>
                <c:when test="${empty demandes}">
                    <p style="text-align: center; color: var(--neutral-gray); padding: 40px;">Aucune demande en attente</p>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead><tr><th>ID</th><th>Consultation</th><th>Spécialité Demandée</th><th>Date</th><th>Action</th></tr></thead>
                        <tbody>
                            <c:forEach var="d" items="${demandes}">
                                <tr>
                                    <td>#${d.id}</td>
                                    <td>${d.consultation.patient.nom} ${d.consultation.patient.prenom}</td>
                                    <td>${d.specialiteDemandee}</td>
                                    <td>
                                        <%
                                            org.example.projet.model.DemandeExpertise dem = (org.example.projet.model.DemandeExpertise) pageContext.getAttribute("d");
                                            if (dem != null && dem.getDateCreation() != null) {
                                                out.print(dem.getDateCreation().format(dateFormatter));
                                            } else {
                                                out.print("-");
                                            }
                                        %>
                                    </td>
                                    <td>
                                        <form method="post" action="${pageContext.request.contextPath}/app/expertise/repondre">
                                            <input type="hidden" name="demandeId" value="${d.id}">
                                            <button type="submit" name="response" value="ACCEPTER" class="btn btn-success">Accepter</button>
                                            <button type="submit" name="response" value="REFUSER" class="btn btn-danger">Refuser</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Historique -->
        <div class="data-table">
            <h3 style="padding: 20px 20px 0; margin: 0;">Historique des Expertises</h3>
            <c:choose>
                <c:when test="${empty historique}">
                    <p style="text-align: center; color: var(--neutral-gray); padding: 40px;">Aucune expertise terminée</p>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead><tr><th>ID</th><th>Consultation</th><th>Statut</th><th>Date Réponse</th></tr></thead>
                        <tbody>
                            <c:forEach var="d" items="${historique}">
                                <tr>
                                    <td>#${d.id}</td>
                                    <td>${d.consultation.patient.nom} ${d.consultation.patient.prenom}</td>
                                    <td><span class="status-badge status-${d.statut.toLowerCase()}">${d.statut}</span></td>
                                    <td>
                                        <%
                                            org.example.projet.model.DemandeExpertise dem = (org.example.projet.model.DemandeExpertise) pageContext.getAttribute("d");
                                            if (dem != null && dem.getDateReponse() != null) {
                                                out.print(dem.getDateReponse().format(dateFormatter));
                                            } else {
                                                out.print("-");
                                            }
                                        %>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

    </main>
</body>
</html>

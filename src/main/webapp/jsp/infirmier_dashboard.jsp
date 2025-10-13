<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>Dashboard Infirmier - TeleCare</title>
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

        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: var(--white); padding: 25px; border-radius: 12px; text-align: center; }
        .stat-number { font-size: 36px; font-weight: 700; color: var(--primary-blue); margin-bottom: 8px; }
        .stat-label { color: var(--neutral-gray); font-size: 14px; font-weight: 500; }

        .btn { padding: 12px 24px; border: none; border-radius: 8px; text-decoration: none; font-weight: 600; cursor: pointer; }
        .btn-primary { background: var(--primary-blue); color: var(--white); }
        .btn-success { background: var(--primary-green); color: var(--white); }
        .btn-secondary { background: var(--neutral-gray); color: var(--white); }

        .data-table { background: var(--white); border-radius: 12px; overflow: hidden; }
        .data-table table { width: 100%; border-collapse: collapse; }
        .data-table th { background: var(--light-gray); padding: 18px 15px; text-align: left; font-weight: 600; }
        .data-table td { padding: 15px; border-bottom: 1px solid #f0f0f0; }

        .status-badge { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-en-attente { background: var(--accent-orange); color: var(--white); }
        .status-en-cours { background: var(--primary-blue); color: var(--white); }
        .status-termine { background: var(--primary-green); color: var(--white); }
        .status-urgent { background: #F44336; color: var(--white); }

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
            <div style="font-size: 14px; opacity: 0.8;">Infirmier</div>
        </div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/app/infirmier/dashboard" class="active">Dashboard</a>
            <a href="${pageContext.request.contextPath}/app/patient">Patients</a>
            <a href="${pageContext.request.contextPath}/jsp/patient_form.jsp">Nouveau Patient</a>
            <a href="${pageContext.request.contextPath}/jsp/home.jsp">Accueil</a>
            <a href="${pageContext.request.contextPath}/logout">Déconnexion</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="content-header">
            <h2>Dashboard Infirmier</h2>
            <div style="display: flex; align-items: center;">
                <div style="width: 40px; height: 40px; border-radius: 50%; background: var(--primary-green); display: flex; align-items: center; justify-content: center; color: var(--white); font-weight: bold; margin-right: 12px;">
                    ${currentUser.prenom.charAt(0)}${currentUser.nom.charAt(0)}
                </div>
                <div>
                    <strong>${currentUser.prenom} ${currentUser.nom}</strong><br>
                    <small style="color: var(--neutral-gray);">Infirmier</small>
                </div>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card"><div class="stat-number">${stats[0]}</div><div class="stat-label">En Attente</div></div>
            <div class="stat-card"><div class="stat-number">${stats[1]}</div><div class="stat-label">En Cours</div></div>
            <div class="stat-card"><div class="stat-number">${stats[2]}</div><div class="stat-label">Terminé</div></div>
            <div class="stat-card"><div class="stat-number">${stats[3]}</div><div class="stat-label">Urgent</div></div>
        </div>

        <div style="background: var(--white); padding: 25px; border-radius: 12px; margin-bottom: 30px;">
            <a href="${pageContext.request.contextPath}/jsp/patient_form.jsp" class="btn btn-success">➕ Nouveau Patient</a>
            <a href="${pageContext.request.contextPath}/app/patient" class="btn btn-primary">📋 Voir Patients</a>
            <a href="${pageContext.request.contextPath}/jsp/home.jsp" class="btn btn-secondary">⬅️ Accueil</a>
        </div>

        <div class="data-table">
            <h3 style="padding: 20px 20px 0; margin: 0;">Patients du Jour (${patients.size()})</h3>
            <c:choose>
                <c:when test="${empty patients}">
                    <p style="text-align: center; color: var(--neutral-gray); padding: 40px;">Aucun patient aujourd'hui</p>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead><tr><th>ID</th><th>Patient</th><th>Heure</th><th>Statut</th><th>Action</th></tr></thead>
                        <tbody>
                            <c:forEach var="p" items="${patients}">
                                <tr>
                                    <td>#${p.id}</td>
                                    <td><strong>${p.nom} ${p.prenom}</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty p.heureArrivee}">
                                                ${p.heureArrivee.toString().substring(11,16)}
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><span class="status-badge status-${p.statut.toLowerCase().replace('_', '-')}">${p.statut}</span></td>
                                    <td>
                                        <c:if test="${p.statut == 'EN_ATTENTE'}">
                                            <a href="${pageContext.request.contextPath}/app/consultation?patientId=${p.id}" class="btn" style="background: var(--primary-green); font-size: 12px; padding: 8px 12px;">Prendre</a>
                                        </c:if>
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

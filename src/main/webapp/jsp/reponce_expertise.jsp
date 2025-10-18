<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Demandes de Télé-Expertise - TeleCare</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        :root {
            --primary-green: #4CAF50;
            --light-beige: #f5f3e7;
            --white: #ffffff;
            --neutral-gray: #757575;
            --dark-gray: #2e2e2e;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--light-beige); color: var(--dark-gray); }
        .sidebar { width: 280px; background: linear-gradient(135deg, var(--primary-green) 0%, #81c784 100%); color: var(--white); position: fixed; height: 100vh; box-shadow: 2px 0 10px rgba(0,0,0,0.1); }
        .sidebar-header { padding: 25px 20px; text-align: center; }
        .sidebar-nav a { display: block; padding: 15px 25px; color: var(--white); text-decoration: none; font-weight: 500; }
        .sidebar-nav a:hover { background: rgba(255,255,255,0.1); }
        .main-content { margin-left: 280px; padding: 30px; }
        .page-header { background: var(--white); padding: 25px; border-radius: 12px; margin-bottom: 30px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .card { background: var(--white); border-radius: 12px; padding: 25px; margin-bottom: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .btn { padding: 8px 16px; border: none; border-radius: 10px; font-weight: 600; cursor: pointer; transition: all 0.2s; font-size: 14px; }
        .btn-primary { background: var(--primary-green); color: var(--white); }
        .btn-secondary { background: var(--neutral-gray); color: var(--white); }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px 10px; border-bottom: 1px solid #eee; text-align: left; font-size: 14px; }
        th { color: var(--primary-green); font-weight: 700; }
        .status { padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 700; display: inline-block; }
        .status-wait { background: #fff3cd; color: #856404; }
        .status-acc { background: #e8f5e9; color: #2e7d32; }
        .status-ref { background: #ffebee; color: #c62828; }
        .muted { color: var(--neutral-gray); font-size: 13px; }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-header">
        <h1>🌿 TeleCare</h1>
        <div style="font-size: 14px; opacity: 0.8;">Médecin Spécialiste</div>
    </div>
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/app/specialiste/demandes">📄 Demandes</a>
        <a href="${pageContext.request.contextPath}/logout">🚪 Déconnexion</a>
    </nav>
</aside>

<main class="main-content">
    <div class="page-header">
        <h2>Demandes de Télé-Expertise</h2>
        <p class="muted">Liste des demandes adressées à vous en tant que spécialiste.</p>
    </div>

    <div class="card">
        <c:choose>
            <c:when test="${not empty demandes}">
                <table>
                    <thead>
                    <tr>
                        <th>Créée le</th>
                        <th>Médecin Généraliste</th>
                        <th>Spécialité demandée</th>
                        <th>Raison</th>
                        <th>Statut</th>
                        <th style="width: 1%">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="d" items="${demandes}">
                        <tr>
                            <td><c:out value="${d.dateCreation}"/></td>
                            <td><c:out value="${d.medecinGeneraliste.nom}"/> <c:out value="${d.medecinGeneraliste.prenom}"/></td>
                            <td><c:out value="${d.specialiteDemandee}"/></td>
                            <td><c:out value="${d.raison}"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${d.statut == 'EN_ATTENTE'}"><span class="status status-wait">En attente</span></c:when>
                                    <c:when test="${d.statut == 'ACCEPTEE'}"><span class="status status-acc">Acceptée</span></c:when>
                                    <c:when test="${d.statut == 'REFUSEE'}"><span class="status status-ref">Refusée</span></c:when>
                                    <c:otherwise><span class="status"><c:out value="${d.statut}"/></span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a class="btn btn-primary" href="${pageContext.request.contextPath}/app/expertise/details?id=${d.id}">Voir détails</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p class="muted">Aucune demande de télé-expertise à afficher.</p>
            </c:otherwise>
        </c:choose>
    </div>
</main>

</body>
</html>
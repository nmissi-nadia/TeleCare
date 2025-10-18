<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Profil Spécialiste - TeleCare</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        :root {
            --green: #2e7d32;
            --green-600: #1b5e20;
            --beige: #f6f1e9;
            --white: #ffffff;
            --muted: #6b7280;
            --border: #e5e7eb;
            --bg: #fafafa;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: system-ui, -apple-system, Segoe UI, Roboto, Ubuntu, Cantarell, "Helvetica Neue", Arial, "Noto Sans", "Apple Color Emoji", "Segoe UI Emoji";
            background: var(--bg);
            color: #111827;
            display: flex;
            min-height: 100vh;
        }

        /* === SIDEBAR === */
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, var(--green) 0%, var(--green-600) 100%);
            color: var(--white);
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            padding: 24px 0;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .sidebar-header h1 {
            font-size: 24px;
            margin: 0;
            color: var(--white);
        }

        .sidebar-header div {
            font-size: 13px;
            opacity: 0.8;
        }

        .sidebar-nav {
            display: flex;
            flex-direction: column;
        }

        .sidebar-nav a {
            color: var(--white);
            text-decoration: none;
            padding: 12px 24px;
            font-weight: 500;
            transition: background 0.3s ease;
        }

        .sidebar-nav a:hover,
        .sidebar-nav a.active {
            background: rgba(255, 255, 255, 0.15);
        }

        .sidebar-footer {
            text-align: center;
            padding: 12px;
            font-size: 13px;
            color: rgba(255, 255, 255, 0.7);
        }

        /* === MAIN CONTENT === */
        .main {
            flex: 1;
            margin-left: 260px;
            padding: 32px;
        }

        .container {
            max-width: 1100px;
            margin: auto;
        }

        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .title {
            font-size: 24px;
            font-weight: 700;
            color: var(--green-600);
        }

        .card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,.04);
        }

        .card.beige { background: var(--beige); }
        .grid { display: grid; gap: 16px; }

        @media (min-width: 900px) {
            .grid.cols-2 { grid-template-columns: 1fr 1fr; }
        }

        .section-title {
            margin: 0 0 12px 0;
            font-size: 18px;
            font-weight: 700;
            color: var(--green);
        }

        .row { display: grid; gap: 12px; }

        @media (min-width: 700px) {
            .row.cols-2 { grid-template-columns: 1fr 1fr; }
            .row.cols-3 { grid-template-columns: 1fr 1fr 1fr; }
        }

        label { display: block; font-size: 14px; color: var(--muted); margin-bottom: 6px; }

        input, select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: #fff;
            font-size: 14px;
        }

        .btn {
            appearance: none;
            border: 0;
            border-radius: 8px;
            padding: 10px 14px;
            font-weight: 600;
            cursor: pointer;
            transition: .15s transform ease;
        }

        .btn:hover { transform: translateY(-1px); }

        .btn-primary { background: var(--green); color: #fff; }
        .btn-outline { background: transparent; color: var(--green); border: 1px solid var(--green); }
        .btn-danger { background: #b91c1c; color: #fff; }

        .table {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid var(--border);
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
        }

        .table th, .table td {
            padding: 12px;
            border-bottom: 1px solid var(--border);
            text-align: left;
        }

        .table th {
            background: var(--beige);
            color: #374151;
            font-weight: 700;
        }

        .alert {
            padding: 10px 12px;
            border-radius: 8px;
            margin-bottom: 12px;
            font-size: 14px;
        }

        .alert-ok {
            background: #e6f4ea;
            color: var(--green-600);
            border: 1px solid #ccebd4;
        }

        .alert-err {
            background: #fde8e8;
            color: #991b1b;
            border: 1px solid #f5c2c2;
        }

    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div>
            <div class="sidebar-header">
                <h1>TeleCare</h1>
                <div>Spécialiste</div>
            </div>

            <nav class="sidebar-nav">
                <a href="${pageContext.request.contextPath}/app/specialiste/dashboard" class="active">🏠 Dashboard</a>
                <a href="${pageContext.request.contextPath}/app/specialiste/profil">⚙️ Mon Profil</a>
                <a href="${pageContext.request.contextPath}/app/specialiste/expertises">📋 Mes Expertises</a>
                <a href="${pageContext.request.contextPath}/jsp/home.jsp">🏡 Accueil</a>
            </nav>
        </div>

        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/logout" style="color:#fff; text-decoration:none;">🚪 Déconnexion</a>
        </div>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="main">
        <div class="container">
            <div class="header">
                <div class="title">Profil spécialiste</div>
            </div>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-ok">${sessionScope.successMessage}</div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-err">${sessionScope.error}</div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <!-- Informations personnelles et configuration -->
            <div class="grid cols-2">
                <div class="card beige">
                    <h3 class="section-title">Informations personnelles</h3>
                    <div class="row">
                        <div><label>Nom</label><div>${specialiste.nom}</div></div>
                        <div><label>Prénom</label><div>${specialiste.prenom}</div></div>
                        <div><label>Login</label><div>${specialiste.login}</div></div>
                        <div><label>Rôle</label><div>${specialiste.role}</div></div>
                    </div>
                </div>

                <div class="card">
                    <h3 class="section-title">Modifier spécialité et tarif global</h3>
                    <form method="post" action="${pageContext.request.contextPath}/app/specialiste/profil">
                        <div class="row cols-2">
                            <div>
                                <label>Spécialité</label>
                                <input name="specialite" value="${specialiste.specialite != null ? specialiste.specialite : ''}" />
                            </div>
                            <div>
                                <label>Tarif expertise (global)</label>
                                <input type="number" step="0.01" name="tarifExpertise"
                                       value="${specialiste.tarifExpertise != null ? specialiste.tarifExpertise : ''}" />
                            </div>
                        </div>
                        <div style="margin-top:12px;">
                            <button type="submit" class="btn btn-primary">Enregistrer</button>
                        </div>
                    </form>
                </div>
            </div>

            <div style="height:16px;"></div>

            <!-- Ajout de créneau et liste -->
            <div class="grid cols-2">
                <div class="card">
                    <h3 class="section-title">Ajouter un créneau</h3>
                    <form method="post" action="${pageContext.request.contextPath}/app/specialiste/profil">
                        <div class="row cols-3">
                            <div>
                                <label>Date</label>
                                <input type="date" name="date" required />
                            </div>
                            <div>
                                <label>Heure début</label>
                                <input type="time" name="heureDebut" required />
                            </div>
                            <div>
                                <label>Heure fin</label>
                                <input type="time" name="heureFin" required />
                            </div>
                        </div>
                        <div class="row" style="margin-top:12px;">
                            <div>
                                <label>Tarif (ce créneau)</label>
                                <input type="number" step="0.01" name="tarif" required />
                            </div>
                        </div>
                        <div style="margin-top:12px;">
                            <button type="submit" class="btn btn-outline">Ajouter</button>
                        </div>
                    </form>
                </div>

                <div class="card">
                    <h3 class="section-title">Créneaux existants</h3>
                    <c:choose>
                        <c:when test="${empty creneaux}">
                            <div class="alert">Aucun créneau enregistré.</div>
                        </c:when>
                        <c:otherwise>
                            <div style="overflow:auto;">
                                <table class="table">
                                    <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Début</th>
                                        <th>Fin</th>
                                        <th>Tarif</th>
                                        <th>Disponibilité</th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="c" items="${creneaux}">
                                        <tr>
                                            <td>${c.dateDisponibilite}</td>
                                            <td>${c.heureDebut}</td>
                                            <td>${c.heureFin}</td>
                                            <td>${c.tarif}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${c.disponible}">Disponible</c:when>
                                                    <c:otherwise>Indisponible</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="display:flex; gap:8px;">
                                                <form method="post" action="${pageContext.request.contextPath}/app/specialiste/profil">
                                                    <input type="hidden" name="action" value="edit"/>
                                                    <input type="hidden" name="id" value="${c.id}"/>
                                                    <button type="submit" class="btn btn-outline">Modifier</button>
                                                </form>
                                                <form method="post" action="${pageContext.request.contextPath}/app/specialiste/profil" onsubmit="return confirm('Supprimer ce créneau ?');">
                                                    <input type="hidden" name="action" value="delete"/>
                                                    <input type="hidden" name="id" value="${c.id}"/>
                                                    <button type="submit" class="btn btn-danger">Supprimer</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
</body>
</html>

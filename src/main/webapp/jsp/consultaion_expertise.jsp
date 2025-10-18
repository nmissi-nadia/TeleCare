<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Demande de Télé-Expertise - TeleCare</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- FullCalendar -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.css" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/main.min.js"></script>

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

        .sidebar {
            width: 280px;
            background: linear-gradient(135deg, var(--primary-green) 0%, #81c784 100%);
            color: var(--white);
            position: fixed;
            height: 100vh;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar-header { padding: 25px 20px; text-align: center; }
        .sidebar-nav a {
            display: block; padding: 15px 25px; color: var(--white);
            text-decoration: none; font-weight: 500;
        }
        .sidebar-nav a:hover { background: rgba(255,255,255,0.1); }

        .main-content { flex: 1; margin-left: 280px; padding: 30px; }

        .page-header {
            background: var(--white);
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .card {
            background: var(--white);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        label { font-weight: 600; color: var(--primary-green); display: block; margin-bottom: 8px; }
        select, textarea, input {
            width: 100%; padding: 12px;
            border-radius: 8px; border: 1px solid #ccc;
            margin-bottom: 15px; font-size: 15px;
        }

        .btn {
            padding: 12px 25px;
            border: none; border-radius: 10px;
            font-weight: 600; cursor: pointer;
            transition: all 0.3s; font-size: 15px;
        }
        .btn-primary { background: var(--primary-green); color: var(--white); }
        .btn-primary:hover { background: #43a047; transform: translateY(-2px); }
        .btn-secondary { background: var(--neutral-gray); color: var(--white); }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-header">
        <h1>🌿 TeleCare</h1>
        <div style="font-size: 14px; opacity: 0.8;">Médecin Généraliste</div>
    </div>
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/app/medecin/dashboard">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/app/patient">👨‍⚕️ Patients</a>
        <a href="${pageContext.request.contextPath}/logout">🚪 Déconnexion</a>
    </nav>
</aside>

<main class="main-content">
    <div class="page-header">
        <h2>Demande de Télé-Expertise</h2>
        <p style="color: var(--neutral-gray);">Recherchez un spécialiste, choisissez un créneau et envoyez votre demande.</p>
    </div>

    <!-- Étape 1 : Recherche de spécialistes -->
    <div class="card">
        <h3>🔍 Rechercher un Spécialiste</h3>
        <form method="get" action="${pageContext.request.contextPath}/app/consultation/expertise">
            <input type="hidden" name="action" value="searchSpecialistes">
            <input type="hidden" name="patientId" value="${patientId}">

            <label for="specialite">Spécialité</label>
            <select id="specialite" name="specialite" required>
                <option value="">-- Sélectionner --</option>
                <c:forEach var="sp" items="${specialites}">
                    <option value="${sp}">${sp}</option>
                </c:forEach>
            </select>

            <label for="tarifMax">Tarif maximum (DH)</label>
            <input type="number" id="tarifMax" name="maxTarif" placeholder="ex: 300">

            <button type="submit" class="btn btn-primary">Rechercher</button>
        </form>
    </div>

    <!-- Étape 2 : Liste des spécialistes -->
    <c:if test="${not empty specialistes}">
        <div class="card">
            <h3>👨‍⚕️ Spécialistes Disponibles</h3>
            <div class="specialist-list">
                <c:forEach var="s" items="${specialistes}">
                    <div class="specialist-card">
                        <div class="specialist-info">
                            <h4>${s.nom} ${s.prenom}</h4>
                            <small>${s.specialite} • ${s.tarifExpertise} DH</small>
                        </div>
                        <form method="get" action="${pageContext.request.contextPath}/app/consultation/expertise">
                            <input type="hidden" name="action" value="slots">
                            <input type="hidden" name="specialisteId" value="${s.id}">
                            <input type="hidden" name="patientId" value="${patientId}">
                            <button type="submit" class="btn btn-primary">Voir créneaux</button>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- Étape 3 : Affichage des créneaux avec calendrier -->
    <c:if test="${not empty creneaux}">
        <div class="card">
            <h3>🗓️ Créneaux Disponibles</h3>
            <div id="calendar"></div>

            <form id="expertiseForm" method="post" action="${pageContext.request.contextPath}/app/consultation/expertise">
                <input type="hidden" name="action" value="create">
                <input type="hidden" name="specialisteId" value="${selectedSpecialiste.id}">
                <input type="hidden" name="patientId" value="${patientId}">
                <input type="hidden" id="selectedSlot" name="creneauChoisi">

                <label for="raison">Raison de la Demande</label>
                <textarea id="raison" name="raison" rows="3" required></textarea>

                <label for="observations">Observations médicales</label>
                <textarea id="observations" name="observations" rows="3"></textarea>

                <div style="text-align:center;margin-top:20px;">
                    <button type="submit" class="btn btn-primary">📨 Envoyer la demande</button>
                </div>
            </form>
        </div>
    </c:if>
</main>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const calendarEl = document.getElementById('calendar');
        if (!calendarEl) return;

        const creneaux = [
            <c:forEach var="c" items="${creneaux}" varStatus="status">
            {
                title: 'Créneau (${c.tarif} DH)',
                start: '${c.dateDisponibilite}T${c.heureDebut}',
                end: '${c.dateDisponibilite}T${c.heureFin}',
                color: '${c.disponible ? "#4CAF50" : "#f44336"}',
                disponible: ${c.disponible}
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            height: 650,
            locale: 'fr',
            selectable: true,
            events: creneaux,
            eventClick: function(info) {
                const slot = info.event.startStr + " - " + info.event.endStr;
                document.getElementById('selectedSlot').value = slot;
                alert("✅ Créneau sélectionné : " + slot);
            }
        });
        calendar.render();
    });
</script>

</body>
</html>

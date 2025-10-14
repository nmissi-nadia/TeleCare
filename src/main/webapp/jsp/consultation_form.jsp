<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<html>
<head>
    <title>TeleCare | Consultation Médicale</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        :root {
            --primary-blue: #1E88E5;
            --primary-green: #9613d2;
            --primary-purple: #8E24AA;
            --accent-orange: #9613d2;
            --neutral-gray: #757575;
            --light-gray: #F5F7FA;
            --white: #FFFFFF;
            --dark-gray: #2E2E2E;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: var(--light-gray);
            color: var(--dark-gray);
            line-height: 1.6;
        }

        /* ===== HEADER ===== */
        .consultation-header {
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-purple));
            color: white;
            padding: 30px 40px;
            border-radius: 0 0 20px 20px;
            text-align: center;
            box-shadow: 0 3px 15px rgba(0,0,0,0.15);
            margin-bottom: 40px;
        }
        .consultation-header h2 {
            font-size: 2rem;
            margin-bottom: 8px;
        }
        .consultation-header p {
            opacity: 0.9;
        }

        /* ===== PATIENT CARD ===== */
        .patient-card {
            background: rgba(255,255,255,0.95);
            border-radius: 16px;
            padding: 30px;
            max-width: 1100px;
            margin: auto;
            margin-bottom: 40px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }
        .patient-card:hover { transform: translateY(-2px); }

        .patient-header {
            display: flex; align-items: center;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px; margin-bottom: 25px;
        }
        .patient-avatar {
            width: 70px; height: 70px;
            border-radius: 50%;
            background: var(--primary-green);
            color: white; display: flex; align-items: center; justify-content: center;
            font-size: 28px; font-weight: bold;
            margin-right: 20px;
            box-shadow: 0 4px 8px rgba(76,175,80,0.4);
        }
        .patient-name { font-size: 1.5rem; color: var(--primary-blue); font-weight: 600; }
        .patient-id { color: var(--neutral-gray); font-size: 0.9rem; }

        /* ===== INFO GRID ===== */
        .patient-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(270px, 1fr));
            gap: 25px;
        }
        .info-section {
            background: #f9fafc;
            padding: 20px;
            border-radius: 12px;
            border-left: 4px solid var(--primary-blue);
        }
        .info-title { font-weight: 700; color: var(--primary-blue); margin-bottom: 10px; font-size: 15px; }
        .info-item { margin: 6px 0; }
        .info-label { font-weight: 500; color: var(--neutral-gray); }
        .info-value { color: var(--dark-gray); font-weight: 500; }

        /* ===== STATUS BADGES ===== */
        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 30px;
            font-size: 13px;
            font-weight: 600;
            color: #fff;
        }
        .status-en-attente { background: var(--accent-orange); }
        .status-en-cours { background: var(--primary-blue); }
        .status-termine { background: var(--primary-green); }
        .status-urgent { background: #E53935; }

        /* ===== FORM ===== */
        .consultation-form {
            max-width: 1100px;
            margin: auto;
            background: var(--white);
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }
        .consultation-form h3 {
            color: var(--primary-blue);
            margin-bottom: 20px;
        }
        textarea {
            width: 100%;
            min-height: 80px;
            padding: 12px;
            border-radius: 10px;
            border: 1px solid #ccc;
            resize: vertical;
            font-family: inherit;
        }

        /* ===== ACTES ===== */
        .actes-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .acte-item {
            background: #f7f9fc;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .acte-item:hover { transform: translateY(-3px); background: #eef3ff; }
        .acte-item.selected {
            background: var(--primary-green);
            color: white;
            border-color: var(--primary-green);
        }
        .total-cout {
            margin-top: 25px;
            text-align: right;
            font-weight: 700;
            color: var(--primary-blue);
            font-size: 1.2rem;
        }

        /* ===== BUTTONS ===== */
        .btn {
            padding: 12px 22px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-success { background: var(--primary-green); color: white; }
        .btn-success:hover { background: #2E7D32; transform: translateY(-2px); }
        .btn-primary { background: var(--primary-blue); color: white; }
        .btn-warning { background: var(--accent-orange); color: white; }
        .btn-secondary { background: var(--neutral-gray); color: white; }

        .btn:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.15); }

        .btn-container {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            justify-content: center;
            margin-top: 35px;
        }

        @media (max-width: 768px) {
            .consultation-header h2 { font-size: 1.5rem; }
            .consultation-form, .patient-card { padding: 20px; }
        }
    </style>
</head>

<body>
<div class="consultation-header">
    <h2>Consultation Médicale</h2>
    <p>Suivi du patient en cours de prise en charge</p>
</div>

<c:choose>
    <c:when test="${empty patient}">
        <div class="patient-card" style="text-align: center;">
            <h3 style="color: #E53935;">❌ Aucun patient sélectionné</h3>
            <a href="${pageContext.request.contextPath}/app/patient" class="btn btn-primary" style="margin-top: 20px;">
                📋 Retour à la liste des patients
            </a>
        </div>
    </c:when>

    <c:otherwise>
        <div class="patient-card">
            <div class="patient-header">
                <div class="patient-avatar">${patient.prenom.charAt(0)}${patient.nom.charAt(0)}</div>
                <div>
                    <div class="patient-name">${patient.nom} ${patient.prenom}</div>
                    <div class="patient-id">#${patient.id}</div>
                </div>
            </div>

            <div class="patient-grid">
                <div class="info-section">
                    <div class="info-title">Informations Personnelles</div>
                    <div class="info-item"><span class="info-label">Naissance :</span>
                        <span class="info-value">
                                <c:if test="${not empty patient.dateNaissance}">
                                    <%= ((java.time.LocalDate) ((org.example.projet.model.Patient) pageContext.findAttribute("patient")).getDateNaissance()).format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) %>
                                </c:if>
                            </span>
                    </div>
                    <div class="info-item"><span class="info-label">N° Sécu :</span> <span class="info-value">${patient.numSecuriteSociale}</span></div>
                    <div class="info-item"><span class="info-label">Arrivée :</span>
                        <span class="info-value">
                                <%
                                    org.example.projet.model.Patient pat = (org.example.projet.model.Patient) pageContext.findAttribute("patient");
                                    if (pat.getHeureArrivee() != null) {
                                        out.print(pat.getHeureArrivee().format(dateTimeFormatter));
                                    } else {
                                        out.print("<span style='color:#999;'>Non définie</span>");
                                    }
                                %>
                            </span>
                    </div>
                </div>

                <div class="info-section">
                    <div class="info-title">Signes Vitaux</div>
                    <div class="info-item"><span class="info-label">Tension :</span> <span class="info-value">${empty patient.tension ? "—" : patient.tension}</span></div>
                    <div class="info-item"><span class="info-label">Fréquence Cardiaque :</span> <span class="info-value">${empty patient.frequenceCardiaque ? "—" : patient.frequenceCardiaque} bpm</span></div>
                    <div class="info-item"><span class="info-label">Température :</span> <span class="info-value">${empty patient.temperature ? "—" : patient.temperature} °C</span></div>
                    <div class="info-item"><span class="info-label">Respiration :</span> <span class="info-value">${empty patient.frequenceRespiratoire ? "—" : patient.frequenceRespiratoire} /min</span></div>
                </div>

                <div class="info-section">
                    <div class="info-title">Statut</div>
                    <c:choose>
                        <c:when test="${patient.statut == 'EN_ATTENTE'}"><span class="status-badge status-en-attente">${patient.statut}</span></c:when>
                        <c:when test="${patient.statut == 'EN_COURS'}"><span class="status-badge status-en-cours">${patient.statut}</span></c:when>
                        <c:when test="${patient.statut == 'URGENT'}"><span class="status-badge status-urgent">${patient.statut}</span></c:when>
                        <c:otherwise><span class="status-badge status-termine">${patient.statut}</span></c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <form class="consultation-form" action="${pageContext.request.contextPath}/app/consultation" method="post">
            <input type="hidden" name="patientId" value="${patient.id}" />

            <h3>🩺 Informations Consultation</h3>
            <label>Observations :</label>
            <textarea name="observations" required placeholder="Décrivez les observations médicales..."></textarea>
            <label style="margin-top: 15px;">Diagnostic :</label>
            <textarea name="diagnostic" required placeholder="Diagnostic médical..."></textarea>

            <h3 style="margin-top: 30px;">⚙️ Actes Techniques</h3>
            <div class="actes-grid">
                <c:forEach var="acte" items="${actes}">
                    <div class="acte-item" onclick="toggleActe(this)" data-id="${acte.id}">
                        <strong>${acte.libelle}</strong><br>
                        <span style="color: var(--primary-green); font-weight: 600;">${acte.tarif} €</span>
                    </div>
                </c:forEach>
            </div>
            <div class="total-cout">💰 Total: <span id="total">0.00</span> DH</div>

            <div class="btn-container">
                <button type="submit" class="btn btn-success"> Terminer</button>
                <a href="${pageContext.request.contextPath}/app/consultation/direct?patientId=${patient.id}" class="btn btn-primary">🚀 Prise Directe</a>
                <a href="${pageContext.request.contextPath}/app/consultation/expertise?patientId=${patient.id}" class="btn btn-warning">👨‍⚕️ Expertise</a>
                <button type="button" class="btn btn-secondary" onclick="window.history.back()">❌ Annuler</button>
            </div>
        </form>
    </c:otherwise>
</c:choose>

<script>
    let selectedActes = [];
    let total = 0;

    function toggleActe(element) {
        const acteId = element.getAttribute('data-id');
        if (selectedActes.includes(acteId)) {
            selectedActes = selectedActes.filter(id => id !== acteId);
            element.classList.remove('selected');
        } else {
            selectedActes.push(acteId);
            element.classList.add('selected');
        }

        total = 0;
        document.querySelectorAll('.acte-item.selected').forEach(item => {
            const tarif = parseFloat(item.querySelector('span').textContent.replace(' €', ''));
            total += tarif;
        });
        document.getElementById('total').textContent = total.toFixed(2);
    }

    document.querySelector('form').addEventListener('submit', function(e) {
        document.querySelectorAll('input[name="actes"]').forEach(input => input.remove());
        selectedActes.forEach(acteId => {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'actes';
            input.value = acteId;
            this.appendChild(input);
        });
    });
</script>
</body>
</html>

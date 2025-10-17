<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Consultation Médicale - TeleCare</title>
    <style>
        :root {
            --primary-blue: #2196F3;
            --primary-green: #4CAF50;
            --accent-orange: #FF9800;
            --neutral-gray: #757575;
            --light-gray: #F5F5F5;
            --white: #FFFFFF;
            --dark-gray: #2E2E2E;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: var(--light-gray); color: var(--dark-gray); }

        .consultation-header {
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-green));
            color: white; text-align: center;
            padding: 35px 20px; border-radius: 0 0 20px 20px; margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .container { max-width: 1100px; margin: 0 auto; padding: 20px; }
        .card {
            background: var(--white);
            padding: 25px; border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h3 { color: var(--primary-blue); margin-bottom: 20px; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(230px, 1fr)); gap: 15px; }
        .info-box { background: #f8f9fa; border-radius: 8px; padding: 15px; }
        .info-box strong { color: var(--primary-blue); display: block; margin-bottom: 4px; }

        .form-group { margin-bottom: 20px; }
        .form-group label { font-weight: 600; display: block; margin-bottom: 8px; }
        .form-group input, .form-group textarea, .form-group select {
            width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 8px; font-size: 1rem;
        }

        textarea { resize: vertical; }

        .btn {
            padding: 12px 20px; border: none; border-radius: 8px;
            cursor: pointer; font-weight: 600; transition: 0.3s;
            color: #fff;
        }
        .btn-primary { background: var(--primary-blue); }
        .btn-success { background: var(--primary-green); }
        .btn-warning { background: var(--accent-orange); }
        .btn-secondary { background: var(--neutral-gray); }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0,0,0,0.2); }

        .btn-group { display: flex; gap: 10px; margin-top: 20px; flex-wrap: wrap; }
        .acte-item { background: #f8f9fa; padding: 10px; border-radius: 8px; margin-bottom: 8px; }
    </style>
</head>

<body>
    <div class="consultation-header">
        <h2>Consultation Médicale</h2>
        <p>Gestion complète de la consultation du patient</p>
    </div>

    <div class="container">
        <c:choose>
            <c:when test="${empty patient}">
                <div class="card">
                    <p style="text-align: center;">Aucun patient sélectionné.</p>
                    <p style="text-align: center;">
                        <a href="${pageContext.request.contextPath}/app/patient" class="btn btn-primary">Retour aux Patients</a>
                    </p>
                </div>
            </c:when>

            <c:otherwise>
                <!-- 🩺 Infos Patient Complètes -->
                <div class="card">
                    <h3>Informations du Patient</h3>
                    <div class="info-grid">
                        <div class="info-box"><strong>Nom</strong>${patient.nom}</div>
                        <div class="info-box"><strong>Prénom</strong>${patient.prenom}</div>
                        <div class="info-box"><strong>Date de naissance</strong>${patient.dateNaissance}</div>
                        <div class="info-box"><strong>Numéro Sécurité Sociale</strong>${patient.numSecuriteSociale}</div>
                        <div class="info-box"><strong>Heure d'arrivée</strong>
                            <%
                                org.example.projet.model.Patient pat = (org.example.projet.model.Patient) pageContext.findAttribute("patient");
                                if (pat.getHeureArrivee() != null) {
                                    out.print(pat.getHeureArrivee().format(dateFormatter));
                                } else {
                                    out.print("Non définie");
                                }
                            %>
                        </div>
                        <div class="info-box"><strong>Statut</strong>${patient.statut}</div>
                        <div class="info-box"><strong>Tension</strong>${patient.tension} mmHg</div>
                        <div class="info-box"><strong>Température</strong>${patient.temperature} °C</div>
                        <div class="info-box"><strong>Fréquence Cardiaque</strong>${patient.frequenceCardiaque} bpm</div>
                        <div class="info-box"><strong>Fréquence Respiratoire</strong>${patient.frequenceRespiratoire} /min</div>
                    </div>
                </div>

                <!-- 🧾 Formulaire Consultation -->
                <form action="${pageContext.request.contextPath}/app/consultation" method="post" class="card">
                    <input type="hidden" name="patientId" value="${patient.id}">

                    <div class="form-group">
                        <label for="type">Type de Consultation :</label>
                        <select name="type" id="type" onchange="handleConsultationType()" required>
                            <option value="DIRECTE">Consultation Directe</option>
                            <option value="EXPERTISE">Demande d’Expertise</option>
                            <option value="ANNULATION">Annulation</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="observations">Observations :</label>
                        <textarea name="observations" id="observations" placeholder="Examen clinique, symptômes..." required></textarea>
                    </div>

                    <div class="form-group">
                        <label for="diagnostic">Diagnostic :</label>
                        <textarea name="diagnostic" id="diagnostic" placeholder="Diagnostic établi..." required></textarea>
                    </div>

                    <div class="form-group" id="traitementField">
                        <label for="traitement">Traitement :</label>
                        <textarea name="traitement" id="traitement" placeholder="Prescription ou recommandations..."></textarea>
                    </div>

                    <!-- Actes médicaux -->
                    <div class="form-group">
                        <label>Actes Médicaux :</label>
                        <c:choose>
                            <c:when test="${not empty actes}">
                                <c:forEach var="acte" items="${actes}">
                                    <div class="acte-item">
                                        <label>
                                            <input type="checkbox" name="actes" value="${acte.id}">
                                            ${acte.libelle} - ${acte.tarif} DH
                                        </label>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p style="color: var(--neutral-gray);">Aucun acte disponible.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn btn-success">💾 Enregistrer</button>
                        <a href="${pageContext.request.contextPath}/app/medecin/dashboard" class="btn btn-secondary">⬅ Retour</a>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        // 🧠 Gérer la redirection automatique vers la page d’expertise
        function handleConsultationType() {
            const type = document.getElementById("type").value;
            const patientId = "${patient.id}";
            if (type === "EXPERTISE") {
                // Redirige automatiquement vers la page de création de demande d'expertise
                window.location.href = "${pageContext.request.contextPath}/app/consultation/expertise?patientId=" + patientId;
            }
        }
    </script>
</body>
</html>

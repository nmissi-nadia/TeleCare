<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Dashboard Spécialiste - TeleCare</title>
    <style>
        :root {
            --success-green: #4CAF50;     /* ✅ Vert pour succès */
            --neutral-gray: #757575;      /* Gris neutre */
            --light-gray: #F5F5F5;        /* ✅ Gris clair */
            --white: #FFFFFF;             /* ✅ Blanc */
            --dark-gray: #424242;         /* Gris foncé */
            --surface-gray: #FAFAFA;      /* Gris surface */
            --error-red: #F44336;         /* Rouge erreur */
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: var(--light-gray); }
        .header { background: var(--neutral-gray); color: white; padding: 20px; text-align: center; }
        .container { max-width: 1200px; margin: 20px auto; padding: 0 20px; }
        .dashboard-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 20px; }
        .card { background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .card-header { background: var(--surface-gray); padding: 15px; border-bottom: 1px solid #dee2e6; font-weight: bold; color: var(--dark-gray); }
        .card-body { padding: 15px; }
        .demande-item { border: 1px solid #ddd; border-radius: 5px; margin-bottom: 15px; padding: 15px; background: var(--surface-gray); }
        .demande-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .patient-info { color: #666; font-size: 14px; }
        .demande-content { margin: 10px 0; }
        .demande-actions { text-align: center; margin-top: 15px; }
        .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; }
        .btn-success { background: var(--success-green); color: white; }
        .btn-danger { background: var(--error-red); color: white; }
        .btn-primary { background: var(--neutral-gray); color: white; }
        .btn:hover { opacity: 0.8; }
        .status-badge { padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: bold; }
        .status-en-attente { background: var(--light-gray); color: var(--dark-gray); }
        .status-en-cours { background: var(--light-gray); color: var(--dark-gray); }
        .status-termine { background: var(--success-green); color: white; }
        .no-data { text-align: center; color: #666; padding: 40px; }
        .stats { display: flex; gap: 15px; margin-bottom: 20px; }
        .stat-card { background: white; padding: 15px; border-radius: 5px; text-align: center; flex: 1; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .stat-number { font-size: 24px; font-weight: bold; color: var(--success-green); }
        .stat-label { color: #666; font-size: 14px; }
    </style>
</head>
<body>
    <div class="header">
        <h1> Dashboard Spécialiste - ${currentUser.prenom} ${currentUser.nom}</h1>
        <p><strong>Spécialité:</strong> ${specialite}</p>
    </div>

    <div class="container">
        <!-- Statistiques -->
        <div class="stats">
            <div class="stat-card">
                <div class="stat-number">${demandesEnAttente.size()}</div>
                <div class="stat-label">Demandes en attente</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${consultationsEnCours.size()}</div>
                <div class="stat-label">Expertises en cours</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${expertisesTerminees.size()}</div>
                <div class="stat-label">Expertises terminées</div>
            </div>
        </div>

        <div class="dashboard-grid">
            <!-- Demandes d'expertise en attente -->
            <div class="card">
                <div class="card-header">
                    Demandes d'Expertise en Attente
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty demandesEnAttente}">
                            <c:forEach var="demande" items="${demandesEnAttente}">
                                <div class="demande-item">
                                    <div class="demande-header">
                                        <div>
                                            <strong>Patient #${demande.consultation.patient.id}</strong>
                                            <div class="patient-info">
                                                ${demande.consultation.patient.nom} ${demande.consultation.patient.prenom}
                                            </div>
                                        </div>
                                        <div class="status-badge status-en-attente">En attente</div>
                                    </div>

                                    <div class="demande-content">
                                        <p><strong>Médecin généraliste:</strong> ${demande.medecinGeneraliste.prenom} ${demande.medecinGeneraliste.nom}</p>
                                        <p><strong>Raison:</strong> ${demande.raison}</p>
                                        <c:if test="${not empty demande.observations}">
                                            <p><strong>Observations:</strong></p>
                                            <p style="font-style: italic; background: white; padding: 8px; border-radius: 3px; margin-top: 5px;">
                                                ${demande.observations}
                                            </p>
                                        </c:if>
                                    </div>

                                    <div class="demande-actions">
                                        <form action="${pageContext.request.contextPath}/app/expertise/repondre" method="post" style="display: inline;">
                                            <input type="hidden" name="demandeId" value="${demande.id}">
                                            <input type="hidden" name="response" value="ACCEPTER">
                                            <button type="submit" class="btn btn-success" onclick="return confirm('Accepter cette demande d\'expertise ?')">
                                                Accepter
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/app/expertise/repondre" method="post" style="display: inline;">
                                            <input type="hidden" name="demandeId" value="${demande.id}">
                                            <input type="hidden" name="response" value="REFUSER">
                                            <button type="submit" class="btn btn-danger" onclick="return confirm('Refuser cette demande d\'expertise ?')">
                                                Refuser
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div cl ass="no-data">
                                <p> Aucune demande d'expertise en attente</p>
                                <p>Toutes les demandes ont été traitées !</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Consultations d'expertise en cours -->
            <div class="card">
                <div class="card-header">
                    🔬 Expertises en Cours
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty consultationsEnCours}">
                            <c:forEach var="consultation" items="${consultationsEnCours}">
                                <div class="demande-item">
                                    <div class="demande-header">
                                        <div>
                                            <strong>Patient #${consultation.patient.id}</strong>
                                            <div class="patient-info">
                                                ${consultation.patient.nom} ${consultation.patient.prenom}
                                            </div>
                                        </div>
                                        <div class="status-badge status-en-cours">En cours</div>
                                    </div>

                                    <div class="demande-content">
                                        <p><strong>Date de début:</strong>
                                            <%= ((org.example.projet.model.Consultation) pageContext.findAttribute("consultation")).getDateConsultation().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %>
                                        </p>
                                        <c:if test="${not empty consultation.observations}">
                                            <p><strong>Observations initiales:</strong></p>
                                            <p style="font-style: italic; background: white; padding: 8px; border-radius: 3px;">
                                                ${consultation.observations}
                                            </p>
                                        </c:if>
                                    </div>

                                    <div class="demande-actions">
                                        <a href="${pageContext.request.contextPath}/app/consultation/expertise?id=${consultation.id}" class="btn btn-primary">
                                            🔬 Continuer l'expertise
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="no-data">
                                <p>🔬 Aucune expertise en cours</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Expertises terminées -->
            <div class="card">
                <div class="card-header">
                    Expertises Terminées
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty expertisesTerminees}">
                            <c:forEach var="consultation" items="${expertisesTerminees}">
                                <div class="demande-item">
                                    <div class="demande-header">
                                        <div>
                                            <strong>Patient #${consultation.patient.id}</strong>
                                            <div class="patient-info">
                                                ${consultation.patient.nom} ${consultation.patient.prenom}
                                            </div>
                                        </div>
                                        <div class="status-badge status-termine">Terminée</div>
                                    </div>

                                    <div class="demande-content">
                                        <p><strong>Date de fin:</strong>
                                            <%= ((org.example.projet.model.Consultation) pageContext.findAttribute("consultation")).getDateConsultation().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %>
                                        </p>
                                        <p><strong>Coût total:</strong> ${consultation.cout} €</p>
                                        <c:if test="${not empty consultation.diagnostic}">
                                            <p><strong>Diagnostic final:</strong> ${consultation.diagnostic}</p>
                                        </c:if>
                                    </div>

                                    <div class="demande-actions">
                                        <button class="btn" style="background: var(--neutral-gray);" onclick=`voirDetails(${consultation.id})`>
                                             Voir détails
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="no-data">
                                <p> Aucune expertise terminée</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Actions générales -->
        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/app/logout" class="btn" style="background: var(--error-red);">
             Déconnexion
            </a>
        </div>
    </div>

    <script>
        function voirDetails(consultationId) {
            window.open('${pageContext.request.contextPath}/app/consultation/details?id=' + consultationId, '_blank', 'width=800,height=600');
        }
    </script>
</body>
</html>
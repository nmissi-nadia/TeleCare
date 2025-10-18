<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Détails de la Demande - TeleCare</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        :root { --primary-green:#4CAF50; --light-beige:#f5f3e7; --white:#fff; --neutral-gray:#757575; --dark-gray:#2e2e2e; }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Segoe UI', sans-serif; background:var(--light-beige); color:var(--dark-gray); }
        .sidebar { width:280px; background:linear-gradient(135deg, var(--primary-green) 0%, #81c784 100%); color:var(--white); position:fixed; height:100vh; box-shadow:2px 0 10px rgba(0,0,0,0.1); }
        .sidebar-header { padding:25px 20px; text-align:center; }
        .sidebar-nav a { display:block; padding:15px 25px; color:var(--white); text-decoration:none; font-weight:500; }
        .sidebar-nav a:hover { background:rgba(255,255,255,0.1); }
        .main-content { margin-left:280px; padding:30px; }
        .page-header { background:var(--white); padding:25px; border-radius:12px; margin-bottom:30px; box-shadow:0 2px 8px rgba(0,0,0,0.1); }
        .card { background:var(--white); border-radius:12px; padding:25px; margin-bottom:25px; box-shadow:0 2px 10px rgba(0,0,0,0.1); }
        .grid { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        .label { font-weight:700; color:var(--primary-green); margin-bottom:4px; }
        .value { padding:10px; border:1px solid #eee; border-radius:8px; background:#fafafa; }
        .btn { padding:10px 18px; border:none; border-radius:10px; font-weight:600; cursor:pointer; }
        .btn-primary { background:var(--primary-green); color:#fff; }
        .muted { color:var(--neutral-gray); font-size:13px; }
    </style>
</head>
<body>
<aside class="sidebar">
    <div class="sidebar-header">
        <h1>🌿 TeleCare</h1>
        <div style="font-size:14px;opacity:.8">Médecin Spécialiste</div>
    </div>
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/app/specialiste/demandes">📄 Demandes</a>
        <a href="${pageContext.request.contextPath}/logout">🚪 Déconnexion</a>
    </nav>
</aside>

<main class="main-content">
    <div class="page-header">
        <h2>Détails de la Demande</h2>
        <p class="muted">Consultez les informations de la demande de télé-expertise.</p>
    </div>

    <div class="card">
        <div class="grid">
            <div>
                <div class="label">Créée le</div>
                <div class="value"><c:out value="${demande.dateCreation}" /></div>
            </div>
            <div>
                <div class="label">Statut</div>
                <div class="value"><c:out value="${demande.statut}" /></div>
            </div>
            <div>
                <div class="label">Médecin Généraliste</div>
                <div class="value">
                    <c:out value="${demande.medecinGeneraliste.nom}" />
                    <c:out value=" " />
                    <c:out value="${demande.medecinGeneraliste.prenom}" />
                </div>
            </div>
            <div>
                <div class="label">Spécialité demandée</div>
                <div class="value"><c:out value="${demande.specialiteDemandee}" /></div>
            </div>
            <div style="grid-column:1 / -1">
                <div class="label">Raison</div>
                <div class="value"><c:out value="${demande.raison}" /></div>
            </div>
            <div style="grid-column:1 / -1">
                <div class="label">Question médicale</div>
                <div class="value"><c:out value="${demande.question}" /></div>
            </div>
            <div style="grid-column:1 / -1">
                <div class="label">Observations (généraliste)</div>
                <div class="value"><c:out value="${demande.observations}" /></div>
            </div>
            <div style="grid-column:1 / -1">
                <div class="label">Diagnostic (réponse)</div>
                <div class="value"><c:out value="${demande.diagnostic}" /></div>
            </div>
        </div>
    </div>

    <!-- Informations Patient -->
    <c:choose>
        <c:when test="${demande.consultation != null && demande.consultation.patient != null}">
            <div class="card">
                <h3 style="margin-bottom:16px; color: var(--primary-green);">Informations du Patient</h3>
                <div class="grid">
                    <div>
                        <div class="label">Nom</div>
                        <div class="value"><c:out value="${demande.consultation.patient.nom}"/></div>
                    </div>
                    <div>
                        <div class="label">Prénom</div>
                        <div class="value"><c:out value="${demande.consultation.patient.prenom}"/></div>
                    </div>
                    <div>
                        <div class="label">Date de naissance</div>
                        <div class="value"><c:out value="${demande.consultation.patient.dateNaissance}"/></div>
                    </div>
                    <div>
                        <div class="label">N° Sécurité Sociale</div>
                        <div class="value"><c:out value="${demande.consultation.patient.numSecuriteSociale}"/></div>
                    </div>
                    <div>
                        <div class="label">Tension</div>
                        <div class="value"><c:out value="${demande.consultation.patient.tension}"/></div>
                    </div>
                    <div>
                        <div class="label">Fréquence cardiaque</div>
                        <div class="value"><c:out value="${demande.consultation.patient.frequenceCardiaque}"/></div>
                    </div>
                    <div>
                        <div class="label">Température</div>
                        <div class="value"><c:out value="${demande.consultation.patient.temperature}"/></div>
                    </div>
                    <div>
                        <div class="label">Fréquence respiratoire</div>
                        <div class="value"><c:out value="${demande.consultation.patient.frequenceRespiratoire}"/></div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card">
                <h3 style="margin-bottom:8px; color: var(--primary-green);">Informations du Patient</h3>
                <p class="muted">Aucune information patient n'est liée à cette demande.</p>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Zone d’actions (répondre / accepter / refuser) -->
    <div class="card">
        <h3 style="margin-bottom:16px; color: var(--primary-green);">Réponse du spécialiste</h3>
        <form method="post" action="${pageContext.request.contextPath}/app/expertise/details" style="margin-bottom:16px;">
            <input type="hidden" name="id" value="${demande.id}"/>
            <input type="hidden" name="action" value="repondre"/>

            <div style="margin-bottom:12px;">
                <div class="label">Diagnostic</div>
                <textarea name="diagnostic" rows="4" class="value" style="width:100%;"></textarea>
            </div>
            <div style="margin-bottom:12px;">
                <div class="label">Observations (spécialiste)</div>
                <textarea name="observationsSpec" rows="3" class="value" style="width:100%;"></textarea>
            </div>

            <button class="btn btn-primary" type="submit">Enregistrer la réponse</button>
        </form>

        <div style="display:flex; gap:12px; flex-wrap: wrap;">
            <form method="post" action="${pageContext.request.contextPath}/app/expertise/details">
                <input type="hidden" name="id" value="${demande.id}"/>
                <input type="hidden" name="action" value="accepter"/>
                <button class="btn btn-primary" type="submit">Accepter la demande</button>
            </form>

            <form method="post" action="${pageContext.request.contextPath}/app/expertise/details">
                <input type="hidden" name="id" value="${demande.id}"/>
                <input type="hidden" name="action" value="refuser"/>
                <div class="label" style="margin-top:8px;">Raison du refus</div>
                <input type="text" name="raisonRefus" class="value" style="width:320px;" placeholder="Saisir la raison"/>
                <button class="btn" type="submit" style="margin-left:8px;">Refuser</button>
            </form>
        </div>
    </div>
</main>
</body>
</html>
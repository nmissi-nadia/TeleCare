<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>Dashboard Médecin - TeleCare</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1000px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; }
        .header { background: #007bff; color: white; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; margin-bottom: 30px; }
        .stat-card { background: #f8f9fa; padding: 15px; text-align: center; border-radius: 5px; }
        .stat-number { font-size: 24px; font-weight: bold; color: #007bff; }
        .btn { background: #007bff; color: white; padding: 12px 20px; text-decoration: none; border-radius: 4px; margin: 5px; }
        .btn-success { background: #28a745; }
        .btn-warning { background: #ffc107; color: #000; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #f8f9fa; }
        .status { padding: 3px 8px; border-radius: 3px; font-size: 11px; font-weight: bold; }
        .status-EN_ATTENTE { background: #ffc107; color: #000; }
        .status-EN_COURS { background: #17a2b8; color: white; }
        .status-TERMINE { background: #28a745; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>👨‍⚕️ Dashboard Médecin - ${currentUser.prenom} ${currentUser.nom}</h2>
        </div>

        <div class="stats">
            <div class="stat-card"><div class="stat-number">${stats[0]}</div><div>Consultations du Jour</div></div>
            <div class="stat-card"><div class="stat-number">${stats[1]}</div><div>En Attente</div></div>
            <div class="stat-card"><div class="stat-number">${stats[2]}</div><div>Terminées</div></div>
        </div>

        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/app/patient" class="btn">📋 Voir Patients</a>
            <a href="${pageContext.request.contextPath}/jsp/home.jsp" class="btn" style="background: #6c757d;">⬅️ Accueil</a>
        </div>

        <h3>Patients en Attente</h3>
        <c:choose>
            <c:when test="${empty patientsEnAttente}">
                <p style="text-align: center; color: #666; padding: 20px;">Aucun patient en attente</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead><tr><th>ID</th><th>Patient</th><th>Heure</th><th>Statut</th><th>Action</th></tr></thead>
                    <tbody>
                        <c:forEach var="p" items="${patientsEnAttente}">
                            <tr>
                                <td>#${p.id}</td>
                                <td><strong>${p.nom} ${p.prenom}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.heureArrivee}">
                                            <fmt:formatDate value="${p.heureArrivee}" pattern="HH:mm" />
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><span class="status status-${p.statut}">${p.statut}</span></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/app/consultation?patientId=${p.id}" class="btn btn-success">Consulter</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

        <h3 style="margin-top: 30px;">Consultations du Jour</h3>
        <c:choose>
            <c:when test="${empty consultationsDuJour}">
                <p style="text-align: center; color: #666; padding: 20px;">Aucune consultation aujourd'hui</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead><tr><th>ID</th><th>Patient</th><th>Heure Consultation</th><th>Statut</th></tr></thead>
                    <tbody>
                        <c:forEach var="c" items="${consultationsDuJour}">
                            <tr>
                                <td>#${c.patient.id}</td>
                                <td><strong>${c.patient.nom} ${c.patient.prenom}</strong></td>
                                <td><fmt:formatDate value="${c.dateConsultation}" pattern="HH:mm" /></td>
                                <td><span class="status status-${c.statut}">${c.statut}</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>

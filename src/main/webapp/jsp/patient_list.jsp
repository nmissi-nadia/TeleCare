<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>Liste des patients du jour</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .btn {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            margin: 5px;
            display: inline-block;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .btn-danger {
            background-color: #dc3545;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .btn-success {
            background-color: #28a745;
        }
        .btn-success:hover {
            background-color: #218838;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-warning:hover {
            background-color: #e0a800;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-EN_ATTENTE {
            background-color: #ffc107;
            color: #212529;
        }
        .status-EN_COURS {
            background-color: #17a2b8;
            color: white;
        }
        .status-TERMINE {
            background-color: #28a745;
            color: white;
        }
        .status-URGENT {
            background-color: #dc3545;
            color: white;
        }
        .vital-signs {
            font-size: 12px;
            color: #666;
            margin-top: 2px;
        }
        .no-patients {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }
        .patient-info {
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Patients du jour - ${patients.size()} patient(s)</h2>

        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/jsp/patient_form.jsp" class="btn">
                + Nouveau Patient
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger"
               onclick="return confirm('Etes-vous sur de vouloir vous deconnecter ?')">
                Deconnexion
            </a>
        </div>

        <c:choose>
            <c:when test="${empty patients}">
                <div class="no-patients">
                    <h3>Aucun patient enregistre aujourd'hui</h3>
                    <p>Commencez par ajouter un nouveau patient.</p>
                    <a href="${pageContext.request.contextPath}/jsp/patient_form.jsp" class="btn">
                        + Ajouter le premier patient
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div style="overflow-x: auto;">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Informations personnelles</th>
                                <th>Signes vitux</th>
                                <th>Heure d'arrivee</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${patients}">
                                <tr>
                                    <td><strong>#${p.id}</strong></td>
                                    <td>
                                        <div class="patient-info">
                                            <strong>${p.nom} ${p.prenom}</strong>
                                        </div>
                                        <div class="patient-info">
                                            <small>Date naissance: <fmt:formatDate value="${p.dateNaissance}" pattern="dd/MM/yyyy" /></small>
                                        </div>
                                        <div class="patient-info">
                                            <small>Securite sociale: ${p.numSecuriteSociale}</small>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="vital-signs">
                                            <c:if test="${not empty p.tension}">
                                                <span>Tension: ${p.tension}</span><br>
                                            </c:if>
                                            <c:if test="${not empty p.frequenceCardiaque}">
                                                <span>Frequence cardiaque: ${p.frequenceCardiaque} bpm</span><br>
                                            </c:if>
                                            <c:if test="${not empty p.temperature}">
                                                <span>Temperature: ${p.temperature}°C</span><br>
                                            </c:if>
                                            <c:if test="${not empty p.frequenceRespiratoire}">
                                                <span>Respiration: ${p.frequenceRespiratoire}/min</span>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td>
                                      <c:choose>
                                          <c:when test="${not empty p.heureArrivee}">
                                              <fmt:formatDate value="${p.heureArrivee}" pattern="HH:mm" />
                                              <br>
                                              <small><fmt:formatDate value="${p.heureArrivee}" pattern="dd/MM/yyyy" /></small>
                                          </c:when>
                                          <c:otherwise>
                                              <span style="color: #999;">Non définie</span>
                                          </c:otherwise>
                                      </c:choose>
                                  </td>
                                        <c:choose>
                                            <c:when test="${p.statut == 'EN_ATTENTE'}">
                                                <a href="${pageContext.request.contextPath}/app/consultation?patientId=${p.id}"
                                                   class="btn btn-success">
                                                    Commencer consultation
                                                </a>
                                            </c:when>
                                            <c:when test="${p.statut == 'EN_COURS'}">
                                                <a href="${pageContext.request.contextPath}/app/consultation?patientId=${p.id}"
                                                   class="btn btn-warning">
                                                    Continuer consultation
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #6c757d;">Consultation terminee</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div style="margin-top: 30px; text-align: center; color: #666;">
                    <p>Total: ${patients.size()} patient(s) enregistre(s) aujourd'hui</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>

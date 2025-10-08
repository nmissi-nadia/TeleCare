<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>Consultation Médicale - TeleCare</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 800px; margin: 0 auto; }
        .patient-info { background: #e3f2fd; padding: 15px; margin-bottom: 20px; border-radius: 5px; }
        .form-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .actes-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px; }
        .acte-item { padding: 10px; border: 1px solid #ddd; border-radius: 5px; cursor: pointer; }
        .acte-item:hover { background: #f0f0f0; }
        .acte-item.selected { background: #d4edda; border-color: #28a745; }
        .selected-actes { background: #f8f9fa; padding: 15px; margin-top: 15px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Consultation Médicale</h1>

        <c:choose>
            <c:when test="${empty patient}">
                <p>Erreur: Aucun patient spécifié</p>
                <a href="${pageContext.request.contextPath}/app/patient">Retour</a>
            </c:when>
            <c:otherwise>
                <div class="patient-info">
                    <h3>Patient: ${patient.nom} ${patient.prenom}</h3>
                    <p>ID: #${patient.id}</p>
                    <p>Arrivée: <fmt:formatDate value="${patient.heureArrivee}" pattern="dd/MM/yyyy HH:mm" /></p>
                    <c:if test="${not empty patient.tension}">
                        <p>Tension: ${patient.tension}</p>
                    </c:if>
                </div>

                <form action="${pageContext.request.contextPath}/app/consultation" method="post">
                    <input type="hidden" name="patientId" value="${patient.id}" />
                    <input type="hidden" name="csrf" value="${sessionScope.csrfToken}" />

                    <div class="form-section">
                        <h3>Informations de Consultation</h3>
                        <label>Observations:</label><br>
                        <textarea name="observations" rows="3" required></textarea><br><br>

                        <label>Diagnostic:</label><br>
                        <textarea name="diagnostic" rows="3" required></textarea><br>
                    </div>

                    <div class="form-section">
                        <h3>Actes Techniques</h3>
                        <div class="actes-grid">
                            <c:forEach var="acte" items="${actes}">
                                <div class="acte-item" onclick="toggleActe(this)" data-id="${acte.id}">
                                    ${acte.libelle} - ${acte.tarif} €
                                </div>
                            </c:forEach>
                        </div>

                        <div class="selected-actes" id="selectedActes" style="display: none;">
                            <h4>Actes sélectionnés:</h4>
                            <div id="selectedList"></div>
                            <p>Total: <span id="total">0.00</span> €</p>
                        </div>
                    </div>

                    <button type="submit">Terminer Consultation</button>
                </form>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        let selectedActes = [];
        let total = 0;

        function toggleActe(element) {
            const acteId = element.getAttribute('data-id');
            const isSelected = selectedActes.includes(acteId);

            if (isSelected) {
                selectedActes = selectedActes.filter(id => id !== acteId);
                element.classList.remove('selected');
            } else {
                selectedActes.push(acteId);
                element.classList.add('selected');
            }

            updateDisplay();
        }

        function updateDisplay() {
            const selectedDiv = document.getElementById('selectedActes');
            const listDiv = document.getElementById('selectedList');
            const totalSpan = document.getElementById('total');

            if (selectedActes.length > 0) {
                selectedDiv.style.display = 'block';
                // Calcul du total à partir des éléments sélectionnés
                total = 0;
                document.querySelectorAll('.acte-item.selected').forEach(item => {
                    const tarif = parseFloat(item.textContent.match(/(\d+\.?\d*)/)[1]);
                    total += tarif;
                });
            } else {
                selectedDiv.style.display = 'none';
            }

            totalSpan.textContent = total.toFixed(2);
        }
    </script>
</body>
</html>

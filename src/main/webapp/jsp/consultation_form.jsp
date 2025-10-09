<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>Consultation - TeleCare</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; }
        .header { background: #007bff; color: white; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .patient-info { background: #e3f2fd; padding: 15px; margin-bottom: 20px; border-radius: 5px; }
        .form-section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input, textarea, select { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 3px; }
        textarea { min-height: 80px; }
        .actes-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px; }
        .acte-item { padding: 10px; border: 1px solid #ddd; border-radius: 5px; cursor: pointer; }
        .acte-item:hover { background: #f0f0f0; }
        .acte-item.selected { background: #d4edda; border-color: #28a745; }
        .btn { background: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-success { background: #28a745; }
        .btn:hover { opacity: 0.9; }
        .total-cout { background: #f8f9fa; padding: 10px; text-align: right; font-weight: bold; margin-top: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Consultation Médicale</h2>
        </div>

        <c:choose>
            <c:when test="${empty patient}">
                <p style="text-align: center; color: red;">Erreur: Aucun patient spécifié</p>
                <a href="${pageContext.request.contextPath}/app/patient" class="btn">Retour</a>
            </c:when>
            <c:otherwise>
                <div class="patient-info">
                    <h3>👨‍⚕️ Patient: ${patient.nom} ${patient.prenom}</h3>
                    <p><strong>ID:</strong> #${patient.id}</p>
                    <p><strong>Arrivée:</strong> <fmt:formatDate value="${patient.heureArrivee}" pattern="dd/MM/yyyy HH:mm" /></p>
                    <c:if test="${not empty patient.tension}">
                        <p><strong>Tension:</strong> ${patient.tension}</p>
                    </c:if>
                    <c:if test="${not empty patient.frequenceCardiaque}">
                        <p><strong>FC:</strong> ${patient.frequenceCardiaque} bpm</p>
                    </c:if>
                </div>

                <form action="${pageContext.request.contextPath}/app/consultation" method="post">
                    <input type="hidden" name="patientId" value="${patient.id}" />
                    <input type="hidden" name="csrf" value="${sessionScope.csrfToken}" />

                    <div class="form-section">
                        <h3>Informations Consultation</h3>
                        <div class="form-row">
                            <div>
                                <label>Observations:</label>
                                <textarea name="observations" required></textarea>
                            </div>
                            <div>
                                <label>Diagnostic:</label>
                                <textarea name="diagnostic" required></textarea>
                            </div>
                        </div>
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
                        <div class="total-cout">Total: <span id="total">0.00</span> €</div>
                    </div>

                    <div style="text-align: center; margin-top: 20px;">
                        <button type="submit" class="btn btn-success">Terminer Consultation</button>
                        <a href="${pageContext.request.contextPath}/app/patient" class="btn" style="background: #6c757d;">Annuler</a>
                    </div>
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

            // Calcul du total
            total = 0;
            document.querySelectorAll('.acte-item.selected').forEach(item => {
                const tarif = parseFloat(item.textContent.match(/(\d+\.?\d*)/)[1]);
                total += tarif;
            });

            document.getElementById('total').textContent = total.toFixed(2);
        }

        // Ajouter les actes au formulaire avant soumission
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
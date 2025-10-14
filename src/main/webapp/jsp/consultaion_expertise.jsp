<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Consultation d'Expertise - TeleCare</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 800px; margin: auto; background: white; padding: 25px; border-radius: 8px; }
        .header { background: #9613d2; color: white; padding: 20px; border-radius: 8px 8px 0 0; margin: -25px -25px 25px -25px; }
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .form-group { margin: 10px 0; }
        label { display: block; font-weight: bold; margin-bottom: 5px; }
        input, select, textarea { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        textarea { height: 100px; }
        .btn { padding: 10px 15px; background: #9613d2; color: white; border: none; margin: 5px; border-radius: 4px; }
        .patient-info { background: #e3f2fd; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .actes-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 10px; margin: 15px 0; }
        .acte-item { padding: 10px; background: #f9f9f9; border: 1px solid #ddd; border-radius: 5px; cursor: pointer; }
        .acte-item:hover { background: #e8f5e8; }
        .acte-item.selected { background: #c8e6c9; border-color: #9613d2; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>🏥 Consultation d'Expertise Spécialisée</h2>
            <p><strong>Spécialiste:</strong> ${currentUser.prenom} ${currentUser.nom}</p>
        </div>

        <div class="patient-info">
            <h3>👤 Informations Patient</h3>
            <p><strong>Nom:</strong> ${patient.nom} ${patient.prenom}</p>
            <p><strong>ID:</strong> #${patient.id}</p>
            <p><strong>Date de naissance:</strong>
                <%= ((java.time.LocalDate) ((org.example.projet.model.Patient) pageContext.findAttribute("patient")).getDateNaissance()).format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) %>
            </p>
            <p><strong>N° Sécurité Sociale:</strong> ${patient.numSecuriteSociale}</p>
        </div>

        <!-- Consultation initiale du généraliste -->
        <div class="section">
            <h3> Consultation Initiale (Généraliste)</h3>
            <c:if test="${not empty consultation.observations}">
                <p><strong>Observations:</strong></p>
                <p style="white-space: pre-line; background: #f5f5f5; padding: 10px; border-radius: 4px;">${consultation.observations}</p>
            </c:if>
            <c:if test="${not empty consultation.diagnostic}">
                <p><strong>Diagnostic préliminaire:</strong></p>
                <p style="white-space: pre-line; background: #f5f5f5; padding: 10px; border-radius: 4px;">${consultation.diagnostic}</p>
            </c:if>
        </div>

        <!-- Formulaire d'expertise du spécialiste -->
        <form action="${pageContext.request.contextPath}/app/consultation/expertise" method="post">
            <input type="hidden" name="consultationId" value="${consultation.id}" />

            <div class="section">
                <h3>🔬 Expertise Spécialisée</h3>

                <div class="form-group">
                    <label for="avis">Avis du spécialiste *:</label>
                    <textarea id="avis" name="avis" required
                              placeholder="Votre analyse spécialisée et conclusions..."></textarea>
                </div>

                <div class="form-group">
                    <label for="diagnostic">Diagnostic spécialisé *:</label>
                    <textarea id="diagnostic" name="diagnostic" required
                              placeholder="Diagnostic définitif après expertise..."></textarea>
                </div>

                <div class="form-group">
                    <label for="traitement">Traitement spécialisé *:</label>
                    <textarea id="traitement" name="traitement" required
                              placeholder="Prescription spécialisée et protocole de soins..."></textarea>
                </div>

                <div class="form-group">
                    <label>Actes médicaux spécialisés (optionnel):</label>
                    <div class="actes-grid">
                        <c:forEach var="acte" items="${actes}">
                            <div class="acte-item" onclick="toggleActe(this)" data-id="${acte.id}">
                                <strong>${acte.libelle}</strong><br>
                                <span style="color: #0e5997;">${acte.tarif} €</span><br>
                                <small>${acte.categorie}</small>
                            </div>
                        </c:forEach>
                    </div>
                    <p><small>Cliquez pour sélectionner les actes réalisés pendant l'expertise</small></p>
                </div>
            </div>

            <div style="text-align: center; margin-top: 30px;">
                <button type="submit" class="btn" onclick="return confirm('Confirmer la fin de l\'expertise ?')">
                     Terminer l'Expertise
                </button>
                <a href="${pageContext.request.contextPath}/app/specialiste/dashboard" class="btn" style="background: #757575;">
                     Retour au Dashboard
                </a>
            </div>
        </form>
    </div>

    <script>
        let selectedActes = [];

        function toggleActe(element) {
            const acteId = element.getAttribute('data-id');

            if (selectedActes.includes(acteId)) {
                selectedActes = selectedActes.filter(id => id !== acteId);
                element.classList.remove('selected');
            } else {
                selectedActes.push(acteId);
                element.classList.add('selected');
            }
        }

        document.querySelector('form').addEventListener('submit', function(e) {
            // Supprimer les anciens champs actes
            document.querySelectorAll('input[name="actes"]').forEach(input => input.remove());

            // Ajouter les actes sélectionnés
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
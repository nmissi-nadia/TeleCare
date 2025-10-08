<html>
<head>
    <title>Enregistrer un patient - Première visite</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .form-group { margin: 10px 0; }
        label { display: inline-block; width: 150px; }
        input { padding: 5px; margin: 5px; }
        .vital-signs { border: 1px solid #ddd; padding: 15px; margin: 10px 0; background-color: #f9f9f9; }
        button { background-color: #007bff; color: white; padding: 10px 20px; border: none; cursor: pointer; }
        button:hover { background-color: #0056b3; }
    </style>
</head>
<body>
    <h2>Enregistrer un patient - Première visite</h2>

    <form action="${pageContext.request.contextPath}/app/patient" method="post">
        <!-- Informations personnelles -->
        <fieldset>
            <legend>Informations personnelles</legend>
            <div class="form-group">
                <label for="nom">Nom:</label>
                <input type="text" id="nom" name="nom" placeholder="Nom" required/>
            </div>

            <div class="form-group">
                <label for="prenom">Prénom:</label>
                <input type="text" id="prenom" name="prenom" placeholder="Prénom" required/>
            </div>

            <div class="form-group">
                <label for="dateNaissance">Date de naissance:</label>
                <input type="date" id="dateNaissance" name="dateNaissance" required/>
            </div>

            <div class="form-group">
                <label for="numSecuriteSociale">Numéro de sécurité sociale:</label>
                <input type="text" id="numSecuriteSociale" name="numSecuriteSociale"
                       placeholder="Ex: 1234567890123" maxlength="13" required/>
            </div>
        </fieldset>

        <!-- Signes vitux -->
        <fieldset class="vital-signs">
            <legend>Signes vitux (Première visite)</legend>
            <div class="form-group">
                <label for="tension">Tension artérielle:</label>
                <input type="number" id="tension" name="tension" step="0.1"
                       placeholder="Ex: 12.5" min="0" max="30"/>
            </div>

            <div class="form-group">
                <label for="frequenceCardiaque">Fréquence cardiaque (bpm):</label>
                <input type="number" id="frequenceCardiaque" name="frequenceCardiaque"
                       placeholder="Ex: 70" min="0" max="200"/>
            </div>

            <div class="form-group">
                <label for="temperature">Température (°C):</label>
                <input type="number" id="temperature" name="temperature" step="0.1"
                       placeholder="Ex: 36.8" min="30" max="45"/>
            </div>

            <div class="form-group">
                <label for="frequenceRespiratoire">Fréquence respiratoire (par min):</label>
                <input type="number" id="frequenceRespiratoire" name="frequenceRespiratoire"
                       placeholder="Ex: 16" min="0" max="50"/>
            </div>

            <div class="form-group">
                <label for="heureArrivee">Heure d'arrivée:</label>
                <input type="datetime-local" id="heureArrivee" name="heureArrivee" required/>
            </div>

            <div class="form-group">
                <label for="statut">Statut:</label>
                <select id="statut" name="statut" required>
                    <option value="">Sélectionner un statut</option>
                    <option value="EN_ATTENTE">En attente</option>
                    <option value="EN_COURS">En cours</option>
                    <option value="TERMINE">Terminé</option>
                    <option value="URGENT">Urgent</option>
                </select>
            </div>
        </fieldset>

        <div class="form-group">
            <button type="submit">Enregistrer le patient</button>
            <button type="reset">Réinitialiser</button>
        </div>
    </form>

    <div style="margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/app/patient">← Retour à la liste des patients</a>
    </div>
</body>
</html>

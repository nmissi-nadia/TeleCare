<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Formulaire Patient - TeleCare</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        :root {
            --primary-blue: #4CAF50;
            --primary-green: #4CAF50;
            --primary-purple: #15e40e;
            --accent-orange: #FF9800;
            --neutral-gray: #757575;
            --light-gray: #F5F5F5;
            --white: #FFFFFF;
            --dark-gray: #424242;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: linear-gradient(135deg, var(--light-gray) 0%, #E8F5E8 100%); color: var(--dark-gray); min-height: 100vh; }

        .container { max-width: 800px; margin: 0 auto; padding: 40px 20px; }

        .page-header { background: linear-gradient(135deg, var(--primary-blue) 0%, var(--primary-purple) 100%); color: var(--white); padding: 30px; border-radius: 16px; text-align: center; margin-bottom: 40px; }
        .page-header h1 { font-size: 32px; font-weight: 700; margin-bottom: 8px; }
        .page-header .subtitle { font-size: 16px; opacity: 0.9; font-weight: 300; }

        .medical-form { background: var(--white); border-radius: 16px; padding: 40px; box-shadow: 0 8px 25px rgba(0,0,0,0.1); }

        .form-section { margin-bottom: 35px; padding: 25px; background: linear-gradient(135deg, #FAFBFF 0%, #F8F9FF 100%); border-radius: 12px; border-left: 4px solid var(--primary-blue); }
        .form-section h3 { color: var(--primary-blue); font-size: 20px; font-weight: 600; margin-bottom: 20px; }

        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: var(--dark-gray); font-size: 14px; text-transform: uppercase; letter-spacing: 0.5px; }

        .form-control { width: 100%; padding: 15px; border: 2px solid #E0E0E0; border-radius: 10px; font-size: 16px; transition: all 0.3s ease; background: var(--white); }
        .form-control:focus { outline: none; border-color: var(--primary-blue); box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1); background: #FAFBFF; }
        .form-control:hover { border-color: var(--primary-blue); }

        .medical-input { background: linear-gradient(135deg, #FFF8E1 0%, #FFF3E0 100%); border-color: var(--accent-orange); }
        .medical-input:focus { background: linear-gradient(135deg, #FFF5E6 0%, #FFE0B2 100%); }

        .form-select { background-position: right 12px center; background-repeat: no-repeat; background-size: 16px; padding-right: 40px; appearance: none; }

        .form-actions { background: linear-gradient(135deg, var(--light-gray) 0%, #F0F0F0 100%); padding: 30px; border-radius: 12px; text-align: center; margin-top: 30px; }

        .btn { padding: 15px 35px; border: none; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.3s ease; text-transform: uppercase; letter-spacing: 0.5px; margin: 0 10px; min-width: 150px; }
        .btn-primary { background: linear-gradient(135deg, var(--primary-green) 0%, #2E7D32 100%); color: var(--white); }
        .btn-primary:hover { transform: translateY(-2px); }
        .btn-secondary { background: linear-gradient(135deg, var(--neutral-gray) 0%, var(--dark-gray) 100%); color: var(--white); }
        .btn-secondary:hover { transform: translateY(-2px); }

        .form-navigation { background: linear-gradient(135deg, #E3F2FD 0%, #BBDEFB 100%); padding: 20px; border-radius: 12px; text-align: center; margin-top: 30px; }
        .form-navigation a { color: var(--primary-blue); text-decoration: none; font-weight: 600; font-size: 16px; display: inline-flex; align-items: center; gap: 8px; transition: all 0.3s ease; padding: 12px 20px; border-radius: 8px; }
        .form-navigation a:hover { background: var(--primary-blue); color: var(--white); transform: translateY(-1px); }

        @media (max-width: 768px) {
            .container { padding: 20px 15px; }
            .page-header { padding: 25px 20px; }
            .page-header h1 { font-size: 28px; }
            .medical-form { padding: 25px 20px; }
            .form-grid { grid-template-columns: 1fr; gap: 20px; }
            .form-section { padding: 20px; }
            .btn { width: 100%; margin: 10px 0; }
            .form-actions { padding: 25px 20px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <header class="page-header ">
            <h1>Formulaire Patient</h1>
            <p class="subtitle">Enregistrement d'un nouveau patient dans le systeme TeleCare</p>
        </header>

        <form class="medical-form" action="${pageContext.request.contextPath}/app/patient" method="post" novalidate>
            <input type="hidden" name="csrf" value="${sessionScope.csrfToken}" />
            <input type="hidden" name="redirectUrl" id="redirectUrl" value="" />
            <fieldset class="form-section">
                <h3>Informations Personnelles</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="nom">Nom</label>
                        <input type="text" id="nom" name="nom" class="form-control" placeholder="Nom du patient" required />
                    </div>

                    <div class="form-group">
                        <label for="prenom">Prenom</label>
                        <input type="text" id="prenom" name="prenom" class="form-control" placeholder="Prenom du patient" required />
                    </div>

                    <div class="form-group">
                        <label for="numSecuriteSociale">Numero de Securite Sociale</label>
                        <input type="text" id="numSecuriteSociale" name="numSecuriteSociale" class="form-control" placeholder="15 chiffres" pattern="\d{15}" maxlength="15" />
                    </div>

                    <div class="form-group">
                        <label for="dateNaissance">Date de Naissance</label>
                        <input type="date" id="dateNaissance" name="dateNaissance" class="form-control" required />
                    </div>

                    <div class="form-group">
                        <label for="adresse">Adresse</label>
                        <input type="text" id="adresse" name="adresse" class="form-control" placeholder="Adresse complete" />
                    </div>

                    <div class="form-group">
                        <label for="telephone">Telephone</label>
                        <input type="tel" id="telephone" name="telephone" class="form-control" placeholder="Ex: 01.23.45.67.89" />
                    </div>
                </div>
            </fieldset>

            <fieldset class="form-section">
                <h3>Signes Vitaux Medicaux</h3>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="tension">Tension (cmHg)</label>
                        <input type="number" id="tension" name="tension" class="form-control medical-input" step="0.1" placeholder="Ex: 12.5" min="0" max="30" required />
                    </div>

                    <div class="form-group">
                        <label for="frequenceCardiaque">Frequence cardiaque (bpm)</label>
                        <input type="number" id="frequenceCardiaque" name="frequenceCardiaque" class="form-control medical-input" placeholder="Ex: 70" min="0" max="200" required />
                    </div>

                    <div class="form-group">
                        <label for="temperature">Temperature (degC)</label>
                        <input type="number" id="temperature" name="temperature" class="form-control medical-input" step="0.1" placeholder="Ex: 36.8" min="30" max="45" required />
                    </div>

                    <div class="form-group">
                        <label for="frequenceRespiratoire">Frequence respiratoire (/min)</label>
                        <input type="number" id="frequenceRespiratoire" name="frequenceRespiratoire" class="form-control medical-input" placeholder="Ex: 16" min="0" max="50" required />
                    </div>

                    <div class="form-group">
                        <label for="heureArrivee">Heure d'Arrivee</label>
                        <input type="datetime-local" id="heureArrivee" name="heureArrivee" class="form-control" required />
                    </div>

                    <div class="form-group">
                        <label for="statut">Statut du Patient</label>
                        <select id="statut" name="statut" class="form-control form-select" required>
                            <option value="">Selectionner un statut</option>
                            <option value="EN_ATTENTE">En Attente</option>
                            <option value="URGENT">Urgent</option>
                        </select>
                    </div>
                </div>
            </fieldset>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Enregistrer le Patient</button>
                <button type="reset" class="btn btn-secondary">Reinitialiser</button>
            </div>
        </form>

        <div class="form-navigation">
            <a href="${pageContext.request.contextPath}/app/patient">Retour a la liste des patients</a>
        </div>
    </div>

    <script>
        document.querySelectorAll('.form-control').forEach(input => {
            input.addEventListener('blur', function() {
                if (this.checkValidity()) {
                    this.style.borderColor = 'var(--primary-green)';
                } else if (this.value !== '') {
                    this.style.borderColor = '#F44336';
                }
            });

            input.addEventListener('focus', function() {
                this.style.borderColor = 'var(--primary-blue)';
            });
        });
        document.addEventListener('DOMContentLoaded', function() {
            const redirectUrlField = document.getElementById('redirectUrl');
            const previousUrl = document.referrer || '${pageContext.request.contextPath}/app/patient';
            
            if (redirectUrlField && previousUrl) {
                redirectUrlField.value = previousUrl;
            }
        });
    </script>
</body>
</html>
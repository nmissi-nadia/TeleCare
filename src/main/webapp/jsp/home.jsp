<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TeleCare - Plateforme de Télé-Expertise Médicale</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: #1a1a1a;
            background-color: #ffffff;
        }

        /* Header Styles */
        .header {
            background-color: #ffffff;
            border-bottom: 1px solid #e5e5e5;
            padding: 1rem 2rem;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 1.75rem;
            font-weight: 700;
            color: #059669;
            text-decoration: none;
        }

        .nav {
            display: flex;
            gap: 2rem;
            align-items: center;
        }

        .nav a {
            color: #4b5563;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }

        .nav a:hover {
            color: #059669;
        }

        .btn {
            padding: 0.625rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            display: inline-block;
        }

        .btn-primary {
            background-color: #059669;
            color: #ffffff;
        }

        .btn-primary:hover {
            background-color: #047857;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(5, 150, 105, 0.3);
        }

        .btn-secondary {
            background-color: transparent;
            color: #059669;
            border: 2px solid #059669;
        }

        .btn-secondary:hover {
            background-color: #059669;
            color: #ffffff;
        }

        /* Hero Section */
        .hero {
            background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
            padding: 6rem 2rem;
            text-align: center;
        }

        .hero-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .hero h1 {
            font-size: 3.5rem;
            font-weight: 800;
            color: #1a1a1a;
            margin-bottom: 1.5rem;
            line-height: 1.2;
        }

        .hero-highlight {
            color: #059669;
        }

        .hero p {
            font-size: 1.25rem;
            color: #4b5563;
            margin-bottom: 2.5rem;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }

        .hero-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .hero-image {
            margin-top: 4rem;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
        }

        .hero-image img {
            width: 100%;
            height: auto;
            display: block;
        }

        /* Stats Section */
        .stats {
            background-color: #059669;
            color: #ffffff;
            padding: 4rem 2rem;
        }

        .stats-container {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 3rem;
            text-align: center;
        }

        .stat-item h3 {
            font-size: 3rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
        }

        .stat-item p {
            font-size: 1.125rem;
            opacity: 0.9;
        }

        /* Features Section */
        .features {
            padding: 6rem 2rem;
            background-color: #ffffff;
        }

        .features-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .section-header {
            text-align: center;
            margin-bottom: 4rem;
        }

        .section-header h2 {
            font-size: 2.5rem;
            font-weight: 800;
            color: #1a1a1a;
            margin-bottom: 1rem;
        }

        .section-header p {
            font-size: 1.125rem;
            color: #6b7280;
            max-width: 600px;
            margin: 0 auto;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .feature-card {
            background-color: #f9fafb;
            border: 1px solid #e5e7eb;
            border-radius: 1rem;
            padding: 2rem;
            transition: all 0.3s;
        }

        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
            border-color: #059669;
        }

        .feature-icon {
            width: 3rem;
            height: 3rem;
            background-color: #d1fae5;
            border-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
        }

        .feature-card h3 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 1rem;
        }

        .feature-card p {
            color: #6b7280;
            line-height: 1.7;
        }

        /* CTA Section */
        .cta {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            color: #ffffff;
            padding: 5rem 2rem;
            text-align: center;
        }

        .cta-container {
            max-width: 800px;
            margin: 0 auto;
        }

        .cta h2 {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 1.5rem;
        }

        .cta p {
            font-size: 1.25rem;
            margin-bottom: 2.5rem;
            opacity: 0.95;
        }

        .btn-white {
            background-color: #ffffff;
            color: #059669;
        }

        .btn-white:hover {
            background-color: #f0fdf4;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
        }

        /* Footer */
        .footer {
            background-color: #1f2937;
            color: #d1d5db;
            padding: 3rem 2rem 1.5rem;
        }

        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .footer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 3rem;
            margin-bottom: 3rem;
        }

        .footer-section h4 {
            color: #ffffff;
            font-size: 1.125rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 0.75rem;
        }

        .footer-section a {
            color: #d1d5db;
            text-decoration: none;
            transition: color 0.3s;
        }

        .footer-section a:hover {
            color: #10b981;
        }

        .footer-bottom {
            border-top: 1px solid #374151;
            padding-top: 1.5rem;
            text-align: center;
            color: #9ca3af;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 2.5rem;
            }

            .hero p {
                font-size: 1.125rem;
            }

            .nav {
                display: none;
            }

            .stat-item h3 {
                font-size: 2.5rem;
            }

            .section-header h2 {
                font-size: 2rem;
            }

            .cta h2 {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<header class="header">
    <div class="header-container">
        <a href="/" class="logo">TeleCare</a>
        <nav class="nav">
            <a href="#features">Fonctionnalités</a>
            <a href="#about">À propos</a>
            <a href="/consultation_form">Consultation</a>
            <a href="/patient_list">Patients</a>
            <a href="#contact">Contact</a>
            <% if (session.getAttribute("user") != null) { 
                String role = (String) session.getAttribute("role");
                String dashboardUrl = "/medecin_dashboard"; // Default for medecin
                if ("infirmier".equals(role)) {
                    dashboardUrl = "/infirmier_dashboard";
                }
            %>
                <a href="<%= dashboardUrl %>" class="btn btn-primary">Dashboard</a>
            <% } else { %>
                <a href="/login" class="btn btn-primary">Connexion</a>
                <a href="/register" class="btn btn-secondary">Inscription</a>
            <% } %>
        </nav>
    </div>
</header>

<!-- Hero Section -->
<section class="hero">
    <div class="hero-container">
        <h1>
            Plateforme de <span class="hero-highlight">Télé-Expertise</span><br>
            Médicale Avancée
        </h1>
        <p>
            Connectez médecins et infirmiers pour une gestion hospitalière optimale
            et un suivi patient de qualité supérieure
        </p>
        <div class="hero-buttons">
            <a href="/register" class="btn btn-primary">Commencer Gratuitement</a>
            <a href="#features" class="btn btn-secondary">Découvrir Plus</a>
        </div>
        <div class="hero-image">
            <img src="/placeholder.svg?height=500&width=1000" alt="TeleCare Dashboard">
        </div>
    </div>
</section>

<!-- Stats Section -->
<section class="stats">
    <div class="stats-container">
        <div class="stat-item">
            <h3>5,000+</h3>
            <p>Professionnels de santé</p>
        </div>
        <div class="stat-item">
            <h3>50,000+</h3>
            <p>Patients suivis</p>
        </div>
        <div class="stat-item">
            <h3>99.9%</h3>
            <p>Disponibilité</p>
        </div>
        <div class="stat-item">
            <h3>24/7</h3>
            <p>Support technique</p>
        </div>
    </div>
</section>

<!-- Features Section -->
<section id="features" class="features">
    <div class="features-container">
        <div class="section-header">
            <h2>Fonctionnalités Principales</h2>
            <p>Des outils puissants pour une collaboration médicale efficace</p>
        </div>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">📋</div>
                <h3>Suivi Médical Complet</h3>
                <p>
                    Gérez les dossiers patients, consultations et prescriptions
                    en temps réel avec une interface intuitive et sécurisée.
                </p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">📊</div>
                <h3>Statistiques en Temps Réel</h3>
                <p>
                    Visualisez les indicateurs clés de performance et suivez
                    l'activité de votre établissement avec des tableaux de bord dynamiques.
                </p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🔒</div>
                <h3>Stockage Sécurisé</h3>
                <p>
                    Vos données médicales sont protégées par un chiffrement de niveau
                    bancaire et conformes aux normes RGPD et HDS.
                </p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">💬</div>
                <h3>Communication Instantanée</h3>
                <p>
                    Échangez avec vos collègues via messagerie sécurisée,
                    visioconférence et partage de documents médicaux.
                </p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">📱</div>
                <h3>Accès Mobile</h3>
                <p>
                    Consultez et mettez à jour les dossiers patients depuis
                    n'importe quel appareil, où que vous soyez.
                </p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🤖</div>
                <h3>Intelligence Artificielle</h3>
                <p>
                    Bénéficiez d'aide au diagnostic et de suggestions thérapeutiques
                    basées sur l'IA pour améliorer la prise en charge.
                </p>
            </div>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta">
    <div class="cta-container">
        <h2>Prêt à Transformer Votre Pratique Médicale ?</h2>
        <p>
            Rejoignez des milliers de professionnels de santé qui font confiance
            à TeleCare pour améliorer la qualité des soins.
        </p>
        <a href="/register" class="btn btn-white">Créer un Compte Gratuit</a>
    </div>
</section>

<!-- Footer -->
<footer class="footer">
    <div class="footer-container">
        <div class="footer-grid">
            <div class="footer-section">
                <h4>TeleCare</h4>
                <p>
                    La plateforme de télé-expertise médicale qui connecte
                    les professionnels de santé pour de meilleurs soins.
                </p>
            </div>
            <div class="footer-section">
                <h4>Produit</h4>
                <ul>
                    <li><a href="#features">Fonctionnalités</a></li>
                    <li><a href="#pricing">Tarifs</a></li>
                    <li><a href="#security">Sécurité</a></li>
                    <li><a href="#integrations">Intégrations</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>Entreprise</h4>
                <ul>
                    <li><a href="#about">À propos</a></li>
                    <li><a href="#careers">Carrières</a></li>
                    <li><a href="#press">Presse</a></li>
                    <li><a href="#contact">Contact</a></li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>Légal</h4>
                <ul>
                    <li><a href="#privacy">Confidentialité</a></li>
                    <li><a href="#terms">Conditions d'utilisation</a></li>
                    <li><a href="#gdpr">RGPD</a></li>
                    <li><a href="#cookies">Cookies</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2025 TeleCare. Tous droits réservés.</p>
        </div>
    </div>
</footer>
</body>
</html>
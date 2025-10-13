<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- SIDEBAR COMMUNE TELECARE -->
<aside class="sidebar">
    <div class="sidebar-header">
        <h1>🏥 TeleCare</h1>
        <div class="subtitle">Système de Gestion Médicale</div>
    </div>
    <nav class="sidebar-nav">
        <ul>
            <!-- Navigation commune -->
            <li><a href="${pageContext.request.contextPath}/jsp/home.jsp">
                <span class="icon">🏠</span> Accueil</a></li>

            <!-- Module Infirmier -->
            <c:if test="${sessionScope.currentUser.role == 'INFIRMIER'}">
                <li><a href="${pageContext.request.contextPath}/app/infirmier/dashboard" class="${pageContext.request.servletPath == '/app/infirmier/dashboard' ? 'active' : ''}">
                    <span class="icon">📊</span> Dashboard Infirmier</a></li>
                <li><a href="${pageContext.request.contextPath}/app/patient" class="${pageContext.request.servletPath == '/app/patient' ? 'active' : ''}">
                    <span class="icon">📋</span> Patients du Jour</a></li>
                <li><a href="${pageContext.request.contextPath}/jsp/patient_form.jsp" class="${pageContext.request.servletPath == '/jsp/patient_form.jsp' ? 'active' : ''}">
                    <span class="icon">➕</span> Enregistrer Patient</a></li>
                <li><a href="${pageContext.request.contextPath}/app/patient/stats" class="">
                    <span class="icon">📈</span > Statistiques Patients</a></li>
            </c:if>

            <!-- Module Médecin Généraliste -->
            <c:if test="${sessionScope.currentUser.role == 'MEDECIN_GENERALISTE'}">
                <li><a href="${pageContext.request.contextPath}/app/medecin/dashboard" class="${pageContext.request.servletPath == '/app/medecin/dashboard' ? 'active' : ''}">
                    <span class="icon">👨‍⚕️</span> Dashboard Médecin</a></li>
                <li><a href="${pageContext.request.contextPath}/app/patient/attente" class="">
                    <span class="icon">⏳</span> Patients en Attente</a></li>
                <li><a href="${pageContext.request.contextPath}/app/consultation/nouvelle" class="">
                    <span class="icon">📝</span> Nouvelle Consultation</a></li>
                <li><a href="${pageContext.request.contextPath}/app/actes" class="">
                    <span class="icon">🔧</span> Gestion des Actes</a></li>
                <li><a href="${pageContext.request.contextPath}/app/consultations/historique" class="">
                    <span class="icon">📚</span> Historique Consultations</a></li>
            </c:if>

            <!-- Module Médecin Spécialiste (si ajouté plus tard) -->
            <c:if test="${sessionScope.currentUser.role == 'MEDECIN_SPECIALISTE'}">
                <li><a href="${pageContext.request.contextPath}/app/medecin/specialiste/dashboard">
                    <span class="icon">🔬</span> Dashboard Spécialiste</a></li>
                <li><a href="${pageContext.request.contextPath}/app/expertises">
                    <span class="icon">📋</span> Demandes d'Expertise</a></li>
            </c:if>

            <!-- Navigation commune -->
            <li><a href="${pageContext.request.contextPath}/app/profil">
                <span class="icon">👤</span> Mon Profil</a></li>
            <li><a href="${pageContext.request.contextPath}/logout">
                <span class="icon">🚪</span> Déconnexion</a></li>
        </ul>
    </nav>
</aside>

<!-- JavaScript pour la sidebar -->
<script>
    // Fonctionnalité de la sidebar commune
    function toggleSidebar() {
        const sidebar = document.querySelector('.sidebar');
        const mainContent = document.querySelector('.main-content');

        if (window.innerWidth <= 768) {
            if (sidebar.style.transform === 'translateX(0px)') {
                sidebar.style.transform = 'translateX(-100%)';
                mainContent.style.marginLeft = '0';
            } else {
                sidebar.style.transform = 'translateX(0px)';
                mainContent.style.marginLeft = '280px';
            }
        }
    }

    // Fermer la sidebar sur mobile quand on clique en dehors
    document.addEventListener('click', function(event) {
        const sidebar = document.querySelector('.sidebar');
        const toggle = document.querySelector('.sidebar-toggle');

        if (window.innerWidth <= 768 &&
            !sidebar.contains(event.target) &&
            !toggle.contains(event.target) &&
            sidebar.style.transform === 'translateX(0px)') {
            sidebar.style.transform = 'translateX(-100%)';
            document.querySelector('.main-content').style.marginLeft = '0';
        }
    });
</script>

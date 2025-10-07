<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html><body>
  <h2>Patients du jour</h2>
  <a href="${pageContext.request.contextPath}/jsp/patient_form.jsp">Ajouter Patient</a>
  <table border="1">
    <tr><th>ID</th><th>Nom</th><th>Arrivée</th><th>Statut</th><th>Action</th></tr>
    <c:forEach var="p" items="${patients}">
      <tr>
        <td>${p.id}</td>
        <td>${p.nom} ${p.prenom}</td>
        <td>${p.heureArrivee}</td>
        <td>${p.statut}</td>
        <td><a href="${pageContext.request.contextPath}/app/consultation?patientId=${p.id}">Créer consultation</a></td>
      </tr>
    </c:forEach>
  </table>
  <a href="${pageContext.request.contextPath}/logout">Logout</a>
</body></html>

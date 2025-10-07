<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html><body>
  <h2>Créer Consultation</h2>
  <c:if test="${not empty patient}">
    <p>Patient: ${patient.nom} ${patient.prenom}</p>
    <form action="${pageContext.request.contextPath}/app/consultation" method="post">
      <input type="hidden" name="patientId" value="${patient.id}" />
      <input type="hidden" name="csrf" value="${sessionScope.csrfToken}" />
      <textarea name="observations" placeholder="Observations"></textarea><br/>
      <textarea name="diagnostic" placeholder="Diagnostic"></textarea><br/>
      <button>Clôturer (prise en charge)</button>
    </form>
  </c:if>
  <a href="${pageContext.request.contextPath}/app/patient">Retour</a>
</body></html>

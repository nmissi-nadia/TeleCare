<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html><body>
  <h2>Enregistrer un patient</h2>
  <form action="${pageContext.request.contextPath}/app/patient" method="post">
    <input name="nom" placeholder="Nom" required/>
    <input name="prenom" placeholder="Prénom" required/>
    <button>Enregistrer</button>
  </form>
  <a href="${pageContext.request.contextPath}/app/patient">Voir la liste des patients</a>
</body></html>

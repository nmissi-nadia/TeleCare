<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html><body>
  <h2>Connexion</h2>
  <c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
  <form action="${pageContext.request.contextPath}/login" method="post">
    <input name="login" placeholder="login" required/>
    <input name="password" type="password" placeholder="mot de passe" required/>
    <button>Se connecter</button>
  </form>
</body></html>

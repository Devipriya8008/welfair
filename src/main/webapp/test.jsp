<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head><title>Test Page</title></head>
<body>
<h1>Basic JSP/EL Test</h1>
<p>testValue: <c:out value="${testValue}"/></p>
<p>testNumber: <c:out value="${testNumber}"/></p>

<h2>Raw EL Output:</h2>
<p>${testValue}</p>
<p>${testNumber}</p>
</body>
</html>
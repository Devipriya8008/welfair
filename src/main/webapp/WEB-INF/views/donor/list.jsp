<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Donor List</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        tr:hover { background-color: #f5f5f5; }
        a.button { text-decoration: none; padding: 5px 10px; background-color: #007BFF; color: white; border-radius: 4px; }
        a.button:hover { background-color: #0056b3; }
    </style>
</head>
<body>
<h1>Donor Management</h1>

<a class="button" href="<c:url value='/donors?action=new'/>">Add New Donor</a>

<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${donors}" var="donor">
        <tr>
            <td><c:out value="${donor.donorId}"/></td>
            <td><c:out value="${donor.name}"/></td>
            <td><c:out value="${donor.email}"/></td>
            <td><c:out value="${donor.phone}"/></td>
            <td>
                <c:choose>
                    <c:when test="${not empty donor.donorId}">
                        <a class="button" href="<c:url value='/donors'><c:param name='action' value='edit'/><c:param name='id' value='${donor.donorId}'/></c:url>">Edit</a>
                        <a class="button" href="<c:url value='/donors'><c:param name='action' value='delete'/><c:param name='id' value='${donor.donorId}'/></c:url>"
                           onclick="return confirm('Are you sure you want to delete this donor?');">Delete</a>
                    </c:when>
                    <c:otherwise>
                        <span style="color:gray;">Invalid ID</span>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

</body>
</html>

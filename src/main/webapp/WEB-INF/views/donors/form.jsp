<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>${donor == null ? 'Add' : 'Edit'} Donor</title>
</head>
<body>
<h1>${donor == null ? 'Add New' : 'Edit'} Donor</h1>
<form action="${donor == null ? 'create' : 'update'}" method="post">
    <c:if test="${donor != null}">
        <input type="hidden" name="id" value="${donor.donorId}">
    </c:if>

    <label>Name:</label>
    <input type="text" name="name" value="${donor.name}" required><br>

    <label>Email:</label>
    <input type="email" name="email" value="${donor.email}"><br>

    <label>Phone:</label>
    <input type="tel" name="phone" value="${donor.phone}"><br>

    <label>Address:</label>
    <textarea name="address">${donor.address}</textarea><br>

    <input type="submit" value="Save">
    <a href="donors">Cancel</a>
</form>
</body>
</html>
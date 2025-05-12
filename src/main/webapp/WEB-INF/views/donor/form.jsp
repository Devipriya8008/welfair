<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>
        <c:choose>
            <c:when test="${empty donor.donorId || donor.donorId == 0}">Add New Donor</c:when>
            <c:otherwise>Edit Donor</c:otherwise>
        </c:choose>
    </title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f6f9;
            color: #333;
            margin: 0;
            padding: 40px;
        }

        h2 {
            color: #2c3e50;
            font-size: 28px;
            text-align: center;
            margin-bottom: 30px;
        }

        form {
            background: #fff;
            padding: 30px 40px;
            max-width: 600px;
            margin: 0 auto;
            border-radius: 10px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }

        .form-group {
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
        }

        label {
            margin-bottom: 6px;
            font-weight: 600;
            color: #34495e;
        }

        input[type="text"],
        input[type="email"],
        input[type="tel"],
        input[type="number"],
        textarea {
            padding: 10px 12px;
            border: 1px solid #dcdfe6;
            border-radius: 6px;
            font-size: 15px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="tel"]:focus,
        input[type="number"]:focus,
        textarea:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
        }

        textarea {
            resize: vertical;
            min-height: 80px;
        }

        .button-group {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
        }

        .button {
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
            transition: background-color 0.3s, transform 0.2s;
            text-decoration: none;
            text-align: center;
        }

        .button:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
        }

        .error {
            color: #e74c3c;
            text-align: center;
            margin-bottom: 20px;
            font-weight: 500;
        }
    </style>




    <!-- Add this to your head tag for the Inter font -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">


    <!-- Add this to your head tag for the Inter font -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

</head>
<body>

<h2>
    <c:choose>
        <c:when test="${empty donor.donorId || donor.donorId == 0}">Add New Donor</c:when>
        <c:otherwise>Edit Donor</c:otherwise>
    </c:choose>
</h2>

<c:if test="${not empty errorMessage}">
    <p class="error"><c:out value="${errorMessage}"/></p>
</c:if>

<form action="${pageContext.request.contextPath}/donors" method="post">
    <input type="hidden" name="action" value="${empty donor.donorId || donor.donorId == 0 ? 'save' : 'update'}"/>

    <input type="hidden" name="fromAdmin" value="true"/>
    <c:if test="${not empty donor.donorId && donor.donorId != 0}">
        <input type="hidden" name="donor_id" value="${donor.donorId}"/>
    </c:if>

    <div class="form-group">
        <label for="user_id">User ID:</label>
        <input type="number" id="user_id" name="user_id"
               value="<c:out value='${donor.userId}'/>" required
               <c:if test="${not empty donor.userId && donor.userId != 0}">readonly</c:if>/>
    </div>

    <div class="form-group">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="<c:out value='${donor.name}'/>" required/>
    </div>

    <div class="form-group">
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<c:out value='${donor.email}'/>" required/>
    </div>

    <div class="form-group">
        <label for="phone">Phone:</label>
        <input type="tel" id="phone" name="phone" value="<c:out value='${donor.phone}'/>"/>
    </div>

    <div class="form-group">
        <label for="address">Address:</label>
        <textarea id="address" name="address"><c:out value='${donor.address}'/></textarea>
    </div>

    <div class="button-group">
        <button type="submit" class="button">Save</button>
        <a href="${pageContext.request.contextPath}/donors" class="button">Cancel</a>
    </div>
</form>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>${formTitle}</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f9;
            color: #333;
            padding: 40px;
        }

        h1 {
            color: #2c3e50;
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
            font-weight: 600;
            margin-bottom: 6px;
            color: #34495e;
        }

        input[type="text"],
        input[type="number"] {
            padding: 10px;
            border: 1px solid #dcdfe6;
            border-radius: 6px;
            font-size: 15px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        input:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
        }

        .button-group {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
        }

        .btn:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
        }

        .cancel-button {
            background-color: #95a5a6;
        }

        .cancel-button:hover {
            background-color: #7f8c8d;
        }

        .error {
            color: #e74c3c;
            text-align: center;
            margin-top: 20px;
            font-weight: 500;
        }
    </style>
</head>
<body>

<h1>${formTitle}</h1>
<h2><%= edit ? "Edit" : "Add New" %> Beneficiary</h2>

<c:if test="${not empty errorMessage}">
    <p class="error">${errorMessage}</p>
</c:if>

<form action="${pageContext.request.contextPath}/inventory" method="post">
    <c:if test="${not empty item.itemId}">
        <input type="hidden" name="item_id" value="${item.itemId}">
    </c:if>

    <div class="form-group">
        <label for="name">Item Name:</label>
        <input type="text" id="name" name="name" value="${item.name}" required>
    </div>

    <div class="form-group">
        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" name="quantity" value="${item.quantity}" required>
    </div>

    <div class="form-group">
        <label for="unit">Unit:</label>
        <input type="text" id="unit" name="unit" value="${item.unit}" required>
    </div>

    <div class="button-group">
        <button type="submit" class="btn">${empty item.itemId ? 'Add' : 'Update'}</button>
        <a href="${pageContext.request.contextPath}/admin-table?table=inventory" class="btn cancel-button">Cancel</a>
    </div>
</form>

</body>
</html>

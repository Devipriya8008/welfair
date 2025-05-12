<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Inventory Form</title>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <html>
    <head>
        <title>Inventory Form</title>
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background: #f4f6f9;
                color: #333;
                padding: 40px;
            }

            h2 {
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
            }

            input[type="text"],
            input[type="number"] {
                padding: 10px;
                border: 1px solid #dcdfe6;
                border-radius: 6px;
                font-size: 15px;
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
            }

            .btn:hover {
                background-color: #2980b9;
            }

            .btn-secondary {
                background-color: #95a5a6;
            }

            .btn-secondary:hover {
                background-color: #7f8c8d;
            }

            .button-group {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
    <h2>${item != null ? "Edit" : "Add"} Inventory Item</h2>

    <form action="inventory" method="post">
        <c:if test="${item != null}">
            <input type="hidden" name="item_id" value="${item.itemId}"/>
        </c:if>

        <div class="form-group">
            <label>Name:</label>
            <input type="text" name="name" value="${item != null ? item.name : ''}" required/>
        </div>

        <div class="form-group">
            <label>Quantity:</label>
            <input type="number" name="quantity" value="${item != null ? item.quantity : ''}" required/>
        </div>

        <div class="form-group">
            <label>Unit:</label>
            <input type="text" name="unit" value="${item != null ? item.unit : ''}" required/>
        </div>

        <div class="button-group">
            <input type="submit" class="btn" value="Save"/>
            <a href="inventory" class="btn btn-secondary">Back to list</a>
        </div>
    </form>
    </body>
    </html>

</head>
<body>
<h2>${item != null ? "Edit" : "Add"} Inventory Item</h2>
<form action="inventory" method="post">
    <c:if test="${item != null}">
        <input type="hidden" name="item_id" value="${item.itemId}"/>
    </c:if>
    <label>Name:</label>
    <input type="text" name="name" value="${item != null ? item.name : ''}" required/><br>
    <label>Quantity:</label>
    <input type="number" name="quantity" value="${item != null ? item.quantity : ''}" required/><br>
    <label>Unit:</label>
    <input type="text" name="unit" value="${item != null ? item.unit : ''}" required/><br>
    <input type="submit" value="Save"/>
</form>
<a href="inventory">Back to list</a>
</body>
</html>

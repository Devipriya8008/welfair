<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>
        <c:choose>
            <c:when test="${empty project.projectId || project.projectId == 0}">Add New Project</c:when>
            <c:otherwise>Edit Project</c:otherwise>
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
        input[type="date"],
        textarea {
            padding: 10px 12px;
            border: 1px solid #dcdfe6;
            border-radius: 6px;
            font-size: 15px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        input:focus,
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

<h2>
    <c:choose>
        <c:when test="${empty project.projectId || project.projectId == 0}">Add New Project</c:when>
        <c:otherwise>Edit Project</c:otherwise>
    </c:choose>
</h2>

<c:if test="${not empty errorMessage}">
    <p class="error"><c:out value="${errorMessage}"/></p>
</c:if>

<form action="${pageContext.request.contextPath}/projects" method="post">
    <input type="hidden" name="action" value="${empty project.projectId || project.projectId == 0 ? 'create' : 'update'}"/>

    <c:if test="${not empty project.projectId && project.projectId != 0}">
        <input type="hidden" name="project_id" value="${project.projectId}"/>
    </c:if>

    <div class="form-group">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="<c:out value='${project.name}'/>" required/>
    </div>

    <div class="form-group">
        <label for="description">Description:</label>
        <textarea id="description" name="description" required><c:out value='${project.description}'/></textarea>
    </div>

    <div class="form-group">
        <label for="start_date">Start Date:</label>
        <input type="date" id="start_date" name="start_date" value="<c:out value='${project.startDate}'/>" required/>
    </div>

    <div class="form-group">
        <label for="end_date">End Date:</label>
        <input type="date" id="end_date" name="end_date" value="<c:out value='${project.endDate}'/>" required/>
    </div>

    <div class="form-group">
        <label for="status">Status:</label>
        <input type="text" id="status" name="status" value="<c:out value='${project.status}'/>" required/>
    </div>

    <div class="button-group">
        <button type="submit" class="button">Save</button>
        <a href="${pageContext.request.contextPath}/projects" class="button cancel-button">Cancel</a>
    </div>
</form>

</body>
</html>

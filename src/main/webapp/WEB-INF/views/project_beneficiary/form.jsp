<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.welfair.model.ProjectBeneficiary" %>

<%
    ProjectBeneficiary assignment = (ProjectBeneficiary) request.getAttribute("assignment");
%>

<html>
<head>
    <title><%= (assignment.getProjectId() == 0) ? "New Assignment" : "Edit Assignment" %></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }
        form {
            width: 400px;
        }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input[type="number"],
        input[type="date"] {
            width: 100%;
            padding: 6px;
            margin-top: 5px;
        }
        input[type="submit"] {
            margin-top: 15px;
            padding: 8px 16px;
        }
        a {
            display: inline-block;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<h1><%= (assignment.getProjectId() == 0) ? "New Assignment" : "Edit Assignment" %></h1>

<form method="post" action="${pageContext.request.contextPath}/project_beneficiaries">
    <label for="projectId">Project ID:</label>
    <input type="number" name="projectId" id="projectId"
           value="<%= assignment.getProjectId() %>" required>

    <label for="beneficiaryId">Beneficiary ID:</label>
    <input type="number" name="beneficiaryId" id="beneficiaryId"
           value="<%= assignment.getBeneficiaryId() %>" required>

    <label for="dateAssigned">Date Assigned:</label>
    <input type="date" name="dateAssigned" id="dateAssigned"
           value="<%= (assignment.getDateAssigned() != null ? assignment.getDateAssigned().toString() : "") %>" required>

    <input type="submit" value="Save Assignment">
</form>

<a href="${pageContext.request.contextPath}/project_beneficiaries">Cancel</a>
</body>
</html>

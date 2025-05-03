<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Project Beneficiary Form</title>
</head>
<body>
<h2>Project Beneficiary Form</h2>
<form action="<%= request.getContextPath() %>/project-beneficiary/insert" method="post">
    <input type="hidden" name="projectId" value="${projectBeneficiary.projectId}"/>
    <input type="hidden" name="beneficiaryId" value="${projectBeneficiary.beneficiaryId}"/>
    <label for="projectId">Project ID:</label>
    <input type="text" id="projectId" name="projectId" value="${projectBeneficiary.projectId}" required/><br><br>
    <label for="beneficiaryId">Beneficiary ID:</label>
    <input type="text" id="beneficiaryId" name="beneficiaryId" value="${projectBeneficiary.beneficiaryId}" required/><br><br>
    <label for="dateAssigned">Date Assigned:</label>
    <input type="date" id="dateAssigned" name="dateAssigned" value="${projectBeneficiary.dateAssigned}" required/><br><br>
    <input type="submit" value="Save"/>
</form>
</body>
</html>

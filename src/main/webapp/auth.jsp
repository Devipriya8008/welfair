<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Select Role</title></head>
<body>
<h2>Select Your Role</h2>
<form action="auth.jsp" method="get">
  <label>Choose Role:</label><br>
  <button type="submit" name="role" value="admin">Admin</button>
  <button type="submit" name="role" value="employee">Employee</button>
  <button type="submit" name="role" value="volunteer">Volunteer</button>
  <button type="submit" name="role" value="donor">Donor</button>
  <input type="hidden" name="action" value="login" />
</form>

<br>

<form action="auth.jsp" method="get">
  <label>New here?</label><br>
  <select name="role" required>
    <option value="">Select Role</option>
    <option value="admin">Admin</option>
    <option value="employee">Employee</option>
    <option value="volunteer">Volunteer</option>
    <option value="donor">Donor</option>
  </select>
  <input type="hidden" name="action" value="register" />
  <button type="submit">Register</button>
</form>
</body>
</html>

<!DOCTYPE html>
<html>
<head>
	<%@ include file="basiccss.jsp" %>
	<%@ include file = "header.jsp" %>
<title>Change Account Details</title>
</head>

<body>
	<div style="margin: 0 auto; text-align: center; display: inline;">
        <h3 style="margin-bottom: 30px;">Change Account Details</h3>
        <% String message = request.getParameter("message"); %>
        <% if (message != null && !message.isEmpty()) { %>
            <div style="color: black; font-weight: bold; margin-bottom: 30px; text-align: center;">
                <%= message %>
            </div>
        <% } %>

		<form name="accountDetailsForm" method="post" action="confirmaccountdetails.jsp" style="width: 300px; margin: 0 auto;">
			<div style="display: flex; flex-direction: column;">
				<div style="display: flex; flex-direction: row; align-items: center;">
					<label for="currentPassword" style="width: 150px;">Current Password:</label>
					<input type="password" id="currentPassword" name="currentPassword" required>
				</div><br>
				
				<div style="display: flex; flex-direction: row; align-items: center;">
					<label for="newPassword" style="width: 150px;">New Password:</label>
					<input type="password" id="newPassword" name="newPassword" required>
				</div><br>
				
				<div style="display: flex; flex-direction: row; align-items: center;">
					<label for="confirmNewPassword" style="width: 150px;">Confirm New Password:</label>
					<input type="password" id="confirmNewPassword" name="confirmNewPassword" required>
				</div><br>
				
				<div style="display: flex; flex-direction: row; align-items: center;">
					<label for="email" style="width: 150px;">Email:</label>
					<input type="email" id="email" name="email" required>
				</div><br>
				
				<div style="display: flex; flex-direction: row; align-items: center;">
					<label for="phone" style="width: 150px;">Phone:</label>
					<input type="tel" id="phone" name="phone">
				</div><br>
				
				<div style="display: flex; flex-direction: row; align-items: center;">
					<label for="address" style="width: 150px;">Address:</label>
					<input type="text" id="address" name="address">
				</div><br>
				
				<div style="display: flex; flex-direction: row; align-items: center;">
					<label for="city" style="width: 150px;">City:</label>
					<input type="text" id="city" name="city">
				</div><br>
				
				<div style="display: flex; flex-direction: row; align-items: center;">
					<label for="state" style="width: 150px;">State:</label>
					<input type="text" id="state" name="state">
				</div><br>
				
				<div style="display: flex; flex-direction: row; align-items: center;">
					<label for="postalCode" style="width: 150px;">Postal Code:</label>
					<input type="text" id="postalCode" name="postalCode">
				</div><br>
				
				<div style="display: flex; flex-direction: row; align-items: center;">
					<label for="country" style="width: 150px;">Country:</label>
					<input type="text" id="country" name="country">
				</div><br>
				
				<input type="submit" value="Submit">
		</form>
	</div>
</body>
</html>
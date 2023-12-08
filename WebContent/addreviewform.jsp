<!DOCTYPE html>
<html>
<head>
	<%@ include file="basiccss.jsp" %>
<%@ include file = "header.jsp" %>
<title>Add a Product</title>
</head>
<body>
<div align="center">

<h3>Make a review!</h3>
<br>
<form name="reviewForm" method=post action="addreview.jsp">
<table style="display:inline">
<tr>
    <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Name:</font></div></td>
    <td><input type="text" class = "longtext" name="revprodname"  size=10 maxlength=40></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Your Review:</font></div></td>
	<td><input type="text" name="review" class="resizedTextbox" size=100 maxlength=1000></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Your Rating out of 10:</font></div></td>
	<td><input type="number" name="rating"  min="0" max="10"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="revSubmit" value="Submit">
</form>

</div>
</body>
</html>

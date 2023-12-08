<!DOCTYPE html>
<html>
<head>
	<%@ include file="basiccss.jsp" %>
<%@ include file = "header.jsp" %>
<title>Add a Product</title>
</head>
<body>
<div style="margin:0 auto;text-align:center;display:inline">

<h3>Add a product!</h3>
<br>
<form name="productForm" method=post action="addproduct.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Name:</font></div></td>
	<td><input type="text" name="productname"  size=10 maxlength=40></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Price (for example: 20.99 ):</font></div></td>
	<td><input type="text" name="price" size=10 maxlength="12"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Image URL:</font></div></td>
	<td><input type="text" name="imageURL" size=10 maxlength="100"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Image (Binary):</font></div></td>
	<td><input type="file" name="image"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Description:</font></div></td>
	<td><input type="text" name="desc" size=10 maxlength="100"></td>
</tr>
<!-- maxlength of category Id may be wrong. -->
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Category Id:</font></div></td>
	<td><input type="text" name="catId" size=10 maxlength="1000"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="prodSubmit" value="Submit">
</form>

</div>
</body>
</html>

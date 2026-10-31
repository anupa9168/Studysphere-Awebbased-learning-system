<%@ Page Language="C#" AutoEventWireup="true"
CodeBehind="AdminLogin.aspx.cs"
Inherits="StudySphere.Admin.AdminLogin" %>

<!DOCTYPE html>

<html>
<head runat="server">

    <title>Admin Login</title>

    <link href="AdminStyle.css" rel="stylesheet" />

</head>

<body>

<form id="form1" runat="server">

<div class="login-box">

    <img src="StudySphere.png" class="logo" />

    <h2>Admin Login</h2>

    <asp:Label ID="Label1" runat="server" Text="Username"></asp:Label>

    <asp:TextBox
        ID="txtUsername"
        runat="server">
    </asp:TextBox>

    <asp:Label ID="Label2" runat="server" Text="Password"></asp:Label>

    <asp:TextBox
        ID="txtPassword"
        runat="server"
        TextMode="Password">
    </asp:TextBox>

    <asp:Button
        ID="btnLogin"
        runat="server"
        Text="Login"
        CssClass="btn"
        OnClick="btnLogin_Click" />

    <asp:Label
        ID="lblMessage"
        runat="server"
        CssClass="message">
    </asp:Label>

</div>

</form>

</body>
</html>
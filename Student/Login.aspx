<%@ Page Language="C#" AutoEventWireup="true"
    CodeFile="Login.aspx.cs"
    Inherits="Login" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Login - StudySphere</title>
    <link href="Login.css" rel="stylesheet" />
</head>

<body>

<form id="form1" runat="server">

    <div class="login-box">

        <!-- Logo -->
        <img src="StudySphere.png" class="logo" />

        <h1>Welcome Back</h1>

        <p class="subtitle">
            Login to your StudySphere account
        </p>

        <!-- Error Message -->
        <asp:Label ID="lblMessage"
            runat="server"
            CssClass="message">
        </asp:Label>

        <!-- Username -->
        <asp:TextBox ID="txtUsername"
            runat="server"
            CssClass="input"
            placeholder="Username">
        </asp:TextBox>

        <!-- Password -->
        <asp:TextBox ID="txtPassword"
            runat="server"
            CssClass="input"
            TextMode="Password"
            placeholder="Password">
        </asp:TextBox>

        <!-- Login Button -->
        <asp:Button ID="btnLogin"
            runat="server"
            Text="Login"
            CssClass="login-btn"
            OnClick="btnLogin_Click" />

        <!-- Register -->
        <p class="register">
            Don't have an account?
            <a href="Register.aspx">Register</a>
        </p>

        <!-- Admin Login -->
        <p class="admin-login">
            Are you an administrator?
            <a href="../Admin/AdminLogin.aspx">
                Login as Administrator
            </a>
        </p>

        <!-- Home -->
        <a href="Home.aspx" class="home-link">
            Back to Home
        </a>

    </div>

</form>

</body>
</html>
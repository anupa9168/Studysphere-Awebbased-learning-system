<%@ Page Language="C#" AutoEventWireup="true"
    CodeFile="Register.aspx.cs"
    Inherits="Register" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>Register - StudySphere</title>
    <link href="Register.css" rel="stylesheet" />
</head>

<body>

<form id="form1" runat="server">

    <div class="register-box">

        <img src="StudySphere.png" class="logo" />

        <h1>Create Account</h1>

        <p class="subtitle">
            Create your StudySphere account
        </p>

        <asp:Label ID="lblMessage"
            runat="server"
            CssClass="message">
        </asp:Label>

        <!-- Full Name -->
        <asp:TextBox ID="txtFullName"
            runat="server"
            CssClass="input"
            placeholder="Full Name">
        </asp:TextBox>

        <!-- Username -->
        <asp:TextBox ID="txtUsername"
            runat="server"
            CssClass="input"
            placeholder="Username">
        </asp:TextBox>

        <!-- Date of Birth -->
        <asp:TextBox ID="txtDateOfBirth"
            runat="server"
            CssClass="input"
            TextMode="Date">
        </asp:TextBox>

        <!-- Email -->
        <asp:TextBox ID="txtEmail"
            runat="server"
            CssClass="input"
            TextMode="Email"
            placeholder="Email Address">
        </asp:TextBox>

        <!-- Password -->
        <div class="password-box">

            <asp:TextBox ID="txtPassword"
                runat="server"
                CssClass="input password-input"
                TextMode="Password"
                placeholder="Password">
            </asp:TextBox>

            <button type="button"
                class="show-password"
                onclick="togglePassword('<%= txtPassword.ClientID %>', this)">
                Show
            </button>

        </div>

        <!-- Confirm Password -->
        <div class="password-box">

            <asp:TextBox ID="txtConfirmPassword"
                runat="server"
                CssClass="input password-input"
                TextMode="Password"
                placeholder="Confirm Password">
            </asp:TextBox>

            <button type="button"
                class="show-password"
                onclick="togglePassword('<%= txtConfirmPassword.ClientID %>', this)">
                Show
            </button>

        </div>

        <!-- Register -->
        <asp:Button ID="btnRegister"
            runat="server"
            Text="Create Account"
            CssClass="register-btn"
            OnClick="btnRegister_Click" />

        <p class="login-link">
            Already have an account?
            <a href="Login.aspx">Login</a>
        </p>

        <a href="Home.aspx" class="home-link">
            Back to Home
        </a>

    </div>

</form>

<script>

    function togglePassword(id, button) {

        var password = document.getElementById(id);

        if (password.type === "password") {

            password.type = "text";
            button.textContent = "Hide";

        } else {

            password.type = "password";
            button.textContent = "Show";

        }
    }

</script>

</body>
</html>
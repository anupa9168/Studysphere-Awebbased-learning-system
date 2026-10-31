<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="ManageUsers.aspx.cs"
    Inherits="StudySphere.Admin.ManageUsers" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">

    <meta charset="utf-8" />

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0" />

    <title>Manage Users - StudySphere</title>

    <!-- Admin CSS -->
    <link href="<%= ResolveUrl("~/Admin/AdminStyle.css") %>" rel="stylesheet" />

    <!-- Manage Users CSS -->
    <link href="<%= ResolveUrl("~/Admin/ManageUsers.css") %>?v=2" rel="stylesheet" />

</head>

<body>

<form id="form1" runat="server">

    <!-- ================= NAVBAR ================= -->

    <div class="admin-navbar">

        <div class="nav-left">

            <asp:Image
                ID="imgLogo"
                runat="server"
                ImageUrl="~/Admin/StudySphere.png"
                CssClass="admin-logo" />

            <span class="admin-title">
                StudySphere Admin
            </span>

        </div>

        <div class="nav-links">

            <asp:LinkButton
                ID="lnkDashboard"
                runat="server"
                CssClass="nav-link"
                OnClick="lnkDashboard_Click">
                Dashboard
            </asp:LinkButton>

            <asp:LinkButton
                ID="lnkUsers"
                runat="server"
                CssClass="nav-link active">
                Users
            </asp:LinkButton>

            <asp:LinkButton
                ID="lnkCourses"
                runat="server"
                CssClass="nav-link"
                OnClick="lnkCourses_Click">
                Courses
            </asp:LinkButton>

            <asp:LinkButton
                ID="lnkResources"
                runat="server"
                CssClass="nav-link"
                OnClick="lnkResources_Click">
                Resources
            </asp:LinkButton>

            <asp:LinkButton
                ID="lnkQuizzes"
                runat="server"
                CssClass="nav-link"
                OnClick="lnkQuizzes_Click">
                Quizzes
            </asp:LinkButton>

            <asp:Button
                ID="btnLogout"
                runat="server"
                Text="Logout"
                CssClass="logout-button"
                OnClick="btnLogout_Click" />

        </div>

    </div>


    <!-- ================= MAIN CONTENT ================= -->

    <div class="users-page">

        <div class="page-header">

            <span class="page-badge">
                ADMINISTRATION
            </span>

            <h1>User Management</h1>

            <p>
                Manage registered StudySphere users and their account information.
            </p>

        </div>


        <!-- ================= SEARCH ================= -->

        <div class="users-toolbar">

            <div class="search-box">

                <asp:TextBox
                    ID="txtSearch"
                    runat="server"
                    CssClass="search-input"
                    placeholder="Search by name, username or email">
                </asp:TextBox>

                <asp:Button
                    ID="btnSearch"
                    runat="server"
                    Text="Search"
                    CssClass="search-button"
                    OnClick="btnSearch_Click" />

            </div>

            <asp:Button
                ID="btnAddUser"
                runat="server"
                Text="+ Add User"
                CssClass="add-user-button"
                OnClick="btnAddUser_Click" />

        </div>


        <!-- ================= MESSAGE ================= -->

        <asp:Label
            ID="lblMessage"
            runat="server"
            CssClass="message-label">
        </asp:Label>


        <!-- ================= USERS TABLE ================= -->

        <div class="users-card">

            <div class="users-card-header">

                <div>

                    <h2>Registered Users</h2>

                    <p>
                        View and manage all registered users.
                    </p>

                </div>

                <div class="user-count">

                    <asp:Label
                        ID="lblUserCount"
                        runat="server"
                        Text="0 Users">
                    </asp:Label>

                </div>

            </div>


            <div class="table-container">

                <asp:GridView
                    ID="gvUsers"
                    runat="server"
                    AutoGenerateColumns="False"
                    DataKeyNames="UserID"
                    CssClass="users-table"
                    GridLines="None"
                    EmptyDataText="No users found."

                    OnRowEditing="gvUsers_RowEditing"
                    OnRowCancelingEdit="gvUsers_RowCancelingEdit"
                    OnRowUpdating="gvUsers_RowUpdating"
                    OnRowDeleting="gvUsers_RowDeleting">

                    <Columns>

                        <asp:BoundField
                            DataField="UserID"
                            HeaderText="ID"
                            ReadOnly="True" />

                        <asp:BoundField
                            DataField="FullName"
                            HeaderText="Full Name" />

                        <asp:BoundField
                            DataField="Username"
                            HeaderText="Username" />

                        <asp:BoundField
                            DataField="DateOfBirth"
                            HeaderText="Date of Birth"
                            DataFormatString="{0:yyyy-MM-dd}" />

                        <asp:BoundField
                            DataField="Email"
                            HeaderText="Email" />

                        <asp:CommandField
                            HeaderText="Actions"
                            ShowEditButton="True"
                            ShowDeleteButton="True"
                            ButtonType="Link"
                            EditText="Edit"
                            DeleteText="Delete"
                            CancelText="Cancel"
                            UpdateText="Save" />

                    </Columns>

                </asp:GridView>

            </div>

        </div>


        <!-- ================= ADD USER MODAL ================= -->

        <asp:Panel
            ID="pnlAddUser"
            runat="server"
            CssClass="modal-overlay"
            Visible="False">

            <div class="modal-box">

                <div class="modal-header">

                    <div>

                        <h2>Add New User</h2>

                        <p>
                            Create a new StudySphere user account.
                        </p>

                    </div>

                    <asp:Button
                        ID="btnClose"
                        runat="server"
                        Text="×"
                        CssClass="close-button"
                        OnClick="btnClose_Click" />

                </div>


                <!-- Form -->

                <div class="form-grid">

                    <div class="form-group">

                        <asp:Label
                            ID="lblFullName"
                            runat="server"
                            Text="Full Name">
                        </asp:Label>

                        <asp:TextBox
                            ID="txtFullName"
                            runat="server"
                            CssClass="form-input">
                        </asp:TextBox>

                    </div>


                    <div class="form-group">

                        <asp:Label
                            ID="lblUsername"
                            runat="server"
                            Text="Username">
                        </asp:Label>

                        <asp:TextBox
                            ID="txtUsername"
                            runat="server"
                            CssClass="form-input">
                        </asp:TextBox>

                    </div>


                    <div class="form-group">

                        <asp:Label
                            ID="lblDateOfBirth"
                            runat="server"
                            Text="Date of Birth">
                        </asp:Label>

                        <asp:TextBox
                            ID="txtDateOfBirth"
                            runat="server"
                            TextMode="Date"
                            CssClass="form-input">
                        </asp:TextBox>

                    </div>


                    <div class="form-group">

                        <asp:Label
                            ID="lblEmail"
                            runat="server"
                            Text="Email">
                        </asp:Label>

                        <asp:TextBox
                            ID="txtEmail"
                            runat="server"
                            TextMode="Email"
                            CssClass="form-input">
                        </asp:TextBox>

                    </div>


                    <div class="form-group full-width">

                        <asp:Label
                            ID="lblPassword"
                            runat="server"
                            Text="Password">
                        </asp:Label>

                        <asp:TextBox
                            ID="txtPassword"
                            runat="server"
                            TextMode="Password"
                            ValidateRequestMode="Disabled"
                            MaxLength="128"
                            CssClass="form-input">
                        </asp:TextBox>

                    </div>

                </div>


                <!-- Buttons -->

                <div class="modal-actions">

                    <asp:Button
                        ID="btnCancel"
                        runat="server"
                        Text="Cancel"
                        CssClass="cancel-button"
                        OnClick="btnCancel_Click" />

                    <asp:Button
                        ID="btnSaveUser"
                        runat="server"
                        Text="Save User"
                        CssClass="save-button"
                        OnClick="btnSaveUser_Click" />

                </div>

            </div>

        </asp:Panel>

    </div>


    <!-- ================= FOOTER ================= -->

    <div class="admin-footer">

        <p>
            © 2026 StudySphere. Admin Management Panel.
        </p>

    </div>

</form>

</body>

</html>

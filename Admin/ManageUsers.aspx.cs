using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using StudySphere.Security;

namespace StudySphere.Admin
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings["StudySphereDB"].ConnectionString;


        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminID"] == null) { Response.Redirect("~/Admin/AdminLogin.aspx"); return; }
            if (!IsPostBack)
            {
                LoadUsers();
            }
        }


        // =========================
        // LOAD USERS
        // =========================

        private void LoadUsers()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT
                        UserID,
                        FullName,
                        Username,
                        DateOfBirth,
                        Email
                    FROM Users
                    ORDER BY UserID DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);

                DataTable dt = new DataTable();

                da.Fill(dt);

                gvUsers.DataSource = dt;
                gvUsers.DataBind();

                lblUserCount.Text = dt.Rows.Count + " Users";
            }
        }


        // =========================
        // SEARCH
        // =========================

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string search = txtSearch.Text.Trim();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT
                        UserID,
                        FullName,
                        Username,
                        DateOfBirth,
                        Email
                    FROM Users
                    WHERE
                        FullName LIKE @Search
                        OR Username LIKE @Search
                        OR Email LIKE @Search
                    ORDER BY UserID DESC";

                SqlCommand cmd = new SqlCommand(query, con);

                cmd.Parameters.AddWithValue(
                    "@Search",
                    "%" + search + "%"
                );

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                DataTable dt = new DataTable();

                da.Fill(dt);

                gvUsers.DataSource = dt;
                gvUsers.DataBind();

                lblUserCount.Text = dt.Rows.Count + " Users";
            }
        }


        // =========================
        // OPEN ADD USER
        // =========================

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            ClearUserFields();

            lblMessage.Text = "";

            pnlAddUser.Visible = true;
        }


        // =========================
        // CLOSE MODAL
        // =========================

        protected void btnClose_Click(object sender, EventArgs e)
        {
            ClearUserFields();

            lblMessage.Text = "";

            pnlAddUser.Visible = false;
        }


        // =========================
        // CANCEL ADD USER
        // =========================

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearUserFields();

            lblMessage.Text = "";

            pnlAddUser.Visible = false;
        }


        // =========================
        // CLEAR FORM
        // =========================

        private void ClearUserFields()
        {
            txtFullName.Text = "";
            txtUsername.Text = "";
            txtDateOfBirth.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
        }


        // =========================
        // SAVE NEW USER
        // =========================

        protected void btnSaveUser_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string username = txtUsername.Text.Trim();
            string dateOfBirth = txtDateOfBirth.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrEmpty(fullName) ||
                string.IsNullOrEmpty(username) ||
                string.IsNullOrEmpty(dateOfBirth) ||
                string.IsNullOrEmpty(email) ||
                string.IsNullOrEmpty(password))
            {
                ShowError("Please fill in all fields.");
                return;
            }

            if (password.Length > 128)
            {
                ShowError("Password must be 128 characters or fewer.");
                return;
            }

            DateTime dob;

            if (!DateTime.TryParse(dateOfBirth, out dob))
            {
                ShowError("Please enter a valid date of birth.");
                return;
            }


            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();


                // Check username
                string checkUsername = @"
                    SELECT COUNT(*)
                    FROM Users
                    WHERE Username = @Username";

                using (SqlCommand cmd =
                    new SqlCommand(checkUsername, con))
                {
                    cmd.Parameters.AddWithValue("@Username", username);

                    int count = Convert.ToInt32(cmd.ExecuteScalar());

                    if (count > 0)
                    {
                        ShowError("Username already exists.");
                        return;
                    }
                }


                // Check email
                string checkEmail = @"
                    SELECT COUNT(*)
                    FROM Users
                    WHERE Email = @Email";

                using (SqlCommand cmd =
                    new SqlCommand(checkEmail, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);

                    int count = Convert.ToInt32(cmd.ExecuteScalar());

                    if (count > 0)
                    {
                        ShowError("Email already exists.");
                        return;
                    }
                }


                // Insert user
                string query = @"
                    INSERT INTO Users
                    (
                        FullName,
                        Username,
                        DateOfBirth,
                        Email,
                        Password
                    )
                    VALUES
                    (
                        @FullName,
                        @Username,
                        @DateOfBirth,
                        @Email,
                        @Password
                    )";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@DateOfBirth", dob);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", PasswordHasher.Hash(password));

                    cmd.ExecuteNonQuery();
                }
            }


            pnlAddUser.Visible = false;

            ClearUserFields();

            ShowSuccess("User added successfully.");

            LoadUsers();
        }


        // =========================
        // EDIT USER
        // =========================

        protected void gvUsers_RowEditing(
            object sender,
            GridViewEditEventArgs e)
        {
            gvUsers.EditIndex = e.NewEditIndex;

            LoadUsers();
        }


        // =========================
        // CANCEL EDIT
        // =========================

        protected void gvUsers_RowCancelingEdit(
            object sender,
            GridViewCancelEditEventArgs e)
        {
            gvUsers.EditIndex = -1;

            LoadUsers();
        }


        // =========================
        // UPDATE USER
        // =========================

        protected void gvUsers_RowUpdating(
            object sender,
            GridViewUpdateEventArgs e)
        {
            GridViewRow row = gvUsers.Rows[e.RowIndex];

            int userID = Convert.ToInt32(
                gvUsers.DataKeys[e.RowIndex].Value
            );


            // Get edited values
            TextBox txtFullNameEdit =
                row.Cells[1].Controls[0] as TextBox;

            TextBox txtUsernameEdit =
                row.Cells[2].Controls[0] as TextBox;

            TextBox txtDateEdit =
                row.Cells[3].Controls[0] as TextBox;

            TextBox txtEmailEdit =
                row.Cells[4].Controls[0] as TextBox;


            if (txtFullNameEdit == null ||
                txtUsernameEdit == null ||
                txtDateEdit == null ||
                txtEmailEdit == null)
            {
                ShowError("Unable to read the edited user information.");

                return;
            }


            string fullName =
                txtFullNameEdit.Text.Trim();

            string username =
                txtUsernameEdit.Text.Trim();

            string dateText =
                txtDateEdit.Text.Trim();

            string email =
                txtEmailEdit.Text.Trim();


            if (string.IsNullOrEmpty(fullName) ||
                string.IsNullOrEmpty(username) ||
                string.IsNullOrEmpty(dateText) ||
                string.IsNullOrEmpty(email))
            {
                ShowError("Please fill in all fields.");

                return;
            }


            DateTime dob;

            if (!DateTime.TryParse(dateText, out dob))
            {
                ShowError("Please enter a valid date of birth.");

                return;
            }


            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                con.Open();


                // Check username used by another user
                string usernameCheck = @"
                    SELECT COUNT(*)
                    FROM Users
                    WHERE Username = @Username
                    AND UserID <> @UserID";

                using (SqlCommand cmd =
                    new SqlCommand(usernameCheck, con))
                {
                    cmd.Parameters.AddWithValue(
                        "@Username",
                        username
                    );

                    cmd.Parameters.AddWithValue(
                        "@UserID",
                        userID
                    );

                    int count =
                        Convert.ToInt32(cmd.ExecuteScalar());

                    if (count > 0)
                    {
                        ShowError(
                            "This username is already used by another user."
                        );

                        return;
                    }
                }


                // Check email used by another user
                string emailCheck = @"
                    SELECT COUNT(*)
                    FROM Users
                    WHERE Email = @Email
                    AND UserID <> @UserID";

                using (SqlCommand cmd =
                    new SqlCommand(emailCheck, con))
                {
                    cmd.Parameters.AddWithValue(
                        "@Email",
                        email
                    );

                    cmd.Parameters.AddWithValue(
                        "@UserID",
                        userID
                    );

                    int count =
                        Convert.ToInt32(cmd.ExecuteScalar());

                    if (count > 0)
                    {
                        ShowError(
                            "This email is already used by another user."
                        );

                        return;
                    }
                }


                // Update user
                string updateQuery = @"
                    UPDATE Users
                    SET
                        FullName = @FullName,
                        Username = @Username,
                        DateOfBirth = @DateOfBirth,
                        Email = @Email
                    WHERE UserID = @UserID";


                using (SqlCommand cmd =
                    new SqlCommand(updateQuery, con))
                {
                    cmd.Parameters.AddWithValue(
                        "@FullName",
                        fullName
                    );

                    cmd.Parameters.AddWithValue(
                        "@Username",
                        username
                    );

                    cmd.Parameters.AddWithValue(
                        "@DateOfBirth",
                        dob
                    );

                    cmd.Parameters.AddWithValue(
                        "@Email",
                        email
                    );

                    cmd.Parameters.AddWithValue(
                        "@UserID",
                        userID
                    );

                    int rowsAffected =
                        cmd.ExecuteNonQuery();


                    if (rowsAffected == 0)
                    {
                        ShowError(
                            "User could not be updated."
                        );

                        return;
                    }
                }
            }


            gvUsers.EditIndex = -1;

            ShowSuccess(
                "User information updated successfully."
            );

            LoadUsers();
        }


        // =========================
        // DELETE USER
        // =========================

        protected void gvUsers_RowDeleting(
            object sender,
            GridViewDeleteEventArgs e)
        {
            int userID = Convert.ToInt32(
                gvUsers.DataKeys[e.RowIndex].Value
            );


            using (SqlConnection con =
                new SqlConnection(connectionString))
            {
                string query = @"
                    DELETE FROM Users
                    WHERE UserID = @UserID";


                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue(
                        "@UserID",
                        userID
                    );

                    con.Open();

                    int rowsAffected =
                        cmd.ExecuteNonQuery();


                    if (rowsAffected == 0)
                    {
                        ShowError(
                            "User could not be deleted."
                        );

                        return;
                    }
                }
            }


            ShowSuccess(
                "User deleted successfully."
            );

            LoadUsers();
        }


        // =========================
        // SUCCESS MESSAGE
        // =========================

        private void ShowSuccess(string message)
        {
            lblMessage.Text = message;

            lblMessage.CssClass =
                "message-label success-message";
        }


        // =========================
        // ERROR MESSAGE
        // =========================

        private void ShowError(string message)
        {
            lblMessage.Text = message;

            lblMessage.CssClass =
                "message-label error-message";
        }


        // =========================
        // DASHBOARD
        // =========================

        protected void lnkDashboard_Click(
            object sender,
            EventArgs e)
        {
            Response.Redirect("AdminDashboard.aspx");
        }

        protected void lnkCourses_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/ManageCourses.aspx");
        }

        protected void lnkResources_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/ManageResources.aspx");
        }

        protected void lnkQuizzes_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Admin/ManageQuizzes.aspx");
        }


        // =========================
        // LOGOUT
        // =========================

        protected void btnLogout_Click(
            object sender,
            EventArgs e)
        {
            Session.Clear();

            Session.Abandon();

            Response.Redirect("AdminLogin.aspx");
        }
    }
}

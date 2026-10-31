using System;
using System.Configuration;
using System.Data.SqlClient;
using StudySphere.Security;

public partial class Register : System.Web.UI.Page
{
    protected void btnRegister_Click(object sender, EventArgs e)
    {
        // Check if all fields are filled
        if (txtFullName.Text.Trim() == "" ||
            txtUsername.Text.Trim() == "" ||
            txtDateOfBirth.Text.Trim() == "" ||
            txtEmail.Text.Trim() == "" ||
            txtPassword.Text == "" ||
            txtConfirmPassword.Text == "")
        
        {
            lblMessage.Text = "Please fill in all fields.";
            return;
        }

        // Check password
        if (txtPassword.Text != txtConfirmPassword.Text)
        {
            lblMessage.Text = "Passwords do not match.";
            return;
        }

        try
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["StudySphereDB"].ConnectionString;

            using (SqlConnection connection =
                new SqlConnection(connectionString))
            {
                // Check if username or email already exists
                string checkQuery = @"
                    SELECT COUNT(*)
                    FROM Users
                    WHERE Username = @Username
                    OR Email = @Email";

                using (SqlCommand checkCommand =
                    new SqlCommand(checkQuery, connection))
                {
                    checkCommand.Parameters.AddWithValue(
                        "@Username", txtUsername.Text.Trim());

                    checkCommand.Parameters.AddWithValue(
                        "@Email", txtEmail.Text.Trim());

                    connection.Open();

                    int existingUser =
                        Convert.ToInt32(checkCommand.ExecuteScalar());

                    if (existingUser > 0)
                    {
                        lblMessage.Text =
                            "Username or email already exists.";
                        return;
                    }
                }

                // Insert new user
                string insertQuery = @"
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

                using (SqlCommand insertCommand =
                    new SqlCommand(insertQuery, connection))
                {
                    insertCommand.Parameters.AddWithValue(
                        "@FullName", txtFullName.Text.Trim());

                    insertCommand.Parameters.AddWithValue(
                        "@Username", txtUsername.Text.Trim());

                    insertCommand.Parameters.AddWithValue(
                        "@DateOfBirth",
                        Convert.ToDateTime(txtDateOfBirth.Text));

                    insertCommand.Parameters.AddWithValue(
                        "@Email", txtEmail.Text.Trim());

          

                    insertCommand.Parameters.AddWithValue(
                        "@Password", PasswordHasher.Hash(txtPassword.Text));

                    insertCommand.ExecuteNonQuery();
                }
            }

            // Registration successful
            Response.Redirect("Login.aspx");
        }
        catch (Exception)
        {
            lblMessage.Text = "Registration failed. Please try again.";
        }
    }
}

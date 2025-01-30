using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using MahApps.Metro.Controls;

namespace DariusInternshipApp
{
    /// <summary>
    /// Interaction logic for Login.xaml
    /// </summary>
    public partial class Login
    {
        public Login()
        {
            InitializeComponent();
        }
        private void txtLoginUsername_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

        private void btnLogin_Click(object sender, RoutedEventArgs e)
        {
            //using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
            //{
            //    using (SqlCommand command = new SqlCommand("sp_create_user", connection))
            //    {
            //        command.CommandType = CommandType.StoredProcedure;
            //        command.Parameters.AddWithValue("usernameVar", "123");
            //        command.Parameters.AddWithValue("encryptedPassword", BCrypt.Net.BCrypt.HashPassword("123"));
            //        command.Parameters.AddWithValue("roleID", "649B9982-C825-4F35-B57F-F53776AF4FC4");
            //        connection.Open();
            //        command.ExecuteNonQuery();

            //    }
            //}

            DataTable dt = new DataTable();
            string hashedPassword = "";
            string loggedInUserUUID = "";
            string roleID = "";
            string roleName = "";
            using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
            {
                using (SqlCommand command = new SqlCommand("sp_get_userPassword", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("username", txtLoginUsername.Text);

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    dt.Load(reader);
                    foreach (DataRow row in dt.Rows)
                    {
                        hashedPassword = row["Password"].ToString();
                        loggedInUserUUID = row["id"].ToString();
                        roleID = row["roleID"].ToString();
                        roleName = row["roleName"].ToString();
                    }
                }
            }

            if (hashedPassword != "" && BCrypt.Net.BCrypt.Verify(pwdLoginPassword.Password, hashedPassword))
            {
                UserManagement mainWindow = new UserManagement();
                mainWindow.userUUID = loggedInUserUUID;
                mainWindow.userRoleID = roleID;
                mainWindow.userRoleName = roleName;
                this.Close();
                mainWindow.Show();
            }
            else if (hashedPassword == "")
            {
                MessageBox.Show("User doesnt exist.");
            }
            else
            {
                MessageBox.Show("Couldnt log in");
            }
        }
    }
}





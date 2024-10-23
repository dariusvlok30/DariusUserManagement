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
        private string connectionStringHardcoded = @"Server=localhost\MSSQLSERVER01;Database=DariusInternship;Trusted_Connection=True;";

        public Login()
        {
            InitializeComponent();
        }
        private void txtLoginUsername_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

        private void btnLogin_Click(object sender, RoutedEventArgs e)
        {
            DataTable dt = new DataTable();
            string hashedPassword = "";
            using (SqlConnection connection = new SqlConnection(connectionStringHardcoded))
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
                    }
                }
            }

            if (hashedPassword != "" && BCrypt.Net.BCrypt.Verify(pwdLoginPassword.Password, hashedPassword))
            {
                UserManagement mainWindow = new UserManagement();
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





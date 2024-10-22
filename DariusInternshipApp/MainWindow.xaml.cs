using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Data;
using System.Data.SqlClient;
using static System.Runtime.InteropServices.JavaScript.JSType;
using System.Reflection.Metadata;
using System.Runtime.ConstrainedExecution;
using System.Security.Policy;
using System.Net;

namespace DariusInternshipApp
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        /*
        NOTES:
        * give objects a name on the frontend so you can call them on the backend.
        * Functions can be found when you go on the frontend, click on an object. 
        *   Then nagivate to Properties.
        *   Then the lightning mark at the top right, thats functions.
        *   Doubleclick on any one of them to create one.
        */
        private int iMaxPages = 0;
        private int iPageNumber = 0;
        private bool bIsLoading = true;
        private string sUserMangement = "User Management";
        private userAction chosenAction;
        private enum userAction
        {
            Add,
            Edit,
            None
        }

        public static string connectionStringHardcoded = @"Server=localhost\MSSQLSERVER01;Database=DariusInternship;Trusted_Connection=True;";
        public MainWindow()
        {
            InitializeComponent();
            // alles onder hier fire as die default constructor klaar geload het.
            LoadMaxPages();
            LoadDataGrid(0);// first we hardcode it to go to page 1, which means we need to pass it 0.
            lblUserManagement.Content = sUserMangement;
            bIsLoading = false;
        }

        private void LoadMaxPages() {
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(connectionStringHardcoded))
            {
                using (SqlCommand command = new SqlCommand("sp_get_usersMaxPaging", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("pageSize", ((ComboBoxItem)cmbRowsPerPage.SelectedItem).Content.ToString());
                    command.Parameters.AddWithValue("pageFilters", "");
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    dt.Load(reader);
                    foreach (DataRow row in dt.Rows)
                    {
                        iMaxPages = int.Parse(row["pages"].ToString());
                        lblMaxPages.Content  = iMaxPages.ToString();
                    }
                }
            }
        }

        private void LoadDataGrid(int pageNumber) {
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(connectionStringHardcoded))
            {
                using (SqlCommand command = new SqlCommand("sp_get_users", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("pageNumber", pageNumber);
                    command.Parameters.AddWithValue("pageSize", ((ComboBoxItem)cmbRowsPerPage.SelectedItem).Content.ToString());
                    command.Parameters.AddWithValue("pageFilters", "");

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    dt.Load(reader);
                    UsersTable.ItemsSource = dt.DefaultView;
                    iPageNumber = pageNumber;
                    txtPageNumber.Text = (iPageNumber + 1).ToString();
                }
            }
        }


        private void UsersTable_Loaded(object sender, RoutedEventArgs e)
        {
            //not used anymore. we call this onLoad of the page.
        }

        private void UsersTable_Selected(object sender, RoutedEventArgs e)
        {
            Console.WriteLine("just so we can hita  breakpoint");
        }

        private void Grid_Loaded(object sender, RoutedEventArgs e)
        {
            // dit is vir die main window, as hy klaar geload het tref dit hier.
        }

        private void btnSearch_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btnClear_Click(object sender, RoutedEventArgs e)
        {
            if (!bIsLoading)
            {
                txtSearch.Clear();
                LoadMaxPages();
                LoadDataGrid(0);// hardcode to go to page 1.
            }
        }

        private void btnRowsPerPage_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (!bIsLoading)
            {
                LoadMaxPages();
                LoadDataGrid(0);// on selection changed we force it to go to page 1
            }
        }

        private void btnFirst_Click(object sender, RoutedEventArgs e)
        {
            if (!bIsLoading)
            {
                LoadMaxPages();
                LoadDataGrid(0);// hardcode to go to page 1.
            }
        }

        private void btnPrevious_Click(object sender, RoutedEventArgs e)
        {
            if (!bIsLoading)
            {
                LoadMaxPages();
                if ((iPageNumber - 1) >= 0)
                {
                    iPageNumber -= 1;
                    LoadDataGrid(iPageNumber);
                }
                else
                {
                    iPageNumber = 0;
                    LoadDataGrid(iPageNumber);
                }

            }
        }

        private void btnNext_Click(object sender, RoutedEventArgs e)
        {
            if (!bIsLoading)
            {
                LoadMaxPages();
                if ((iPageNumber + 1) < iMaxPages)
                {
                    iPageNumber += 1;
                    LoadDataGrid(iPageNumber);
                }
                else if ((iPageNumber + 1) == iMaxPages) 
                {
                    iPageNumber = iMaxPages -1;
                    LoadDataGrid(iPageNumber);
                }
            }
        }

        private void btnLast_Click(object sender, RoutedEventArgs e)
        {
            if (!bIsLoading)
            {
                LoadMaxPages();
                LoadDataGrid(iMaxPages -1);
            }
        }

        private void UsersTable_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            DataGrid dataGrid = sender as DataGrid;
            DataGridRow row = (DataGridRow)dataGrid.ItemContainerGenerator.ContainerFromIndex(dataGrid.SelectedIndex);

            if (row != null) {

                //get the UUID from the first column
                DataGridCell RowColumnUUID = dataGrid.Columns[0].GetCellContent(row).Parent as DataGridCell;
                txtUserUUID.Text = ((TextBlock)RowColumnUUID.Content).Text;
                //get the username from the second column
                DataGridCell RowColumnUsername = dataGrid.Columns[1].GetCellContent(row).Parent as DataGridCell;
                txtUsername.Text = ((TextBlock)RowColumnUsername.Content).Text;

                if (!txtUserUUID.Text.Equals(""))
                {
                    pwdUserPassword.Clear();
                    grdPassword.Visibility = Visibility.Hidden;
                    chosenAction = userAction.Edit;
                    lblUserManagement.Content = sUserMangement + " - Update User";
                    btnDelete.Visibility = Visibility.Visible;
                }
                else
                {
                    pwdUserPassword.Clear();
                    grdPassword.Visibility = Visibility.Hidden;
                    btnDelete.Visibility = Visibility.Hidden;
                }
            }

        }

        private void btnCancel_Click(object sender, RoutedEventArgs e)
        {
            chosenAction = userAction.None;
            btnDelete.Visibility = Visibility.Hidden;
            txtUserUUID.Clear();
            txtUsername.Clear();
            pwdUserPassword.Clear();
            grdPassword.Visibility = Visibility.Hidden;
            lblUserManagement.Content = sUserMangement;

        }

        private void btnNewUser_Click(object sender, RoutedEventArgs e)
        {
            chosenAction = userAction.Add;
            btnDelete.Visibility = Visibility.Hidden;
            txtUserUUID.Clear();
            txtUserUUID.Text = "(auto generated)";
            txtUsername.Clear();
            pwdUserPassword.Clear();
            grdPassword.Visibility = Visibility.Visible;
            lblUserManagement.Content = sUserMangement + " - Create User";
        }

        private void btnSave_Click(object sender, RoutedEventArgs e)
        {
            if (chosenAction == userAction.Add)
            {
                using (SqlConnection connection = new SqlConnection(connectionStringHardcoded))
                {
                    using (SqlCommand command = new SqlCommand("sp_create_user", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("usernameVar", txtUsername.Text);
                        command.Parameters.AddWithValue("encryptedPassword", BCrypt.Net.BCrypt.HashPassword(pwdUserPassword.Password));
                        connection.Open();
                        command.ExecuteNonQuery();
                        LoadDataGrid(0);
                        MessageBox.Show("User Successfully Created");

                    }
                }
            }
            else if (chosenAction == userAction.Edit)
            {
                using (SqlConnection connection = new SqlConnection(connectionStringHardcoded))
                {
                    using (SqlCommand command = new SqlCommand("sp_update_userDetails", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("id", txtUserUUID.Text);
                        command.Parameters.AddWithValue("usernameVar", txtUsername.Text);
                        connection.Open();
                        command.ExecuteNonQuery();
                        LoadDataGrid(0);
                        MessageBox.Show("User Successfully Updated");
                    }
                }
            }
            grdPassword.Visibility = Visibility.Hidden;
            pwdUserPassword.Clear();
            
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
                MessageBox.Show("Successfully logged in");
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
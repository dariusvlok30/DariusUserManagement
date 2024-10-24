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

namespace DariusInternshipApp
{
    /// <summary>
    /// Interaction logic for UserManagement.xaml
    /// </summary>
    public partial class UserManagement
    {
        #region Variables
        public string userUUID = "";
        private int iMaxPages = 0;
        private int iPageNumber = 0;
        private bool bIsLoading = true;
        private string sUserMangement = "User Management";
        private string sNotifaction = "Notification: ";
        private userAction chosenAction;
        private enum userAction
        {
            Add,
            Edit,
            None
        }
        public static string connectionStringHardcoded = @"Server=localhost\MSSQLSERVER01;Database=DariusInternship;Trusted_Connection=True;";
        #endregion

        public UserManagement()
        {
            InitializeComponent();
            // populate user management
            LoadMaxPages();
            LoadDataGrid(0);
            lblUserManagement.Content = sUserMangement;
            LoadAuditsGrid();
            bIsLoading = false;
        }

        private void LoadMaxPages(string rowsPerPage) 
        {
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(connectionStringHardcoded))
            {
                using (SqlCommand command = new SqlCommand("sp_get_usersMaxPaging", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("pageSize", rowsPerPage);
                    command.Parameters.AddWithValue("pageFilters", "");
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    dt.Load(reader);
                    foreach (DataRow row in dt.Rows)
                    {
                        iMaxPages = int.Parse(row["pages"].ToString());
                        lblMaxPages.Content = iMaxPages.ToString();
                        txtPageNumber.Items.Clear();
                        for (int i = 0; i < iMaxPages; i++)
                        {
                            txtPageNumber.Items.Add((i + 1).ToString());
                        }
                        txtPageNumber.SelectedIndex = 0;
                    }
                }
            }
        }

        private void LoadMaxPages()
        {
            LoadMaxPages(((ComboBoxItem)cmbRowsPerPage.SelectedItem).Content.ToString());
        }

        private void LoadDataGrid(int pageNumber)
        {
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

        #region button events
        private void btnClear_Click(object sender, RoutedEventArgs e)
        {
            if (!bIsLoading)
            {
                txtSearch.Clear();
                LoadMaxPages();
                LoadDataGrid(0);// hardcode to go to page 1.
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
                    iPageNumber = iMaxPages - 1;
                    LoadDataGrid(iPageNumber);
                }
            }
        }

        private void btnLast_Click(object sender, RoutedEventArgs e)
        {
            if (!bIsLoading)
            {
                LoadMaxPages();
                LoadDataGrid(iMaxPages - 1);
            }
        }

        #endregion

        private void btnRowsPerPage_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (!bIsLoading)
            {
                LoadMaxPages();
                LoadDataGrid(0);// on selection changed we force it to go to page 1
            }
        }

        private void UsersTable_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            DataGrid dataGrid = sender as DataGrid;
            DataGridRow row = (DataGridRow)dataGrid.ItemContainerGenerator.ContainerFromIndex(dataGrid.SelectedIndex);

            if (row != null)
            {

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

        #region user CRUD
        private void btnCancel_Click(object sender, RoutedEventArgs e)
        {
            chosenAction = userAction.None;
            btnDelete.Visibility = Visibility.Hidden;
            txtUserUUID.Clear();
            txtUsername.Clear();
            pwdUserPassword.Clear();
            grdPassword.Visibility = Visibility.Hidden;
            lblUserManagement.Content = sUserMangement;
            lblNotify.Content = sNotifaction + "Action Cancelled";
            InsertAudit("Action Cancelled");
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
                        lblNotify.Content = sNotifaction + "User " + txtUsername.Text + " Created";
                        InsertAudit("User " + txtUsername.Text + " Created");

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
                        lblNotify.Content = sNotifaction + "User " + txtUsername.Text + " Updated";
                        InsertAudit("User " + txtUsername.Text + " Updated");
                    }
                }
            }
            grdPassword.Visibility = Visibility.Hidden;
            pwdUserPassword.Clear();
            txtUsername.Clear();
            txtUserUUID.Clear();

        }

        private void btnDelete_Click(object sender, RoutedEventArgs e)
        {
            using (SqlConnection connection = new SqlConnection(connectionStringHardcoded))
            {
                using (SqlCommand command = new SqlCommand("sp_delete_user", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("id", txtUserUUID.Text);
                    connection.Open();
                    command.ExecuteNonQuery();
                    lblNotify.Content = sNotifaction + "User " + txtUsername.Text + " Deleted";
                    LoadDataGrid(0);
                    InsertAudit("User " + txtUsername.Text + " Deleted");
                    lblUserManagement.Content = sUserMangement;
                    txtUserUUID.Clear();
                    txtUsername.Clear();
                }
            }
        }

        #endregion

        private void txtPageNumber_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }

        private void TabControl_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (!bIsLoading) 
            {
                if ((sender as TabControl).SelectedIndex.Equals(1))
                {
                    LoadAuditsGrid();
                }
            }
        }

        private void LoadAuditsGrid() 
        {
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(connectionStringHardcoded))
            {
                using (SqlCommand command = new SqlCommand("select * from vw_audit order by dateOfChange asc", connection))
                {
                    command.CommandType = CommandType.Text;

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    dt.Load(reader);
                    AuditTable.ItemsSource = dt.DefaultView;
                }
            }
        }

        private void InsertAudit(string descriptionOfChange)
        {
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(connectionStringHardcoded))
            {
                using (SqlCommand command = new SqlCommand("sp_insert_audit", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("userUUID", userUUID);
                    command.Parameters.AddWithValue("changeDescription", descriptionOfChange);
                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }
    }
}

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
using System.Xml.Linq;

namespace DariusInternshipApp
{
    /// <summary>
    /// Interaction logic for UserManagement.xaml
    /// </summary>
    public partial class UserManagement
    {
        #region Variables
        public string userUUID = "";
        public string userRoleID = "";
        public string userRoleName = "";
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

        private userAction chosenPartAction;

        private List<Part> listParts = new List<Part>();
        private List<PartMovement> listPartsMovement = new List<PartMovement>();
        private List<PartCategory> listPartCategory = new List<PartCategory>();

        #endregion

        public UserManagement()
        {
            InitializeComponent();
            // populate user management
            LoadMaxPages();
            LoadDataGrid(0);
            lblUserManagement.Content = sUserMangement;
            if (userRoleName.Equals("Admin")) {
                LoadAuditsGrid();
            }
            LoadRoles();
            bIsLoading = false;
        }

        private void LoadMaxPages(string rowsPerPage) 
        {
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
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
            using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
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

                DataGridCell RowColumnRoleID = dataGrid.Columns[2].GetCellContent(row).Parent as DataGridCell;
                if (RowColumnRoleID != null)
                {
                    cmbRole.SelectedValue = ((TextBlock)RowColumnRoleID.Content).Text;
                }
                else
                {
                    cmbRole.SelectedIndex = -1;
                }
               

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
                using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
                {
                    using (SqlCommand command = new SqlCommand("sp_create_user", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("usernameVar", txtUsername.Text);
                        command.Parameters.AddWithValue("encryptedPassword", BCrypt.Net.BCrypt.HashPassword(pwdUserPassword.Password));
                        command.Parameters.AddWithValue("roleID", cmbRole.SelectedValue);
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
                using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
                {
                    using (SqlCommand command = new SqlCommand("sp_update_userDetails", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("id", txtUserUUID.Text);
                        command.Parameters.AddWithValue("usernameVar", txtUsername.Text);
                        command.Parameters.AddWithValue("roleID", cmbRole.SelectedValue);
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
            using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
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
                    if (userRoleName.Equals("Admin"))
                    {
                        LoadAuditsGrid();
                    }
                }
            }
        }

        private void LoadAuditsGrid() 
        {
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
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
            using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
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

        private void LoadRoles()
        {
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
            {
                using (SqlCommand command = new SqlCommand("select * from vw_role", connection))
                {
                    command.CommandType = CommandType.Text;

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    dt.Load(reader);
                    cmbRole.Items.Clear();
                    List<KeyValuePair<string, string>> lKvpForRoles = new List<KeyValuePair<string, string>>();
                    foreach (DataRow dr in dt.Rows) 
                    {
                        lKvpForRoles.Add(new KeyValuePair<string, string>(dr["id"].ToString(), dr["description"].ToString()));
                    }
                    cmbRole.ItemsSource = lKvpForRoles;
                }
            }
        }

        #region parts

        public DataTable getParts()
        {
            DataTable dataTable = new DataTable();
            try
            {
                using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
                {
                    connection.Open();

                    string strSelectionQuery = "select * from vw_parts";
                    if (cmbPartCategory.SelectedIndex > 0)
                    {
                        strSelectionQuery += " where partsCategoryID = " + cmbPartCategory.SelectedValue;
                    }

                    using (SqlCommand command = new SqlCommand(strSelectionQuery, connection))
                    {
                        command.CommandType = CommandType.Text;
                        IDataReader iDataReader = command.ExecuteReader();
                        dataTable.Load(iDataReader);
                    }
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"SQL Error: {ex.Message}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }
            return dataTable;
        }

        public void LoadPartsDataGrid()
        {
            try
            {
                listParts.Clear();
                DataTable dtParts = getParts();
                foreach (DataRow row in dtParts.Rows)
                {
                    Part part = new Part();
                    part.id = Convert.ToInt32(row["id"]);
                    part.partNumber = row["partNumber"].ToString();

                    part.name = row["name"].ToString();
                    part.description = row["description"].ToString();
                    part.pricePerUnit = Convert.ToDouble(row["pricePerUnit"].ToString());
                    part.expectedStock = Convert.ToInt32(row["expectedStock"].ToString());
                    part.stockOnHand = Convert.ToInt32(row["stockOnHand"].ToString());
                    part.stockToOrder = Convert.ToInt32(row["stockToOrder"].ToString());
                    part.priceForStockOnHand = Convert.ToDouble(row["priceForStockOnHand"].ToString());
                    part.partCategoryID = Convert.ToInt32(row["partCategoryID"].ToString());
                    part.partCategoryName = row["partCategoryName"].ToString();
                    listParts.Add(part);
                }

                dgPartsManagement.ItemsSource = null;
                dgPartsManagement.ItemsSource = listParts;
            }
            catch (Exception ex)
            {

            }
        }

        public DataTable getPartsMovement()
        {
            DataTable dataTable = new DataTable();
            try
            {
                using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
                {
                    connection.Open();

                    string strSelectionQuery = $"select * from vw_partsMovement where [partsID] = {txtEditPartID.Text}";

                    using (SqlCommand command = new SqlCommand(strSelectionQuery, connection))
                    {
                        command.CommandType = CommandType.Text;
                        IDataReader iDataReader = command.ExecuteReader();
                        dataTable.Load(iDataReader);
                    }
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"SQL Error: {ex.Message}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }
            return dataTable;
        }

        public void LoadPartsMovementDataGrid()
        {
            try
            {
                listPartsMovement.Clear();
                DataTable dtPartsMovement = getPartsMovement();
                foreach (DataRow row in dtPartsMovement.Rows)
                {
                    PartMovement part = new PartMovement();
                    part.id = Convert.ToInt32(row["id"]);
                    part.price = Convert.ToDouble(row["price"].ToString());
                    part.stockOnHand = Convert.ToInt32(row["stockOnHand"].ToString());
                    part.partsID = Convert.ToInt32(row["partsID"]);
                    part.dateAltered = Convert.ToDateTime(row["dateAltered"].ToString());
                    listPartsMovement.Add(part);
                }

                dgPartsMovement.ItemsSource = null;
                dgPartsMovement.ItemsSource = listPartsMovement;
                dgPartsMovement.Columns[0].Visibility = Visibility.Collapsed;
                dgPartsMovement.Columns[3].Visibility = Visibility.Collapsed;
            }
            catch (Exception ex)
            {

            }
        }

        public DataTable getPartsCategories()
        {
            DataTable dataTable = new DataTable();
            try
            {
                using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
                {
                    connection.Open();

                    using (SqlCommand command = new SqlCommand("select * from vw_partsCategories", connection))
                    {
                        command.CommandType = CommandType.Text;
                        IDataReader iDataReader = command.ExecuteReader();
                        dataTable.Load(iDataReader);
                    }
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"SQL Error: {ex.Message}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }
            return dataTable;
        }

        public void LoadPartsCategoriesDropdowns()
        {
            PartCategory partCategoryAll = new PartCategory() { id = -1, name = "All" };

            listPartCategory.Clear();
            listPartCategory.Add(partCategoryAll);
            DataTable dtParts = getPartsCategories();
            foreach (DataRow row in dtParts.Rows)
            {
                PartCategory partCategory = new PartCategory();
                partCategory.id = Convert.ToInt32(row["id"]);
                partCategory.name = row["name"].ToString();
                listPartCategory.Add(partCategory);
            }

            cmbPartCategory.ItemsSource = listPartCategory;
            cmbPartCategory.SelectedIndex = 0;

            listPartCategory.Remove(partCategoryAll);
            cmbEditPartCategory.ItemsSource = listPartCategory;
            cmbEditPartCategory.SelectedIndex = -1;

        }


        private void btnCancelParts_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btnDeleteParts_Click(object sender, RoutedEventArgs e)
        {

        }
        #endregion parts

        private void txtPageNumber_SelectionChanged_1(object sender, SelectionChangedEventArgs e)
        {

        }

        private void btnCapture_Click(object sender, RoutedEventArgs e)
        {
            using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
            {
                using (SqlCommand command = new SqlCommand("sp_insert_partsMovement", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("partID", txtEditPartID.Text);
                    command.Parameters.AddWithValue("partPrice", txtEditPartPrice.Text);
                    command.Parameters.AddWithValue("stockOnHand", txtEditPartStockOnHand.Text);
                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
            LoadPartsDataGrid();
            LoadPartsMovementDataGrid();
        }

        private void cmbPartCategory_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            LoadPartsDataGrid();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            LoadPartsDataGrid();
            LoadPartsCategoriesDropdowns();
        }

        private void btnSaveParts_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (chosenPartAction.Equals(userAction.Add))
                {
                    using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
                    {
                        using (SqlCommand command = new SqlCommand("sp_create_part", connection))
                        {
                            command.CommandType = CommandType.StoredProcedure;

                            command.Parameters.AddWithValue("@partNumber", txtEditPartNumber.Text);
                            command.Parameters.AddWithValue("@name", txtEditPartName.Text);
                            command.Parameters.AddWithValue("@partsCategoryID", cmbEditPartCategory.SelectedValue);
                            command.Parameters.AddWithValue("@price", txtEditPartPrice.Text);
                            command.Parameters.AddWithValue("@expectedStock", txtEditPartExpectedStock.Text);
                            command.Parameters.AddWithValue("@stockOnHand", txtEditPartStockOnHand.Text);
                            connection.Open();
                            command.ExecuteNonQuery();
                        }
                    }

                    MessageBox.Show("Part added successfully!");

                    LoadPartsDataGrid();
                }
                else if (chosenPartAction == userAction.Edit)
                {
                    using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
                    {
                        using (SqlCommand command = new SqlCommand("sp_update_parts", connection))
                        {
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.AddWithValue("partID", txtEditPartID.Text);
                            command.Parameters.AddWithValue("partName", txtEditPartName.Text);
                            command.Parameters.AddWithValue("partNumber", txtEditPartNumber.Text);
                            command.Parameters.AddWithValue("partDescription", txtEditPartDescription.Text);
                            command.Parameters.AddWithValue("partpartsCategoryID", cmbEditPartCategory.SelectedValue);
                            command.Parameters.AddWithValue("partPrice", txtEditPartPrice.Text);
                            command.Parameters.AddWithValue("partExpectedStock", txtEditPartExpectedStock.Text);
                            connection.Open();
                            command.ExecuteNonQuery();
                        }
                    }
                    LoadPartsDataGrid();
                }


            }
            catch (Exception ex)
            {
                MessageBox.Show("Error adding part: " + ex.Message);
            }


            
        }

        private void dgPartsManagement_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            DataGrid dataGrid = sender as DataGrid;
            DataGridRow row = (DataGridRow)dataGrid.ItemContainerGenerator.ContainerFromIndex(dataGrid.SelectedIndex);

            if (dataGrid.SelectedItem is Part selectedPart)
            {
                
                txtEditPartID.Text = selectedPart.id.ToString();
                txtEditPartNumber.Text = selectedPart.partNumber;
                txtEditPartName.Text = selectedPart.name;
                txtEditPartPrice.Text = selectedPart.pricePerUnit.ToString();
                txtEditPartExpectedStock.Text = selectedPart.expectedStock.ToString();
                txtEditPartStockOnHand.Text = selectedPart.stockOnHand.ToString();

                
                LoadPartsMovementDataGrid();

                
                btnDeleteParts.Visibility = Visibility.Visible;
            }

            if (row != null)
            {
                DataGridCell RowColumnID = dataGrid.Columns[0].GetCellContent(row).Parent as DataGridCell;
                txtEditPartID.Text = ((TextBlock)RowColumnID.Content).Text;

                DataGridCell RowColumnPartNumber = dataGrid.Columns[1].GetCellContent(row).Parent as DataGridCell;
                txtEditPartNumber.Text = ((TextBlock)RowColumnPartNumber.Content).Text;

                DataGridCell RowColumnPartName = dataGrid.Columns[2].GetCellContent(row).Parent as DataGridCell;
                txtEditPartName.Text = ((TextBlock)RowColumnPartName.Content).Text;

                DataGridCell RowColumnPartPrice = dataGrid.Columns[4].GetCellContent(row).Parent as DataGridCell;
                txtEditPartPrice.Text = ((TextBlock)RowColumnPartPrice.Content).Text;

                DataGridCell RowColumnPartExpectedStock = dataGrid.Columns[5].GetCellContent(row).Parent as DataGridCell;
                txtEditPartExpectedStock.Text = ((TextBlock)RowColumnPartExpectedStock.Content).Text;

                DataGridCell RowColumnPartStockOnHand = dataGrid.Columns[6].GetCellContent(row).Parent as DataGridCell;
                txtEditPartStockOnHand.Text = ((TextBlock)RowColumnPartStockOnHand.Content).Text;

                LoadPartsMovementDataGrid();

                DataGridCell RowColumnPartCategoryID = dataGrid.Columns[9].GetCellContent(row).Parent as DataGridCell;
                if (RowColumnPartCategoryID != null)
                {
                    cmbEditPartCategory.SelectedValue = ((TextBlock)RowColumnPartCategoryID.Content).Text;
                }
                else
                {
                    cmbEditPartCategory.SelectedIndex = -1;
                }


                if (!txtEditPartID.Text.Equals(""))
                {
                    lblPartManagement.Content = "Part Management";
                    chosenPartAction = userAction.Edit;
                    btnDelete.Visibility = Visibility.Visible;

                }
                else
                {
                    chosenPartAction = userAction.None;
                    btnDelete.Visibility = Visibility.Hidden;
                }
            }
        }

        private void btnPartsSearch_Click(object sender, RoutedEventArgs e)
        {

        }

        private void btnPartsClear_Click(object sender, RoutedEventArgs e)
        {

        }


        private void cmbPartsRowsPerPage_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }

        private void btnAddPart_Click(object sender, RoutedEventArgs e)
        {

            btnDeleteParts.Visibility = Visibility.Hidden;

            chosenPartAction = userAction.Add;
            btnDelete.Visibility = Visibility.Hidden;
            txtEditPartID.Clear();
            txtEditPartID.Text = "(auto generated)";
            txtEditPartNumber.Clear();
            txtEditPartNumber.Text = "";
            txtEditPartName.Clear();
            txtEditPartName.Text = "";
            txtEditPartPrice.Clear();
            txtEditPartPrice.Text = "";
            txtEditPartExpectedStock.Clear();
            txtEditPartExpectedStock.Text = "";
            txtEditPartStockOnHand.Clear();
            txtEditPartStockOnHand.Text = "";
            grdPassword.Visibility = Visibility.Visible;
            lblPartManagement.Content = "Add New Part";
        }

        private void txtUserUUID_TextChanged(object sender, TextChangedEventArgs e)
        {

        }

        private void txtUsername_TextChanged(object sender, TextChangedEventArgs e)
        {

        }
        private void btnbtnDeleteParts(object sender, RoutedEventArgs e)
        {
            using (SqlConnection connection = new SqlConnection(Application.Current.Resources["DbConnectionString"].ToString()))
            {
                using (SqlCommand command = new SqlCommand("sp_delete_part  ", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("id", txtEditPartID.Text);
                    connection.Open();
                    command.ExecuteNonQuery();
                    lblNotify.Content = sNotifaction + "Part " + txtUsername.Text + " Deleted";
                    LoadDataGrid(0);
                    InsertAudit("Part " + txtEditPartID.Text + " Deleted");
                    lblUserManagement.Content = sUserMangement;
                    txtEditPartID.Clear();
                    txtEditPartName.Clear();
                }
            }
        }
    }

    public class Part
    {
        public int id { get; set; }
        public string? partNumber { get; set; }
        public string? name { get; set; }
        public string? description { get; set; }
        public double pricePerUnit { get; set; }
        public int expectedStock { get; set; }
        public int stockOnHand { get; set; }
        public int stockToOrder { get; set; }
        public double priceForStockOnHand { get; set; }
        public int? partCategoryID { get; set; }
        public string? partCategoryName { get; set; }
    }

    public class PartCategory
    {
        public int id { get; set; }
        public string? name { get; set; }
    }

    public class PartMovement
    {
        public int id { get; set; }
        public double price { get; set; }
        public int stockOnHand { get; set; }
        public int partsID { get; set; }
        public DateTime dateAltered { get; set; }
    }
}




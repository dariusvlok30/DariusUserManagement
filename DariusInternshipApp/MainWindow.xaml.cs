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

        public static string connectionStringHardcoded = @"Server=localhost\MSSQLSERVER01;Database=DariusInternship;Trusted_Connection=True;";
        public MainWindow()
        {
            InitializeComponent();
        }

        private void UsersTable_Loaded(object sender, RoutedEventArgs e)
        {
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(connectionStringHardcoded)) 
            {
                using (SqlCommand command = new SqlCommand("sp_get_users", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("pageNumber", 0);// more sal ons die values replace met enes wat die users kan kies.
                    command.Parameters.AddWithValue("pageSize", 100);
                    command.Parameters.AddWithValue("pageFilters", "");

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    dt.Load(reader);
                    UsersTable.ItemsSource = dt.DefaultView;
                }
            }

        }

        private void UsersTable_Selected(object sender, RoutedEventArgs e)
        {
            Console.WriteLine("just so we can hita  breakpoint");
        }

        private void Grid_Loaded(object sender, RoutedEventArgs e)
        {
            // dit is vir die main window, as hy klaar geload het tref dit hier.
        }
    }
}
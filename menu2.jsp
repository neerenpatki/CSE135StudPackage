<b>Navigation Menu</b>
<ul>
  <%-- Import the java.sql package --%>
  <%@ page import="java.sql.*"%>
  <%-- -------- Open Connection Code -------- --%>
  <%
  
  Connection conn = null;
  PreparedStatement pstmt = null;
  ResultSet rs = null;

  try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/Project1DB?" +
                    "user=postgres&password=postgres");
  %>

  <%-- -------- SELECT Statement Code -------- --%>
     <%
        // Create the statement
        Statement statement = conn.createStatement();

        // Use the created statement to SELECT
        // the student attributes FROM the Student table.
        rs = statement.executeQuery("SELECT name FROM categories");
        } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                //out.println("Unable to perform operation specified on category.");
                //throw new RuntimeException(e);
        }
      %>
      <% while (rs.next()) { %>
  <li><a href="products.jsp"><%= rs.getString("name") %><a></li>

  <%}%>
</ul>

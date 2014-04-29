<b>Categories Menu</b>
<p />
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
      <form action="products_browsing.jsp">
      <input type="submit" name="action" value="All Products" style="height:20px; width:100px">
      </form>
      <% while (rs.next()) { %>
    <form action="products_browsing.jsp">
    <input type="submit" name="action" value=<%= rs.getString("name") %> style="height:20px; width:100px">
  </form>
    <!--<a href="products.jsp" value=<%= rs.getString("name") %>><%= rs.getString("name") %><a></li>-->

  <%}%>

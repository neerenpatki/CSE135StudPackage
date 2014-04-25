<html>
  <head>
    <title>Sign Up Page (JSP)</title>
  </head>
  <body>
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

    <%-- -------- INSERT Code -------- --%>
    <%
        String action = request.getParameter("action");
        // Check if an insertion is requested
        if (action != null && action.equals("insert")) {

          // Begin transaction
          conn.setAutoCommit(false);

            // Create the prepared statement and use it to
            // INSERT student values INTO the students table.
          pstmt = conn
            .prepareStatement("INSERT INTO owners (username, age, state) VALUES (?, ?, ?)");
          pstmt.setString(1, request.getParameter("username"));
          pstmt.setInt(2, Integer.parseInt(request.getParameter("age")));
          pstmt.setString(3, request.getParameter("state"));
          int rowCount = pstmt.executeUpdate();

          // Commit transaction
          conn.commit();
          conn.setAutoCommit(true);


          out.println("You have successfully signed up.");

        }
    %>

    <%} catch(Exception e){
    
                out.println("Your signup failed.");
        }
       %>
        
        <p /><a href="signup.html">Return to signup page</a>
        
        <p /><a href="login.html">Login</a>
        
        
  </body>
</html>
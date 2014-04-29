<html>
  <head>
    <title>Sign Up Page</title>
  </head>
  <body>
    <%@ page import="java.sql.*"%>
    <%-- -------- Open Connection Code -------- --%>
     <%          
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean emptyString = false;
        boolean spaces = false;
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

        emptyString = request.getParameter("username").equals("");
        spaces = request.getParameter("username").contains(" ");

        // Check if an insertion is requested
        if (action != null && action.equals("insert") && emptyString == false && spaces == false) {

          // Begin transaction
          conn.setAutoCommit(false);

            // Create the prepared statement and use it to
            // INSERT student values INTO the students table.
          pstmt = conn
            .prepareStatement("INSERT INTO users (username, age, state, role) VALUES (?, ?, ?, ?)");
          pstmt.setString(1, request.getParameter("username"));
          pstmt.setInt(2, Integer.parseInt(request.getParameter("age")));
          pstmt.setString(3, request.getParameter("state"));
          pstmt.setString(4, request.getParameter("role"));
          int rowCount = pstmt.executeUpdate();

          // Commit transaction
          conn.commit();
          conn.setAutoCommit(true);


          out.println("You have successfully signed up.");

        }
        else if(emptyString == true){
            throw new RuntimeException("EMPTY STRING");
        }
        else if(spaces == true){
            throw new RuntimeException("SPACES EXIST");
        }
    %>

    <%} catch(Exception e){
                //throw new Exception(e);
               //out.println(e);
                if (e.getMessage().contains("For input string:")) {
                    out.println("The age field must be an integer. Please try signing up again.");
                } else if (e.getMessage().contains("duplicate key value violates unique constraint")) {
                    out.println("The username \"" + request.getParameter("username") + "\" has already " +"been taken. Please sign up again with a different username.");
                } else if(e.getMessage().contains("EMPTY STRING")) {
                    out.println("You must enter something in the username field. Please try again.");
                }else if(e.getMessage().contains("SPACES EXIST")){
                    out.println("You may not have spaces in your username. Please try again.");
                }
                else{
                    out.println("Your signup failed.");
                }
        }
                
     %>
        
        <p /><a href="signup.html">Return to signup page</a>
        
        <p /><a href="login.html">Login</a>
        
        
  </body>
</html>
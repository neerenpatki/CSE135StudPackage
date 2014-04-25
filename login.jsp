<html>
  <head>
    <title>Login Page</title>
  </head>
  <body>
    <%@ page import="java.sql.*"%>
    <%---------- Open Connection Code ----------%>
     <%          
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean loginFailed = false;
        
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
        // Check if an login is requested
        if (action != null && action.equals("login")) {
            String selectSQL = "SELECT username FROM owners WHERE ? = owners.username";
            pstmt = conn.prepareStatement(selectSQL);
            pstmt.setString(1, request.getParameter("username"));
            rs = pstmt.executeQuery();
            if(rs.next()){
                out.println("Hello "+ request.getParameter("username"));
            }
            else{ 
                out.println("The provided name \""+request.getParameter("username")+"\" is not known");
                loginFailed = true;
            }
        }
    %>
    <%if(loginFailed){%>
        <form method="GET" action="login.jsp">
            <input type="hidden" name="action" value="login"/>
            <b>Username:</b>
            <input type="text" name="username"/> <p />
            <input type="submit" value="Login"/>
        </form>
        <form action="signup.html">
            <input type="submit" value="signup">
        </form>
    <%}%>
        
  </body>
</html>
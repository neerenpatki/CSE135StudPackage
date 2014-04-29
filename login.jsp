<html>
  <head>
    <title>Login Page</title>
  </head>
  <body>
    <%@ page import="java.sql.*"
    import="java.util.ArrayList" %>
    <%---------- Open Connection Code ----------%>
     <%          
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean loginFailed = false;
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
            // Check if a login is requested
            if (action != null && action.equals("login")) {
                String selectSQL = "SELECT username, role FROM users WHERE ? = users.username";
                pstmt = conn.prepareStatement(selectSQL);
                pstmt.setString(1, request.getParameter("username"));
                rs = pstmt.executeQuery();
                // Login was successful
                if (rs.next()) {
                    out.println("Hello " + request.getParameter("username"));
                    // Store the username in the current session
                    session.setAttribute("userSession", rs.getString("username"));
                    session.setAttribute("userRole", rs.getString("role"));
                    // The user is an Owner
                    if (rs.getString("role").equals("Owner")) { %>
                        <jsp:forward page="categories.jsp">
                            <jsp:param name="Owner" value="OwnerLoggedIn"/>
                        </jsp:forward>
                        // Take them to the categories page
                    <%} else {// The user is a Customer
                        ArrayList<Integer> shoppingCart = new ArrayList<Integer>();
                        ArrayList<Integer> quantities = new ArrayList<Integer>();
                        session.setAttribute("shoppingCart", shoppingCart);
                        session.setAttribute("quantities", quantities);%>
                        <jsp:forward page="products_browsing.jsp?action=All+Products">
                            <jsp:param name="Customer" value="CustomerLoggedIn"/>
                        </jsp:forward>
                        // Take them to the product browsing page
                    <%}
                }
                else {
                    // Login failed with specified username 
                    out.println("The provided name \"" + request.getParameter("username") +
                     "\" is not known. Please try logging in again.");
                    loginFailed = true;
                }
            }
        } catch (SQLException e) {
            out.println("There was a problem logging in. Please try again.");
            //throw new RuntimeException(e);
        }
    %>
    <p/>
    <%if (loginFailed) {%>
        <form method="GET" action="login.jsp">
            <input type="hidden" name="action" value="login"/>
            <b>Username:</b>
            <input type="text" name="username"/> <p />
            <input type="submit" value="Login"/>
        </form>
        <form action="signup.html">
            <input type="submit" value="Sign Up">
        </form>
    <%}%>
        
  </body>
</html>
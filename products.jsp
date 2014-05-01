<html>
<head>
    <title>Products Page</title>
  </head>
<body>
<table>
    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <jsp:include page="menu2.jsp" />
        </td>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            String category = "";
            int catID = 0;
            int prodID = 0;
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            ResultSet catRS = null;
            ResultSet defaultValRS = null;
            String selectSQL2 = "";
            boolean emptyString = false;

            if (session.getAttribute("category") == null) {
                session.setAttribute("category", "categories.name");
            }
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/Project1DB?" +
                    "user=postgres&password=postgres");
                if (request.getParameter("name") != null)
                    emptyString = request.getParameter("name").equals("");
            %>

            <%-- -------- INSERT Code -------- --%>
            <%

                String action = request.getParameter("action");
                category = (String)session.getAttribute("category");  
                Statement statement = conn.createStatement();

                Statement insertSt = conn.createStatement();

                // Check if an insertion is requested
                if (action != null && action.equals("insert") && !emptyString) {

                    // Begin transaction
                    conn.setAutoCommit(false);
                    catID = Integer.parseInt(request.getParameter("categoryOption"));


                    // Get the ID of the product that will be inserted
                    String insertSQL = "INSERT INTO products (name, SKU, price) VALUES ('" + 
                        request.getParameter("name") + "', " +
                        request.getParameter("SKU") + ", " +
                        request.getParameter("price") + ") RETURNING id";
                    rs = insertSt.executeQuery(insertSQL);

                    if (rs.next()) {
                        prodID = rs.getInt("id");
                    }                    

                    pstmt = conn
                    .prepareStatement("INSERT INTO hasProduct (category, product) VALUES (?, ?)");

                    pstmt.setInt(1, catID);
                    pstmt.setInt(2, prodID);

                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%

                Statement updateSt = conn.createStatement();
                // Check if an update is requested
                if (action != null && action.equals("update") && !emptyString) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // UPDATE student values in the Students table.
                    pstmt = conn
                        .prepareStatement("UPDATE products SET name = ?, SKU = ?, price = ?" +
                        " WHERE id = ?");

                    pstmt.setString(1, request.getParameter("name"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("SKU")));
                    pstmt.setDouble(3, Double.parseDouble(request.getParameter("price")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    pstmt = conn
                        .prepareStatement("UPDATE hasProduct SET category = ?" +
                        " WHERE product = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("category")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("id")));
                    rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }

            %>
            <%-- -------- DELETE Code -------- --%>
            <%

                // Check if a delete is requested
                if (action != null && action.equals("delete") && !emptyString) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // DELETE students FROM the Students table.
                    pstmt = conn
                        .prepareStatement("DELETE FROM hasProduct WHERE product = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    pstmt = conn
                        .prepareStatement("DELETE FROM products WHERE id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                    rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>

            <%

                Statement allProdSt = conn.createStatement();
                String allProdSQL = "SELECT * from products";
                if (action != null && action.equals("All Products")) {
                    session.setAttribute("category", "categories.name");
                    rs = allProdSt.executeQuery(allProdSQL);
                }

            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement2 = conn.createStatement();
                String productRequest = request.getParameter("action");
                if (productRequest != null && !productRequest.equals("insert") && 
                !productRequest.equals("update") && !productRequest.equals("delete") && 
                !productRequest.equals("All Products") && !productRequest.equals("search")) {
                    category = productRequest;
                    session.setAttribute("category", "'" + category + "'");
                }
                selectSQL2 = "SELECT * FROM products WHERE id IN " +
                "(SELECT product FROM hasProduct WHERE category " +
                "IN (SELECT id FROM categories WHERE categories.name = " + (String)session.getAttribute("category") + "))";


                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                if (productRequest != null && !productRequest.equals("All Products"))
                    rs = statement2.executeQuery(selectSQL2);

            %>

             <%-- SEARCH Statement Code --%>
            <%
                if (action != null && action.equals("search")) {
                    Statement searchSt = conn.createStatement();
                    String searchSQL = "SELECT * FROM products WHERE name LIKE '%" + 
                    request.getParameter("searchValue") + "%' AND id IN (SELECT product FROM hasProduct WHERE category IN (SELECT id FROM categories WHERE categories.name = " + (String)session.getAttribute("category") + "))";
                    rs = searchSt.executeQuery(searchSQL);
                }
                out.println("Hello " + session.getAttribute("userSession") + "!");

            %>

            <% Statement catStatement = conn.createStatement();
                String categorySQL = "SELECT name, id FROM categories";
                catRS = catStatement.executeQuery(categorySQL);

            %>

            <form align="right" action="products.jsp">
                    <input type="hidden" name="action" value="search">
                    <b>Search for Products:</b>
                    <input type="text" name="searchValue" value="">
                    <input type="submit" value="Search">
            </form>
            
            <table border="1">
            <tr>
                <th>Product ID</th>
                <th>Category</th>
                <th>Product Name</th>
                <th>Product SKU</th>
                <th>Product Price</th>
            </tr>
            <tr>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th>
                     <SELECT NAME="categoryOption">
                    <%
                        while (catRS != null && catRS.next()) { %>
                            <OPTION value=<%=catRS.getInt("id")%>><%=catRS.getString("name")%></OPTION>
                        <%}%>
                        </SELECT>
                    </th>
                    <th><input value="" name="name" size="50"/></th>
                    <th><input value="" name="SKU" size="30"/></th>
                    <th><input value="" name="price" size="30"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>
                
            <%-- -------- Iteration Code -------- --%>
            <%

                // Iterate over the ResultSet
                while (rs.next()) {
                    categorySQL = "SELECT name, id FROM categories";
                    catRS = catStatement.executeQuery(categorySQL);
            %>

            <tr>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>

                <%-- Get the id --%>
                <td>
                    <%=rs.getInt("id")%>
                </td>

                <%-- Get the Category --%>
                <td>
                     <SELECT NAME="category">
                    <%
                        Statement defaultSt = conn.createStatement();
                        while (catRS != null && catRS.next()) {
                            categorySQL = "SELECT name FROM categories WHERE id IN (SELECT category FROM " + "hasProduct WHERE product = " + rs.getInt("id") + " )";
                            defaultValRS = defaultSt.executeQuery(categorySQL);
                            if (defaultValRS.next()) {
                                out.println(defaultValRS.getString("name"));
                                if  (defaultValRS.getString("name").equals(catRS.getString("name"))) { %>
                                    <OPTION value=<%=catRS.getInt("id")%> selected><%=catRS.getString("name")%></OPTION>
                                <%} else { %>
                                 <OPTION value=<%=catRS.getInt("id")%>><%=catRS.getString("name")%></OPTION>

                                <%}
                            }                            
                       }%>
                        </SELECT>
                </td>

                <%-- Get the product name --%>
                <td>
                    <input value="<%=rs.getString("name")%>" name="name" size="50"/>
                </td>

                <%-- Get the product SKU --%>
                <td>
                    <input value="<%=rs.getString("SKU")%>" name="SKU" size="30"/>
                </td>

                <%-- Get the product price --%>
                <td>
                    <input value="<%=rs.getDouble("price")%>" name="price" size="30"/>
                </td>

                <%-- Button --%>
                <td><input type="submit" value="Update"></td>
                </form>
                <form action="products.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=rs.getInt("id")%>" name="id"/>
                    <%-- Button --%>
                <td><input type="submit" value="Delete"/></td>
                </form>
            </tr>

            <%
                }
                rs = statement.executeQuery("SELECT * FROM products");
                catRS = statement.executeQuery("SELECT * FROM products");
                defaultValRS = statement.executeQuery("SELECT * FROM products");

            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();
                catRS.close();
                defaultValRS.close();


                // Close the Statement
                insertSt.close();

                allProdSt.close();

                statement.close();

                statement2.close();
                updateSt.close();
                catStatement.close();


                // Close the Connection
                conn.close();
            } catch (Exception e) {
                //out.println(e);
                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                /*if (e.getMessage().contains("duplicate key value violates unique constraint")) {
                    out.println("Another product already has the specified SKU number.");
                } else if (e.getMessage().contains("For input string:")) {
                    out.println("The product's SKU and price must be numbers.");
                }*/

                out.println(" Unable to perform operation specified on product.");
                //throw new RuntimeException(e);
            }
            finally {
                // Release resources in a finally block in reverse-order of
                // their creation

                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) { } // Ignore
                    rs = null;
                }
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { } // Ignore
                    pstmt = null;
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
            %>
        </table>
        </td>
    </tr>
</table>
</body>

</html>


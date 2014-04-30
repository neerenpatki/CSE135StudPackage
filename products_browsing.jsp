<html>

<body>
<table>
    <tr>
    <% if (session.getAttribute("userSession") != null) { %>

        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <jsp:include page="pbmenu.jsp" />
        </td>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"
            import="java.util.ArrayList" %>
            <%-- -------- Open Connection Code -------- --%>
            <%
            String category = "";
            String action = "";
            int catID = 0;
            int prodID = 0;
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            ResultSet catRS = null;
            ResultSet defaultValRS = null;
            String selectSQL2 = "";
            String addedProduct = request.getParameter("addedProduct");

                // This if statement will be entered if a product was added from product ordering page
                if (addedProduct != null) {
                    // Store product ID's in shopping cart
                    ArrayList<Integer> shoppingCart = new ArrayList<Integer>();
                    ArrayList<Integer> quantities = new ArrayList<Integer>();
                    shoppingCart = (ArrayList<Integer>)session.getAttribute("shoppingCart");
                    quantities = (ArrayList<Integer>)session.getAttribute("quantities");
                    //out.println(request.getParameter("quantity"));
                    quantities.add(Integer.parseInt(request.getParameter("quantity")));
                    shoppingCart.add((Integer)session.getAttribute("productID"));
                    session.setAttribute("shoppingCart", shoppingCart);
                }

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

                %>

                <%-- All Products Code --%>
                <%
                    action = request.getParameter("action");
                    Statement allProdSt = conn.createStatement();
                    String allProdSQL = "SELECT * from products";
                    if ((action != null && action.equals("All Products") || 
                    ((String)session.getAttribute("category")).equals("categories.name"))) {
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
                    !productRequest.equals("update") &&
                    !productRequest.equals("delete") && !productRequest.equals("All Products")) {
                        category = productRequest;
                        session.setAttribute("category", "'" + category + "'");
                    }

                    selectSQL2 = "SELECT * FROM products WHERE id IN " +
                    "(SELECT product FROM hasProduct WHERE category " +
                    "IN (SELECT id FROM categories WHERE categories.name = " + (String)session.getAttribute("category") + "))";


                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    if (productRequest != null && !productRequest.equals("All Products")) {
                        rs = statement2.executeQuery(selectSQL2);
                    }

                %>
                <% 
                    Statement catStatement = conn.createStatement();
                    String categorySQL = "SELECT name, id FROM categories";
                    catRS = catStatement.executeQuery(categorySQL);
                %>


                <%-- SEARCH Statement Code --%>
                <%

                    if (action != null && action.equals("search")) {
                        Statement searchSt = conn.createStatement();
                        String searchSQL = "SELECT * FROM products WHERE name LIKE '%" + 
                        request.getParameter("searchValue") + "%'";
                        rs = searchSt.executeQuery(searchSQL);
                    }

                 out.println("Hello " + session.getAttribute("userSession") + "!");
                %>

                <form align="right" action="products_browsing.jsp">
                    <input type="hidden" name="action" value="search">
                    <b>Search for Products:</b>
                    <input type="text" name="searchValue" value="">
                    <input type="submit" value="Search">
                </form>
                <!-- Add an HTML table header row to format the results -->
                <table border="1">
                <tr>
                    <th>Product ID</th>
                    <th width="400px">Category</th>
                    <th width="400px">Product Name</th>
                    <th width="150px">Product SKU</th>
                    <th width="150px">Product Price</th>
                </tr>
                <% 
                    //catStatement = conn.createStatement();
                    
                %>
                <%-- -------- Iteration Code -------- --%>

                <%
                    // Iterate over the ResultSet
                    while (rs != null && rs.next()) {
                        categorySQL = "SELECT name FROM categories WHERE id IN (SELECT category FROM " +
                        "hasProduct WHERE product = " + rs.getInt("id") + ")";
                        catRS = catStatement.executeQuery(categorySQL);

                %>

                <tr>

                    <%-- Get the id --%>
                    <td>
                        <%=rs.getInt("id")%>
                    </td>

                    <%-- Get the Category --%>
                    <td>
                        <%
                            while (catRS != null && catRS.next()) { %>
                                <%=catRS.getString("name")%>
                           <%}%>
                    </td>

                    <%-- Get the product name --%>
                    <td>
                        <a href="product_order.jsp?action=<%=rs.getInt("id")%>"><%=rs.getString("name")%></a>
                    </td>

                    <%-- Get the product SKU --%>
                    <td>
                        <%=rs.getString("SKU")%>
                    </td>

                    <%-- Get the product price --%>
                    <td>
                        <%=rs.getDouble("price")%>
                    </td>
                </tr>

                <%
                    }
                %>

                <%-- -------- Close Connection Code -------- --%>
                <%
                    // Close the ResultSet
                    rs.close();
                    catRS.close();
                    //defaultValRS.close();
                    // Close the Statement
                    //insertSt.close();

                    //allProdSt.close();

                    //statement.close();

                    statement2.close();
                    //updateSt.close();
                    catStatement.close();
                    //defaultSt.close();


                    // Close the Connection
                    conn.close();
                } catch (Exception e) {
                    out.println("Crash");
                    //throw new RuntimeException(e);
                    // Wrap the SQL exception in a runtime exception to propagate
                    // it upwards
                    /*if (e.getMessage().contains("duplicate key value violates unique constraint")) {
                        out.println("Another product already has the specified SKU number.");
                    } else if (e.getMessage().contains("For input string:")) {
                        out.println("The product's SKU and price must be numbers.");
                    }*/

                    //out.println(" Unable to perform operation specified on product.");
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
    <%} else {
                out.println("Please log in first!"); %>
                <p /><a href="login.html">Login</a>
           <%}%>
</table>
</body>

</html>


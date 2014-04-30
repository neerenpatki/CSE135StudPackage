<html>
<head>
    <title>Buy Shopping Cart Page</title>
  </head>
<body>
<table>
    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <jsp:include page="pbmenu.jsp" />
        </td>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"
            import="java.util.ArrayList"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            String category = "";
            String prodID = "";
            String prodName = "";
            double prodPrice = 0.0;
 
            prodID = request.getParameter("action");

            ArrayList<Integer> shoppingCart = (ArrayList<Integer>)session.getAttribute("shoppingCart");
            ArrayList<Integer> quantities = (ArrayList<Integer>)session.getAttribute("quantities");

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            Statement statement = null;
            
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/Project1DB?" +
                    "user=postgres&password=postgres");

                if (prodID != null) {
                    statement = conn.createStatement();

                    rs = statement.executeQuery("SELECT name, price FROM products WHERE id = " + prodID);
                    if (rs.next()) {
                        prodName = rs.getString("name");
                        prodPrice = rs.getDouble("price");
                    }
                    session.setAttribute("productID", Integer.parseInt(prodID));
                %>

                <table border="1">
                <tr>
                    <th>Product Name</th>
                    <th>Product Quantity</th>
                    <th>Product Price</th>
                </tr>
                <%-- -------- Iteration Code -------- --%>

                <tr>
                   
                    <%-- Button --%>
                    <form action="products_browsing.jsp?action=All+Products">
                        <input type="hidden" name="addedProduct" value="<%=prodID%>"/>
                        <td><%=prodName%></td>
                        <td><input type="text" name="quantity" value="1"/> </td>
                        <td><%=prodPrice%></td>
                        <td><input type="submit" value="Add to Shopping Cart"/></td>
                    </form>
                    
                </tr>

            </table><p />
            <% } %>

            <h4>Products Currently in Shopping Cart:</h4>
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>Product Name</th>
                <th>Product Quantity</th>
                <th>Product Price</th>
            </tr>
            <%-- -------- Iteration Code -------- --%>
            <% if (shoppingCart != null) {
                for (int i = 0; i < shoppingCart.size(); i++) { 
                    rs = statement.executeQuery("SELECT name, price FROM products WHERE id = " +
                    shoppingCart.get(i));
                    if (rs.next()) {

                %>
                    <tr>
                        <%-- Get the name --%>
                        <td><%=rs.getString("name")%>
                        </td>

                        <td><%=quantities.get(i)%></td>

                        <%-- Get the price --%>
                        <td><%=rs.getDouble("price")%>
                        </td>
                    </tr>
                <%  }
                }
            }%>

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();

                // Close the Statement
                statement.close();

                // Close the Connection
                conn.close();
            } catch (SQLException e) {
                //out.println(e);
                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                if (e.getMessage().contains("violates foreign key constraint")) {
                    out.println("The specified category was not deleted because there are still" +  
                    " products associated with that category.");
                } else if (e.getMessage().contains("duplicate key value violates unique constraint")) {
                    out.println("A category with the specified name already exists so no new category" +
                    " was created.");
                }
                out.println(" Unable to perform operation specified on category.");
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


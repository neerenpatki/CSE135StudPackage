<html>

<body>
<table>
    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <jsp:include page="menu2.jsp" />
        </td>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"
            import="java.util.ArrayList"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            String category = "";
            String prodName = "";
 
            prodName = request.getParameter("action");

            ArrayList<String> shoppingCart = (ArrayList<String>)session.getAttribute("shoppingCart");
            ArrayList<Integer> quantities = new ArrayList<Integer>();

            if (prodName != null) {
                session.setAttribute("productName", prodName);
            %>

            <table border="1">
            <tr>
                <th>Product Name</th>
                <th>Product Quantity</th>
            </tr>
            <%-- -------- Iteration Code -------- --%>

            <tr>
                <%-- Get the name --%>
                <td>
                    <%=prodName%>
                </td>

                <%-- Get the quantity --%>
                <td>
                    <input type="text" name="action" value="1"/>
                </td>

                <%-- Button --%>
                <td><form action="products_browsing.jsp?action=All+Products">
                    <input name="productName" value="<%=prodName%>"/> 
                    <input type="submit" name="addedProduct" value="Add to Shopping Cart"/>
                    </form>
                </td>

            </tr>

        </table><p />
        <% } %>
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>Product Name</th>
                <th>Product Quantity</th>
            </tr>
            <%-- -------- Iteration Code -------- --%>
            <% if (shoppingCart != null) {
                for (int i = 0; i < shoppingCart.size(); i++) { %>
            <tr>


                <%-- Get the name --%>
                <td><%=shoppingCart.get(i)%>
                </td>

                <%-- Get the Category --%>
                <td>
                </td>
            </tr>
                <%}
            }%>
        </table>
        </td>
    </tr>
</table>
</body>

</html>


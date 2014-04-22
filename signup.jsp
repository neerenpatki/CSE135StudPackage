<html>
  <head>
    <title>Sign Up Page (JSP)</title>
  </head>
  <body>
    <%
       //int times = 3;
       String username = request.getParameter("username");
       String age = request.getParameter("age");
    %>
    <%= "Your username: " + username %>
    <%= "Your Age: " + Integer.parseInt(age) %>

  </body>
</html>
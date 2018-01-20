<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />
            </td>
            <td>

            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {
                    // Load Oracle Driver class file
                    DriverManager.registerDriver
                        (new org.postgresql.Driver());
    
                    // Make a connection to the Oracle datasource "cse132b"
                    Connection conn = DriverManager.getConnection
                       ("jdbc:postgresql://localhost:5432/cse132","postgres", "admin");
            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO UndergraduateDegrees VALUES (?,?,?,?,?,?)");

                        pstmt.setString(1, request.getParameter("UNDERGRADUATEDEGREETITLE"));
                        pstmt.setInt(
                            2, Integer.parseInt(request.getParameter("MINLOWERDIVISIONUNITS")));
                        pstmt.setInt(
                            3, Integer.parseInt(request.getParameter("MINUPPERDIVISIONUNITS")));
                        pstmt.setInt(
                            4, Integer.parseInt(request.getParameter("TOTALUNITSREQUIRED")));
                        pstmt.setString(5, request.getParameter("AVERAGEGRADE"));
                        pstmt.setInt(
                            6, Integer.parseInt(request.getParameter("TECHNICALUNITSREQUIRED")));

                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE UndergraduateDegrees SET MINLOWERDIVISIONUNITS = ?," +
                            " MINUPPERDIVISIONUNITS = ?, TOTALUNITSREQUIRED = ?, AVERAGEGRADE = ?, TECHNICALUNITSREQUIRED = ? WHERE UNDERGRADUATEDEGREETITLE = ?");
                        
                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("MINLOWERDIVISIONUNITS")));
                        pstmt.setInt(
                            2, Integer.parseInt(request.getParameter("MINUPPERDIVISIONUNITS")));
                        pstmt.setInt(
                            3, Integer.parseInt(request.getParameter("TOTALUNITSREQUIRED")));
                        pstmt.setString(4, request.getParameter("AVERAGEGRADE"));
                        pstmt.setInt(
                            5, Integer.parseInt(request.getParameter("TECHNICALUNITSREQUIRED")));
                        pstmt.setString(6, request.getParameter("UNDERGRADUATEDEGREETITLE"));
                        

                        int rowCount = pstmt.executeUpdate();
                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- DELETE Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the student FROM the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM UndergraduateDegrees WHERE UNDERGRADUATEDEGREETITLE = ?");

                        pstmt.setString(1, request.getParameter("UNDERGRADUATEDEGREETITLE"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Undergraduatedegrees");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                         <th>Undergraduate Degree Title</th>
                         <th>Minimum Lower Division Units</th>
                         <th>Minimum Upper Division Units</th>
                         <th>Total Units Required</th>
                         <th>Minimum Grade Required</th>
                         <th>Tech Elective Units Required</th>
                         <th>Action</th>
                    </tr>
                    <tr>
                        <form action="undergraduatedegrees.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="UNDERGRADUATEDEGREETITLE" size="30"></th>
                            <th><input value="" name="MINLOWERDIVISIONUNITS" size="32"></th>
                            <th><input value="" name="MINUPPERDIVISIONUNITS" size="32"></th>
                            <th><input value="" name="TOTALUNITSREQUIRED" size="25"></th>
                            <th><input value="" name="AVERAGEGRADE" size="25"></th>
                            <th><input value="" name="TECHNICALUNITSREQUIRED" size="30"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="undergraduatedegrees.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the ID, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("UNDERGRADUATEDEGREETITLE") %>" 
                                    name="UNDERGRADUATEDEGREETITLE" size="25">
                            </td>    
                            <td>
                                <input value="<%= rs.getInt("MINLOWERDIVISIONUNITS") %>" 
                                    name="MINLOWERDIVISIONUNITS" size="30">
                            </td>    
                            <td>
                                <input value="<%= rs.getInt("MINUPPERDIVISIONUNITS") %>" 
                                    name="MINUPPERDIVISIONUNITS" size="30">
                            </td> 
                            <td>
                                <input value="<%= rs.getInt("TOTALUNITSREQUIRED") %>" 
                                    name="TOTALUNITSREQUIRED" size="25">
                            </td>   
                            <td>
                                <input value="<%= rs.getString("AVERAGEGRADE") %>" 
                                    name="AVERAGEGRADE" size="25">
                            </td> 
                            <td>
                                <input value="<%= rs.getInt("TECHNICALUNITSREQUIRED") %>" 
                                    name="TECHNICALUNITSREQUIRED" size="25">
                            </td> 
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="undergraduatedegrees.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("UNDERGRADUATEDEGREETITLE") %>" name="UNDERGRADUATEDEGREETITLE">
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Delete">
                            </td>
                        </form>
                    </tr>
            <%
                    }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
    
                    // Close the Statement
                    statement.close();
    
                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>

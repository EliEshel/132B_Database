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
                            "INSERT INTO Graduatedegrees VALUES (?,?,?)");

                        pstmt.setString(1, request.getParameter("GRADUATEDEGREETITLE"));
                        pstmt.setString(2, request.getParameter("CONCENTRATION"));
                        pstmt.setString(3, request.getParameter("TYPE"));

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
                            "UPDATE Graduatedegrees SET TYPE = ? WHERE CONCENTRATION = ? AND GRADUATEDEGREETITLE = ?");
                        
                        pstmt.setString(1, request.getParameter("TYPE"));
                        pstmt.setString(2, request.getParameter("CONCENTRATION"));
                        pstmt.setString(3, request.getParameter("GRADUATEDEGREETITLE"));
                        

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
                            "DELETE FROM Graduatedegrees WHERE CONCENTRATION = ? AND GRADUATEDEGREETITLE = ?");

                        pstmt.setString(1, request.getParameter("CONCENTRATION"));
                        pstmt.setString(2, request.getParameter("GRADUATEDEGREETITLE"));
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
                        ("SELECT * FROM Graduatedegrees");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                         <th>Graduate Degree Title</th>
                         <th>Concentration</th>
                         <th>Type</th>
                         <th>Action</th>
                    </tr>
                    <tr>
                        <form action="graduatedegrees.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="GRADUATEDEGREETITLE" size="28"></th>
                            <th><input value="" name="CONCENTRATION" size="20"></th>
                            <th><input value="" name="TYPE" size="20"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="graduatedegrees.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the ID, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("GRADUATEDEGREETITLE") %>" 
                                    name="GRADUATEDEGREETITLE" size="28">
                            </td>    
                            <td>
                                <input value="<%= rs.getString("CONCENTRATION") %>" 
                                    name="CONCENTRATION" size="20">
                            </td>   
                            <td>
                                <input value="<%= rs.getString("TYPE") %>" 
                                    name="TYPE" size="20">
                            </td>   
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="graduatedegrees.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("GRADUATEDEGREETITLE") %>" name="GRADUATEDEGREETITLE">
                            <input type="hidden" 
                                value="<%= rs.getString("CONCENTRATION") %>" name="CONCENTRATION">
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

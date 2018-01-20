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
                            "INSERT INTO studentpastclasses VALUES (?, ?, ?, ?)");

                        pstmt.setInt(1,Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setInt(2,Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setString(3, request.getParameter("GRADE"));
                        pstmt.setInt(4,Integer.parseInt(request.getParameter("UNITS")));

                        
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
                            "UPDATE studentpastclasses SET GRADE = ?, UNITS = ? WHERE STUDENTID = ? AND SECTIONID = ?");

                        pstmt.setString(1, request.getParameter("GRADE"));
                        pstmt.setInt(2,Integer.parseInt(request.getParameter("UNITS")));
                        pstmt.setInt(3,Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setInt(4,Integer.parseInt(request.getParameter("SECTIONID")));

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
                            "DELETE FROM studentpastclasses WHERE STUDENTID = ? AND SECTIONID = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("SECTIONID")));
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
                        ("SELECT * FROM studentpastclasses");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                         <th>Student ID</th>
                         <th>Section ID</th>
                         <th>Grade</th>
                         <th>Units</th>
                         <th>Action</th>
                    </tr>
                    <tr>
                        <form action="studentpastclasses.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENTID" size="12"></th>
                            <th><input value="" name="SECTIONID" size="12"></th>
                            <th><input value="" name="GRADE" size="10"></th>
                            <th><input value="" name="UNITS" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="studentpastclasses.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the STUDENT --%>
                            <td>
                                <input value="<%= rs.getInt("STUDENTID") %>" 
                                    name="STUDENTID" size="12">
                            </td>
                            <%-- Get the SECTIONED --%>
                            <td>
                                <input value="<%= rs.getInt("SECTIONID") %>" 
                                    name="SECTIONID" size="12">
                            </td> 
                            <%-- Get the GRADE --%>
                            <td>
                                <input value="<%= rs.getString("GRADE") %>" 
                                    name="GRADE" size="10">
                            </td>  
                            <td>
                                <input value="<%= rs.getInt("UNITS") %>" 
                                    name="UNITS" size="10">
                            </td>
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="studentpastclasses.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("STUDENTID") %>" name="STUDENTID">
                            <input type="hidden" 
                                value="<%= rs.getInt("SECTIONID") %>" name="SECTIONID">
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
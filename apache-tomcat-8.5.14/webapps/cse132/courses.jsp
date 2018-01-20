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
                            "INSERT INTO courses VALUES (?, ?, ?)");

                        pstmt.setString(1,request.getParameter("COURSENUMBER"));
                        pstmt.setBoolean(2, Boolean.parseBoolean(request.getParameter("LABREQUIREMENT")));
                        pstmt.setBoolean(3, Boolean.parseBoolean(request.getParameter("CONSENTOFINSTRUCTOR")));

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
                           "UPDATE courses SET LABREQUIREMENT = ?, " +
                            "CONSENTOFINSTRUCTOR = ? WHERE COURSENUMBER = ?");

                        pstmt.setBoolean(1, Boolean.parseBoolean(request.getParameter("LABREQUIREMENT")));
                        pstmt.setBoolean(2, Boolean.parseBoolean(request.getParameter("CONSENTOFINSTRUCTOR")));
                        pstmt.setString(3,request.getParameter("COURSENUMBER"));

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
                            "DELETE FROM courses WHERE COURSENUMBER = ?");

                        pstmt.setString(1,request.getParameter("COURSENUMBER"));
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
                        ("SELECT * FROM courses");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                         <th>Course Number</th>
                         <th>Lab Requirement</th>
                         <th>Consent of Instructor</th>
                         <th>Action</th>
                    </tr>
                    <tr>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="COURSENUMBER" size="20"></th>
                            <th><input value="" name="LABREQUIREMENT" size="20"></th>
                            <th><input value="" name="CONSENTOFINSTRUCTOR" size="25"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the COURSENUMBER --%>
                            <td>
                                <input value="<%= rs.getString("COURSENUMBER") %>" 
                                    name="COURSENUMBER" size="20">
                            </td> 
                            <%-- Get the LABREQUIREMENT --%>
                            <td>
                                <input value="<%= rs.getBoolean("LABREQUIREMENT") %>" 
                                    name="LABREQUIREMENT" size="20">
                            </td>   
                            <%-- Get the CONSENTOFINSTRUCTOR --%>
                            <td>
                                <input value="<%= rs.getBoolean("CONSENTOFINSTRUCTOR") %>" 
                                    name="CONSENTOFINSTRUCTOR" size="25">
                            </td> 
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("COURSENUMBER") %>" name="COURSENUMBER">
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
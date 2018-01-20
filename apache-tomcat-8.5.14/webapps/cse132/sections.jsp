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
                            "INSERT INTO sections VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

                        pstmt.setInt(1,Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setString(2, request.getParameter("QUARTER"));
                        pstmt.setInt(3,Integer.parseInt(request.getParameter("ENROLLMENTLIMIT")));
                        pstmt.setString(4,request.getParameter("COURSENUMBER"));
                        pstmt.setString(5,request.getParameter("CONCENTRATION"));
                        pstmt.setInt(6,Integer.parseInt(request.getParameter("YEAR")));
                        pstmt.setString(7, request.getParameter("LOWERUPPERDIVISION"));
                        pstmt.setBoolean(8, Boolean.parseBoolean(request.getParameter("TECHNICALELECTIVE")));
                        
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
                            "UPDATE sections SET QUARTER = ?, YEAR = ?, ENROLLMENTLIMIT = ?, COURSENUMBER = ?, CONCENTRATION = ?, LOWERUPPERDIVISION = ?, TECHNICALELECTIVE =? WHERE SECTIONID = ?");

                        pstmt.setString(1, request.getParameter("QUARTER"));
                        pstmt.setInt(2,Integer.parseInt(request.getParameter("YEAR")));
                        pstmt.setInt(3,Integer.parseInt(request.getParameter("ENROLLMENTLIMIT")));
                        pstmt.setString(4, request.getParameter("COURSENUMBER"));
                        pstmt.setString(5,request.getParameter("CONCENTRATION"));
                        pstmt.setString(6, request.getParameter("LOWERUPPERDIVISION"));
                        pstmt.setBoolean(7, Boolean.parseBoolean(request.getParameter("TECHNICALELECTIVE")));
                        pstmt.setInt(8,Integer.parseInt(request.getParameter("SECTIONID")));
                        


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
                            "DELETE FROM sections WHERE SECTIONID = ?");

                        pstmt.setInt(1,Integer.parseInt(request.getParameter("SECTIONID")));
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
                        ("SELECT * FROM sections");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                         <th>Section ID</th>
                         <th>Quarter</th>
                         <th>Year</th>
                         <th>Enrollment Limit</th>
                         <th>Course Number</th>
                         <th>Concentration</th>
                         <th>Lower/Upper Division</th>
                         <th>Technical Elective</th>
                         <th>Action</th>
                    </tr>
                    <tr>
                        <form action="sections.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SECTIONID" size="12"></th>
                            <th><input value="" name="QUARTER" size="10"></th>
                            <th><input value="" name="YEAR" size="10"></th>
                            <th><input value="" name="ENROLLMENTLIMIT" size="20"></th>
                            <th><input value="" name="COURSENUMBER" size="20"></th>
                            <th><input value="" name="CONCENTRATION" size="20"></th>
                            <th><input value="" name="LOWERUPPERDIVISION" size="23"></th>
                            <th><input value="" name="TECHNICALELECTIVE" size="20"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="sections.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SECTIONID --%>
                            <td>
                                <input value="<%= rs.getInt("SECTIONID") %>" 
                                    name="SECTIONID" size="12">
                            </td>
                            <%-- Get the QUARTER --%>
                            <td>
                                <input value="<%= rs.getString("QUARTER") %>" 
                                    name="QUARTER" size="10">
                            </td>  
                            <td>
                                <input value="<%= rs.getInt("YEAR") %>" 
                                    name="YEAR" size="10">
                            </td>  
                            <%-- Get the ENROLLMENTLIMIT --%>
                            <td>
                                <input value="<%= rs.getInt("ENROLLMENTLIMIT") %>" 
                                    name="ENROLLMENTLIMIT" size="20">
                            </td>   
                            <%-- Get the COURSENUMBER --%>
                            <td>
                                <input value="<%= rs.getString("COURSENUMBER") %>" 
                                    name="COURSENUMBER" size="20">
                            </td>  
                            <td>
                                <input value="<%= rs.getString("CONCENTRATION") %>" 
                                    name="CONCENTRATION" size="20">
                            </td> 
                            <td>
                                <input value="<%= rs.getString("LOWERUPPERDIVISION") %>" 
                                    name="LOWERUPPERDIVISION" size="20">
                            </td> 
                            <td>
                                <input value="<%= rs.getBoolean("TECHNICALELECTIVE") %>" 
                                    name="TECHNICALELECTIVE" size="20">
                            </td>  
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="sections.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
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

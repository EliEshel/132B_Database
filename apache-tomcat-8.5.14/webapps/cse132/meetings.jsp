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
                            "INSERT INTO meetings VALUES (?, ?, ?, ?, ?, ?, ?)");

                        pstmt.setInt(1,Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setString(2, request.getParameter("MEETINGTYPE"));
                        pstmt.setString(3, request.getParameter("MEETINGDATE"));
                        pstmt.setString(4, request.getParameter("MEETINGSTART"));
                        pstmt.setString(5, request.getParameter("BUILDING"));
                        pstmt.setString(6, request.getParameter("ROOM"));
                        pstmt.setString(7, request.getParameter("MEETINGEND"));

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
                            "UPDATE meetings SET MEETINGTYPE = ?, MEETINGDATE = ?, MEETINGSTART = ?, MEETINGEND = ?, BUILDING = ?, ROOM = ? WHERE SECTIONID = ?");

                        
                        pstmt.setString(1, request.getParameter("MEETINGTYPE"));
                        pstmt.setString(2, request.getParameter("MEETINGDATE"));
                        pstmt.setString(3, request.getParameter("MEETINGSTART"));
                        pstmt.setString(4, request.getParameter("MEETINGEND"));
                        pstmt.setString(5, request.getParameter("BUILDING"));
                        pstmt.setString(6, request.getParameter("ROOM"));
                        pstmt.setInt(7,Integer.parseInt(request.getParameter("SECTIONID")));

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
                            "DELETE FROM meetings WHERE SECTIONID = ?");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("SECTIONID")));
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
                        ("SELECT * FROM meetings");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                         <th>Section ID</th>
                         <th>Meeting Type</th>
                         <th>Meeting Date</th>
                         <th>Meeting Start Time</th>
                         <th>Meeting End Time</th>
                         <th>Building</th>
                         <th>Room</th>
                         <th>Action</th>
                    </tr>
                    <tr>
                        <form action="meetings.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SECTIONID" size="12"></th>
                            <th><input value="" name="MEETINGTYPE" size="20"></th>
                            <th><input value="" name="MEETINGDATE" size="20"></th>
                            <th><input value="" name="MEETINGSTART" size="20"></th>
                            <th><input value="" name="MEETINGEND" size="20"></th>
                            <th><input value="" name="BUILDING" size="20"></th>
                            <th><input value="" name="ROOM" size="20"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="meetings.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SECTIONID --%>
                            <td>
                                <input value="<%= rs.getInt("SECTIONID") %>" 
                                    name="SECTIONID" size="12">
                            </td>
                            <%-- Get the MEETINGTYPE --%>
                            <td>
                                <input value="<%= rs.getString("MEETINGTYPE") %>" 
                                    name="MEETINGTYPE" size="20">
                            </td>  
                            <%-- Get the MEETINGDATE --%>
                            <td>
                                <input value="<%= rs.getString("MEETINGDATE") %>" 
                                    name="MEETINGDATE" size="20">
                            </td>   
                            <%-- Get the MEETINGTIME --%>
                            <td>
                                <input value="<%= rs.getString("MEETINGSTART") %>" 
                                    name="MEETINGSTART" size="20">
                            </td> 
                            <td>
                                <input value="<%= rs.getString("MEETINGEND") %>" 
                                    name="MEETINGEND" size="20">
                            </td> 
                            <%-- Get the BUILDING --%>
                            <td>
                                <input value="<%= rs.getString("BUILDING") %>" 
                                    name="BUILDING" size="20">
                            </td> 
                            <%-- Get the ROOM --%>
                            <td>
                                <input value="<%= rs.getString("ROOM") %>" 
                                    name="ROOM" size="20">
                            </td> 
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="meetings.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("SECTIONID") %>" name="SECTIONID">
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
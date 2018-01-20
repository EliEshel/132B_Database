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
                            "INSERT INTO concentrations VALUES (?,?,?,?)");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setString(2, request.getParameter("CONCENTRATIONTITLE"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("UNITSNECESSARY")));
                        pstmt.setDouble(4, Double.parseDouble(request.getParameter("MINGPA")));

                        
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
                            "UPDATE concentrations SET UNITSNECESSARY = ?, MINGPA = ?" +
                            " WHERE STUDENTID = ? and CONCENTRATIONTITLE = ?");
                        
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("UNITSNECESSARY")));
                        pstmt.setDouble(2, Double.parseDouble(request.getParameter("MINGPA")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setString(4, request.getParameter("CONCENTRATIONTITLE"));

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
                            "DELETE FROM concentrations WHERE STUDENTID = ? and CONCENTRATIONTITLE = ?");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setString(2, request.getParameter("CONCENTRATIONTITLE"));
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
                        ("SELECT * FROM concentrations");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                         <th>Student ID</th>
                         <th>Concentration Title</th>
                         <th>Units Necessary</th>
                         <th>Minimum GPA</th>
                         <th>Action</th>
                    </tr>
                    <tr>
                        <form action="concentrations.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENTID" size="20"></th>
                            <th><input value="" name="CONCENTRATIONTITLE" size="25"></th>
                            <th><input value="" name="UNITSNECESSARY" size="25"></th>
                            <th><input value="" name="MINGPA" size="25"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="concentrations.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the ID, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("STUDENTID") %>" 
                                    name="STUDENTID" size="20">
                            </td>    
                            <td>
                                <input value="<%= rs.getString("CONCENTRATIONTITLE") %>" 
                                    name="CONCENTRATIONTITLE" size="25">
                            </td>    
                            <td>
                                <input value="<%= rs.getInt("UNITSNECESSARY") %>" 
                                    name="UNITSNECESSARY" size="25">
                            </td> 
                            <td>
                                <input value="<%= rs.getDouble("MINGPA") %>" 
                                    name="MINGPA" size="25">
                            </td> 
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="concentrations.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("STUDENTID") %>" name="STUDENTID">
                            <input type="hidden" 
                                value="<%= rs.getString("CONCENTRATIONTITLE") %>" name="CONCENTRATIONTITLE">
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

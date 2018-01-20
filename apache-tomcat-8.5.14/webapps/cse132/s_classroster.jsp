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

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <form action="s_classroster.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            
            <tr>
                         <th>Search Roster by Class Title</th>
                         <th>Action</th>
            </tr>
            

            <%

                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet res = statement.executeQuery
                        ("SELECT CLASSTITLE FROM Classes");

                     //USE THIS TO FIND THE RESULTSET VALUE. FIND THIS VALUE STORED AT THE BOTTOM OF CATALINA.OUT FILE.
               /*         System.out.println("VALUE STORED");
                        ResultSetMetaData rsmd = res.getMetaData();
                        int columnsNumber = rsmd.getColumnCount(); 
                        while ( res.next() ) {
                            for (int i = 1; i <= columnsNumber; i++) {
                               if (i > 1) System.out.print(",  ");
                               String columnValue = res.getString(i);
                               System.out.print(columnValue + " " + rsmd.getColumnName(i));
                            }
                            System.out.println("");
                        }
                */
            %>

            <!-- Add an HTML table header row to format the results -->
            <tr>
            <th>    
            <select name="CLASSTITLE">
            <%
                    while ( res.next() ) {
            %>

                            <option value="<%=res.getString(1)%>"><%=res.getString(1)%></option>

            <%
                    }
            %>
                            </select></th>
                            <th><input type="submit" value="Search"></th>
                        </form>
                    </tr>


            <%-- -------- QUERY Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("search")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        String query = "select distinct cl.COURSENUMBER, cl.CLASSTITLE, s.QUARTER from CLASSES cl, COURSES co, SECTIONS s where co.COURSENUMBER = cl.COURSENUMBER and co.COURSENUMBER = s.COURSENUMBER and CLASSTITLE = ?";
                        String query2 = "select s.STUDENTID, s.SSN, s.FIRSTNAME, s.MIDDLENAME, s.LASTNAME, s.RESIDENCY, s.ENROLLMENTSTATUS, s.DEGREESHELD, s.PERIODSOFATTENDANCE, cu.UNITS, cu.GRADINGOPTION from STUDENT s, CURRENTENROLLMENT cu, CLASSES cl where s.STUDENTID = cu.STUDENTID and cu.COURSENUMBER = cl.COURSENUMBER and CLASSTITLE = ?";

                        PreparedStatement pstmt = conn.prepareStatement(query);
                        PreparedStatement pstmt2 = conn.prepareStatement(query2);

                        pstmt.setString(1, request.getParameter("CLASSTITLE"));
                        pstmt2.setString(1, request.getParameter("CLASSTITLE"));
                        
                        ResultSet rs = pstmt.executeQuery();
                        ResultSet rs2 = pstmt2.executeQuery();

                        
                        /* //USE THIS TO FIND THE RESULTSET VALUE. FIND THIS VALUE STORED AT THE BOTTOM OF CATALINA.OUT FILE.
                        System.out.println("VALUE STORED");
                        ResultSetMetaData rsmd = rs.getMetaData();
                        int columnsNumber = rsmd.getColumnCount(); 
                        while ( rs.next() ) {
                            for (int i = 1; i <= columnsNumber; i++) {
                               if (i > 1) System.out.print(",  ");
                               String columnValue = rs.getString(i);
                               System.out.print(columnValue + " " + rsmd.getColumnName(i));
                            }
                            System.out.println("");
                        }*/


                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    
            %>
                    <tr>
                         <th>Course Number</th>
                         <th>Class Title</th>
                         <th>Quarter</th>
                    </tr>
            <%
                    
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="s_classroster.jsp" method="get">
                            <input type="hidden" value="search" name="action">

                           
                            <td>
                                <input value="<%= rs.getString("COURSENUMBER") %>" 
                                    name="COURSENUMBER" size="40">
                            </td>
                             <td>
                                <input value="<%= rs.getString("CLASSTITLE") %>" 
                                    name="CLASSTITLE" size="15">
                            </td>
                             <td>
                                <input value="<%= rs.getString("QUARTER") %>" 
                                    name="QUARTER" size="15">
                            </td>
                            </form>
                    </tr>
            <%
                    }

            %>

                    <tr>
                         <th><u>Form</font></u></th>
                    </tr>
                    <tr>
                         <th>Student ID</th>
                         <th>SSN</th>
                         <th>First Name</th>
                         <th>Middle Name</th>
                         <th>Last Name</th>
                         <th>Residency</th>
                         <th>Enrollment</th>
                         <th>Degrees Held</th>
                         <th>Periods of Attendance</th>
                         <th>Units</th>
                         <th>Grading Option</th>
                    </tr>

            <%
                    while ( rs2.next() ) {
            %>
                    <tr>
                        <form action="s_classroster.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs2.getInt(1) %>" 
                                    name="STUDENTID" size="40">
                            </td>
                             <td>
                                <input value="<%= rs2.getInt(2) %>" 
                                    name="SSN" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getString(3) %>" 
                                    name="FIRSTNAME" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getString(4) %>" 
                                    name="MIDDLENAME" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getString(5) %>" 
                                    name="LASTNAME" size="15">
                            </td>
                             <td>
                                <input value="<%= rs2.getString(6) %>" 
                                    name="RESIDENCY" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getBoolean(7) %>" 
                                    name="ENROLLMENTSTATUS" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getString(8) %>" 
                                    name="DEGREESHELD" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getString(9) %>" 
                                    name="PERIODSOFATTENDENCE" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getInt(10) %>" 
                                    name="UNITS" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getString(11) %>" 
                                    name="GRADINGOPTION" size="15">
                            </td>
                    </tr>

            <%
                    }

                    // Close the ResultSet
                    rs.close();
                    rs2.close();
    
                    // Close the Statement
                    //statement.close();
    
                    // Close the Connection
                    conn.close();
                }
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
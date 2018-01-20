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

            <table border="1">
                    <form action="s_remaininggraduate.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            
            <tr>
                         <th>Search Student by SSN</th>
                         <th>Search Graduate Degree Title</th>
                         <th>Action</th>
            </tr>
            

            <%

                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet res = statement.executeQuery
                        ("SELECT distinct SSN, GRADUATEDEGREETITLE FROM Student, GraduateDegrees");

                     //USE THIS TO FIND THE RESULTSET VALUE. FIND THIS VALUE STORED AT THE BOTTOM OF CATALINA.OUT FILE.
                       System.out.println("VALUE STORED");
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
                
            %>

            <!-- Add an HTML table header row to format the results -->
            <tr>
            <th>    
            <select name="SSN">
            <%
                    while ( res.next() ) {
            %>

                            <option value="<%=res.getInt(1)%>"><%=res.getInt(1)%></option>

            <%
                    }
            %>
                            </select></th>
            <th>    
            <select name="GRADUATEDEGREETITLE">
            <%
                    int hi = 1;
                    while (res.previous()){
                    hi = hi - 1;
                    }
                    System.out.println(hi);
                    while ( res.next() ) {
            %>

                            <option value="<%=res.getString(2)%>"><%=res.getString(2)%></option>

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
                        String query = "select SSN, FIRSTNAME, MIDDLENAME, LASTNAME from STUDENT where SSN = ?";
                        String query2 = "select CLASSES.COURSENUMBER, CLASSTITLE, SECTIONS.SECTIONID, QUARTER, UNITS from STUDENT, CURRENTENROLLMENT, COURSES, CLASSES, SECTIONS where STUDENT.STUDENTID = CURRENTENROLLMENT.STUDENTID and CURRENTENROLLMENT.COURSENUMBER = CLASSES.COURSENUMBER and CURRENTENROLLMENT.SECTIONID = SECTIONS.SECTIONID and COURSES.COURSENUMBER = CURRENTENROLLMENT.COURSENUMBER and SSN = ?";

                        PreparedStatement pstmt = conn.prepareStatement(query);
                        PreparedStatement pstmt2 = conn.prepareStatement(query2);

                        pstmt.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        pstmt2.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        
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
                         <th>Student SSN</th>
                         <th>First Name</th>
                         <th>Middle Name</th>
                         <th>Last Name</th>
                    </tr>
            <%
                    
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="s_remaininggraduate.jsp" method="get">
                            <input type="hidden" value="search" name="action">

                           
                            <td>
                                <input value="<%= rs.getInt("SSN") %>" 
                                    name="SSN" size="25">
                            </td>
                             <td>
                                <input value="<%= rs.getString("FIRSTNAME") %>" 
                                    name="FIRSTNAME" size="15">
                            </td>
                             <td>
                                <input value="<%= rs.getString("MIDDLENAME") %>" 
                                    name="MIDDLENAME" size="15">
                            </td>
                             <td>
                                <input value="<%= rs.getString("LASTNAME") %>" 
                                    name="LASTNAME" size="15">
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
                         <th>Course Number</th>
                         <th>Class Name</th>
                         <th>Section ID</th>
                         <th>Quarter</th>
                         <th>Units</th>
                    </tr>

            <%
                    while ( rs2.next() ) {
            %>
                    <tr>
                        <form action="s_remaininggraduate.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs2.getString(1) %>" 
                                    name="COURSNUMBER" size="25">
                            </td>
                             <td>
                                <input value="<%= rs2.getString(2) %>" 
                                    name="CLASSTITLE" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getInt(3) %>" 
                                    name="SECTIONID" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getString(4) %>" 
                                    name="QUARTER" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getInt(5) %>" 
                                    name="UNITS" size="20">
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
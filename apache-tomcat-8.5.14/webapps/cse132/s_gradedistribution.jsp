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
                    <form action="s_gradedistribution.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            
            <tr>
                         <th>Search Course Number</th>
                         <th>Search Professor</th>
                         <th>Search Quarter</th>
                         <th>Search Year</th>
                         <th>Action</th>
            </tr>
            

            <%

                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet res = statement.executeQuery
                        ("SELECT COURSENUMBER FROM Courses");

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
            <select name="COURSENUMBER">
            <%
                    while ( res.next() ) {
            %>

                            <option value="<%=res.getString(1)%>"><%=res.getString(1)%></option>

            <%
                    }
            %>
                            </select></th>
            <%

                    Statement statement2 = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet res2 = statement2.executeQuery
                        ("SELECT Facultyname FROM Faculty");

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
            <th>    
            <select name="FACULTYNAME">
            <%
                    while ( res2.next() ) {
            %>

                            <option value="<%=res2.getString(1)%>"><%=res2.getString(1)%></option>

            <%
                    }
            %>
                            </select></th>
            <%

                    Statement statement3 = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet res3 = statement3.executeQuery
                        ("SELECT distinct QUARTER FROM Sections");

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
            <th>    
            <select name="QUARTER">
            <%
                    while ( res3.next() ) {
            %>

                            <option value="<%=res3.getString(1)%>"><%=res3.getString(1)%></option>

            <%
                    }
            %>
                            </select></th>
            <%

                    Statement statement4 = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet res4 = statement4.executeQuery
                        ("SELECT distinct YEAR FROM Sections");

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
            <th>    
            <select name="YEAR">
            <%
                    while ( res4.next() ) {
            %>

                            <option value="<%=res4.getInt(1)%>"><%=res4.getInt(1)%></option>

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
                        String query = "select grade, sumgrade from CPQG where course = ? and professor = ? and quarter = ? and year = ?";

                        String query2 = "select grade, sumgrade from CPG where course = ? and professor = ?";

                        String query3 = "select 'A', sum(tableID.ID) from (select p.GRADE, count(p.GRADE) AS ID from STUDENTPASTCLASSES p, SECTIONS s where s.COURSENUMBER = ? and p.SECTIONID = s.SECTIONID and p.GRADE like 'A%' GROUP BY p.GRADE) as tableID union select 'B', sum(tableID.ID) from (select p.GRADE, count(p.GRADE) AS ID from STUDENTPASTCLASSES p, SECTIONS s where s.COURSENUMBER = ? and p.SECTIONID = s.SECTIONID and p.GRADE like 'B%' GROUP BY p.GRADE) as tableID union select 'C', sum(tableID.ID) from (select p.GRADE, count(p.GRADE) AS ID from STUDENTPASTCLASSES p, SECTIONS s where s.COURSENUMBER = ? and p.SECTIONID = s.SECTIONID and p.GRADE like 'C%' GROUP BY p.GRADE) as tableID union select 'D', sum(tableID.ID) from (select p.GRADE, count(p.GRADE) AS ID from STUDENTPASTCLASSES p, SECTIONS s where s.COURSENUMBER = ? and p.SECTIONID = s.SECTIONID and p.GRADE like 'D%' GROUP BY p.GRADE) as tableID";
                        String query4 = "select sum(g.NUMBER_GRADE)/count(p.GRADE) from STUDENTPASTCLASSES p, SECTIONS s, FACULTYCLASSES f, GRADE_CONVERSION g where s.COURSENUMBER = ? and g.LETTER_GRADE = p.GRADE and f.FACULTYNAME = ? and f.SECTIONID = p.SECTIONID and p.SECTIONID = s.SECTIONID";

                        PreparedStatement pstmt = conn.prepareStatement(query);
                        PreparedStatement pstmt2 = conn.prepareStatement(query2);
                        PreparedStatement pstmt3 = conn.prepareStatement(query3);
                        PreparedStatement pstmt4 = conn.prepareStatement(query4);

                        pstmt.setString(1, request.getParameter("COURSENUMBER"));
                        pstmt.setString(2, request.getParameter("FACULTYNAME"));
                        pstmt.setString(3, request.getParameter("QUARTER"));
                        pstmt.setInt(4,Integer.parseInt(request.getParameter("YEAR")));
                        pstmt2.setString(1, request.getParameter("COURSENUMBER"));
                        pstmt2.setString(2, request.getParameter("FACULTYNAME"));
                        pstmt3.setString(1, request.getParameter("COURSENUMBER"));
                        pstmt3.setString(2, request.getParameter("COURSENUMBER"));
                        pstmt3.setString(3, request.getParameter("COURSENUMBER"));
                        pstmt3.setString(4, request.getParameter("COURSENUMBER"));
                        pstmt4.setString(1, request.getParameter("COURSENUMBER"));
                        pstmt4.setString(2, request.getParameter("FACULTYNAME"));
                        
                        ResultSet rs = pstmt.executeQuery();
                        ResultSet rs2 = pstmt2.executeQuery();
                        ResultSet rs3 = pstmt3.executeQuery();
                        ResultSet rs4 = pstmt4.executeQuery();

                        
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
                         <th><u>Professor,Course,Quarter</font></u></th>
                    </tr>
                    <tr>
                         <th>Grade</th>
                         <th>Grade Count</th>
                    </tr>
            <%
                    
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="s_gradedistribution.jsp" method="get">
                            <input type="hidden" value="search" name="action">

                           
                            <td>
                                <input value="<%= rs.getString(1) %>" 
                                    name="GRADE" size="28">
                            </td>
                             <td>
                                <input value="<%= rs.getInt(2) %>" 
                                    name="GRADECOUNT" size="25">
                            </td>
                            </form>
                    </tr>
            <%
                    }

            %>

                    <tr>
                         <th><u>Professor,Course</font></u></th>
                    </tr>
                    <tr>
                         <th>Grade</th>
                         <th>Grade Count</th>
                    </tr>

            <%
                    while ( rs2.next() ) {
            %>
                    <tr>
                        <form action="s_gradedistribution.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs2.getString(1) %>" 
                                    name="GRADE" size="28">
                            </td>
                             <td>
                                <input value="<%= rs2.getInt(2) %>" 
                                    name="GRADECOUNT" size="25">
                            </td>
                    </tr>

            <%
                    }
            %>

                    <tr>
                         <th><u>Course</font></u></th>
                    </tr>
                    <tr>
                         <th>Grade</th>
                         <th>Grade Count</th>
                    </tr>

            <%
                    while ( rs3.next() ) {
            %>
                    <tr>
                        <form action="s_gradedistribution.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs3.getString(1) %>" 
                                    name="GRADE" size="28">
                            </td>
                             <td>
                                <input value="<%= rs3.getInt(2) %>" 
                                    name="GRADECOUNT" size="25">
                            </td>
                    </tr>

            <%
                    }
            %>

                    <tr>
                         <th>Grade Point Average</font></th>
                    </tr>

            <%
                    while ( rs4.next() ) {
            %>
                    <tr>
                        <form action="s_gradedistribution.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs4.getFloat(1) %>" 
                                    name="GPA" size="28">
                            </td>
                    </tr>

            <%
                    }

                    // Close the ResultSet
                    rs.close();
                    rs2.close();
                    rs3.close();
                    rs4.close();
    
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
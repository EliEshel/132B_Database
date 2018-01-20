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
                    <form action="s_gradereport.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            
            <tr>
                         <th>Search Grade Report by SSN</th>
                         <th>Action</th>
            </tr>
            

            <%

                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet res = statement.executeQuery
                        ("SELECT SSN FROM Student");

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
            <select name="SSN">
            <%
                    while ( res.next() ) {
            %>

                            <option value="<%=res.getInt(1)%>"><%=res.getInt(1)%></option>

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
                        String query2 = "select se.COURSENUMBER, st.SSN, se.SECTIONID, se.QUARTER, se.YEAR, p.GRADE, p.UNITS from STUDENT st, STUDENTPASTCLASSES p, SECTIONS se, CLASSES c where st.STUDENTID = p.STUDENTID and p.SECTIONID = se.SECTIONID and c.COURSENUMBER = se.COURSENUMBER and SSN = ? GROUP BY se.YEAR, se.QUARTER, se.COURSENUMBER, st.SSN, se.SECTIONID, p.GRADE, p.UNITS";
                        String query3 = "select sum(g.NUMBER_GRADE)/count(p.GRADE) from STUDENTPASTCLASSES p, STUDENT st, GRADE_CONVERSION g where st.STUDENTID = p.STUDENTID and p.GRADE = g.LETTER_GRADE and st.SSN = ?";
                        String query4 = "select s.QUARTER, s.YEAR, sum(g.NUMBER_GRADE)/count(p.GRADE) from STUDENTPASTCLASSES p, STUDENT st, GRADE_CONVERSION g, SECTIONS s where st.STUDENTID = p.STUDENTID and p.GRADE = g.LETTER_GRADE and s.SECTIONID = p.SECTIONID and st.SSN = ? GROUP BY s.YEAR, s.QUARTER";

                        PreparedStatement pstmt = conn.prepareStatement(query);
                        PreparedStatement pstmt2 = conn.prepareStatement(query2);
                        PreparedStatement pstmt3 = conn.prepareStatement(query3);
                        PreparedStatement pstmt4 = conn.prepareStatement(query4);

                        pstmt.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        pstmt2.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        pstmt3.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        pstmt4.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        
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
                         <th>Student SSN</th>
                         <th>First Name</th>
                         <th>Middle Name</th>
                         <th>Last Name</th>
                    </tr>
            <%
                    
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="s_gradereport.jsp" method="get">
                            <input type="hidden" value="search" name="action">

                           
                            <td>
                                <input value="<%= rs.getInt("SSN") %>" 
                                    name="SSN" size="32">
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
                         <th>Class Title</th>
                         <th>Section ID</th>
                         <th>Quarter</th>
                         <th>Year</th>
                         <th>Grade</th>
                         <th>Units</th>
                    </tr>

            <%
                    while ( rs2.next() ) {
            %>
                    <tr>
                        <form action="s_gradereport.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs2.getString(1) %>" 
                                    name="COURSNUMBER" size="32">
                            </td>
                             <td>
                                <input value="<%= rs2.getString(2) %>" 
                                    name="SSN" size="15">
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
                                    name="YEAR" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getString(6) %>" 
                                    name="GRADE" size="15">
                            </td>
                            <td>
                                <input value="<%= rs2.getInt(7) %>" 
                                    name="UNITS" size="15">
                            </td>

            <%
                    }
            %>
                    <tr>
                         <th>Cummulative GPA</th>
                    </tr>

            <%
                    while ( rs3.next() ) {
            %>
                    <tr>
                        <form action="s_gradereport.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs3.getFloat(1) %>" 
                                    name="GPA" size="32">
                            </td>

            <%
                    }
            %>
                <tr>
                             <th>Quarterly GPA</th>
                </tr>

                <%
                        while ( rs4.next() ) {
                %>
                        <tr>
                            <form action="s_gradereport.jsp" method="get">
                                <input type="hidden" value="search" name="action">
                                <td>
                                    <input value="<%= rs4.getString(1) %>" 
                                        name="QUARTER" size="32">
                                </td>
                                <td>
                                    <input value="<%= rs4.getString(2) %>" 
                                        name="YEAR" size="15">
                                </td>
                                <td>
                                    <input value="<%= rs4.getFloat(3) %>" 
                                        name="GPA" size="15">
                                </td>

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
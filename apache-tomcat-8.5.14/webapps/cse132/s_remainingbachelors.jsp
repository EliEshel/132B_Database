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
                    <form action="s_remainingbachelors.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            
            <tr>
                         <th>Search Student by SSN</th>
                         <th>Search Undergraduate Degree Title</th>
                         <th>Action</th>
            </tr>
            

            <%

                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet res = statement.executeQuery
                        ("SELECT distinct SSN FROM Student");               
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
            </select>
            <%
                    statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    res = statement.executeQuery
                        ("SELECT distinct UNDERGRADUATEDEGREETITLE FROM UnderGraduateDegrees");
            %>
            <th>
            <select name="UNDERGRADUATEDEGREETITLE">
            <%
                    while (res.next()){

            %>

                            <option value="<%=res.getString(1)%>"><%=res.getString(1)%></option>
            <%
                }
            %>

            </select>
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
                        String query = "select distinct s.SSN, s.FIRSTNAME, s.MIDDLENAME, s.LASTNAME, w.UNDERGRADDEGREETITLE from WORKINGUNDERGRADDEGREE w, STUDENT s, UNDERGRADUATEDEGREES g where SSN = ? and w.UNDERGRADDEGREETITLE = ? and s.STUDENTID = w.STUDENTID and w.UNDERGRADDEGREETITLE = g.UNDERGRADUATEDEGREETITLE";
                        String query2 = "select g.TOTALUNITSREQUIRED, g.MINLOWERDIVISIONUNITS, g.MINUPPERDIVISIONUNITS from WORKINGUNDERGRADDEGREE w, STUDENT s, UNDERGRADUATEDEGREES g where SSN = ? and w.UNDERGRADDEGREETITLE = ? and s.STUDENTID = w.STUDENTID and w.UNDERGRADDEGREETITLE = g.UNDERGRADUATEDEGREETITLE";

                        String query3 = "select sc.COURSENUMBER, sp.UNITS, sc.TECHNICALELECTIVE from STUDENTPASTCLASSES sp, SECTIONS sc, STUDENT s where s.SSN = ? and sc.SECTIONID = sp.SECTIONID and s.STUDENTID = sp.STUDENTID";

                        //String query4 = "select (sum(sp.UNITS)), (sum(sp.UNITS)), (sum(sp.UNITS)) from STUDENTPASTCLASSES sp, SECTIONS sc, STUDENT s, UNDERGRADUATEDEGREES g, WORKINGUNDERGRADDEGREE w where s.SSN = ? and w.UNDERGRADDEGREETITLE = ? and sc.SECTIONID = sp.SECTIONID and s.STUDENTID = sp.STUDENTID and w.STUDENTID = s.STUDENTID and w.UNDERGRADDEGREETITLE = g.UNDERGRADUATEDEGREETITLE";

                        String query4 = "select (u.TOTALUNITSREQUIRED - sum(p.UNITS)) from STUDENT s, STUDENTPASTCLASSES p, UNDERGRADUATEDEGREES u, WORKINGUNDERGRADDEGREE w, SECTIONS se where s.SSN = ? and s.STUDENTID = w.STUDENTID and w.UNDERGRADDEGREETITLE = u.UNDERGRADUATEDEGREETITLE and s.STUDENTID = p.STUDENTID and se.SECTIONID = p.SECTIONID GROUP BY u.TOTALUNITSREQUIRED";

                        String query5 = "select (u.MINLOWERDIVISIONUNITS - sum(p.UNITS)) from STUDENT s, STUDENTPASTCLASSES p, UNDERGRADUATEDEGREES u, WORKINGUNDERGRADDEGREE w, SECTIONS se where s.SSN = ? and s.STUDENTID = w.STUDENTID and w.UNDERGRADDEGREETITLE = u.UNDERGRADUATEDEGREETITLE and s.STUDENTID = p.STUDENTID and se.SECTIONID = p.SECTIONID and se.LOWERUPPERDIVISION = 'Lower' GROUP BY u.MINLOWERDIVISIONUNITS";

                        String query6 = "select (u.MINUPPERDIVISIONUNITS - sum(p.UNITS)) from STUDENT s, STUDENTPASTCLASSES p, UNDERGRADUATEDEGREES u, WORKINGUNDERGRADDEGREE w, SECTIONS se where s.SSN = ? and s.STUDENTID = w.STUDENTID and w.UNDERGRADDEGREETITLE = u.UNDERGRADUATEDEGREETITLE and s.STUDENTID = p.STUDENTID and se.SECTIONID = p.SECTIONID and se.LOWERUPPERDIVISION = 'Upper' GROUP BY u.MINUPPERDIVISIONUNITS";

                        String query7 = "select (u.TECHNICALUNITSREQUIRED - sum(p.UNITS)) from STUDENT s, STUDENTPASTCLASSES p, UNDERGRADUATEDEGREES u, WORKINGUNDERGRADDEGREE w, SECTIONS se where s.SSN = ? and s.STUDENTID = w.STUDENTID and w.UNDERGRADDEGREETITLE = u.UNDERGRADUATEDEGREETITLE and s.STUDENTID = p.STUDENTID and se.SECTIONID = p.SECTIONID and se.TECHNICALELECTIVE = true GROUP BY u.TECHNICALUNITSREQUIRED";

                        
 
                        PreparedStatement pstmt = conn.prepareStatement(query);
                        PreparedStatement pstmt2 = conn.prepareStatement(query2);
                        PreparedStatement pstmt3 = conn.prepareStatement(query3);
                        PreparedStatement pstmt4 = conn.prepareStatement(query4);
                        PreparedStatement pstmt5 = conn.prepareStatement(query5);
                        PreparedStatement pstmt6 = conn.prepareStatement(query6);
                        PreparedStatement pstmt7 = conn.prepareStatement(query7);

                        pstmt.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        pstmt.setString(2, request.getParameter("UNDERGRADUATEDEGREETITLE"));
                        pstmt2.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        pstmt2.setString(2, request.getParameter("UNDERGRADUATEDEGREETITLE"));
                        pstmt3.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        pstmt4.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        pstmt5.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        pstmt6.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        pstmt7.setInt(1,Integer.parseInt(request.getParameter("SSN")));


                        
                        ResultSet rs = pstmt.executeQuery();
                        ResultSet rs2 = pstmt2.executeQuery();
                        ResultSet rs3 = pstmt3.executeQuery();
                        ResultSet rs4 = pstmt4.executeQuery();
                        ResultSet rs5 = pstmt5.executeQuery();
                        ResultSet rs6 = pstmt6.executeQuery();
                        ResultSet rs7 = pstmt7.executeQuery();

                        
                         //USE THIS TO FIND THE RESULTSET VALUE. FIND THIS VALUE STORED AT THE BOTTOM OF CATALINA.OUT FILE.
                        /*System.out.println("VALUE STORED2");
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
                         <th>Undergraduate Degree Title</th>
                    </tr>
            <%
                    
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="s_remainingbachelors.jsp" method="get">
                            <input type="hidden" value="search" name="action">

                           
                            <td>
                                <input value="<%= rs.getInt(1) %>" 
                                    name="SSN" size="42">
                            </td>
                             <td>
                                <input value="<%= rs.getString(2) %>" 
                                    name="FIRSTNAME" size="42">
                            </td>
                             <td>
                                <input value="<%= rs.getString(3) %>" 
                                    name="MIDDLENAME" size="42">
                            </td>
                             <td>
                                <input value="<%= rs.getString(4) %>" 
                                    name="LASTNAME" size="42">
                            </td>
                            <td>
                                <input value="<%= rs.getString(5) %>" 
                                    name="UNDERGRADUATEDEGREETITLE" size="30">
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
                         <th>Total Units Required</th>
                         <th>Minimum Lower Units Required</th>
                         <th>Minimum Upper Units Required</th>
                    </tr>

            <%
                    while ( rs2.next() ) {
            %>
                    <tr>
                        <form action="s_remainingbachelors.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs2.getInt(1) %>" 
                                    name="TOTALUNITSREQUIRED" size="42">
                            </td>
                            <td>
                                <input value="<%= rs2.getInt(2) %>" 
                                    name="MINLOWERDIVISIONUNITS" size="42">
                            </td>
                            <td>
                                <input value="<%= rs2.getInt(3) %>" 
                                    name="MINUPPERDIVISIONUNITS" size="42">
                            </td>
                            </form>
                    </tr>

            <%
                    }
            %>

                    <tr>
                         <th>Class Completed</th>
                         <th>Units</th>
                         <th>Technical Elective</th>
                    </tr>

            <%
                    while ( rs3.next() ) {
            %>
                    <tr>
                        <form action="s_remainingbachelors.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs3.getString(1) %>" 
                                    name="COURSENUMBER" size="42">
                            </td>
                            <td>
                                <input value="<%= rs3.getInt(2) %>" 
                                    name="UNITS" size="42">
                            </td>
                            <td>
                                <input value="<%= rs3.getBoolean(3) %>" 
                                    name="TECHNICALELECTIVE" size="42">
                            </td>
                            </form>
                    </tr>

            <%
                    }
            %>

                    <tr>
                         <th>Total Units Remaining</th>
                         <th>Lower Division Units Remaining</th>
                         <th>Upper Division Units Remaining</th>
                         <th>Tech Elective Units Remaining</th>
                    </tr>

            <%
                    while ( rs4.next() ) {
            %>
                    <tr>
                        <form action="s_remainingbachelors.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs4.getInt(1) %>" 
                                    name="TOTALUNITSREMAINING" size="42">
                            </td>
                            </form>
                    

            <%
                    }
            %>



            <%
                    while ( rs5.next() ) {
            %>
                    
                        <form action="s_remainingbachelors.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs5.getInt(1) %>" 
                                    name="LOWERDIVREMAINING" size="42">
                            </td>
                            </form>
                  

            <%
                    }
            %>



            <%
                    while ( rs6.next() ) {
            %>
                    
                        <form action="s_remainingbachelors.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs6.getInt(1) %>" 
                                    name="UPPERDIVREMAINING" size="42">
                            </td>
                            </form>
                    

            <%
                    }
            %>
                


            <%
                    while ( rs7.next() ) {
            %>
                    
                        <form action="s_remainingbachelors.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                          <td>
                                <input value="<%= rs7.getInt(1) %>" 
                                    name="TECHNICALUNITSREMAINING" size="42">
                            </td>
                            </form>
                    </tr>


            <%
                    }/*
            %>
                         <th>Next Offered Quarter</th>
                         <th>Year</th>

            <%
                    while ( rs4.next() ) {
            %>
                    <tr>
                        <form action="s_remaininggraduate.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs4.getString(1) %>" 
                                    name="QUARTER" size="42">
                            </td>
                            <td>
                                <input value="<%= rs4.getInt(2) %>" 
                                    name="YEAR" size="42">
                            </td>
                            </form>
                    </tr>

            <%
                    }*/

                    // Close the ResultSet
                    rs.close();
                    rs2.close();
                    rs3.close();
                    rs4.close();
                    rs5.close();
                    rs6.close();
                    rs7.close();
    
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

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
                        ("SELECT distinct GRADUATEDEGREETITLE FROM GraduateDegrees");
            %>
            <th>
            <select name="GRADDEGREETITLE">
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
                        String query = "select distinct s.SSN, s.FIRSTNAME, s.MIDDLENAME, s.LASTNAME, w.GRADDEGREETITLE, g.TYPE from WORKINGGRADDEGREE w, STUDENT s, GRADUATEDEGREES g where SSN = ? and w.GRADDEGREETITLE = ? and s.STUDENTID = w.STUDENTID and w.GRADDEGREETITLE = g.GRADUATEDEGREETITLE";
                        String query2 = "select c.CONCENTRATIONTITLE from WORKINGGRADDEGREE w, STUDENT s, SECTIONS se, STUDENTPASTCLASSES p, STUDENTPASTCLASSES ps, CONCENTRATIONS c, GRADE_CONVERSION g, GRADUATEDEGREES gr where s.SSN = ? and gr.GRADUATEDEGREETITLE = ? and w.GRADDEGREETITLE = gr.GRADUATEDEGREETITLE and se.SECTIONID = p.SECTIONID and c.CONCENTRATIONTITLE = gr.CONCENTRATION and w.STUDENTID = s.STUDENTID and s.STUDENTID = c.STUDENTID and c.STUDENTID = p.STUDENTID and c.CONCENTRATIONTITLE = se.CONCENTRATION and ps.GRADE = 'S' and p.GRADE = g.LETTER_GRADE GROUP BY c.CONCENTRATIONTITLE, c.UNITSNECESSARY, c.MINGPA HAVING (sum(p.UNITS)+sum(ps.UNITS)) >= c.UNITSNECESSARY and sum(g.NUMBER_GRADE)/count(p.GRADE) >= c.MINGPA union select c.CONCENTRATIONTITLE from WORKINGGRADDEGREE w, STUDENT s, SECTIONS se, STUDENTPASTCLASSES p, CONCENTRATIONS c, GRADE_CONVERSION g, GRADUATEDEGREES gr where s.SSN = ? and gr.GRADUATEDEGREETITLE = ? and w.GRADDEGREETITLE = gr.GRADUATEDEGREETITLE and se.SECTIONID = p.SECTIONID and c.CONCENTRATIONTITLE = gr.CONCENTRATION and w.STUDENTID = s.STUDENTID and s.STUDENTID = c.STUDENTID and c.STUDENTID = p.STUDENTID and c.CONCENTRATIONTITLE = se.CONCENTRATION and p.GRADE = g.LETTER_GRADE GROUP BY c.CONCENTRATIONTITLE, c.UNITSNECESSARY, c.MINGPA HAVING sum(p.UNITS) >= c.UNITSNECESSARY and sum(g.NUMBER_GRADE)/count(p.GRADE) >= c.MINGPA";
                        //String query3 = "select distinct c.COURSENUMBER from COURSES c, SECTIONS se, STUDENT s, GRADUATEDEGREES g, WORKINGGRADDEGREE w where c.COURSENUMBER = se.COURSENUMBER and g.GRADUATEDEGREETITLE = ? and g.GRADUATEDEGREETITLE = w.GRADDEGREETITLE and g.CONCENTRATION = se.CONCENTRATION and w.STUDENTID = s.STUDENTID and c.COURSENUMBER not in (select s.COURSENUMBER from SECTIONS s, STUDENT st, STUDENTPASTCLASSES p where p.SECTIONID = s.SECTIONID and st.SSN = ?)";
                        String query3 = "select * from (select c.COURSENUMBER, min(se.QUARTER), min(se.YEAR), ROW_NUMBER() OVER (PARTITION BY c.COURSENUMBER ORDER BY min(se.YEAR)) AS RowNumber from SECTIONS se, COURSES c where (se.YEAR > 2005 or (se.YEAR = 2005 and se.QUARTER = 'Fall')) and se.COURSENUMBER = c.COURSENUMBER and se.COURSENUMBER in (select distinct c.COURSENUMBER from COURSES c, SECTIONS se, STUDENT s, GRADUATEDEGREES g, WORKINGGRADDEGREE w where c.COURSENUMBER = se.COURSENUMBER and s.SSN = ? and g.GRADUATEDEGREETITLE = ? and g.GRADUATEDEGREETITLE = w.GRADDEGREETITLE and g.CONCENTRATION = se.CONCENTRATION and w.STUDENTID = s.STUDENTID and c.COURSENUMBER not in (select s.COURSENUMBER from SECTIONS s, STUDENT st, STUDENTPASTCLASSES p where p.SECTIONID = s.SECTIONID and st.SSN = ?)) group by c.COURSENUMBER, se.YEAR, se.QUARTER) AS a WHERE a.RowNumber = 1";

                        PreparedStatement pstmt = conn.prepareStatement(query);
                        PreparedStatement pstmt2 = conn.prepareStatement(query2);
                        PreparedStatement pstmt3 = conn.prepareStatement(query3);
                        //PreparedStatement pstmt4 = conn.prepareStatement(query4);

                        pstmt.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        pstmt.setString(2, request.getParameter("GRADDEGREETITLE"));
                        pstmt2.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        pstmt2.setString(2, request.getParameter("GRADDEGREETITLE"));
                        pstmt2.setInt(3,Integer.parseInt(request.getParameter("SSN")));
                        pstmt2.setString(4, request.getParameter("GRADDEGREETITLE"));
                        pstmt3.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        pstmt3.setString(2, request.getParameter("GRADDEGREETITLE"));
                        pstmt3.setInt(3,Integer.parseInt(request.getParameter("SSN")));
                        //pstmt4.setString(1, request.getParameter("GRADDEGREETITLE"));
                        //pstmt4.setInt(2,Integer.parseInt(request.getParameter("SSN")));

                        
                        ResultSet rs = pstmt.executeQuery();
                        ResultSet rs2 = pstmt2.executeQuery();
                        ResultSet rs3 = pstmt3.executeQuery();
                        //ResultSet rs4 = pstmt4.executeQuery();

                        
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
                         <th>Graduate Degree Title</th>
                         <th>Type</th>
                    </tr>
            <%
                    
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="s_remaininggraduate.jsp" method="get">
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
                                    name="LASTNAME" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString(5) %>" 
                                    name="GRADDEGREETITLE" size="30">
                            </td>
                             <td>
                                <input value="<%= rs.getString(6) %>" 
                                    name="TYPE" size="15">
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
                         <th>Completed Concentrations</th>
                    </tr>

            <%
                    while ( rs2.next() ) {
            %>
                    <tr>
                        <form action="s_remaininggraduate.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs2.getString(1) %>" 
                                    name="CONCENTRATION" size="42">
                            </td>
                            </form>
                    </tr>

            <%
                    }
            %>

                    <tr>
                         <th>Incomplete Classes in Concentrations</th>
                         <th>Next Offered Quarter,</th>
                         <th>Year</th>

            <%
                    while ( rs3.next() ) {
            %>
                    <tr>
                        <form action="s_remaininggraduate.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs3.getString(1) %>" 
                                    name="COURSENUMBER" size="42">
                            </td>
                            <td>
                                <input value="<%= rs3.getString(2) %>" 
                                    name="QUARTER" size="42">
                            </td>
                            <td>
                                <input value="<%= rs3.getInt(3) %>" 
                                    name="YEAR" size="42">
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
                    //rs4.close();
    
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
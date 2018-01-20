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
                    <form action="s_classschedule.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            
            <tr>
                         <th>Search Student by SSN</th>
                         <th>Action</th>
            </tr>
            

            <%

                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet res = statement.executeQuery
                        ("SELECT SSN FROM Student where Student.Enrollmentstatus = true");

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
                        String query = "select distinct SSN, FIRSTNAME, MIDDLENAME, LASTNAME from STUDENT where SSN = ?";
                        String query2 = "select distinct c.CLASSTITLE, c.COURSENUMBER, s.SECTIONID, ce.CLASSTITLE, ce.COURSENUMBER, se.SECTIONID from CLASSES c, CLASSES ce, SECTIONS s, SECTIONS se, MEETINGS m, MEETINGS me, ALLMEETINGS a, ALLMEETINGS l, ALLMEETINGS h, ALLMEETINGS x, ALLMEETINGS y, ALLMEETINGS z where a.ROW >= l.ROW and a.ROW < h.ROW and l.DATE = me.MEETINGDATE and l.TIMES = me.MEETINGSTART and h.TIMES = me.MEETINGEND and h.DATE = me.MEETINGDATE and x.ROW = a.ROW and x.ROW >= y.ROW and x.ROW < z.ROW and y.DATE = m.MEETINGDATE and y.TIMES = m.MEETINGSTART and z.TIMES = m.MEETINGEND and z.DATE = m.MEETINGDATE and m.SECTIONID in (select m.SECTIONID from MEETINGS m, ALLMEETINGS a, ALLMEETINGS l, ALLMEETINGS h where a.ROW >= l.ROW and a.ROW < h.ROW and l.DATE = m.MEETINGDATE and l.TIMES = m.MEETINGSTART and h.TIMES = m.MEETINGEND and h.DATE = m.MEETINGDATE and a.ROW in (select a.ROW from CURRENTENROLLMENT c, STUDENT s, MEETINGS m, ALLMEETINGS a, ALLMEETINGS l, ALLMEETINGS h where a.ROW >= l.ROW and a.ROW < h.ROW and l.DATE = m.MEETINGDATE and l.TIMES = m.MEETINGSTART and h.TIMES = m.MEETINGEND and h.DATE = m.MEETINGDATE and c.SECTIONID = m.SECTIONID and c.STUDENTID = s.STUDENTID and s.SSN = ?)) and m.SECTIONID <> me.SECTIONID and s.COURSENUMBER = c.COURSENUMBER and se.COURSENUMBER = ce.COURSENUMBER and m.SECTIONID = s.SECTIONID and me.SECTIONID = se.SECTIONID";

                        //String query2 = "select a.DATE, a.TIMES from MEETINGS me, MEETINGS m, ALLMEETINGS a, ALLMEETINGS l, ALLMEETINGS h, ALLMEETINGS x, ALLMEETINGS y, ALLMEETINGS z where a.ROW >= l.ROW and a.ROW < h.ROW and l.DATE = me.MEETINGDATE and l.TIMES = me.MEETINGSTART and h.TIMES = me.MEETINGEND and h.DATE = me.MEETINGDATE and x.ROW = a.ROW and x.ROW >= y.ROW and x.ROW < z.ROW and y.DATE = m.MEETINGDATE and y.TIMES = m.MEETINGSTART and z.TIMES = m.MEETINGEND and z.DATE = m.MEETINGDATE";

                        //String query2 = "select a.ROW from MEETINGS m, ALLMEETINGS a, ALLMEETINGS l, ALLMEETINGS h where a.ROW >= l.ROW and a.ROW < h.ROW and l.DATE = m.MEETINGDATE and l.TIMES = m.MEETINGSTART and m.MEETINGEND = h.TIMES and h.DATE = m.MEETINGDATE";

                        PreparedStatement pstmt = conn.prepareStatement(query);
                        PreparedStatement pstmt2 = conn.prepareStatement(query2);

                        pstmt.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        pstmt2.setInt(1,Integer.parseInt(request.getParameter("SSN")));
                        //pstmt2.setInt(2,Integer.parseInt(request.getParameter("SSN")));
                        
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
                        <form action="s_classschedule.jsp" method="get">
                            <input type="hidden" value="search" name="action">

                           
                            <td>
                                <input value="<%= rs.getInt("SSN") %>" 
                                    name="SSN" size="25">
                            </td>
                             <td>
                                <input value="<%= rs.getString("FIRSTNAME") %>" 
                                    name="FIRSTNAME" size="30">
                            </td>
                             <td>
                                <input value="<%= rs.getString("MIDDLENAME") %>" 
                                    name="MIDDLENAME" size="30">
                            </td>
                             <td>
                                <input value="<%= rs.getString("LASTNAME") %>" 
                                    name="LASTNAME" size="30">
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
                         <th>Conflicted Class Title</th>
                         <th>Conflicted Course Number</th>
                         <th>Conflicted Section ID</th>
                         <th>Conflicting Class Title</th>
                         <th>Conflicting Coursenumber</th>
                         <th>Conflicting Section ID</th>
                    </tr>

            <%
                    while ( rs2.next() ) {
            %>
                    <tr>
                        <form action="s_classschedule.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs2.getString(1) %>" 
                                    name="MEETINGS" size="25">
                            </td>
                            <td>
                                <input value="<%= rs2.getString(2) %>" 
                                    name="MEETINGS" size="30">
                            </td>
                            <td>
                                <input value="<%= rs2.getInt(3) %>" 
                                    name="MEETINGS" size="30">
                            </td>
                            <td>
                                <input value="<%= rs2.getString(4) %>" 
                                    name="MEETINGS" size="30">
                            </td>
                            <td>
                                <input value="<%= rs2.getString(5) %>" 
                                    name="MEETINGS" size="30">
                            </td>
                            <td>
                                <input value="<%= rs2.getInt(6) %>" 
                                    name="MEETINGS" size="25">
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
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
                    <form action="s_meetingtimes.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            
            <tr>
                         <th>Search Open Times by Section ID</th>
                         <th>Starting Date</th>
                         <th>Ending Date</th>
                         <th>Action</th>
            </tr>
            

            <%

                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet res = statement.executeQuery
                        ("SELECT SECTIONID FROM Sections");

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
            <select name="SECTIONID">
            <%
                    while ( res.next() ) {
            %>

                            <option value="<%=res.getInt(1)%>"><%=res.getInt(1)%></option>

            <%
                    }
            %>
                            </select></th>
            <%

                    Statement statement2 = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet res2 = statement2.executeQuery
                        ("SELECT distinct DATE FROM Allmeetings");

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
            <select name="STARTDATE">
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
                        ("SELECT distinct DATE FROM Allmeetings");

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
            <select name="ENDDATE">
            <%
                    while ( res3.next() ) {
            %>

                            <option value="<%=res3.getString(1)%>"><%=res3.getString(1)%></option>

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
                        String query = "select s.SECTIONID, s.COURSENUMBER from SECTIONS s where s.SECTIONID = ?";
                        String query2 = "select a.DATE, a.TIMES from ALLMEETINGS a where a.ROW not in (select a.ROW FROM ALLMEETINGS a, MEETINGS m where m.SECTIONID in (select c.SECTIONID from CURRENTENROLLMENT c where c.STUDENTID in (select c.STUDENTID from CURRENTENROLLMENT c where c.SECTIONID = ?)) and a.TIMES >= m.MEETINGSTART and a.DATE = m.MEETINGDATE and a.TIMES < MEETINGEND) and a.ROW in (select a.ROW from ALLMEETINGS a where a.ROW >= (select a.ROW from ALLMEETINGS a where a.DATE = ? and a.TIMES = '8:00 AM') and a.ROW <= (select a.ROW from ALLMEETINGS a where a.DATE = ? and a.TIMES = '8:00 PM')) ";

                        PreparedStatement pstmt = conn.prepareStatement(query);
                        PreparedStatement pstmt2 = conn.prepareStatement(query2);

                        pstmt.setInt(1,Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt2.setInt(1,Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt2.setString(2, request.getParameter("STARTDATE"));
                        //pstmt2.setString(3, request.getParameter("STARTTIME"));
                        pstmt2.setString(3, request.getParameter("ENDDATE"));
                        //pstmt2.setString(5, request.getParameter("ENDTIME"));
                        
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
                         <th>Section ID</th>
                         <th>Course Number</th>
                    </tr>
            <%
                    
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="s_meetingtimes.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs.getInt("SECTIONID") %>" 
                                    name="SECTIONID" size="40">
                            </td>
                             <td>
                                <input value="<%= rs.getString("COURSENUMBER") %>" 
                                    name="COURSENUMBER" size="40">
                            </td>
                    </tr>
            <%
                    }

            %>

                    <tr>
                         <th><u>Form</font></u></th>
                    </tr>
                    <tr>
                         <th>Dates</th>
                         <th>Times</th>
                    </tr>

            <%
                    while ( rs2.next() ) {
            %>
                    <tr>
                        <form action="s_meetingtimes.jsp" method="get">
                            <input type="hidden" value="search" name="action">
                            <td>
                                <input value="<%= rs2.getString(1) %>" 
                                    name="DATES" size="40">
                            </td>
                            <td>
                                <input value="<%= rs2.getString(2) %>" 
                                    name="TIMES" size="40">
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
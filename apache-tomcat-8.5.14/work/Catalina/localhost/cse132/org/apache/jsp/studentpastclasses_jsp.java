/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/8.5.14
 * Generated at: 2017-05-11 04:51:17 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;

public final class studentpastclasses_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent,
                 org.apache.jasper.runtime.JspSourceImports {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  private static final java.util.Set<java.lang.String> _jspx_imports_packages;

  private static final java.util.Set<java.lang.String> _jspx_imports_classes;

  static {
    _jspx_imports_packages = new java.util.HashSet<>();
    _jspx_imports_packages.add("java.sql");
    _jspx_imports_packages.add("javax.servlet");
    _jspx_imports_packages.add("javax.servlet.http");
    _jspx_imports_packages.add("javax.servlet.jsp");
    _jspx_imports_classes = null;
  }

  private volatile javax.el.ExpressionFactory _el_expressionfactory;
  private volatile org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public java.util.Set<java.lang.String> getPackageImports() {
    return _jspx_imports_packages;
  }

  public java.util.Set<java.lang.String> getClassImports() {
    return _jspx_imports_classes;
  }

  public javax.el.ExpressionFactory _jsp_getExpressionFactory() {
    if (_el_expressionfactory == null) {
      synchronized (this) {
        if (_el_expressionfactory == null) {
          _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
        }
      }
    }
    return _el_expressionfactory;
  }

  public org.apache.tomcat.InstanceManager _jsp_getInstanceManager() {
    if (_jsp_instancemanager == null) {
      synchronized (this) {
        if (_jsp_instancemanager == null) {
          _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
        }
      }
    }
    return _jsp_instancemanager;
  }

  public void _jspInit() {
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
      throws java.io.IOException, javax.servlet.ServletException {

    final java.lang.String _jspx_method = request.getMethod();
    if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method) && !javax.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
      response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSPs only permit GET POST or HEAD");
      return;
    }

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("<html>\n");
      out.write("\n");
      out.write("<body>\n");
      out.write("    <table border=\"1\">\n");
      out.write("        <tr>\n");
      out.write("            <td valign=\"top\">\n");
      out.write("                ");
      out.write("\n");
      out.write("                ");
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "menu.html", out, false);
      out.write("\n");
      out.write("            </td>\n");
      out.write("            <td>\n");
      out.write("\n");
      out.write("            ");
      out.write("\n");
      out.write("            ");
      out.write("\n");
      out.write("            \n");
      out.write("    \n");
      out.write("            ");
      out.write("\n");
      out.write("            ");

                try {
                    // Load Oracle Driver class file
                    DriverManager.registerDriver
                        (new org.postgresql.Driver());
    
                    // Make a connection to the Oracle datasource "cse132b"
                    Connection conn = DriverManager.getConnection
                       ("jdbc:postgresql://localhost:5432/cse132","postgres", "admin");
            
      out.write("\n");
      out.write("\n");
      out.write("            ");
      out.write("\n");
      out.write("            ");

                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO studentpastclasses VALUES (?, ?, ?)");

                        pstmt.setInt(1,Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setInt(2,Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setString(3, request.getParameter("GRADE"));

                        
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            
      out.write("\n");
      out.write("\n");
      out.write("            ");
      out.write("\n");
      out.write("            ");

                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE studentpastclasses SET GRADE = ? WHERE STUDENTID = ? AND SECTIONID = ?");

                        pstmt.setString(1, request.getParameter("GRADE"));
                        pstmt.setInt(2,Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setInt(3,Integer.parseInt(request.getParameter("SECTIONID")));

                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            
      out.write("\n");
      out.write("\n");
      out.write("            ");
      out.write("\n");
      out.write("            ");

                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the student FROM the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM studentpastclasses WHERE STUDENTID = ? AND SECTIONID = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENTID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("SECTIONID")));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            
      out.write("\n");
      out.write("\n");
      out.write("            ");
      out.write("\n");
      out.write("            ");

                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM studentpastclasses");
            
      out.write("\n");
      out.write("\n");
      out.write("            <!-- Add an HTML table header row to format the results -->\n");
      out.write("                <table border=\"1\">\n");
      out.write("                    <tr>\n");
      out.write("                         <th>Student ID</th>\n");
      out.write("                         <th>Section ID</th>\n");
      out.write("                         <th>Grade</th>\n");
      out.write("                         <th>Action</th>\n");
      out.write("                    </tr>\n");
      out.write("                    <tr>\n");
      out.write("                        <form action=\"studentpastclasses.jsp\" method=\"get\">\n");
      out.write("                            <input type=\"hidden\" value=\"insert\" name=\"action\">\n");
      out.write("                            <th><input value=\"\" name=\"STUDENTID\" size=\"12\"></th>\n");
      out.write("                            <th><input value=\"\" name=\"SECTIONID\" size=\"12\"></th>\n");
      out.write("                            <th><input value=\"\" name=\"GRADE\" size=\"10\"></th>\n");
      out.write("                            <th><input type=\"submit\" value=\"Insert\"></th>\n");
      out.write("                        </form>\n");
      out.write("                    </tr>\n");
      out.write("\n");
      out.write("            ");
      out.write("\n");
      out.write("            ");

                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            
      out.write("\n");
      out.write("\n");
      out.write("                    <tr>\n");
      out.write("                        <form action=\"studentpastclasses.jsp\" method=\"get\">\n");
      out.write("                            <input type=\"hidden\" value=\"update\" name=\"action\">\n");
      out.write("\n");
      out.write("                            ");
      out.write("\n");
      out.write("                            <td>\n");
      out.write("                                <input value=\"");
      out.print( rs.getInt("STUDENTID") );
      out.write("\" \n");
      out.write("                                    name=\"STUDENTID\" size=\"12\">\n");
      out.write("                            </td>\n");
      out.write("                            ");
      out.write("\n");
      out.write("                            <td>\n");
      out.write("                                <input value=\"");
      out.print( rs.getInt("SECTIONID") );
      out.write("\" \n");
      out.write("                                    name=\"SECTIONID\" size=\"12\">\n");
      out.write("                            </td> \n");
      out.write("                            ");
      out.write("\n");
      out.write("                            <td>\n");
      out.write("                                <input value=\"");
      out.print( rs.getString("GRADE") );
      out.write("\" \n");
      out.write("                                    name=\"GRADE\" size=\"10\">\n");
      out.write("                            </td>  \n");
      out.write("                            ");
      out.write("\n");
      out.write("                            <td>\n");
      out.write("                                <input type=\"submit\" value=\"Update\">\n");
      out.write("                            </td>\n");
      out.write("                        </form>\n");
      out.write("                        <form action=\"studentpastclasses.jsp\" method=\"get\">\n");
      out.write("                            <input type=\"hidden\" value=\"delete\" name=\"action\">\n");
      out.write("                            <input type=\"hidden\" \n");
      out.write("                                value=\"");
      out.print( rs.getInt("STUDENTID") );
      out.write("\" name=\"STUDENTID\">\n");
      out.write("                            <input type=\"hidden\" \n");
      out.write("                                value=\"");
      out.print( rs.getInt("SECTIONID") );
      out.write("\" name=\"SECTIONID\">\n");
      out.write("                            ");
      out.write("\n");
      out.write("                            <td>\n");
      out.write("                                <input type=\"submit\" value=\"Delete\">\n");
      out.write("                            </td>\n");
      out.write("                        </form>\n");
      out.write("                    </tr>\n");
      out.write("            ");

                    }
            
      out.write("\n");
      out.write("\n");
      out.write("            ");
      out.write("\n");
      out.write("            ");

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
            
      out.write("\n");
      out.write("                </table>\n");
      out.write("            </td>\n");
      out.write("        </tr>\n");
      out.write("    </table>\n");
      out.write("</body>\n");
      out.write("\n");
      out.write("</html>");
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}

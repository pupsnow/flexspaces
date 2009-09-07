<%@ page language="java" extends="org.jboss.portal.core.servlet.jsp.PortalJsp" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet" %>

<portlet:defineObjects/>

<form method="post" action="<portlet:actionURL/>">
   <table>
      <tr class="portlet-msg-alert">
`        <td colspan="2"><%= request.getParameter("message") != null ?  request.getParameter("message") : ""%></td>
      </tr>
      <tr class="portlet-section-body">
         <td>FlexSpaces SWF URL</td>
         <td><input type="text" name="flexspacesSwfUrl" value="<%= request.getAttribute("flexspacesSwfUrl") %>" size="50"/></td>
      </tr>
      <tr class="portlet-section-body">
         <td>FlexSpaces Base URL</td>
         <td><input type="text" name="flexspacesBaseUrl" value="<%= request.getAttribute("flexspacesBaseUrl") %>" size="50"/></td>
      </tr>
      <tr class="portlet-section-body">
         <td>Width</td>
         <td><input type="text" name="flashWidth" value="<%= request.getAttribute("flashWidth") %>"/></td>
      </tr>      
      <tr class="portlet-section-body">
         <td>Height</td>
         <td><input type="text" name="flashHeight" value="<%= request.getAttribute("flashHeight") %>"/></td>
      </tr>
      <tr class="portlet-section-body">
         <td>Show DocLib</td>
         <td><input type="text" name="showDocLib" value="<%= request.getAttribute("showDocLib") %>" /></td>
      </tr>
      <tr class="portlet-section-body">
         <td>Show Search</td>
         <td><input type="text" name="showSearch" value="<%= request.getAttribute("showSearch") %>" /></td>
      </tr>
      <tr class="portlet-section-body">
         <td>Show Tasks</td>
         <td><input type="text" name="showTasks" value="<%= request.getAttribute("showTasks") %>" /></td>
      </tr>
      <tr class="portlet-section-body">
         <td>Show WCM</td>
         <td><input type="text" name="showWcm" value="<%= request.getAttribute("showWcm") %>" /></td>
      </tr>
      <tr class="portlet-section-body">
         <td>Show Header</td>
         <td><input type="text" name="showHeader" value="<%= request.getAttribute("showHeader") %>" /></td>
      </tr>
      <tr class="portlet-section-body">
         <td>Show CoverFlow</td>
         <td><input type="text" name="haveCoverFlow" value="<%= request.getAttribute("haveCoverFlow") %>" /></td>
      </tr>
      <tr class="portlet-section-body">
         <td>Alfresco URL</td>
         <td><input type="text" name="alfrescoUrl" value="<%= request.getAttribute("alfrescoUrl") %>" size="50" /></td>
      </tr>      
      <tr class="portlet-section-body">
         <td align="right"><input type="submit" name="op" value="Update"/></td>
         <td align="left"><input type="submit" name="op" value="Cancel"/></td>
      </tr>
    </table>
</form>

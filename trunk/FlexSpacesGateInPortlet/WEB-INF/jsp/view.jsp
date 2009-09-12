<%@ page %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet" %>
<%@ page isELIgnored="false" %>

<portlet:defineObjects/>

<%
      String align = "middle";
      String allowScriptAccess = "sameDomain";
      String bgcolor = "#000000";
      String devicefont = "true";
      String loop = "true";
      String menu = "false";
      String play = "true";
      String quality = "best";
      String salign = "";
      String scale = "showall";
      String swliveconnect = "false";
      String wmode = "opaque";
      
      String flexspacesSwfUrl = request.getAttribute("flexspacesSwfUrl").toString();
      String flexspacesBaseUrl = request.getAttribute("flexspacesBaseUrl").toString();
      String flashWidth = request.getAttribute("flashWidth").toString();
      String flashHeight = request.getAttribute("flashHeight").toString();
      String showDocLib = request.getAttribute("showDocLib").toString();
      String showSearch = request.getAttribute("showSearch").toString();
      String showTasks = request.getAttribute("showTasks").toString();
      String showWcm = request.getAttribute("showWcm").toString();
      String showHeader = request.getAttribute("showHeader").toString();
      String haveCoverFlow = request.getAttribute("haveCoverFlow").toString();
      String alfrescoUrl = request.getAttribute("alfrescoUrl").toString();

      String flashVariables = "doclib=" + showDocLib + "&search=" + showSearch + "&tasks=" + showTasks + "&wcm=" + showWcm + "&header=" + showHeader 
                              + "&coverflow=" + haveCoverFlow + "&alfrescourl=" + alfrescoUrl;
      //                      + "&coverflow=" + haveCoverFlow + "&alfrescourl=" + alfrescoUrl + "&user=admin&pw=admin&autologin=false";
%>



<center>
   <object width="<%= flashWidth %>" height="<%= flashHeight %>">
   
      <param name="movie" value="<%= flexspacesSwfUrl %>"/>
      
      <embed      
         align="<%= align %>"
         allowScriptAccess="<%= allowScriptAccess %>"
         base="<%= flexspacesBaseUrl %>" 
         bgcolor="<%= bgcolor %>"
         devicefont="<%= devicefont %>"
         flashvars="<%= flashVariables %>"
         height="<%= flashHeight %>"         
         loop="<%= loop %>"
         menu="<%= menu %>"
         play="<%= play %>"
         quality="<%= quality %>"
         salign="<%= salign %>"
         scale="<%= scale %>"
         src="<%= flexspacesSwfUrl %>"          
         swliveconnect="<%= swliveconnect %>"
         width="<%= flashWidth %>" 
         wmode="<%= wmode %>"         
      </embed>
   </object>
</center>


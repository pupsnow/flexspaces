
<%@ include file="/init.jsp" %>

<c:choose>
   <c:when test="<%= Validator.isNotNull(flexspacesSwfUrl) %>">

      <%

      String align = "left";
      String allowScriptAccess = "sameDomain";
      String base = ".";
      String bgcolor = "#000000";
      String devicefont = "true";
      String height = flashHeight;
      String loop = "true";
      String menu = "false";
      String play = "false";
      String quality = "best";
      String salign = "";
      String scale = "showall";
      String swliveconnect = "false";
      String width = "100%";
      String wmode = "opaque";

      String flashVariables = "doclib=" + showDocLib + "&search=" + showSearch + "&tasks=" + showTasks + "&wcm=" + showWcm + "&header=" + showHeader 
                              + "&coverflow=" + haveCoverFlow + "&alfrescourl=" + alfrescoUrl;
  //                          + "&coverflow=" + haveCoverFlow + "&alfrescourl=" + alfrescoUrl + "&user=admin&pw=admin&autologin=false";
      %>

      <liferay-ui:flash
         align="<%= align %>"
         allowScriptAccess="<%= allowScriptAccess %>"
         base="<%= base %>"
         bgcolor="<%= bgcolor %>"
         devicefont="<%= devicefont %>"
         flashvars="<%= flashVariables %>"
         height="<%= height %>"
         loop="<%= loop %>"
         menu="<%= menu %>"
         movie="<%= flexspacesSwfUrl %>"
         play="<%= play %>"
         quality="<%= quality %>"
         salign="<%= salign %>"
         scale="<%= scale %>"
         swliveconnect="<%= swliveconnect %>"
         width="<%= width %>"
         wmode="<%= wmode %>"
      />
   </c:when>
   <c:otherwise>
      <liferay-util:include page="/html/portal/portlet_not_setup.jsp" />
   </c:otherwise>
</c:choose>
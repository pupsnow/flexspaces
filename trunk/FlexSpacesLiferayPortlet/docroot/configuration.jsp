
<%@ include file="/init.jsp" %>

<%
if (flexspacesSwfUrl.equals(StringPool.BLANK))
{
    String contextName = "flexspaces-liferay-portlet";
    flexspacesSwfUrl = HttpUtil.getProtocol(request) + "://" + request.getServerName() + ":" + request.getServerPort() + "/" + contextName + "/FlexSpaces.swf";    
}

if (flashHeight.equals(StringPool.BLANK))
{
   flashHeight = "700";
}

if (showDocLib.equals(StringPool.BLANK))
{
   showDocLib = "true";
}

if (showSearch.equals(StringPool.BLANK))
{
   showSearch = "true";
}

if (showTasks.equals(StringPool.BLANK))
{
   showTasks = "true";
}

if (showWcm.equals(StringPool.BLANK))
{
   showWcm = "false";
}

if (showHeader.equals(StringPool.BLANK))
{
   showHeader = "true";
}

if (haveCoverFlow.equals(StringPool.BLANK))
{
   haveCoverFlow = "false";
}

if (alfrescoUrl.equals(StringPool.BLANK))
{
   alfrescoUrl = "http://localhost:8080/alfresco/service";
}

flexspacesSwfUrl = ParamUtil.getString(request, "flexspacesSwfUrl", flexspacesSwfUrl);
flashHeight = ParamUtil.getString(request, "flashHeight", flashHeight);
showDocLib = ParamUtil.getString(request, "showDocLib", showDocLib);
showSearch = ParamUtil.getString(request, "showSearch", showSearch);
showTasks = ParamUtil.getString(request, "showTasks", showTasks);
showWcm = ParamUtil.getString(request, "showWcm", showWcm);
showHeader = ParamUtil.getString(request, "showHeader", showHeader);
haveCoverFlow = ParamUtil.getString(request, "haveCoverFlow", haveCoverFlow);
alfrescoUrl = ParamUtil.getString(request, "alfrescoUrl", alfrescoUrl);

%>

<form action="<liferay-portlet:actionURL portletConfiguration="true" />" method="post" name="<portlet:namespace />fm">
<input name="<portlet:namespace /><%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />

<table class="lfr-table">
<tr>
   <td>
      FlexSpaces SWF
   </td>
   <td>
      <input class="lfr-input-text" name="<portlet:namespace />flexspacesSwfUrl" type="text" value="<%= flexspacesSwfUrl %>" />
   </td>
</tr>
<tr>
   <td>
      Height
   </td>
   <td>
      <input class="lfr-input-text" name="<portlet:namespace />flashHeight" type="text" value="<%= flashHeight %>" />
   </td>
</tr>
<tr>
   <td>
      Show DocLib
   </td>
   <td>
      <input class="lfr-input-text" name="<portlet:namespace />showDocLib" type="text" value="<%= showDocLib %>" />
   </td>
</tr>
<tr>
   <td>
      Show Search
   </td>
   <td>
      <input class="lfr-input-text" name="<portlet:namespace />showSearch" type="text" value="<%= showSearch %>" />
   </td>
</tr>
<tr>
   <td>
      Show Tasks
   </td>
   <td>
      <input class="lfr-input-text" name="<portlet:namespace />showTasks" type="text" value="<%= showTasks %>" />
   </td>
</tr>
<tr>
   <td>
      Show WCM
   </td>
   <td>
      <input class="lfr-input-text" name="<portlet:namespace />showWcm" type="text" value="<%= showWcm %>" />
   </td>
</tr>
<tr>
   <td>
      Show Header
   </td>
   <td>
      <input class="lfr-input-text" name="<portlet:namespace />showHeader" type="text" value="<%= showHeader %>" />
   </td>
</tr>
<tr>
   <td>
      Show CoverFlow
   </td>
   <td>
      <input class="lfr-input-text" name="<portlet:namespace />haveCoverFlow" type="text" value="<%= haveCoverFlow %>" />
   </td>
</tr>
<tr>
   <td>
      Alfresco URL
   </td>
   <td>
      <input class="lfr-input-text" name="<portlet:namespace />alfrescoUrl" type="text" value="<%= alfrescoUrl %>" />
   </td>
</tr>

</table>

<br />

<input type="button" value="<liferay-ui:message key="save" />" onClick="submitForm(document.<portlet:namespace />fm);" />

</form>

<c:if test="<%= windowState.equals(WindowState.MAXIMIZED) %>">
   <script type="text/javascript">
      Liferay.Util.focusFormField(document.<portlet:namespace />fm.<portlet:namespace />movie);
   </script>
</c:if>
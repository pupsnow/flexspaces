
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>

<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.GetterUtil" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="com.liferay.portal.kernel.util.PropertiesUtil" %>
<%@ page import="com.liferay.portal.kernel.util.StringPool" %>
<%@ page import="com.liferay.portal.kernel.util.StringUtil" %>
<%@ page import="com.liferay.portal.kernel.util.Validator" %>
<%@ page import="com.liferay.portlet.PortletPreferencesFactoryUtil" %>

<%@ page import="java.util.Properties" %>

<%@ page import="javax.portlet.PortletPreferences" %>
<%@ page import="javax.portlet.WindowState" %>

<%@ page import="com.liferay.portal.kernel.util.HttpUtil" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="javax.portlet.PortletContext" %>

<portlet:defineObjects />

<liferay-theme:defineObjects />

<%
WindowState windowState = renderRequest.getWindowState();

PortletPreferences preferences = renderRequest.getPreferences();

String portletResource = ParamUtil.getString(request, "portletResource");

if (Validator.isNotNull(portletResource))
{
   preferences = PortletPreferencesFactoryUtil.getPortletSetup(request, portletResource);
}

String flexspacesSwfUrl = preferences.getValue("flexspaces-swf-url", StringPool.BLANK);
String flashHeight = preferences.getValue("flash-height", StringPool.BLANK);
String showDocLib = preferences.getValue("show-doclib", StringPool.BLANK);
String showSearch = preferences.getValue("show-search", StringPool.BLANK);
String showTasks = preferences.getValue("show-tasks", StringPool.BLANK);
String showWcm = preferences.getValue("show-wcm", StringPool.BLANK);
String showHeader = preferences.getValue("show-header", StringPool.BLANK);
String haveCoverFlow = preferences.getValue("have-coverflow", StringPool.BLANK);
String alfrescoUrl = preferences.getValue("alfresco-url", StringPool.BLANK);

%>
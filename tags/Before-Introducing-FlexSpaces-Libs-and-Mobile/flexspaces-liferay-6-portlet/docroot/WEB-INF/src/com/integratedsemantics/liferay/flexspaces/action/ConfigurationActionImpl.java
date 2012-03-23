package com.integratedsemantics.liferay.flexspaces.action;

import com.liferay.portal.kernel.portlet.BaseConfigurationAction;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portlet.PortletPreferencesFactoryUtil;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.PortletPreferences;


public class ConfigurationActionImpl extends BaseConfigurationAction
{
	public void processAction(PortletConfig portletConfig, ActionRequest actionRequest,	ActionResponse actionResponse)
		throws Exception 
	{
		String cmd = ParamUtil.getString(actionRequest, Constants.CMD);

		if (!cmd.equals(Constants.UPDATE))
		{
			return;
		}

		String flexspacesSwfUrl = ParamUtil.getString(actionRequest, "flexspacesSwfUrl");
        String flashHeight = ParamUtil.getString(actionRequest, "flashHeight");
        String showDocLib = ParamUtil.getString(actionRequest, "showDocLib");
        String showSearch = ParamUtil.getString(actionRequest, "showSearch");
        String showTasks = ParamUtil.getString(actionRequest, "showTasks");
        String showWcm = ParamUtil.getString(actionRequest, "showWcm");
        String showHeader = ParamUtil.getString(actionRequest, "showHeader");
        String haveCoverFlow = ParamUtil.getString(actionRequest, "haveCoverFlow");
        String alfrescoUrl = ParamUtil.getString(actionRequest, "alfrescoUrl");
		
		String portletResource = ParamUtil.getString(actionRequest, "portletResource");
		
		PortletPreferences preferences = PortletPreferencesFactoryUtil.getPortletSetup(actionRequest, portletResource);

		preferences.setValue("flexspaces-swf-url", flexspacesSwfUrl);
        preferences.setValue("flash-height", flashHeight);
        preferences.setValue("show-doclib", showDocLib);
        preferences.setValue("show-search", showSearch);
        preferences.setValue("show-tasks", showTasks);
        preferences.setValue("show-wcm", showWcm);
        preferences.setValue("show-header", showHeader);
        preferences.setValue("have-coverflow", haveCoverFlow);
        preferences.setValue("alfresco-url", alfrescoUrl);
        
        preferences.store();

		SessionMessages.add(actionRequest, portletConfig.getPortletName() + ".doConfigure");
	}

}
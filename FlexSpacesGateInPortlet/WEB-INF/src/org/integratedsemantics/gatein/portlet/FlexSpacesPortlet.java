package org.integratedsemantics.gatein.portlet;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.GenericPortlet;
import javax.portlet.PortletException;
import javax.portlet.PortletMode;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequestDispatcher;
import javax.portlet.PortletSecurityException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import java.io.IOException;

public class FlexSpacesPortlet extends GenericPortlet
{
   public void processAction(ActionRequest request, ActionResponse response) throws PortletException, PortletSecurityException, IOException
   {
      String op = request.getParameter("op");
      if ((op != null) && (op.trim().length() > 0))
      {
         if (op.equalsIgnoreCase("update"))
         {
            PortletPreferences prefs = request.getPreferences();
            
            String flexspacesSwfUrl = request.getParameter("flexspacesSwfUrl");
            String flexspacesBaseUrl = request.getParameter("flexspacesBaseUrl");
            String flashWidth = request.getParameter("flashWidth");
            String flashHeight = request.getParameter("flashHeight");
            String showDocLib = request.getParameter("showDocLib");
            String showSearch = request.getParameter("showSearch");
            String showTasks = request.getParameter("showTasks");
            String showWcm = request.getParameter("showWcm");
            String showHeader = request.getParameter("showHeader");
            String haveCoverFlow = request.getParameter("haveCoverFlow");
            String alfrescoUrl = request.getParameter("alfrescoUrl");
                        
            prefs.setValue("flexspacesSwfUrl", flexspacesSwfUrl);
            prefs.setValue("flexspacesBaseUrl", flexspacesBaseUrl);
            prefs.setValue("flashWidth", flashWidth);
            prefs.setValue("flashHeight", flashHeight);
            prefs.setValue("showDocLib", showDocLib);
            prefs.setValue("showSearch", showSearch);
            prefs.setValue("showTasks", showTasks);
            prefs.setValue("showWcm", showWcm);
            prefs.setValue("showHeader", showHeader);
            prefs.setValue("haveCoverFlow", haveCoverFlow);
            prefs.setValue("alfrescoUrl", alfrescoUrl);                        
            
            prefs.store();           
            response.setPortletMode(PortletMode.VIEW);
            return;
         }
         else if (op.equalsIgnoreCase("cancel"))
         {
            response.setPortletMode(PortletMode.VIEW);
            return;
         }
      }
      response.setPortletMode(PortletMode.EDIT);
   }

   public void doView(RenderRequest request, RenderResponse response)
   {
      try
      {
         setRenderParameters(request);
         response.setContentType("text/html");
         PortletRequestDispatcher prd = getPortletContext().getRequestDispatcher("/WEB-INF/jsp/view.jsp");
         prd.include(request, response);
      }
      catch(Exception e)
      {
         e.printStackTrace();
      }
   }
   
   public void doEdit(RenderRequest request, RenderResponse response)
   {
      try
      {
         setRenderParameters(request);
         response.setContentType("text/html");
         PortletRequestDispatcher prd = getPortletContext().getRequestDispatcher("/WEB-INF/jsp/edit.jsp");
         prd.include(request, response);
      }
      catch(Exception e)
      {
         e.printStackTrace();
      }
   }

   private void setRenderParameters(RenderRequest request)
   {
      PortletPreferences prefs = request.getPreferences();
      
      request.setAttribute("flexspacesSwfUrl", prefs.getValue("flexspacesSwfUrl", "http://localhost:8080/flexspaces/FlexSpaces.swf"));
      request.setAttribute("flexspacesBaseUrl", prefs.getValue("flexspacesBaseUrl", "http://localhost:8080/flexspaces/"));
      request.setAttribute("flashWidth", prefs.getValue("flashWidth", "100%"));
      request.setAttribute("flashHeight", prefs.getValue("flashHeight", "700"));
      request.setAttribute("showDocLib", prefs.getValue("showDocLib", "true"));
      request.setAttribute("showSearch", prefs.getValue("showSearch", "true"));
      request.setAttribute("showTasks", prefs.getValue("showTasks", "true"));
      request.setAttribute("showWcm", prefs.getValue("showWcm", "false"));
      request.setAttribute("showHeader", prefs.getValue("showHeader", "true"));
      request.setAttribute("haveCoverFlow", prefs.getValue("haveCoverFlow", "false"));
      request.setAttribute("alfrescoUrl", prefs.getValue("alfrescoUrl", "http://localhost:8080/alfresco/service"));
      
   }
}


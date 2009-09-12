9/10/09
Steve Reiner
Integrated Semantics

I tested this portlet for FlexSpaces with the GateIn portal beta1 (with both tomcat and jboss as). 
For a gadget, see flexspacesGadget.zip

(I also will cover on the integratedsemantics.org blog)

Web Script setup
Your Alfresco server needs to have the FlexSpaces integratedsemantics.zip webscripts installed. 
See the readmeWebScripts.txt and the webscripts-only.zip download in the XML Data WebScripts section.

GateIn install (either bundled with Tomcat or with JBoss AS)
http://www.jboss.org/gatein/downloads.html

Alfresco
1. Install alfresco and gatein with separate app servers. I already had Alfresco 3.2 installed,
I had trouble getting the gatein gadgets stuff to work when the gatein had its ports
changed, so I left the gatein app server ports alone and changed the "80xx" ports in alfresco tomcate/conf/server.xml to "90xx"
2. start alfresco server 

GateIn Setup:
1. Copy the flexspaces-gatein-portlet.war to for tomcat: <gatein>/tomcat/webapps for jbossas: <gatein>/server/default/deply
2. Start up gatein  with http://localhost:8080/portal/ and login ( user: root  pw: gtn)
3. Navigate to Administration / Application Registry
4. Selcct Portlet large square icon
5. Verify that the FlexSpacesPortlet is listed under Flexspaces-gatein-portlet
6. Select the Organize large square icon
7. Select the Web category and click the + sign
8. select the radio btn for FlexSpacesPortlet (on 3rd page), give a display name: FlexSpaces and click the add button
9. Choose make it public checkbox for quick testing or select add permission platform/users  and the *
10. Go to home page and and click Add New Page from the Editor menu at the top right
11. Give your page a node name and a display name and click next
12. Keep the empty layout (the dashboard layout is for gadgets) and click next
13. Optionally add layout container from the containers tab (flexspaces needs a good bit of space so one row layout or no layout container will work best)
14, Add flexspaces portlet via dragging from the Applications tab / Web area, and click the save icon
15. Use the edit UI of the FlexSpaces portlet to change preferences
16. login ( user: admin pw: admin or other user) in the FlexSpaces portlet

Notes:
a. the logout link in flexspaces does log out, but the sessiondata with ticket in the local sharedobject doesn't get cleared out. If
you then restart it within 30 minutes, there will be a bunch of authenication prompts. So until this is fixed, don't logout, just
close your browser. (This issue is with useSessionData="true" in FlexSpacesConfig.xml)
b. When the flex app in the portlet is restarted after a portlet resize (maximize, restore to normal) any search query will
need to be redone
c. Need add use of shared libraries to support using less memory  with multiple FlexSpaces portlets or other Flex based portlets.
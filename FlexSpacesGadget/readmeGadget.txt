9/10/09
Steve Reiner
Integrated Semantics

I tested this gadget for FlexSpaces with the GateIn portal beta1 (with both tomcat and jboss as). It should work with other Google gadget containers.

FlexSpaces setup
This gadget leverages a url to the swf of a flexspaces browser install in your alfresco app server. 
Install the flexspaces webapp dir in flexspaces-browser.zip in your alfresco tomcat following readmeFlexSpacesBrowser.txt
(you will additionally need to:
a. set the port to 9080 in FlexSpacesConfig.xml
b. set useSessionData to "true" in FlexSpacesConfig.xml

Web Script setup
Your Alfresco server also needs to have the FlexSpaces integratedsemantics.zip webscripts installed. 
See the readmeWebScripts.txt and the webscripts-only.zip download in the XML Data WebScripts section.

GateIn install
http://www.jboss.org/gatein/downloads.html

Gadget Setup:
(I also describe on the integratedsemantics.org blog)
1. Install alfresco and gatein with separate app servers. I had trouble getting the gatein gadgets stuff to work when the gatein had its ports
changed, so I left the gatein app server ports alone and changed the "80xx" ports in alfresco tomcate/conf/server.xml to "90xx"
2. have alfresco server running, start up gatein (either the tomcat or jbossas verson) with http://localhost:8080/portal/ and login ( user: root  pw: gtn)
3. navigate to Administration / Application Registry
4. Selcct Gadget large square icon
5. Click create a new gadget
6. Replace the default gadget text with the contents of flexspaces-gadget.xml and click Save.
7. Select the Organize large square icon
8. Select the gadget category and click the + sign
9. Change the application type combo to Widget
10. select the radio btn for flexspaces, give a display name: FlexSpaces and click the add button
11. choose make it public checkbox for quick testing or select add permission platform/users  and the *
12. Go to a dashboard page
13. Click Add Widget, and drag the FlexSpaces onto the dashboard page
14. Maximize the FlexSpaces gadget, and login ( user: admin pw: admin or other user)
15. When you use and preferences ui (pencil icon), GateIn doesn't display the default values (might be easier to edit the xml until gatein fixes this.
(you can go back to the Administration / Application Registry  / Gadget admin area, select the flexspaces gadget and edit it with edit gadget icon. 
The default values in the UserPref items could be changed)

Notes:
a. the logout link in flexspaces does log out, but the sessiondata with ticket in the local sharedobject doesn't get cleared out. If
you then restart it within 30 minutes, there will be a bunch of authenication prompts. So until this is fixed, don't logout, just
close your browser. (This issue is with useSessionData="true" in FlexSpacesConfig.xml)
b. When the flex app in the portlet is restarted after a portlet resize (maximize, restore to normal) any search query will
need to be redone
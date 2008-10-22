
8/25/08
Steve Reiner
integratedsemantics.org
integratedsemantics.com

FlexSpaces+Browser readme

Server Web Scripts Installation

    See readme in webscripts only dir

Web Server Setup

1. Put the flexspaces folder in your web server (i.e. <installdir>/tomcat/webapps/flexspaces )

2. Set the host and port in flexspaces/alfresco-config.xml to reflect where the flex app should
call for alfresco server webscripts 

3. alfresco-config.xml has alfrescoUrlPart to set a different url for the "/alfresco/service"  part of the server url
(NEW in 0.6, more of the url in alfresco-config.xml, "/alfresco/service" not just "/alfresco/)

4. Note tested with Alfresco 2.2.0 Enterprise, 2.90C_dev, 3.0 Labs (1032, 1066)
(min version for webscripts is 2.1)

Client install of Flash Player with Browser

1. On Clients, install the latest 9.x flash player for the given browser
2. Windows, Mac, Linux supported
3. Install from your browser:
http://www.adobe.com/go/getflashplayer
(Note: FlexSpaces.html will direct you to the install too)


To run FlexSpaces from browser:

http://localhost:8080/flexspaces/FlexSpaces.html
(or where you installed flexspaces in your webserver)


FlexSpaces+Browser Notes:

1. A Flex Builder 3.0 project with Flex and ActionScript source included in this release.
For FlexSpaces+Browser, only the FlexSpaces project is need (not the FlexSpacesAir one)

2. 0.6 test configurations:
a.tested on vista client with firefox 3, IE7, with alfresco server on windows vista x64 / 32bit java,
and Vista 32bit / 32bit java
b. Mac OSX 10.5.4 Safari client to remote server (will test)
c. Fedora 9 as server (will test)
d. XP client (will test)
e  Previous version had been tested Ubuntu/Firefox client
   
3.To use File/Preview menu need to use Tools/Make Flash Preview on docs first

4. FlexSpaces+Brower supports drag/drop and clipboard within FlexSpaces 
   (AIR version also supports drag/drop with shell desktop files)
 
5 Drag / Drop between two repository folders using the dual folder view:
no key or ctrl to copy, shift key to move
(Note: dual panes are toggled off by default in this version, use "Dual Panes" and WCM Dual Panes" view menus to turn on)

6. Main menu items  and context menus now enabled/disabled based on user's permissions. 
(ok button in properties and add/remove buttons tags/categories dialogs  are also hidden if you don't have write permission)

7. thumbnails don't seem to be generated in avm/wcm (icon/thumbnail view mode, coverflow view mode)

8 Will get new webscript errror dialog if username or password is wrong at login, need to fix

9.You may get a stop_fla:MainTimeline error message before displaying flash previews on 3.0 (both share without flexspaces, flexspaces)

10. builtin popup blockers (firefox 3, etc.) may block viewing files on flexspaces+browser, need to confure or disable popup blockers

11. tag cloud and tag editing not enabled on pre 2.9 due to requiring 2.9/3.0 server for this feature

12. Thumbnails, coverflow depends on thumbnail service addded in 3.0,  these are disable on pre 3.0








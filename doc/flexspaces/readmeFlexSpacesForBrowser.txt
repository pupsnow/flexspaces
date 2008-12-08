
11/08/08
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

4. New in 0.7 in alfresco-config.xml
a. <server livecycle="false"/> livecycle="false" for regular alfresco, livecycle="true" for livecycle content services es
b. <locale default-locale="en_US"/> sets which locale/language menu set of xml files to load from the config dir
(For ui strings other thean menus, flexspaces currently only built with English set of resource bundles. source code also has German,Spanish, Japanese)

New in 0.8 in alfresco-config.xml Calais config

<calais enable="true" key="<Calais api key>" />
1. To use the semantic features in FlexSapces you need to set enable="true", register for a Calais key at
http://opencalais.com/user/register and put it in key attribute of the calais element in alfresco-config.xml
2. You also need to install the Calais integration forge project http://forge.alfresco.com/projects/calais/
amp in your alfresco server
3. Notes:Calais currently only supports Engish content. It will support one more language at end of 2008, a
nd more languages in Q1 2009. If the content is too short, Calais may not recognize what language the content is in.

New in 0.8 alfresco-config.xml  Google Map config
<googlemap enable="true" url="<domain or ip address registered for google map key>" key="<Google map flash api key>"/>        
1. To use the general map component or the semantic tag map in FlexSpaces you need to set enable to true on this,
register for a google map api for your domain or ip address at http://code.google.com/apis/maps/signup.html, put registered
domain address or ip address in url attribute, put google map api key in the key attribute
2. Note: will get debug watermarks on map if key is not set, or when debugging on localhost

4. Note tested mainly with Alfresco 3.0 Enterprise, 
(min version for webscripts is 2.1)

Client install of Flash Player 9.x 
0. Uninstall current flash players if not 9.x
1. On Clients, install the latest 9.x flash player for the given browser
2. Windows, Mac, Linux supported
3. Download: archive of all 9.x versions
http://fpdownload.macromedia.com/get/flashplayer/installers/archive/fp9_archive.zip
For developers debugging with Flex Builder
http://fpdownload.macromedia.com/get/flashplayer/installers/archive/fp9_debug_archive.zip
4. Install 124 version
Windows / FireFox: flashplayer9r124_win.exe
Windows / IE: flashplayer9r124_winax.exe

Client install of Flash Player 10.x
1. Uninstall current flash players
Although mainly support flash 9.x player. Did some testing with flash 10 player. Only issue: edit does checkout + download with
flash 9.x player. With flash 10.x player, edit will only do the checkout. Can still do the download as a  separate step with flash 10.x player.
2. Install from your browser: (if have both IE and Firefox, need to from each browser)
http://www.adobe.com/go/getflashplayer


To run FlexSpaces from browser:

http://localhost:8080/flexspaces/FlexSpaces.html
(or where you installed flexspaces in your webserver)


FlexSpaces+Browser Notes:

1. A Flex Builder 3.0 project with Flex and ActionScript source included in this release.
For FlexSpaces+Browser, only the FlexSpaces project is need (not the FlexSpacesAir one)

2. 0.8, 0.7 test configurations:
a.tested on vista client with firefox 3, with alfresco 3.0 enterprise server on windows vista x64 / 32bit java,
Previous versions tested with these clients
b. IE7
c. Mac OSX 10.5.4 Safari client
d  Ubuntu 8.0.4 / Firefox client
Previously tested with 3b labs, 2.2.0 enterprise, adobe livecycle content services es 8.2 update 1   

3. To use File/Preview menu need to use Tools/Make Flash Preview on docs first

4. FlexSpaces+Brower supports drag/drop and clipboard within FlexSpaces 
   (AIR version also supports drag/drop with shell desktop files)
 
5 Drag / Drop between two repository folders using the dual folder view:
no key or ctrl to copy, shift key to move
(Note: dual panes are toggled off by default in this version, use "Dual Panes" and WCM Dual Panes" view menus to turn on)

6. Main menu items  and context menus now enabled/disabled based on user's permissions. 
(ok button in properties and add/remove buttons tags/categories dialogs  are also hidden if you don't have write permission)

7.You may get a stop_fla:MainTimeline error message before displaying flash previews on 3.0
(this only with debug versions of the flash player)

8. builtin popup blockers (firefox 3, etc.) may block viewing files on flexspaces+browser, need to confure or disable popup blockers

9. tag cloud and tag editing not enabled on pre 2.9 due to requiring 2.9/3.0 server for this feature (semantic tags  are different
than regular tags, only require the calais integration)

10. Thumbnails, coverflow depends on thumbnail service addded in 3.0,  these are disable on pre 3.0
(Currently thumbnails from upload from flexspaces will have placeholders. Will show thumbnails from files uploaded in Share)







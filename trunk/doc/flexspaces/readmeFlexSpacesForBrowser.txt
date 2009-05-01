
4/30/09
Steve Reiner
integratedsemantics.org
integratedsemantics.com

FlexSpaces+Browser readme

Server Web Scripts Installation (required to run client)
    See readmeWebScripts.txt

Web Server Setup

1. Put the flexspaces folder in your web server (i.e. <installdir>/tomcat/webapps/flexspaces )

2. flexspaces/FlexSpacesConfig.xml 
see readmeFlexSpacesForAIR.txt for instructions


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

1. FlexSpaces+Brower supports drag/drop and clipboard within FlexSpaces 
   (AIR version also supports drag/drop with shell desktop files)
 
2 Drag / Drop between two repository folders using the dual folder view:
no key or ctrl to copy, shift key to move
(Note: dual panes are toggled off by default in this version, use "Dual Panes" and WCM Dual Panes" view menus to turn on)

3. Main menu items  and context menus now enabled/disabled based on user's permissions. 
(ok button in properties and add/remove buttons tags/categories dialogs  are also hidden if you don't have write permission)

4. builtin popup blockers (firefox 3, etc.) may block viewing files on flexspaces+browser, need to confure or disable popup blockers

5. tag cloud and tag editing not enabled on pre 2.9 due to requiring 2.9/3.0 server for this feature (semantic tags  are different
than regular tags, only require the calais integration)

6. Thumbnails, coverflow depends on thumbnail service addded in 3.0,  these are disable on pre 3.0







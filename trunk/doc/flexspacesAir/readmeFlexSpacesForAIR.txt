11/04/08
Steve Reiner
integratedsemantics.org
integratedsemantics.com

FlexSpaces+AIR readme
(also see FlexSpaces+Browser readme)

Server Web Scripts Installation
See readme in webscripts only dir


Adobe AIR Installation
Install lastest Adobe AIR  for windows / mac 
http://get.adobe.com/air/
or alpha for Linux
http://labs.adobe.com/technologies/air/

Note tested with Alfresco 3.0 Enterprise
previously test Alfresco 2.2.0 Enterprise, Labs 3b, 2.90C_dev, 
and adobe livecycle content services es 8.2 update 1
(min version for webscripts is 2.1)

FlexSpaces+AIR Windows Installation

1. After first installing Adobe AIR itself, double click on FlexSpacesAIR.air brown box and click on Install button

2. Click on on continue button (even though it says install location c:\Program Files on windows, default install dir will
be c:\Program Files\FlexSpacesAIR

3. When FlexSpaces+AIR launches enter user name / password in the login screen

4. the default localhost port 8080 can be changed in c:\Program Files\FlexSpacesAIR\alfresco-config.xml
alfresco-config.xml has alfrescoUrlPart to set a different url for the "/alfresco/service"  part of the server url
(NEW in 0.6, more of the url in alfresco-config.xml, "/alfresco/service" not just "/alfresco/)

New in 0.7 in alfresco-config.xml
a. <server livecycle="false"/> livecycle="false" for regular alfresco, livecycle="true" for livecycle content services es
b. <locale default-locale="en_US"/> sets which locale/language menu set of xml files to load from the config dir
(For ui strings other thean menus, flexspaces currently only built with English set of resource bundles. source code also has German,Spanish, Japanese)


5. By default a shortcut icon FlexSpaceAir will be created on your desktop

FlexSpaces+AIR Mac OSX Installation
1. Install released AIR 1.x runtime for the Mac
http://get.adobe.com/air/
2. Double click and install FlexSpacesAir.air from http://forge.alfresco.com/projects/flexspaces/
3. Set host and port name in alfresco-config.xml
a. In finder choose “Show Package Contents” on installed FlexSpacesAir.app
b. alfresco-config.xml is in contents/resources/

FlexSpaces+AIR Linux Installation (based on Ubuntu 8.04)
1. To install adobe air alpha runtime for linux:
http://labs.adobe.com/technologies/air/
http://www.sizlopedia.com/2008/04/06/how-to-install-adobe-air-on-ubuntu/
2. Double click and install FlexSpacesAir.air from http://forge.alfresco.com/projects/flexspaces/
3. Set host and port in /opt/FlexSpacesAir/alfresco-config.xml
(note the linux air alpha currently does not support internal viewing of pdfs)
(make pdf, make flash preview, view flash preview features of FlexSpaces still work)


FlexSpaces+AIR Notes:
(also see readmeFlexSpacesForBrowser.txt)

1. Flex Builder 3.0 projects with Flex and ActionScript source included in this release.
The project for FlexSpacesAir depends on the FlexSpaces project

2. 0.7 flexspaces+air client 
a. tested on vista with AIR 1.1 (AIR did auto upgrade of AIR)
prevously tested with
b. tested pm Mac OSX 10.5.4 with AIR 1.1 (AIR did auto upgrade of AIR)
c. Linux Ubuntu 8.04 with AIR linux alpha

3.Native Drag/Drop and Native clipboard between shell and flexspacesair is supported one direction 
   (uploading to the repository) and as copy mode only
   . 

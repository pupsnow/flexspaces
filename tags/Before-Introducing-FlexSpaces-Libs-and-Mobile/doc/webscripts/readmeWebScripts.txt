
11/04/08
Steve Reiner
integratedsemantics.org
integratedsemantics.com

Instructions for setup of integratedsemantics XML Data JavaScript Webscripts for any of the following:

1. FlexSpace+AIR
2. FlexSpaces+Browser
3. FlexSpaces page site components for Alfresco 3.0 Share / Surf
4. Custom Ajax/html/etc. application calling restful webscripts that can use XML data coming back
5. Custom flex application calling restful webscripts that can use XML data coming back

Server Web Scrips Uninstall of old version of flexspaces/integratedsemantics webscripts
1. if on filesystem webscript classpath, stop server, remove integratedsemantics dir, install new ones, restart
2. if in data dictionary webscripts extension area, delete both integratedsemantics.zip and integratedsemntics folder
with the alfresco webclient, import new integratedsemantics.zip, use the webscript home page to http://localhost:8080/alfresco/service/
and use the refresh webscripts button

Server Web Scripts Installation
1. Install unzipped integratedsemantics.zip  integractedsemantics webscripts dir in the repository data dictionary webscripts extension folder 
or in a webscript extension classpath folder
http://wiki.alfresco.com/wiki/Web_Scripts#Step_2:_Storing_a_Web_Script
(Easy way: In web client use the Import action and import integratedsemantics.zip into /Company Home/Data Dictionary/Web Scripts Extensions/
Folder inside it will be unzipped automatically)

Server setup for flash preview webscripts 
(optional for 2.1-2.9)
(alfresco 3.0 doesn't need custom-transform-context.xml, 3.0 install already has pdf2swf on windows, 
need to install dev snapshot of swftools for linux)

(Note this is optional, only for flash previews. If you  get errors in your alfresco startup console, undo the add of custom-transform-context.xml)
1. Have headless openoffice working correctly for transform to pdf
2. Install newest development snapshot of swftools (newer than 8.1 release) from www.swftools.org (avail for windows and linux)
for pdf2swf (The development shapshot can generate the needed flash 9 format files, 8.1 swftools can't)
3. Add swftools install dir to system path so pdf2swf can be run
4. Copy the included custom-transform-context.xml config file to some alfresco extension area 
   ( <installdir>\tomcat\shared\classes\alfresco\extension on tomcat)
5. Currently FlexSpaces will create a flash preview file in the current dir when
"Make Flash Preview" feature is used (a different location can be passed to the make preview webscript)

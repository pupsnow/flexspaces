4/30/09
Steve Reiner
integratedsemantics.org
integratedsemantics.com

FlexSpaces+AIR readme
(also see doc/readmeFlexSpacesForBrowser.txt)

Server Web Scripts Installation (needed before can use clients)
(also see doc/readmeWebScripts.txt)


Adobe AIR Installation
Install lastest Adobe AIR  for windows / mac 
http://get.adobe.com/air/
or alpha for Linux
http://labs.adobe.com/technologies/air/

(0.9 tested with AIR 1.5.1, with Alfreso Labs 3 final/stable)
previously test Alfresco 3.0 Enterprise, Alfresco 2.2.0 Enterprise, Labs 3b, 2.90C_dev, 
and Adobe livecycle content services es 8.2 update 1
(min version for webscripts is 2.1)

FlexSpaces+AIR Windows Installation

1. After first installing Adobe AIR itself, double click on FlexSpacesAIR.air brown box and click on Install button

2. Click on on continue button (even though it says install location c:\Program Files on windows, default install dir will
be c:\Program Files\FlexSpacesAIR

Can only launch right after install if server is running on localhost:8080, otherwise need to change FlexSpacesConfig.xml
By default a shortcut icon FlexSpaceAir will be created on your desktop
When FlexSpaces+AIR launches enter user name / password in the login screen

3. the default localhost and port 8080 can be changed in c:\Program Files\FlexSpacesAIR\FlexSpacesConfig.xml
        <property name="domain" value="localhost"/>
        <property name="port" value="8080"/>

4. for LiveCycle instead of Alfresco (see readmeLiveCycleContentServices.txt) in FlexSpacesConfig.xml
        <property name="alfrescoUrlPart" value="/contentspace/servicee" />
        <property name="isLiveCycleContentServices" value="true"/>
        <property name="serverVersion" value="2.1"/>   
Note: currently FlexSpaces as built will run (after config) only on LiveCycle on localhost:8080
To run on a different host:port, you need to have flexspaces+browser or flexspaces+air recompiled (using available
source and flex builder) after changing the 2 urls in services-config.xml in the source

5. Locale (FlexSpacesConfig.xml)
        <property name="locale" value="en_US"/>        
Sets which locale/language menu set of xml files to load from the config dir
(For ui strings other thean menus, flexspaces currently only built with English set of resource bundles
and flexspaces would need to be rebuilt (sources has English, German, Spanish, French, Japanese, Greek)

6. Calais sematic tagging features config (FlexSpacesConfig.xml)
(Semantic Tag clouds in search tab view, semantic tags in Tags/Categories dialog, suggest and auto tag menus)
        <property name="enableCalias" value="true"/>        
        <property name="calaisKey" value="key you get"/>         
a. To use the semantic features in FlexSapces you need to set enableCalias, value="true",
register for a Calais key at http://opencalais.com/user/register and put its in value attribute for calaisKey
b. You also need to install the Calais integration forge project http://forge.alfresco.com/projects/calais/
amp in your alfresco server
c. Notes:Calais currently only supports Engish and French content. Calais plans to add more languages.
If the content is too short, Calais may not recognize what language the content is in.

7. Google Map config (FlexSpacesConfig.xml)
(Used in Semantic Tag Map in search tab view, also need to configure Calais)
      <property name="enableGoogleMap" value="false"/>      
      <!--  url of ip address or domain google api key is for --> 
      <property name="googleMapUrl" value="value"/>      
      <!--  google map api key --> 
      <property name="googleMapKey" value="value"/>                           
       
a. To use the general map component or the semantic tag map in FlexSpaces you need to set enableGoogleMap 
value attribute to true
b. register for a google map api for your domain or ip address at http://code.google.com/apis/maps/signup.html, 
put registereddomain address or ip address in value attribute for googleMapUrl, 
c. put google map api key in the value attribute for googleMapKey
d. Note1: will get debug watermarks on map if key is not set, or when debugging on localhost
e. Node2: on AIR, google map adds noticable delay on startup

8. What tab views to show (FlexSpacesConfig.xml)
        <property name="showDocLib" value="true"/>        
        <property name="showSearch" value="true"/>                
        <property name="showTasks" value="true"/>        
        <property name="showWCM" value="false"/>        
        <!-- show share tab is only used in air version -->
        <property name="showShare" value="false"/>  

9. Whether to have coverflow view mode in addition to icon and grid in folder views (FlexSpacesConfig.xml)
        <property name="haveCoverFlow" value="false"/>      

10. Default page size in views, page size pick list (FlexSpacesConfig.xml)      
        <property name="docLibPageSize" value="10"/>    
        <property name="wcmPageSize" value="10"/>    
        <property name="searchPageSize" value="10"/>    
        <property name="taskAttachmentsPageSize" value="10"/>    
        <property name="versionsPageSize" value="10"/>    
        <property name="favoritesPageSize" value="10"/>    
        <property name="checkedOutPageSize" value="10"/>    
        <property name="pageSizeList">
            <array-collection>
                <value>10</value>
                <value>20</value>
                <value>30</value>
                <value>40</value>
                <value>50</value>
            </array-collection>
        </property>                               


FlexSpaces+AIR Mac OSX Installation
1. Install released AIR 1.x runtime for the Mac
http://get.adobe.com/air/
2. Double click and install FlexSpacesAir.air from http://forge.alfresco.com/projects/flexspaces/
3. Set host and port name in FlexSpacesConfig.xml
a. In finder choose “Show Package Contents” on installed FlexSpacesAir.app
b. FlexSpacesConfig.xml is in contents/resources/

FlexSpaces+AIR Linux Installation (based on Ubuntu 8.04)
1. To install adobe air runtime for linux:
http://get.adobe.com/air/
http://www.sizlopedia.com/2008/04/06/how-to-install-adobe-air-on-ubuntu/
2. Double click and install FlexSpacesAir.air from http://forge.alfresco.com/projects/flexspaces/
3. Set host and port in /opt/FlexSpacesAir/FlexSpacesConfig.xml


FlexSpaces+AIR Notes:

1.Native Drag/Drop and Native clipboard between shell and flexspacesair is supported one direction 
   (uploading to the repository) and as copy mode only
   . 

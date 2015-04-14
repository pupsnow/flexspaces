# Brief Install Steps for Adobe LiveCycle Content Services ES2 #

## Web Scripts Installation ##
  1. In ContentSpace use the Import action and import integratedsemantics.zip into /Company Home/Data Dictionary/Web Scripts Extensions/
  1. restart LiveCycle JBoss service or use the "Refresh Web Scripts" button on http://hostname:8080/contentspace/service/ on the web script home page
  1. verify install of webscripts on the web script home page by "Browse by Web Script Package" and you should see bunch of /integratedsemantics packages

## FlexSpaces "In Browser" Installation ##
  1. copy "flexspaces" folder to C:\Adobe\Adobe LiveCycle ES2\jboss\server\lc\_turnkey\deploy\jboss-web.deployer\ROOT.war
  1. configure domain (hostname or ip address) and port in FlexSpacesConfig.xml
  1. configure FlexSpacesConfig.xml for LiveCycle instead of Alfresco
  1. run  http://hostname:8080/flexspaces/FlexSpaces.html

## FlexSpaces AIR Installation ##
  1. Run FlexSpacesAir.air to install but don't launch right after install
  1. configure domain (hostname or ip address) and port in FlexSpacesConfig.xml
  1. configure FlexSpacesConfig.xml for LiveCycle instead of Alfresco
  1. on 32 bit Windows FlexSpacesConfig.xml is in c:\Program Files\FlexSpacesAIR\FlexSpacesConfig.xml
  1. on 64 bit Windows FlexSpacesConfig.xml is in C:\Program Files (x86)\FlexSpacesAir
  1. on Mac: In finder choose "Show Package Contents" on installed FlexSpacesAir.app, FlexSpacesConfig.xml is in contents/resources/
  1. example of how to switch from using Alfresco to using LiveCycle in FlexSpacesConfig.xml :
'
> > <!-- property name="alfrescoUrlPart" value="/alfresco/service"/-->
> > <!-- for livecycle content services use next line and comment out previous line -->
> > 

&lt;property name="alfrescoUrlPart" value="/contentspace/wcservice" /&gt;




> <!-- isLiveCycleContentServices: false for regular alfresco, true for adobe livecycle content services -->
> 

&lt;property name="isLiveCycleContentServices" value="true"/&gt;



> <!-- alfresco server version, allows early enable/disable of features, before getting from version from server -->
> <!-- for livecycle  content services ES2 9.0, use the version of alfresco included (3.1)  -->
> 

&lt;property name="serverVersion" value="3.1"/&gt;


'
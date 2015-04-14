# Brief Install Steps for Alfresco #

## Web Scripts Installation ##
  1. In Alfreso Explorer (Web Client) use the Import action and import integratedsemantics.zip into /Company Home/Data Dictionary/Web Scripts Extensions/
  1. restart Alfresco server or use the "Refresh Web Scripts" button on http://localhost:8080/alfresco/service/ on the web script home page
  1. verify install of webscripts on the web script home page by "Browse by Web Script Package" and you should see bunch of /integratedsemantics packages

## FlexSpaces "In Browser" Installation ##
  1. web script installation required first
  1. copy "flexspaces" folder to <alfresco install dir>/tomcat/webapps
  1. configure domain (hostname or ip address) and port in FlexSpacesConfig.xml
  1. run  http://localhost:8080/flexspaces/FlexSpaces.html

## FlexSpaces AIR Installation ##
  1. web script installation required first
  1. Run FlexSpacesAir.air to install but don't launch right after install
  1. configure domain (hostname or ip address) and port in FlexSpacesConfig.xml
  1. on 32 bit Windows FlexSpacesConfig.xml is in c:\Program Files\FlexSpacesAIR\FlexSpacesConfig.xml
  1. on 64 bit Windows FlexSpacesConfig.xml is in C:\Program Files (x86)\FlexSpacesAir
  1. on Mac: In finder choose "Show Package Contents" on installed FlexSpacesAir.app, FlexSpacesConfig.xml is in contents/resources/
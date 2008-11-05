11/04/08


FlexSpaces page site components for Alfresco Share 3.0 / Surf

Note for 0.7
Prevously tested these page site componets with FlexSpaces 0.6 and earlier versions of alfesco 3.0 labs
Need to test with with FlexSpaces 0.7, and with the released alfresco 3.0 enterprise share

1. Install flexspaces integratedsemantics.zip webscripts per readme in webscripts only dir

2. Have copies of files from flexspaces+browser flexspaces folder in

    <installdir>/tomcat/webapps/share/flexspaces

    for use by flexspaces share site page components

3. copy files in this share/WEB-INF to

   <installdir>/tomcat/webapps/share/WEB-INF

4. In <installdir>/tomcat/webapps/share/WEB-INF/classes/alfresco/site-data/presets/presets.xml

    Merge all or some of the flexspaces page ids 

      {"pageId":"flexspaces-all"}, {"pageId":"flexspaces-doclib"}, {"pageId":"flexspaces-search"}, 
      {"pageId":"flexspaces-tasks"}, {"pageId":"flexspaces-wcm"}

    share\WEB-INF\classes\alfresco\site-webscripts\org\integratedsemantics\components\flexspaces-all

    as in the sample presets.xml.sample in this dir into the site dashboard section of presets.xml.
    The these pages will be available in newly created sites after changing presets.xml

    To change an exsiting site, add the desired flexspaces page ids to the dashboard.xml file 
    in the wcm / avm store

        AVM / sitestore / alfresco / site-data/ pages / site / <sitename> / dashboard.xml


5. notes on flexspaces site page components

a. flexspaces-all page id will have all flexspaces tabs in an integrated site pagecomponent,

b. others only one tab view of flexspaces. 

c. <installdir>/tomcat/webapps/share/WEB-INF/classes/alfresco/
site-webscripts/org/integratedsemantics/components/flexspaces-all/flexspaces-all.get.html.ftl
   can be changed in &doclib=true&search=true&tasks=true&wcm=true" with "false" to leave out views
   from the "flexspaces-all" component
   

6. NOTE: in share/flexspaces copy of flexspaces+browser files, alfresco-config.xml also needs to be setup with host,etc.

7. Tested share with flexspaces site components inside on vista+ie7, vista+firefox3

8. No work yet to have shared/cached flex libraries/modules for site page components yet (memory, startup time)

9. arg for background color in the future would make it look more seamless







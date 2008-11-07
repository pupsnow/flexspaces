11/06/08


FlexSpaces page site components for Alfresco Share 3.0 / Surf

Notes for 0.7
1. Tested these flexspaces share page site components with the released alfresco 3.0 enterprise share
(and "presets.xml sample" based on the "presets.xml" from the released alfresco 3.0 enterprise share)

2. Tested share with flexspaces site components inside on vista+firefox3 and flash player 9.x
(note: share currently supports flash 9.x player not flash 10.x player)

3. Had to modifiy FlexSpacesPresenter.as from 0.7 to get the single view page site components to work in share. 
(this change to flexspaces+browser 0.7 source  in flexspaces-src, and prebuilt into the FlexSpaces.swf in share/flexspaces)


Install instructions:

1. Install integratedsemantics.zip webscripts per doc/webscripts readme

2. copy files  included in share/flexspaces

    <installdir>/tomcat/webapps/share/flexspaces

    for use by flexspaces share site page components

(these files not the same as those from flexspaces+browser 0.7, FlexSpaces.swf has modified FlexSpacesPresenter.as built in)


3. copy files included in share/WEB-INF to

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


5. NOTE: in share/flexspaces copy of flexspaces+browser files, alfresco-config.xml also needs to be setup with host,etc.

6. If all 5 flexspaces page site components are included with all regular share site pages, the title link area will wrap
Shorter page links can be used in for the flexspaces pages by editing the <title> in
C:\Alfresco\install\enterprise\3.0\tomcat\webapps\share\WEB-INF\classes\alfresco\site-data\pages
flexspaces-all.xml
flexspaces-doclib.xml
flexspaces-search.xml
flexspaces-tasks.xml
flexspaces-wcm.xml

Notes on flexspaces site page components

1. flexspaces-all page id will have all flexspaces tabs in an integrated site pagecomponent,

2. others only one tab view of flexspaces. 

3. <installdir>/tomcat/webapps/share/WEB-INF/classes/alfresco/
site-webscripts/org/integratedsemantics/components/flexspaces-all/flexspaces-all.get.html.ftl
   can be changed in &doclib=true&search=true&tasks=true&wcm=true" with "false" to leave out views
   from the "flexspaces-all" component

4. No work yet to have shared/cached flex libraries/modules for site page components yet (memory, startup time)

5. arg for background color in the future would make it look more seamless









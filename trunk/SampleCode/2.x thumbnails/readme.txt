
Thumbnails / Coverflow for FlexSpaces/FlexSpacesAir on either Alfresco 2.x 
or Adobe LiveCycle Content Services ES by using the Thumbnails alfresco forge project

11/14/08

FlexSpaces checks to see  if running on at least alfresco 3.0 before enabling thumbnailing viewing features
(will view, won't create on upload, for now need to upload in Share to create thumbnail on 3.0)

These files modify FlexSpaces 0.7 to work with thumbnails from generated from the Thumbnails project in the alfresco forge

and remove the constraint on being 3.0+ for thumbnails

(to create the thumbnails the action to create thumbnails needs to be run in regular JSF Web Client manually or a content rule needs to be setup)


In addition to enabling display of thumbnails, these changes also enable the coverflow view.



1. Swap in these files into your FlexSpaces project src

   FlexSpaces\src\org\integratedsemantics\flexspaces\model\folder\Folder.as

   FlexSpaces\src\org\integratedsemantics\flexspaces\component\folderview\NodeListViewPresenter.as

   FlexSpaces\src\org\integratedsemantics\flexspaces\view\FlexSpacesPresenter.as


2. Rebuild FlexSpaces / FlexSpaces  flex builder projects


3. upload this modified webscript file to Alfresco server

   /Company Home/ Data Dictionary / Web Scripts Extensions / integratedsemantics / folderlist
   
   folderlist.get.xml.ftl
   
   
 
 4. Install thumbnails 0.5 project from the alfresco forge per its readme.html
 
 Note: Some additional thumbnails project install instructions for dobe LiveCycle Content Services ES:
 
 In:
 a. C:\Adobe\LiveCycle8.2\jboss\server\all\deploy\adobe-contentservices.ear\contentservices.war\WEB-INF\classes\alfresco\
 content-services-context.xml  
     took comments off of <property name="imageMagickContentTransformer">...</property>
     took comments off <bean id="transformer.ImageMagick"
 
 b. And install ImageMagick (and have it on system path and rename convert.exe to imconvert.exe)
    http://wiki.alfresco.com/wiki/ImageMagick_Configuration
    intstallers: http://www.imagemagick.org/download/binaries/
    
 
 c. Also if you want the modifications the thumbnails project did to the Alfresco jsp files you would have to manually merge in
 the changes to the LC CS contentspace versions of the files (don't over-write the contentspace jsp files)
 Since I was just trying to get FlexSpaces work, I skipped this step.  You will still have the "Create thumbnails of the item" action availble
 in the contentspace app even if you skip merging the jsps.
 
 
 5. Note on authentication dialogs in FlexSpaces with LC CS
 Until I find a way around the catch 22 of Adobe LC CS only supporting a ticket http header and not having the url ticket that regular alfresco has, 
 and the restrictions on the use of http headers with various flex/flash apis, you will get some authentication dialogs initially when viewing thumbnails. 
 Having your browser remember these username/passwords will save you some typing.
 

11/13/08

FlexSpaces checks to see running on at least 3.0 before enabling thumbnailing viewing features
(will view, won't create on upload, for now need to upload in Share to create thumbnail on 3.0)

These files modify FlexSpaces 0.7 to work with thumbnails from generated from the Thumbnails project in the alfresco forge

and remove the constraint on being 3.0+ for thumbnails

(to create the thumbnails the action to create thumbnails needs to be run in regular JSF Web Client manually or a content rule needs to be setup)


1. Swap in these files into your FlexSpaces project src

   FlexSpaces\src\org\integratedsemantics\flexspaces\model\folder\Folder.as

   FlexSpaces\src\org\integratedsemantics\flexspaces\component\folderview\NodeListViewPresenter.as

   FlexSpaces\src\org\integratedsemantics\flexspaces\view\FlexSpacesPresenter.as


2. Rebuild FlexSpaces / FlexSpaces  flex builder projects


3. upload this modified webscript file to Alfresco server

   /Company Home/ Data Dictionary / Web Scripts Extensions / integratedsemantics / folderlist
   
   folderlist.get.xml.ftl
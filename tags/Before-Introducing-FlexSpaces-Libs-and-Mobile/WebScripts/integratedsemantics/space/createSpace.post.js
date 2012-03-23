/* Inputs */
   var parentNodeId = args.parentid;
   var parentPath = args.parentpath;
   var spaceName = args.sn;
   var spaceTitle = (args.st == "undefined") ? "" : args.st;
   var spaceDescription = (args.sd == "undefined") ? "" : args.sd;
   var templateId = args.t;
   var icon= (args.icon == "undefined") ? "space-icon-default" : args.icon;

/* Outputs */
var resultString = "Action failed";
var resultCode = false;

try
{
   resultString = "Could not create space";
   var nodeNew;
         
   if ((spaceName == null) || (spaceName == ""))
   {
      resultString = "Space must have a Name";
   }
   else
   {
      var nodeParent = null;
      if ((parentNodeId != null) && (parentNodeId != ""))
      {
         nodeParent = search.findNode("workspace://SpacesStore/" + parentNodeId);
      }   
      else if ((parentPath != null) && (parentPath != ""))
      {
         nodeParent = roothome.childByNamePath(parentPath);
      }
      
      if (nodeParent != null)
      {      
         // Copy from template?
         if ((templateId != null) && (templateId != ""))
         {
            nodeTemplate = search.findNode("workspace://SpacesStore/" + templateId);
            nodeNew = nodeTemplate.copy(nodeParent, true);
            nodeNew.name = spaceName;
         }
         else
         {
            nodeNew = nodeParent.createFolder(spaceName);
         }
         // Always add title & description, icon
         nodeNew.properties["cm:title"] = spaceTitle;
         nodeNew.properties["cm:description"] = spaceDescription;
         nodeNew.properties["app:icon"] = icon;
         nodeNew.save();
         // Add uifacets aspect for the web client
         nodeNew.addAspect("app:uifacets");
         if (nodeNew != null)
         {
            resultString = "New space created";
            resultCode = true;
         }
      }   
   }
}
catch (e)
{
   resultString = "Action failed due to exception";
}

model.resultString = resultString;
model.resultCode = resultCode;
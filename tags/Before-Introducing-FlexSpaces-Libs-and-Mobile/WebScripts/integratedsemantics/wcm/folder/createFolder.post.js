/* Inputs */
   var storeId = args.storeid;
   var parentPath = args.parentpath;
   var folderName = args.name;
   var folderTitle = (args.title == "undefined") ? "" : args.title;
   var folderDescription = (args.desc == "undefined") ? "" : args.desc;

/* Outputs */
var resultString = "Action failed";
var resultCode = false;

try
{
   resultString = "Could not create folder";
   var nodeNew;
         
   if ((folderName == null) || (folderName == ""))
   {
      resultString = "Folder must have a Name";
   }
   else
   {
      var nodeParent = null;
      if ( (storeId != null) && (storeId != "") && (parentPath != null) && (parentPath != "") )
      {
         var store = avm.lookupStore(storeId);
         if (store != null)
         {
            var pathWithStore = storeId + ":" + parentPath;
            nodeParent = avm.lookupNode(pathWithStore);
         }
      }            
      
      if (nodeParent != null)
      {      
         nodeNew = nodeParent.createFolder(folderName);

         if (nodeNew != null)
         {
            // note: currently javascript api doesn't work when setting properties on avm nodes
            //nodeNew.properties["cm:title"] = folderTitle;
            //nodeNew.properties["cm:description"] = folderDescription;                                 
            //nodeNew.save();
         
            resultString = "New folder created";
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
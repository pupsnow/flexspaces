/** 
 *  Move avm node to avm folder
 *
 *    args.sourcestoreid      avm storeid for source
 *    args.sourcepath   source path of avm file or folder to move
 *    args.taregtstoreid      avm storeid for target
 *    args.targetpath   target avm path of parent folder to move into
 * 
 */

/* Inputs */
var sourceStoreId = args.sourcestoreid;
var sourcePath = args.sourcepath;
var targetStoreId = args.targetstoreid;
var targetPath = args.targetpath;

/* Outputs */
var resultString = "wcm move failed due to args";
var resultCode = false;
var newNode = null;

var sourceNode = null;
var targetNode = null;

if ( (sourceStoreId != null) && (sourceStoreId != "") && (targetStoreId != null) && (targetStoreId != "") )
{
   var sourceStore = avm.lookupStore(sourceStoreId);
   var targetStore = avm.lookupStore(targetStoreId);
   if ( (sourceStore != null) && (targetStore != null) )
   {
      if ( (sourcePath != null) && (sourcePath != "") )
      {
         var sourcePathWithStore = sourceStoreId + ":" + sourcePath;
         sourceNode = avm.lookupNode(sourcePathWithStore);
      }   

      if ( (targetPath != null) && (targetPath != "") )
      {
         var targetPathWithStore = targetStoreId + ":" + targetPath;
         targetNode = avm.lookupNode(targetPathWithStore);
      }  
      
      try
      {
         if ( (sourceNode != null) && (targetNode != null) )
         {
            resultString = "Could not move node";

            newNode = sourceNode.move(targetNode);
            if (newNode != null)
            {
               resultString = "Node was moved";
               resultCode = true;
            }
         }
      }
      catch (e)
      {
         resultString = "wcm move failed due to exception";
      }
      
   }
}            

model.resultString = resultString;
model.resultCode = resultCode;
model.newNode = newNode
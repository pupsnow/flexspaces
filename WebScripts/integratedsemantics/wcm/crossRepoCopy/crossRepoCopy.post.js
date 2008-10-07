/** 
 *  Copy node between AVM and ADM
 */

/* AVM -> ADM Inputs */
var sourceStoreId = args.sourcestoreid;
var sourceAvmPath = args.sourceavmpath;
var targetAdmPath = args.targetadmpath;

/* ADM -> AVM Inputs */
var sourceNodeId = args.sourcenodeid;
var targetStoreId = args.targetstoreid;
var targetAvmPath = args.targetavmpath;


/* Outputs */
var resultString = "avm adm cross repo copy failed due to args";
var resultCode = false;
var newNode = null;

var sourceNode = null;
var targetNode = null;

if ( (sourceStoreId != null) && (sourceStoreId != "") && (sourceAvmPath != null) && (sourceAvmPath != "") && (targetAdmPath != null) && (targetAdmPath != "") )
{
   var sourceStore = avm.lookupStore(sourceStoreId);
   if ( sourceStore != null)
   {
      var sourcePathWithStore = sourceStoreId + ":" + sourceAvmPath;
      sourceNode = avm.lookupNode(sourcePathWithStore);
   }

   var targetNode = roothome.childByNamePath(targetAdmPath);
} 
else if ( (sourceNodeId != null) && (sourceNodeId != "") && (targetStoreId != null) && (targetStoreId != "") && (targetAvmPath != null) && (targetAvmPath != "") )
{
   var sourceNode = search.findNode("workspace://SpacesStore/" + sourceNodeId);

   var targetStore = avm.lookupStore(targetStoreId);
   if (targetStore != null)
   {
      var targetPathWithStore = targetStoreId + ":" + targetAvmPath;
      targetNode = avm.lookupNode(targetPathWithStore);      
   }   
}
      
try
{
   if ( (sourceNode != null) && (targetNode != null) )
   {
      resultString = "Could not copy node";

      newNode = crossRepoCopy.copy(sourceNode, targetNode, sourceNode.name);
      if (newNode != null)
      {
         resultString = "Node was copied";
         resultCode = true;
      }
   }
}
catch (e)
{
   resultString = "wcm copy failed due to exception";
}

model.resultString = resultString;
model.resultCode = resultCode;
model.newNode = newNode
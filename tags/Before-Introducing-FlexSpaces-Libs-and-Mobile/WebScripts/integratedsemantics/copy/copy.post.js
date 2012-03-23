/** 
 *  Copy node to Repository folder
 *
 *    args.nodeid   node id of node to copy
 *    args.path   target path of parent folder to copy into
 * 
 */

/* Outputs */
var resultString = "Action failed";
var resultCode = false;
var newNode;


var sourceNodeId = args.nodeid;
if ((sourceNodeId != "") && (sourceNodeId != null) )
{
   var sourceNode = search.findNode("workspace://SpacesStore/" + sourceNodeId);

   if (sourceNode != null)
   {
      try
      {
         resultString = "Could not copy node";


         if ((args.path) && (args.path != ""))
         {
            var nodeParent = roothome.childByNamePath(args.path);
            if (nodeParent != null)
            {
               newNode = sourceNode.copy(nodeParent, true);
               if (newNode != null)
               {
                  resultString = "Node was copied";
                  resultCode = true;
               }
            }
         }
      }
      catch (e)
      {
         resultString = "Action failed due to exception";
      }
   }
}
model.resultString = resultString;
model.resultCode = resultCode;
model.newNode = newNode
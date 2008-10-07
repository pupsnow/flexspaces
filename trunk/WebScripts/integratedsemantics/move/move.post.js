/** 
 *  Move node to Repository folder
 *
 *    args.nodeid   node id of node to copy
 *    args.path     targetpath of parent folder to move into
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
         resultString = "Could not move node";

         if ((args.path) && (args.path != ""))
         {
            var nodeParent = roothome.childByNamePath(args.path);
            if (nodeParent != null)
            {
               if (sourceNode.isDocument)
               {
                  newNode = sourceNode.move(nodeParent);
                  if (newNode != null)
                  {
                     resultString = "Node was moved";
                     resultCode = true;
                  }
               }
               else
               {
                  newNode = sourceNode.copy(nodeParent, true);
                  if (newNode != null)
                  {
                     resultString = "Node was copied, not moved";
                     if (sourceNode.remove())
                     {
                        resultString = "Node was moved";
                        resultCode = true;
                     }
                  }
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
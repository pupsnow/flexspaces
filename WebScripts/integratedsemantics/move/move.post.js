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


if (args.nodeid)
{
   var sourceNodeId = args.nodeid;
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
               newNode = sourceNode.move(nodeParent);
               if (newNode != null)
               {
                  resultString = "Node was moved";
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
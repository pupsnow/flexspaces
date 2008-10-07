/* Inputs */

/* Outputs */
var resultString = "Action failed";
var resultCode = false;

var node = null;

var nodeId = args.nodeid;
if ((nodeId != "") && (nodeId != null))
{
    var node = search.findNode("workspace://SpacesStore/" + nodeId);
}

if ( (args.storeid) && (args.storeid != "") && (args.path) && (args.path != "") )
{
   var store = avm.lookupStore(args.storeid);
   if (store != null)
   {
      var pathWithStore = args.storeid + ":" + args.path;
      var node = avm.lookupNode(pathWithStore);
   }
}


if (node != null)
{
  try
  {
      resultString = "Could not delete document/folder";
      if (node.remove())
      {
          resultString = "Document/Folder deleted";
          resultCode = true;
      }
  }
  catch(e)
  {
      resultString = "Action failed due to exception";
  }
}


model.resultString = resultString;
model.resultCode = resultCode;
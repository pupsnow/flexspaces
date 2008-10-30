
var nodeId = args.nodeid;

// get node
var node = search.findNode("workspace://SpacesStore/" + nodeId); 
if ( (node != null) && (node.isDocument == true) )
{
   model.node = node;
} 
else 
{
   status.code = 400;
   status.message = "Invalid node id " + nodeId;
   status.redirect = true;
}

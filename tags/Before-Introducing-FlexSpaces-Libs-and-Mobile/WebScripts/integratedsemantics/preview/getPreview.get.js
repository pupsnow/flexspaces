
// Gets flash preview node
//

// get doc node with nodeid
var node = null;
if ((args.nodeid) && (args.nodeid != ""))
{
   node = search.findNode("workspace://SpacesStore/" + args.nodeid);
}

// or get doc node with nodepath
if (node == null)
{
   if ((args.nodepath) && (args.nodepath != ""))
   {
      node = roothome.childByNamePath(args.nodepath);
   }
}
model.node = node;


var preview = null;

if (node != null)
{
    var previews = node.assocs["cm:references"];
    if (previews != null)
    {
        for each (p in previews)
        {
            if (p != null)
            {
                preview = p;
            }    
        }
    }
}

model.preview = preview;



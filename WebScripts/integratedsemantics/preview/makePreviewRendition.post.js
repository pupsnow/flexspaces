
// make flash preview rendition
//

// get node to make rendition of with nodeid
var node = null;
if ((args.nodeid) && (args.nodeid != ""))
{
   node = search.findNode("workspace://SpacesStore/" + args.nodeid);
}

// or get node to make rendition of with path
if (node == null)
{
   if ((args.nodepath) && (args.nodepath != ""))
   {
      node = roothome.childByNamePath(args.nodepath);
   }
}
model.node = node;


// get folder to store rendition in with folderid
var folder = null;
if ((args.folderid) && (args.folderid != ""))
{
   folder = search.findNode("workspace://SpacesStore/" + args.folderid);
}
// or get folder to store rendition in with folderpath
if (folder == null)
{
   if ((args.folderpath) && (args.folderpath != ""))
   {
      folder = roothome.childByNamePath(args.folderpath);
   }
}
model.folder = folder;


var previewnode  = null;
model.previewnode = null;
if (node != null && folder != null)
{
   node.addAspect("cm:referencing");

   // make flash preview rendition
   previewnode = node.transformDocument("application/x-shockwave-flash", folder);
   if (previewnode != null)
   {
      model.previewnode = previewnode;
      previewnode.properties.content.mimetype = "application/x-shockwave-flash";
      node.createAssociation(previewnode, "cm:references");
      node.save();
      previewnode.save();
   }
}

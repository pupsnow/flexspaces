
var isAvmNode = false;

if ((args.nodeid) && (args.nodeid != ""))
{
   // use doc mgt nodeid
   model.node = search.findNode("workspace://SpacesStore/" + args.nodeid);
}
else if ( (args.storeid) && (args.storeid != "") && (args.path) && (args.path != "") )
{
   // use avm storeid and path
   var store = avm.lookupStore(args.storeid);
   if (store != null)
   {
      var pathWithStore = args.storeid + ":" + args.path;
      model.node = avm.lookupNode(pathWithStore);
      isAvmNode = true;
   }
}
else
{
   // use doc mgt path
   if ((args.path) && (args.path != ""))
   {
      model.node = roothome.childByNamePath(args.path);
   }
}


if (model.node != null)
{
   if (isAvmNode == true)
   {
      if ( (args.name != "undefined") && (args.name != model.node.name))
      {
         // need to use rename on avm nodes
         model.node.rename(args.name);
      }
      
      // currently javascript api doesn't work to set other properties on AVM nodes   
   }
   else
   {
      if (args.name != "undefined")
      {
         model.node.properties.name = args.name;
      }

      if (args.title != "undefined")
      {
         model.node.properties.title = args.title;
      }

      if (args.description != "undefined")   
      {
         model.node.properties.description = args.description;
      }

      if (model.node.isDocument == true)
      {
         if (args.author != "undefined")
         {
            model.node.properties.author = args.author;
         }
      }

      model.node.save();
   }
      
}




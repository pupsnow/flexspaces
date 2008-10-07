
if ((args.nodeid) && (args.nodeid != ""))
{
   // use doc mgt nodeid
   model.node = search.findNode("workspace://SpacesStore/" + args.nodeid);
   model.emailid=model.node.properties["{http://www.alfresco.org/model/system/1.0}node-dbid"];
}
else if ( (args.storeid) && (args.storeid != "") && (args.path) && (args.path != "") )
{
   // use avm storeid and path
   var store = avm.lookupStore(args.storeid);
   if (store != null)
   {
      var pathWithStore = args.storeid + ":" + args.path;
      model.node = avm.lookupNode(pathWithStore);
      model.emailid = "";
   }
}
else
{
   // use doc mgt path
   if ((args.path) && (args.path != ""))
   {
      model.node = roothome.childByNamePath(args.path);
      model.emailid=model.node.properties["{http://www.alfresco.org/model/system/1.0}node-dbid"];
   }
}


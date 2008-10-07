
if ((args.nodeid) && (args.nodeid != ""))
{
   model.node = search.findNode("workspace://SpacesStore/" + args.nodeid);
}


if (model.node == null)
{
   if ((args.path) && (args.path != ""))
   {
      if (args.path == "/")
      {
         model.node = companyhome;
      }
      else
      {
         model.node = roothome.childByNamePath(args.path);
      }   
   }
}

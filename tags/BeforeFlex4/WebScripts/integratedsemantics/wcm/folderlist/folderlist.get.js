script:
{
   if ( (args.storeid) && (args.storeid != "") && (args.path) && (args.path != "") )
   {
      var store = avm.lookupStore(args.storeid);
      if (store == undefined)
      {
         status.code = 404;
         status.message = "Store " + args.storeid + " not found.";
         status.redirect = true;
         break script;
      }
      
      var path = args.storeid + ":" + args.path;
      var node = avm.lookupNode(path);
      if (node == undefined)
      {
         status.code = 404;
         status.message = "Path " + args.path + " within store " + args.storeid + " not found.";
         status.redirect = true;
         break script;
      }   

      // setup model for templates
      model.store = store;
      model.node = node;       
   }
   else
   {
      status.code = 400;
      status.message = "Store id and path have not been provided.";
      status.redirect = true;
      break script;
   }
}

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

var children = model.node.children;
model.totalSize = children.length;

if ((args.pagesize != undefined) && (args.pagenum != undefined))
{
   var pageSize = parseInt(args.pagesize);
   var pageNum = parseInt(args.pagenum);

   var begin = pageNum * pageSize;
   var end = begin + pageSize;
   
   model.children = children.slice(begin, end);
   
   model.pageSize = pageSize;
   model.pageNum = pageNum;
}
else
{
   model.children = children;
   
   model.pageSize = 0;
   model.pageNum = 0;   
}   

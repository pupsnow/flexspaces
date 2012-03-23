
var query = null;

if ((args.text) && (args.text != ""))
{
   query = "TEXT:\"" + args.text + "\"" + " OR ( @cm\\:name:\"" + args.text + "\" AND (TYPE:\"{http://www.alfresco.org/model/content/1.0}content\" OR TYPE:\"{http://www.alfresco.org/model/content/1.0}folder\") )";
}
else if ((args.lucenequery) && (args.lucenequery != ""))
{
    query = args.lucenequery;
}

var results = search.luceneSearch(query);

model.totalSize = results.length;

model.query = query;

if ((args.pagesize != undefined) && (args.pagenum != undefined))
{
   var pageSize = parseInt(args.pagesize);
   var pageNum = parseInt(args.pagenum);

   var begin = pageNum * pageSize;
   var end = begin + pageSize;
   model.results = results.slice(begin, end);
   
   model.pageSize = pageSize;
   model.pageNum = pageNum;
}
else
{
   model.results = results;
   
   model.pageSize = 0;
   model.pageNum = 0;   
}   


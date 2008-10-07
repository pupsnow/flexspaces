
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

model.results = results;
model.totalResults = results.length;

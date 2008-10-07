
if (args.noderef == "rootCategory")
{
   nodes = classification.getRootCategories("cm:generalclassifiable");
} 
else 
{
   nodes = search.findNode(args.noderef).children;
}
model.nodes = nodes;
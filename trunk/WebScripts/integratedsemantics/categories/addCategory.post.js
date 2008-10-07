model.categoryActions = addCategory(args.noderef, args.categorynoderef);

function addCategory(nodeRef, categoryNodeRef)
{
   var resultString = "Action failed";
   var resultCode = false;
   var node = null;

   if ((categoryNodeRef != "") && (categoryNodeRef != null))
   {

      var categoryNode = search.findNode(categoryNodeRef);      

      if ((nodeRef != "") && (nodeRef != null))
      {
         var node = search.findNode(nodeRef);
   
         if (node != null)
         {
            try
            {
               var categories;
               
               // Must have categoryNode node
               if (categoryNode != null)
               {
                  resultString = "Already had category";
                  categories = node.properties["cm:categories"];
                  if (categories == null)
                  {
                     categories = new Array();
                  }
                  // Check node doesn't already have this category
                  var hasCategory = false;
                  for each (category in categories)
                  {
                     if (category != null)
                     {
                        if (category.nodeRef.toString() == categoryNodeRef)
                        {
                           hasCategory = true;
                           break;
                        }
                     }
                  }
                  if (!hasCategory)
                  {
                     // Add category to our node
                     categories.push(categoryNode);
                     var categoriesArray = new Array();
                     categoriesArray["cm:categories"] = categories;
                     node.addAspect("cm:generalclassifiable", categoriesArray);
                     resultString = "Category added to node";
                     resultCode = true;
                  }
               }
            }
            catch(e)
            {
               resultString = "Action failed due to exception [" + e.toString() + "]";
            }
         }
      }
   }

   var result =
   {
      "resultString": resultString,
      "resultCode": resultCode,
   };
   return result;
}


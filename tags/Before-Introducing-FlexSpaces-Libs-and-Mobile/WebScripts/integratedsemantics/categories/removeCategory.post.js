model.categoryActions = removeCategory(args.noderef, args.categorynoderef);

function removeCategory(nodeRef, categoryNodeRef)
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
               
               resultString = "Could not remove category";
               var oldCategories = node.properties["cm:categories"];
               if (oldCategories == null)
               {
                  oldCategories = new Array();
               }
               categories = new Array();
               // Find this category
               for each (category in oldCategories)
               {
                  if (category != null)
                  {
                     if (category.nodeRef.toString() != categoryNodeRef)
                     {
                        categories.push(category);
                     }
                  }
               }
               // Removed category?
               if (oldCategories.length > categories.length)
               {
                  var categoriesArray = new Array();
                  categoriesArray["cm:categories"] = categories;
                  node.addAspect("cm:generalclassifiable", categoriesArray);
                  resultString = "Category removed";
                  resultCode = true;
               }
               else
               {
                  resultString = "Node doesn't have category";
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

model.tagActions = removeTag(args.noderef, args.tag);

function removeTag(nodeRef, tagName)
{
   var resultString = "Action failed";
   var resultCode = false;
   var node = null;

   if ((tagName != "") && (tagName != null))
   {
      tagName = tagName.toLowerCase();

      if ((nodeRef != "") && (nodeRef != null))
      {
         var node = search.findNode(nodeRef);
   
         if (node != null)
         {
            try
            {
               var tags;
               
               resultString = "Could not remove tag";
               var oldTags = node.properties["cm:taggable"];
               if (oldTags == null)
               {
                  oldTags = new Array();
               }
               tags = new Array();
               // Find this tag
               for each (tag in oldTags)
               {
                  if (tag != null)
                  {
                     if (tag.name != tagName)
                     {
                        tags.push(tag);
                     }
                  }
               }
               // Removed tag?
               if (oldTags.length > tags.length)
               {
                  tagsArray = new Array();
                  tagsArray["cm:taggable"] = tags;
                  node.addAspect("cm:taggable", tagsArray);
                  resultString = "Tag removed";
                  resultCode = true;
               }
               else
               {
                  resultString = "Not tagged with '" + tagName + "'";
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

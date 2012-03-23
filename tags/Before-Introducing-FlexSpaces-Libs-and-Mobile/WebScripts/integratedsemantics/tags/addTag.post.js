model.tagActions = addTag(args.noderef, args.tag);

function addTag(nodeRef, tagName)
{
   var resultString = "Action failed";
   var resultCode = false;
   var node = null;
   var newTag = null;
   var newTagNodeRef = "";

   if ((tagName != "") && (tagName != null))
   {
      tagName = tagName.toLowerCase();

      // Make sure the tag is in the repo
      newTag = createTag(tagName);
      if (newTag != null)
      {
         resultString = "Tag added";
         resultCode = true;
         newTagNodeRef = newTag.nodeRef.toString();
      }
      else
      {
         resultString = "Tag '" + tagName + "' not indexed";
      }

      // Adding the tag to a node?
      if ((nodeRef != "") && (nodeRef != null))
      {
         var node = search.findNode(nodeRef);
   
         if (node != null)
         {
            try
            {
               var tags;
               
               // Must have newTag node
               if (newTag != null)
               {
                  resultString = "Already tagged with '" + tagName + "'";
                  tags = node.properties["cm:taggable"];
                  if (tags == null)
                  {
                     tags = new Array();
                  }
                  // Check node doesn't already have this tag
                  var hasTag = false;
                  for each (tag in tags)
                  {
                     if (tag != null)
                     {
                        if (tag.name == tagName)
                        {
                           hasTag = true;
                           break;
                        }
                     }
                  }
                  if (!hasTag)
                  {
                     // Add it to our node
                     tags.push(newTag);
                     tagsArray = new Array();
                     tagsArray["cm:taggable"] = tags;
                     node.addAspect("cm:taggable", tagsArray);

                     resultString = "Document tagged";
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
      "newTag": newTagNodeRef
   };
   return result;
}

/*
 * Create a new tag if the passed-in one doesn't exist
 */
function createTag(tagName)
{
   var existingTags = classification.getRootCategories("cm:taggable");
   for each (existingTag in existingTags)
   {
      if (existingTag.name == tagName)
      {
         return existingTag;
      }
   }

   var tagNode = classification.createRootCategory("cm:taggable", tagName);
   return tagNode;
}

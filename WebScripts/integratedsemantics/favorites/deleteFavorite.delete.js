
var nodeId = args.nodeid;

deleteFavorite(nodeId);

function deleteFavorite(nodeId)
{
   model.resultString = "Action failed";
   model.resultCode = false;

   var node = search.findNode("workspace://SpacesStore/" + nodeId); 
   if (node != null)
   {
      var prefs = person.childAssocs["app:configurations"][0].children[0];
      var shortcutIds = prefs.properties["app:shortcuts"];

      if (shortcutIds instanceof Array)
      {
         for (i = 0; i < shortcutIds.length; i++)
         {
            if (shortcutIds[i] == nodeId)
            {
               if (i == (shortcutIds.length-1))
               {
                  shortcutIds.pop();
               }
               else
               {
                  shortcutIds.splice(i, 1);
                  break;
               }   
            }
         }
      }
      else
      {
         if (shortcutIds == nodeId)
         {
            prefs.properties["app:shortcuts"] = [];            
         }
      }

      prefs.save();

      model.resultString = "favorite deleted";
      model.resultCode = true;
   }   
}

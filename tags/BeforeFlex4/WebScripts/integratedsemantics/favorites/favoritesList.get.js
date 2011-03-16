
   var favorites = [];  
   model.favorites = favorites;
   
   var configList = person.childAssocs["app:configurations"];
   if ((configList != null) && (configList.length != 0))
   {
      var config = configList[0];
      var prefsList = config.children;

      if (prefsList.length != 0)
      {
         var prefs = prefsList[0];
         var shortcuts = prefs.properties["app:shortcuts"];
         if (shortcuts != null)
         {
            if (shortcuts instanceof Array)
            {            
               for (i = 0; i < shortcuts.length; i++)
               {
                  var node = search.findNode("workspace://SpacesStore/" + shortcuts[i]); 
                  if (node != null)
                  {
                     favorites.push(node);
                  }
               }            
            }
            else
            {
               var node = search.findNode("workspace://SpacesStore/" + shortcuts); 
               if (node != null)
               {
                  favorites.push(node);
               }
            }
         }
      }
   }   



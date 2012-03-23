
// todo replace with Java webscript

var nodeId = args.nodeid;

newFavorite(nodeId);


function newFavorite(nodeId)
{
   model.resultString = "Action failed";
   model.resultCode = false;
   
   var app = "{http://www.alfresco.org/model/application/1.0}";

   var node = search.findNode("workspace://SpacesStore/" + nodeId); 
   if (node != null)
   {
      var configList = person.childAssocs["app:configurations"];
      var configs;
      if ((configList == null) || (configList.length == 0))
      {
         person.addAspect(app + "configurable");
         var props = [];      
         configs = person.createNode("configurations", app + "configurations", props, app + "configurations", app + "configurations");
      }
      else
      {
         configs = person.childAssocs["app:configurations"][0];
      }

      var prefsList = configs.children;
      var prefs;
      if ((prefsList == null) || (prefsList.length == 0))
      {
         var props2 = new Array(1);
         var ids = [];
         // need to have more than one value to get a multivalued prop not just array with one value 
         // (via javascript api createNode with this property, not via java) for some reason, 
         //if later favorite is deleted
         ids.push(nodeId);       
         ids.push("0");  
         ids.push("1");  
         props2[app + "shortcuts"] = ids;
         // note: this may be alfresco 3.0 javascript api
         prefs = configs.createNode("preferences", "cm:cmobject", props2, "cm:contains", app + "preferences");   
      }
      else
      {
         prefs = configs.children[0];
      }

      var alreadyExists = false;
      if (prefs != null)
      {
         var shortcutIds = prefs.properties["app:shortcuts"];
         if (shortcutIds != null)
         {
            if (shortcutIds instanceof Array)
            {
               for each (shortcutId in shortcutIds) 
               {
                  if (shortcutId == nodeId)
                  {
                     alreadyExists = true;
                     break;
                  }
               }
               if (alreadyExists == false)
               {
                  shortcutIds.push(nodeId);
                  prefs.save();
                  model.resultString = "new favorite added";
                  model.resultCode = true;
               }
            }
            else
            {
               if (shortcutIds != nodeId)
               {
                  var ids2 = [];
                  ids2.push(shortcutIds);
                  ids2.push(nodeId);
                  prefs.properties["app:shortcuts"] = ids2;                  
                  prefs.save();
                  model.resultString = "new favorite added";
                  model.resultCode = true;                  
               }
            }
         }
      }
   }

}
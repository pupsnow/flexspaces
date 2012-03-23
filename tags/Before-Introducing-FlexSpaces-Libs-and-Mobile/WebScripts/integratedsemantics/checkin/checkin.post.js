
/* Outputs */
var resultString = "Action failed";
var resultCode = false;

var docNodeId = args.nodeid;
if ((docNodeId != "") && (docNodeId != null))
{
   var docNode = search.findNode("workspace://SpacesStore/" + docNodeId);

   if (docNode != null && docNode.isDocument)
   {
      try
      {
         var originalDoc = docNode.checkin();
         if (originalDoc != null)
         {
            resultString = "Document checked in";
            resultCode = true;
         }
      }
      catch(e)
      {
         resultString = "Action failed due to exception";
      }
   }
}

model.resultString = resultString;
model.resultCode = resultCode;
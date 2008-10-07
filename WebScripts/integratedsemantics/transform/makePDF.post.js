
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
         resultString = "Could not convert document";
         var nodeTrans = docNode.transformDocument("application/pdf");
         if (nodeTrans != null)
         {
            nodeTrans.properties.content.mimetype = "application/pdf";
            resultString = "Document converted";
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
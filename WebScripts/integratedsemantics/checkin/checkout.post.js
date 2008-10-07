
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
         var workingCopy = docNode.checkout();
         if (workingCopy != null)
         {
            resultString = "Document checked out";
            resultCode = true;
            model.workingCopy = workingCopy;
            
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
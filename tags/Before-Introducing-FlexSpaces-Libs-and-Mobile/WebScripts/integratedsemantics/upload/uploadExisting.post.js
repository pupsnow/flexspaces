
var filename = null;
var content = null;
var mimetype = null;

var name = null;
var title = null;
var description = null;
var author = null;

var nodeid = null;

var storeid = null;
var path = null;

var checkin = false;


// locate file attributes
for each (field in formdata.fields)
{

   switch (String(field.name).toLowerCase())
   {
      case "title":
         title = field.value;
         break;
      case "desc":
         description = field.value;
         break;
      case "author":
         author = field.value;
         break;
      case "name":
         // for having name propertie different than original filename
         name = field.value;
         break;
      case "file":
         if (field.isFile)
         {
            filename = field.filename;
            content = field.content;
         }
         break;
      case "mimetype": 
         mimetype = field.value;
         break;
      case "nodeid":  
         nodeid = field.value;
         break;
      case "storeid":   
         storeid = field.value;
         break;
      case "path":  
         path = field.value;
         break;
      case "checkin":  
         checkin = (field.value == "true");
         break;
   }  

}

var isAvmNode = false;
var node = null;
if ((nodeid != null) && (nodeid != ""))
{
   // get doc to upload into with nodeid
   node = search.findNode("workspace://SpacesStore/" + nodeid);
}
else if ( (storeid != null) && (storeid != "") && (path != null) && (path != "") )
{
   // get file to upload into with avm storeid and avm path
   var store = avm.lookupStore(storeid);
   if (store != null)
   {
      var pathWithStore = storeid + ":" + path;
      node = avm.lookupNode(pathWithStore);
      isAvmNode = true;
   }
}

var version = server.version;
var versionNum = parseFloat(version);

// ensure node and mandatory file attributes have been located
if (node == null || filename == undefined || content == undefined)
{
   status.code = 400;
   status.message = "Uploaded file cannot be located in request";
   status.redirect = true;
}
else
{
   if (isAvmNode == false)
   {
      node.properties.content.write(content);
      
      node.properties.content.mimetype = mimetype;
      
      if (versionNum >= 2.9)
      {
         node.properties.content.encoding = "UTF-8";
      }
      else
      {
         node.properties.encoding = "UTF-8";   
      }

      if (name != null)
      {
         node.properties.name = name; 
      }
      else
      {
         node.properties.name = filename;
      }

      if (title != null)
      {
         node.properties.title = title;
      }

      if (description != null)
      {
         node.properties.description = description;
      }

      if (author != null)
      {
         node.properties.author = author;
      }
      
      node.save();

      if (checkin == true)
      {
         node.checkin();
      }      
   }
   else
   {
      // currently setting content property on avm nodes with the javascript
      // api doesn't work (or other properties), so delete and recreate
      var parent = node.parent;
      node.remove();      
      upload = parent.createFile("upload" + parent.children.length + "_" + filename);
      upload.properties.content.write(content);
      
      upload.properties.content.mimetype = mimetype;
      
      if (versionNum >= 2.9)
      {
         upload.properties.content.encoding = "UTF-8";
      }
      else
      {
         upload.properties.encoding = "UTF-8";   
      }

      // need to use rename on avm nodes      
      if (name != null)
      {
         upload.rename(name); 
      }
      else
      {
         upload.rename(filename);
      }

      upload.save();
   }      

   // setup model for response template
   model.node = node;
}



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

var thumbnailNames = null;

var type = "cm:content";


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
      case "thumbnails":
         thumbnailNames = field.value;
      case "type":
         type = field.value;
         break;         
   }  
}

var isAvmNode = false;

if ((nodeid != null) && (nodeid != ""))
{
   // get folder to upload into using doc mgt nodeid
   model.folder = search.findNode("workspace://SpacesStore/" + nodeid);
}
else if ( (storeid != null) && (storeid != "") && (path != null) && (path != "") )
{
   // get folder to upload into with avm storeid and avm path
   var store = avm.lookupStore(storeid);
   if (store != null)
   {
      var pathWithStore = storeid + ":" + path;
      model.folder = avm.lookupNode(pathWithStore);
      isAvmNode = true;
   }
}
else if ((path != null) && (path != ""))
{
   // get folder to upload into with doc mgt path
   model.folder = roothome.childByNamePath(path);
}

var version = server.version;
var versionNum = parseFloat(version);

// ensure folder and mandatory file attributes have been located
if (model.folder == null || filename == undefined || content == undefined)
{
   status.code = 400;
   status.message = "Uploaded file cannot be located in request";
   status.redirect = true;
}
else
{
   // create document in model.folder for uploaded file
   upload = model.folder.createNode("upload" + model.folder.children.length + "_" + filename, type);
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
   
   if (isAvmNode == false)
   {
      if (name != null)
      {
        upload.properties.name = name; 
      }
      else
      {
        upload.properties.name = filename;
      }

      if (title != null)
      {
        upload.properties.title = title;
      }

      if (description != null)
      {
        upload.properties.description = description;
      }

      if (author != null)
      {
        upload.properties.author = author;
      }

      upload.save();
   }
   else
   {
      // need to use rename on avm nodes
      if (name != null)
      {
        upload.rename(name); 
      }
      else
      {
        upload.rename(filename);
      }

      // note setting other properties does not work currently
      // with the javascript api on avm nodes

      upload.save();
   }      

   
   if (versionNum >= 3.0)
   {
      if (thumbnailNames != null)
      {
         var thumbnails = thumbnailNames.split(",");
         for (var i = 0; i < thumbnails.length; i++)
         {
            var thumbnailName = thumbnails[i];
            if(thumbnailName != "" && thumbnailService.isThumbnailNameRegistered(thumbnailName))
            {
               upload.createThumbnail(thumbnailName, true);
            }
         }
      }
   }     

   // setup model for response template
   model.upload = upload;
}


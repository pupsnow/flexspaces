package org.integratedsemantics.flexspaces.model.folder
{
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;
    
    import org.integratedsemantics.flexspaces.model.AppModelLocator;    


    /**
     *  Model for folder view, folderNode and collection of node children
     * 
     */
    public class Folder extends NodeCollection
    {
        // node for the folder itself
        public var folderNode:Node;
        
        // used for current path property
        // note: this ui display path which may be different than repo path
        protected var curPath:String;


        /**
         * Constructor 
         * 
         */
        public function Folder()
        {
            super();
        }
        
        /**
         * Setter of current path of the folder
         *  
         * @param newPath  new path of the folder 
         * 
         */
        public function set currentPath(newPath:String):void
        {
            this.curPath = newPath;
        }
        
        /**
         * Getter of current path of the folder
         *  
         * @return  curent path
         * 
         */
        public function get currentPath():String
        {
            return this.curPath;
        }

        /**
         * Init folder collection with new data
         * 
         * @param data xml data for folder collection
         */
        public function init(data:Object):void
        {
            var result:XML = data as XML;
            var model:AppModelLocator = AppModelLocator.getInstance();
                        
            var dataPath:String = String(result.path);

            //  when initializing curPath is "/", use company home path we will get back
            if (curPath == "/")
            {
                curPath = dataPath;
            }

            // only take new data if its for current path of this folder collection
            if (dataPath == curPath)
            {
                this.folderNode = new Node();
                
                folderNode.name = String(result.name); 
                
                folderNode.nodeRef = String(result.noderef);

                folderNode.storeProtocol = String(result.storeProtocol);
                folderNode.storeId = String(result.storeId);
                folderNode.id = String(result.id);
                
                folderNode.parentPath = String(result.parentPath);
                folderNode.path = String(result.path);
                
                folderNode.readPermission = (result.readPermission == "true");
                folderNode.writePermission = (result.writePermission == "true");
                folderNode.deletePermission = (result.deletePermission == "true");
                folderNode.createChildrenPermission = (result.createChildrenPermission == "true");
                                                             
                var nodeXMLCollection:XMLListCollection = new XMLListCollection(result.node);
                
                this.nodeCollection = new ArrayCollection();
                
                for each (var xmlNode:XML in nodeXMLCollection)
                {
                    var node:Node = new Node();
                    
                    node.name = xmlNode.name;
                    
                    node.nodeRef = xmlNode.noderef;
                    
                    node.storeProtocol = xmlNode.storeProtocol;
                    node.storeId = xmlNode.storeId;
                    node.id = xmlNode.id;
                    
                    node.parentPath = xmlNode.parentPath;
                    node.path = xmlNode.path;
                    node.displayPath = xmlNode.path;

                    // strip off initial slash. add src path, so local icons will be found
                    node.icon16 = xmlNode.icon16;
                    node.icon16 = model.srcPath + node.icon16.substr(1);
                    node.icon32 = xmlNode.icon32;
                    node.icon32 = model.srcPath + node.icon32.substr(1);
                    node.icon64 = xmlNode.icon64;
                    node.icon64 = model.srcPath + node.icon64.substr(1);

                    node.isFolder = xmlNode.isFolder == "true";
                    node.type = xmlNode.type;
                    
                    node.desc = xmlNode.desc;
                    
                    node.size = xmlNode.size;
                    
                    node.created = xmlNode.created;
                    node.modified = xmlNode.modified;
                    
                    node.viewurl = xmlNode.viewurl;
                    
                    node.isLocked = (xmlNode.islocked == "true");
                    node.isWorkingCopy = (xmlNode.isWorkingCopy == "true");
                    
                    node.readPermission = (xmlNode.readPermission == "true");
                    node.writePermission = (xmlNode.writePermission == "true");
                    node.deletePermission = (xmlNode.deletePermission == "true");
                    node.createChildrenPermission = (xmlNode.createChildrenPermission == "true");
                    
                    if (node.isFolder == true)
                    {
                        node.thumbnailUrl = node.icon64;
                    }
                    else
                    {
			            // chanage for thumbnails from thumbnails forge project                    	
                        //node.thumbnailUrl = getThumbnailUrl(node);
                        node.thumbnailUrl = xmlNode.thumbnailUrl;
                    }

                    nodeCollection.addItem(node);
                }
                
                this.source = nodeCollection.source;
                this.refresh();
            }
        }
        
    }
}
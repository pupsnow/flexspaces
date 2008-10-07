package org.integratedsemantics.flexspaces.model.wcm.folder
{
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;
    
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    
        
    /**
     * Model for wcm/avm folder with a wcm folder node and collection of wcm node children
     * These collections are used as models for wcm folder views 
     * 
     */
    [Bindable] 
    public class WcmFolder extends Folder
    {               
        /**
         * Constructor 
         * 
         */
        public function WcmFolder()
        {
            super();
        }
        
        /**
         * Handler called when folder list data service successfully completed
         * 
         * @param xml folder list data
         */
        public function initFolderListData(data:Object):void
        {
            var result:XML = data as XML;
            var model:AppModelLocator = AppModelLocator.getInstance();
            
            var dataPath:String = String(result.path);
            var dataStoreId:String = String(result.storeId);

            if (folderNode.storeId != null)
            {
                var curPathWithoutStoreId:String = "/" + curPath.substr(folderNode.storeId.length + 6);

                // only take new data if its for current path of this wcm folder collection
                if ( (dataStoreId == folderNode.storeId) && (dataPath == curPathWithoutStoreId) )
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
                        var node:WcmNode = new WcmNode();
                        
                        node.name = xmlNode.name;
                        
                        node.nodeRef = xmlNode.noderef;

                        node.storeProtocol = xmlNode.storeProtocol;
                        node.storeId = xmlNode.storeId;
                        node.id = xmlNode.id;
                        
                        node.parentPath = xmlNode.parentPath;
                        node.path = xmlNode.path;
                        node.displayPath = curPath + "/" + xmlNode.name;
                        
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
                            node.thumbnailUrl = getThumbnailUrl(node);    
                        }

                        nodeCollection.addItem(node);
                    }
                    
                    this.source = nodeCollection.source;
                    this.refresh();
                }
            }
        }
                
        /**
         * Handler called when store data service successfully completed
         * 
         * @param data avm store data
         */
        public function initStoreData(data:Object):void
        {
            var result:XML = data as XML;
            
            // only take store data if at root level or uninitialized
            if ( curPath == null || curPath == "/AVM" )
            {
                this.folderNode = new Node();
                folderNode.name = "AVM"; 
                folderNode.id = "AVM";
                
                var nodeXMLCollection:XMLListCollection = new XMLListCollection(result.store);
                
                this.nodeCollection = new ArrayCollection();
                
                var model : AppModelLocator = AppModelLocator.getInstance();
 
                for each (var xmlNode:XML in nodeXMLCollection)
                {
                    if ( displayStore(xmlNode.id) == true)
                    {
                        var node:WcmNode = new WcmNode();
                        node.name = xmlNode.name;
                        node.id = xmlNode.id;
                        node.path = "/" ;
                        node.displayPath = "/AVM/" + xmlNode.id;
                        node.icon16 = model.srcPath + "images/icons/space-icon-default-16.gif";
                        node.icon32 = model.srcPath + "images/icons/space-icon-default.gif";
                        node.icon64 = model.srcPath + "images/icons/space-icon-default-64.png";
                        node.isFolder = true;
                        node.type = "";
                        node.desc = "";
                        node.size = "";
                        node.created = xmlNode.createdDate;
                        node.modified = "";
                        node.viewurl = "";
                        node.storeId = xmlNode.id
                        node.nodeRef = xmlNode.id;
                        
                        node.thumbnailUrl = node.icon64;

                        nodeCollection.addItem(node);
                    }
                }
                
                this.source = nodeCollection.source;
                this.refresh();
            }
        }        

        /**
         * Determine whether to display store
         * 
         * @param storeId store id
         * @return  return true if store should be displayed
         * 
         */
        public static function displayStore(storeId:String):Boolean
        {
            var previewStore:int = storeId.indexOf("--preview");    
            var workflowStore:int = storeId.indexOf("--workflow");
            if  ((previewStore == -1) && (workflowStore == -1))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
                        
    }
}

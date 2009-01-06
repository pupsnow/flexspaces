package org.integratedsemantics.flexspaces.model.wcm.folder
{
    import mx.collections.ArrayCollection;
    
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.wcm.tree.WcmTreeNode;
    
        
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
            var result:WcmFolder = data as WcmFolder;
            
            var dataPath:String = String(result.folderNode.path);
            var dataStoreId:String = String(result.folderNode.storeId);

            if (folderNode.storeId != null)
            {
                var curPathWithoutStoreId:String = "/" + curPath.substr(folderNode.storeId.length + 6);

                // only take new data if its for current path of this wcm folder collection
                if ( (dataStoreId == folderNode.storeId) && (dataPath == curPathWithoutStoreId) )
                {
	                this.folderNode = result.folderNode;
					this.nodeCollection = result.nodeCollection;                
	                result.nodeCollection = null;
                    
                    for each (var node:WcmNode in this.nodeCollection)
                    {
                        node.displayPath = curPath + "/" + node.name;                        
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
            var result:WcmTreeNode = data as WcmTreeNode;
            
            // only take store data if at root level or uninitialized
            if ( curPath == null || curPath == "/AVM" )
            {
                this.folderNode = new Node();
                folderNode.name = "AVM"; 
                folderNode.id = "AVM";
                
                this.nodeCollection = new ArrayCollection();
                
                var model : AppModelLocator = AppModelLocator.getInstance();
 
                for each (var treeNode:WcmTreeNode in result.children)
                {
                    if ( displayStore(treeNode.id) == true)
                    {
                        var node:WcmNode = new WcmNode();
                        node.name = treeNode.name;
                        node.id = treeNode.id;
                        node.path = "/" ;
                        node.displayPath = "/AVM/" + treeNode.id;
                        node.icon16 = model.appConfig.srcPath + "images/icons/space-icon-default-16.gif";
                        node.icon32 = model.appConfig.srcPath + "images/icons/space-icon-default.gif";
                        node.icon64 = model.appConfig.srcPath + "images/icons/space-icon-default-64.png";
                        node.isFolder = true;
                        node.type = "";
                        node.desc = "";
                        node.size = "";
                        node.created = treeNode.createdDate;
                        node.modified = "";
                        node.viewurl = "";
                        node.storeId = treeNode.id
                        node.nodeRef = treeNode.id;
                        
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

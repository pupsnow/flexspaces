package org.integratedsemantics.flexspaces.model.tasks
{
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;
    
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.folder.NodeCollection;    
    
    
    /**
     * Collection of node documents attached to a task 
     * This is used as the model for the task attachments sub view
     * 
     */
    [Bindable] 
    public class AttachmentsCollection extends NodeCollection
    {       
        /**
         * Constructor 
         * 
         */
        public function AttachmentsCollection()
        {
            super();
        }
        
        /**
         * Inits with task attachment data
         * 
         * @param data  task attachments data
         */
        public function initData(data:Object):void
        {
            var result:XML = data as XML;
            var model:AppModelLocator = AppModelLocator.getInstance();
            
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
                    node.thumbnailUrl = getThumbnailUrl(node);    
                }

                nodeCollection.addItem(node);
            }
            
            this.source = nodeCollection.source;
            this.refresh();
        }
                       
    }
}

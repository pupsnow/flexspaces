package org.integratedsemantics.flexspaces.presmodel.wcm.tree
{
    import mx.collections.ArrayCollection;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.wcm.WcmTreeDataEvent;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
    import org.integratedsemantics.flexspaces.model.wcm.folder.WcmFolder;
    import org.integratedsemantics.flexspaces.model.wcm.tree.WcmTreeNode;
    import org.integratedsemantics.flexspaces.presmodel.tree.TreePresModel;
   
   
    /**
     * Presentation model for a view of the avm stores in a tree
     *  
     */
    [Bindable] 
    public class WcmTreePresModel extends TreePresModel
    {
        /**
         * Constructor 
         * 
         */
        public function WcmTreePresModel()        
        {
            super();            
        }
        
        /**
         * Get avm stores
         * 
         */
        public function getStores(responder:Responder):void
        {
            var path:String = "/AVM";
            var wcmTreeDataEvent:WcmTreeDataEvent = new WcmTreeDataEvent(WcmTreeDataEvent.WCM_STORES_DATA, responder);
            wcmTreeDataEvent.dispatch();                                
        }
                
       /**
        * Get subfolder data for node from the server 
        * 
        * @param node parent folder node to get subfolder data for
        * 
        * todo: curently won't get nodes already loaded, need to suport refreshing tree after deletions, 
        * time period to refresh to get other user edits, etc.
        * 
        */
        override public function getNodeChildren(node:TreeNode, responder:Responder):void
        {
            if (node.hasBeenLoaded == false)
            {
                this.setLoadingNode(node);
                //var pathWithoutStoreId:String = "/" + node.path.substr(node.storeId.length + 6);
                var pathWithoutStoreId:String = "/" + node.displayPath.substr(node.storeId.length + 6);
                var wcmTreeDataEvent:WcmTreeDataEvent = new WcmTreeDataEvent(WcmTreeDataEvent.WCM_TREE_DATA, responder, 
                                                                             node.storeId, pathWithoutStoreId);
                wcmTreeDataEvent.dispatch();                                
            }            
        } 
        
        /**
         * Handler called when tree data service successfully completed
         * 
         * @param data tree data return
         */
        public function onResultWcmTreeData(data:Object):void
        {
            var result:WcmTreeNode = data as WcmTreeNode
            
            if (rootNode == null)
            {
                rootNode = result;
                loadingNode = rootNode;
            }
            else
            {
            	loadingNode.children = result.children;
            	result.children = null;
                loadingNode.hasBeenLoaded = true;                                
            }       
        }
        
        /**
         * Handler called when store data service successfully completed
         * 
         * @param data store data
         */
        public function onResultGetStores(data:Object):void
        {
            var result:WcmTreeNode = data as WcmTreeNode
            
            if (rootNode == null)
            {
                rootNode = result;
                loadingNode = rootNode;
            }
            else
            {
            	loadingNode.children = result.children;
            	result.children = null;
                loadingNode.hasBeenLoaded = true;                                
            }       
        }
        
    }
}
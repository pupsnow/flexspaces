package org.integratedsemantics.flexspaces.presmodel.tree
{
    import mx.collections.ArrayCollection;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.TreeDataEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
   
   
    /**
     * Presentation model a view of the repository in a tree
     *  
     */
    [Bindable] 
    public class TreePresModel extends PresModel
    {
        public var rootNode:TreeNode;
        
        public var loadingNode:TreeNode;

        public var selectedNode:TreeNode = null;
		
    	// cmis
        public var doneTreeData:Boolean = false;

        
        /**
         * Constructor 
         * 
         */
        public function TreePresModel()        
        {
            super();
        }
        
        /**
         * Get tree data
         * 
         * @param path   path or "/" for company home
         * 
         */
        public function getTreeData(path:String, responder:Responder):void
        {
            //trace("TreePresModel getTreeData path " + path);
            var treeDataEvent:TreeDataEvent = new TreeDataEvent(TreeDataEvent.TREE_DATA, responder, path); 
            treeDataEvent.dispatch();                                     
        }
        
        /**
        * Set the tree node being data loaded 
        * 
        * @param loadingNode tree node to load
        */
        protected function setLoadingNode(loadingNode:TreeNode):void
        {
            this.loadingNode = loadingNode;    
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
       public function getNodeChildren(node:TreeNode, responder:Responder):void
        {
            //trace("TreePresModel getNodeChildren path " + node.path + " hasBeenLoaded " + node.hasBeenLoaded + " cmisChildren " + node.cmisChildren);
            //trace("TreePresModel getNodeChildren() path " + node.path + " hasBeenLoaded " + node.hasBeenLoaded);
            if (node.hasBeenLoaded == false)
            {
                this.setLoadingNode(node);
                var treeDataEvent:TreeDataEvent = new TreeDataEvent(TreeDataEvent.TREE_DATA, responder, node.path, node.cmisChildren); 
                treeDataEvent.dispatch();                                            
            } 
        } 
                        
        /**
         * Handler called when tree data service successfully completed
         * 
         * @param data  tree data returned
         */
        public function onResultTreeData(data:Object):void
        {
            //trace("TreePresModel onResultTreeData");
            var result:TreeNode = data as TreeNode;

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

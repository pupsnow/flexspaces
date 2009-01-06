package org.integratedsemantics.flexspaces.presmodel.semantictags.tree
{
    import com.adobe.rtc.util.ISO9075;
    
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.SearchEvent;
    import org.integratedsemantics.flexspaces.control.event.SemanticTagsEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
   
   
    /**
     * Presentatopm model of a view of all semantic tag categories and semantic tags in a tree
     *  
     */
    [Bindable] 
    public class SemanticTagTreePresModel extends PresModel
    {
        public var doSearchOnClick:Boolean = false;

        public var rootNode:TreeNode;
        
        public var loadingNode:TreeNode;
        
        public var selectedNode:TreeNode = null;

		        
        /**
         * Constructor 
         * 
         * 
         */
        public function SemanticTagTreePresModel()        
        {
            super();
        }
        
        /**
         * Refresh semantic tag tree with latest semantic tag data
         * 
         * @param responder responder to callback with result or fault 
         * 
         */
        public function refresh(responder:Responder):void
        {
            // call sever to request semanatic tag  tree data, use a fake "rootCategory" nodeRef     
            // to get the top level semantic tag categories
            var repoNode:RepoNode = new RepoNode();
            repoNode.nodeRef = "rootCategory";
            var semanticTagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.GET_SEMANTIC_TAG_TREE, responder, repoNode); 
            semanticTagsEvent.dispatch();                                            
        }

        /**
        * Set the tree node being data loaded 
        * 
        * @param loadingNode tree node to load
        */
        public function setLoadingNode(loadingNode:TreeNode):void
        {
            this.loadingNode = loadingNode;    
        }
                
       /**
        * Get semantic tag sub category data for node from the server 
        * 
        * @param node parent semantic tag category node to get semantic tag sub category data for
        * @param responder responder to callback with result or fault 
        * 
        */
        public function getNodeChildren(node:TreeNode, responder:Responder):void
        {
            if (node.hasBeenLoaded == false)
            {
                this.setLoadingNode(node);
                var semanticTagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.GET_SEMANTIC_TAG_TREE, responder, node); 
                semanticTagsEvent.dispatch();                                            
            }            
        } 
                        
        /**
         * Search on semantic tag
         *  
         * @param tagName name of semantic tag to search for
         * 
         */
        public function tagSearch(tagName:String, responder:Responder):void
        {
            if (doSearchOnClick == true)
            {
                // search on nodes with this category                    
                var escapedSemanticCat:String = ISO9075.encode(tagName);                                     
                var query:String = 'PATH:\"/cm:semantictaggable//cm:' + escapedSemanticCat + '/member\"';                   
                                                        
                var searchEvent:SearchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, query);
                searchEvent.dispatch();
            }                                                          
        }
        
		public function selectSemanticTag(selectedItem:Object, responder:Responder):void
		{
	        selectedNode = selectedItem as TreeNode; 

            if ((selectedNode != null) && (doSearchOnClick == true))
            {
                // get tag name
                var tagName:String = selectedNode.name;
				
 				tagSearch(tagName, responder);      
            }	
		}                
                
    }
    
}

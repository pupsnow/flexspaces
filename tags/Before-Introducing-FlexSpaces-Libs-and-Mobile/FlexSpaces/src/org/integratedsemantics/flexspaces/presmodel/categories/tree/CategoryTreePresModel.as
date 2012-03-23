package org.integratedsemantics.flexspaces.presmodel.categories.tree
{
    import com.adobe.rtc.util.ISO9075;
    
    import mx.collections.ArrayCollection;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.CategoriesEvent;
    import org.integratedsemantics.flexspaces.control.event.SearchEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
   
   
    /**
     * Presentation model of categories and sub-categories in a tree
     *  
     */
    [Bindable] 
    public class CategoryTreePresModel extends PresModel
    {
        public var doSearchOnClick:Boolean = false;

        public var rootNode:TreeNode = null;
        
        public var loadingNode:TreeNode = null;

		public var selectedNode:TreeNode = null;
		
        
        /**
         * Constructor 
         * 
         */
        public function CategoryTreePresModel()        
        {
            super();
        }
                
        /**
         * Refresh category tree with latest category data 
         * 
         */
        public function getCategories(responder:Responder):void
        {
            // call sever to request category  tree data, use a fake "rootCategory" nodeRef     
            // to get the top level categories
            var repoNode:RepoNode = new RepoNode();
            repoNode.nodeRef = "rootCategory";
            var categoriesEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.GET_CATEGORIES, responder, repoNode); 
            categoriesEvent.dispatch();                                            
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
        * Get sub category data for node from the server 
        * 
        * @param node parent category node to get sub category data for
        * 
        * todo: curently won't get nodes already loaded, need to suport refreshing tree after deletions, 
        * time period to refresh to get other user edits, etc.
        * 
        */
       public function getNodeChildren(node:TreeNode, responder:Responder):void
        {
            if (node.hasBeenLoaded == false)
            {
                this.setLoadingNode(node);
                var categoriesEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.GET_CATEGORIES, responder, node); 
                categoriesEvent.dispatch();                                            
            }            
        } 
                                        
		public function selectCategory(selectedItem:Object, responder:Responder):void
		{
	        selectedNode = selectedItem as TreeNode; 

            if (doSearchOnClick == true)
            {
	            if (selectedNode != null)
	            {
	                // get category name
	                var categoryName:String = selectedNode.name;
	            
	                // search on nodes with this category
					var escapedCat:String = ISO9075.encode(categoryName);                     
	                var query:String = 'PATH:\"/cm:generalclassifiable//cm:' + escapedCat + '/member\"';                   
	                var searchEvent:SearchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, query);
	                searchEvent.dispatch();
	            }	
            }		
		}                
           
        /**
         * Handler called when get categories service successfully completed
         * 
         * @param data category data returned
         */
        public function onResultGetCategories(data:Object):void
        {
            var result:TreeNode = data as TreeNode;

            if (rootNode == null)
            {
                rootNode = result;

				// todo i18n
	            rootNode.label = "Categories";
    	        rootNode.name = "Categories";                  

	            rootNode.id = "rootCategory";
    	        rootNode.nodeRef = "rootCategory";  
                                
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

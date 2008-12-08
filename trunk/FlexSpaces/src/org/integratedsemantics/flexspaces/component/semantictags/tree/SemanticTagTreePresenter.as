package org.integratedsemantics.flexspaces.component.semantictags.tree
{
    import com.adobe.rtc.util.ISO9075;
    
    import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.events.ListEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.search.event.SearchResultsEvent;
    import org.integratedsemantics.flexspaces.control.event.SearchEvent;
    import org.integratedsemantics.flexspaces.control.event.SemanticTagsEvent;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
   
   
    /**
     * Presents a view of all semantic tag categories and semantic tags in a tree
     *  
     * Supervising Presenter/Controller of SemanticTagTreeViewBase views 
     * 
     */
    public class SemanticTagTreePresenter extends Presenter
    {
        public var doSearchOnClick:Boolean = false;

        [Bindable] protected var rootNode:TreeNode;
        
        protected var loadingNode:TreeNode;

		[Embed(source="images/icons/add_category.gif")]
		private var tagIcon:Class;
		
		        
        /**
         * Constructor 
         * 
         * @param treeView tree view to control
         * 
         */
        public function SemanticTagTreePresenter(treeView:SemanticTagTreeViewBase)        
        {
            super(treeView);

            if (treeView.initialized == true)
            {
                onCreationComplete(new Event(""));
            }
            else
            {
                observeCreation(treeView, onCreationComplete);            
            }
        }
        
        /**
         * Getter for the view
         *  
         * @return view
         * 
         */
        protected function get treeView():SemanticTagTreeViewBase
        {
            return this.view as SemanticTagTreeViewBase;            
        }       

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            treeView.addEventListener(ListEvent.ITEM_CLICK, treeClicked);           
            treeView.addEventListener(ListEvent.CHANGE, treeChanged);
            
            treeView.setStyle("defaultLeafIcon", tagIcon);
            
            refresh();
        }
        
        /**
         * Refresh semantic tag tree with latest semantic tag data 
         * 
         */
        public function refresh():void
        {
            // call sever to request semanatic tag  tree data, use a fake "rootCategory" nodeRef     
            // to get the top level semantic tag categories
            var repoNode:RepoNode = new RepoNode();
            repoNode.nodeRef = "rootCategory";
            var responder:Responder = new Responder(onResultGetSemanticTags, onFaultGetSemanticTags);
            var semanticTagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.GET_SEMANTIC_TAG_TREE, responder, repoNode); 
            semanticTagsEvent.dispatch();                                            
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
        * Get semantic tag sub category data for node from the server 
        * 
        * @param node parent semantic tag category node to get semantic tag sub category data for
        * 
        * todo: curently won't get nodes already loaded, need to suport refreshing tree after deletions, 
        * time period to refresh to get other user edits, etc.
        * 
        */
       protected function getNodeChildren(node:TreeNode):void
        {
            if (node.hasBeenLoaded == false)
            {
                this.setLoadingNode(node);
                var responder:Responder = new Responder(onResultGetSemanticTags, onFaultGetSemanticTags);
                var semanticTagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.GET_SEMANTIC_TAG_TREE, responder, node); 
                semanticTagsEvent.dispatch();                                            
            }            
        } 
        
        /**
         * Expand tree node and get data from server for children
         *  
         * @param item     tree node item
         * @param open     open state
         * @param animate  should it animate while opening
         * @param dispatchEvent is dispatch event
         * @param cause  event cause
         * 
         */
        public function expandItem(item:Object, open:Boolean, animate:Boolean=false, dispatchEvent:Boolean=false, cause:Event=null):void
        {
            if (open == true)
            {
                var node:TreeNode = item as TreeNode;
                getNodeChildren(node);                
            }
            
            treeView.expandItem(item, open, animate, dispatchEvent, cause);           
        }
                
        /**
         * Handler called when get categories service successfully completed
         * 
         * @param data category data returned
         */
        protected function onResultGetSemanticTags(data:Object):void
        {
            var result:XML = data as XML;
            
            var useLeafIcon:Boolean = false; 

            var currentNode:TreeNode = null;
            if (rootNode == null)
            {
                rootNode = new TreeNode("Semantic Categories/Tags", "rootCategory");
                rootNode.nodeRef = "rootCategory";  
                rootNode.name = "Semantic Categories/Tags";                  
                currentNode = rootNode;
                loadingNode = rootNode;
                treeView.dataProvider = rootNode;
            }
            else
            {
                currentNode = loadingNode;
                useLeafIcon = true;
            }
       
            if (currentNode != null)
            {
                currentNode.children = new ArrayCollection();

                for each (var category:XML in result.category)
                {
                    var childNode:TreeNode = new TreeNode(category.name, category.id);
                    childNode.nodeRef = category.noderef;
                    childNode.name = category.name;    
                    childNode.qnamePath = category.qnamePath;                
                    currentNode.children.addItem(childNode);
                    if (useLeafIcon == true)
                    {
                    	//childNode.children = null;
                    	treeView.setItemIcon(childNode, tagIcon, null);                    	
                    }
                }
                currentNode.hasBeenLoaded = true;

                treeView.callLater(expandLater);
            }                
        }        
        
        /**
         * Handler called when server get categories returns fault
         *  
         * @param info fault info
         * 
         */
        protected function onFaultGetSemanticTags(info:Object):void
        {
            trace("onFaultGetSemanticTags" + info);            
        }   
        
		protected function expandLater():void
		{
			var isOpen:Boolean = treeView.isItemOpen(loadingNode);
			if (isOpen == false)
			{
        		treeView.expandItem(loadingNode, true, false);
   			}			
		}
        
        protected var prevItem:Object;
        
        /**
         * Handle toggling open category tree folder on clicks
         *  
         * @param event tree click event
         * 
         */
        protected function treeClicked(event:Event):void
        {
            var toggle:Boolean = treeView.isItemOpen(treeView.selectedItem);
            if (toggle == true)
            {
                if (treeView.selectedItem == prevItem)
                {
                    expandItem(treeView.selectedItem, false, false);
                }
            } 
            else
            {
                expandItem(treeView.selectedItem, true, false);
            }
            
            prevItem = treeView.selectedItem;
        }                                     
        
        /**
         * Handle tree changed event
         *  
         * @param event tree changed event
         * 
         */
        protected function treeChanged(event:Event):void
        {
            if (doSearchOnClick == true)
            {
                var selectedNode:TreeNode = treeView.selectedItem as TreeNode;            
                if (selectedNode != null)
                {
                    // get category name
                    var categoryName:String = selectedNode.name;
                
                    // search on nodes with this category                    
	                var escapedSemanticCat:String = ISO9075.encode(categoryName);                                     
                    var query:String = 'PATH:\"/cm:semantictaggable//cm:' + escapedSemanticCat + '/member\"';                   
                                                            
                    var responder:Responder = new Responder(onResultSearch, onFaultSearch);
                    var searchEvent:SearchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, query);
                    searchEvent.dispatch();
                }
            }                                                          
        }
        
        /**
         * Handler called when search service successfully returns results
         * 
         * @parm data search results data
         */
        protected function onResultSearch(data:Object):void
        {
            var searchResultsEvent:SearchResultsEvent = new SearchResultsEvent(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, data);
            var dispatched:Boolean = treeView.dispatchEvent(searchResultsEvent);                        
        }

        /**
         * Handle fault in search operation
         * 
         * @param info fault info
         */
        protected function onFaultSearch(info:Object):void
        {
            trace("onFaultSearch " + info);     
        }        
        

    }
    
}

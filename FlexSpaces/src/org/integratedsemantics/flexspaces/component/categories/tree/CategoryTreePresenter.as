package org.integratedsemantics.flexspaces.component.categories.tree
{
    import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.events.ListEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.search.event.SearchResultsEvent;
    import org.integratedsemantics.flexspaces.control.event.CategoriesEvent;
    import org.integratedsemantics.flexspaces.control.event.SearchEvent;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
   
   
    /**
     * Presents a view of categories and sub-categories in a tree
     *  
     * Supervising Presenter/Controller of CategoryTreeViewBase views 
     * 
     */
    public class CategoryTreePresenter extends Presenter
    {
        public var doSearchOnClick:Boolean = false;

        [Bindable] protected var rootNode:TreeNode;
        
        protected var loadingNode:TreeNode;

        
        /**
         * Constructor 
         * 
         * @param treeView tree view to control
         * 
         */
        public function CategoryTreePresenter(treeView:CategoryTreeViewBase)        
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
        protected function get treeView():CategoryTreeViewBase
        {
            return this.view as CategoryTreeViewBase;            
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
            
            refresh();
        }
        
        /**
         * Refresh category tree with latest category data 
         * 
         */
        public function refresh():void
        {
            // call sever to request category  tree data, use a fake "rootCategory" nodeRef     
            // to get the top level categories
            var repoNode:RepoNode = new RepoNode();
            repoNode.nodeRef = "rootCategory";
            var responder:Responder = new Responder(onResultGetCategories, onFaultGetCategories);
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
       protected function getNodeChildren(node:TreeNode):void
        {
            if (node.hasBeenLoaded == false)
            {
                this.setLoadingNode(node);
                var responder:Responder = new Responder(onResultGetCategories, onFaultGetCategories);
                var categoriesEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.GET_CATEGORIES, responder, node); 
                categoriesEvent.dispatch();                                            
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
        protected function onResultGetCategories(data:Object):void
        {
            var result:XML = data as XML;

            var currentNode:TreeNode = null;
            if (rootNode == null)
            {
                rootNode = new TreeNode("Categories", "rootCategory");
                rootNode.nodeRef = "rootCategory";  
                rootNode.name = "Categories";                  
                currentNode = rootNode;
                treeView.dataProvider = rootNode;
            }
            else
            {
                currentNode = loadingNode;
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
                }
                currentNode.hasBeenLoaded = true;
                treeView.validateNow();
                treeView.expandItem(currentNode, true, true);
            }                
        }        
        
        /**
         * Handler called when server get categories returns fault
         *  
         * @param info fault info
         * 
         */
        protected function onFaultGetCategories(info:Object):void
        {
            trace("onFaultGetCategories" + info);            
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
                    expandItem(treeView.selectedItem, false, true);
                }
            } 
            else
            {
                expandItem(treeView.selectedItem, true, true);
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
                    var query:String = 'PATH:\"/cm:generalclassifiable//cm:' + categoryName + '/member\"';                   
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

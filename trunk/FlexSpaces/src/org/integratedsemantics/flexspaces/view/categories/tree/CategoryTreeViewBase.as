package org.integratedsemantics.flexspaces.view.categories.tree
{
    import mx.controls.Tree;
    import mx.events.ListEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
    import org.integratedsemantics.flexspaces.presmodel.categories.tree.CategoryTreePresModel;
    import org.integratedsemantics.flexspaces.view.search.event.SearchResultsEvent;
    
        
    /**
     * Base view class for repository tree views
     * 
     */
    public class CategoryTreeViewBase extends Tree
    {        
        [Bindable]
        public var categoryTreePresModel:CategoryTreePresModel;
        
                
        /**
         * Constructor 
         */
        public function CategoryTreeViewBase()
        {
            super();
        }
        
        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            addEventListener(ListEvent.ITEM_CLICK, treeClicked);           
            addEventListener(ListEvent.CHANGE, treeChanged);

            refresh();
        }

		public function refresh():void
		{
            var responder:Responder = new Responder(onResultGetCategories, onFaultGetCategories);            
            categoryTreePresModel.getCategories(responder);			
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
        override public function expandItem(item:Object, open:Boolean, animate:Boolean=false, dispatchEvent:Boolean=false, cause:Event=null):void
        {
            if (open == true)
            {
                var node:TreeNode = item as TreeNode;
	            var responder:Responder = new Responder(onResultGetCategories, onFaultGetCategories);
                categoryTreePresModel.getNodeChildren(node, responder);                
            }
            
            super.expandItem(item, open, animate, dispatchEvent, cause);           
        }
        
		protected function expandLater():void
		{
			if (categoryTreePresModel.loadingNode != null)
			{
				var isOpen:Boolean = isItemOpen(categoryTreePresModel.loadingNode);
				if (isOpen == false)
				{
	        		expandItem(categoryTreePresModel.loadingNode, true, false);
	   			}
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
            var toggle:Boolean = isItemOpen(selectedItem);
            if (toggle == true)
            {
                if (selectedItem == prevItem)
                {
                    expandItem(selectedItem, false, false);
                }
            } 
            else
            {
                expandItem(selectedItem, true, false);
            }
            
            prevItem = selectedItem;
        }                                     
        
        /**
         * Handle tree changed event
         *  
         * @param event tree changed event
         * 
         */
        protected function treeChanged(event:Event):void
        {
            var responder:Responder = new Responder(onResultSearch, onFaultSearch);
	        categoryTreePresModel.selectCategory(selectedItem, responder);           
        }

        /**
         * Handler called when get categories service successfully completed
         * 
         * @param data category data returned
         */
        protected function onResultGetCategories(data:Object):void
        {
        	categoryTreePresModel.onResultGetCategories(data);
	        callLater(expandLater);
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

        /**
         * Handler called when search service successfully returns results
         * 
         * @parm data search results data
         */
        protected function onResultSearch(data:Object):void
        {
            var searchResultsEvent:SearchResultsEvent = new SearchResultsEvent(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, data);
            var dispatched:Boolean = dispatchEvent(searchResultsEvent);                        
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
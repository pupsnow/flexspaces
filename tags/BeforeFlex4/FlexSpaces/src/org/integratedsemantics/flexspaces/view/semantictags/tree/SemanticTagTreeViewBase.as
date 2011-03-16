package org.integratedsemantics.flexspaces.view.semantictags.tree
{
    import mx.collections.ArrayCollection;
    import mx.controls.Tree;
    import mx.events.ListEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
    import org.integratedsemantics.flexspaces.presmodel.semantictags.tree.SemanticTagTreePresModel;
    import org.integratedsemantics.flexspaces.view.search.event.SearchResultsEvent;
    
        
    /**
     * Base view class for semantic tag tree views
     * 
     */
    public class SemanticTagTreeViewBase extends Tree
    {        
        [Bindable]
        public var semanticTagTreePresModel:SemanticTagTreePresModel;

		[Embed(source="images/icons/add_category.gif")]
		private var tagIcon:Class;
		

        /**
         * Constructor 
         */
        public function SemanticTagTreeViewBase()
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
        	if (semanticTagTreePresModel != null)
        	{
	            addEventListener(ListEvent.ITEM_CLICK, treeClicked);           
	            addEventListener(ListEvent.CHANGE, treeChanged);
	            
	            setStyle("defaultLeafIcon", tagIcon);
	            
	            var responder:Responder = new Responder(onResultGetSemanticTags, onFaultGetSemanticTags);
	            semanticTagTreePresModel.refresh(responder);
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
        override public function expandItem(item:Object, open:Boolean, animate:Boolean=false, dispatchEvent:Boolean=false, cause:Event=null):void
        {
            if (open == true)
            {
                var node:TreeNode = item as TreeNode;
                
                var responder:Responder = new Responder(onResultGetSemanticTags, onFaultGetSemanticTags);
                
                semanticTagTreePresModel.getNodeChildren(node, responder);                
            }
            
            super.expandItem(item, open, animate, dispatchEvent, cause);           
        }
        
        /**
         * Handler called when get categories service successfully completed
         * 
         * @param data category data returned
         */
        protected function onResultGetSemanticTags(data:Object):void
        {
            var result:TreeNode = data as TreeNode;

            if (semanticTagTreePresModel.rootNode == null)
            {
                semanticTagTreePresModel.rootNode = result;
                
            	// todo i18m
		        semanticTagTreePresModel.rootNode.label = "Semantic Categories/Tags";
                semanticTagTreePresModel.rootNode.name = "Semantic Categories/Tags";                  

        	    semanticTagTreePresModel.rootNode.id = "rootCategory";
                semanticTagTreePresModel.rootNode.nodeRef = "rootCategory";  
               
                semanticTagTreePresModel.loadingNode = semanticTagTreePresModel.rootNode;
            }
            else
            {
                semanticTagTreePresModel.loadingNode.children = result.children;
                result.children = null;
                semanticTagTreePresModel.loadingNode.hasBeenLoaded = true;
                for each (var childNode:TreeNode in semanticTagTreePresModel.loadingNode.children)
                {
	               	setItemIcon(childNode, tagIcon, null);                    	
                }
            }
        	
            callLater(expandLater);
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
			var isOpen:Boolean = isItemOpen(semanticTagTreePresModel.loadingNode);
			if (isOpen == false)
			{
        		expandItem(semanticTagTreePresModel.loadingNode, true, false);
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
            semanticTagTreePresModel.selectSemanticTag(selectedItem, responder);
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
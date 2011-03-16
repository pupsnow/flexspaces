package org.integratedsemantics.flexspaces.view.semantictags.suggesttree
{
    import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Tree;
    import mx.events.ListEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.model.tree.SemanticTagTreeNode;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
    import org.integratedsemantics.flexspaces.presmodel.semantictags.suggesttree.SemanticTagSuggestionTreePresModel;
    
        
    /**
     * Base view class for semantic tag suggestions tree views
     * 
     */
    public class SemanticTagSuggestionTreeViewBase extends Tree
    {        
        [Bindable]
        public var semanticTagSuggestionTreePresModel:SemanticTagSuggestionTreePresModel;

		[Embed(source="images/icons/add_category.gif")]
		private var tagIcon:Class;


        /**
         * Constructor 
         */
        public function SemanticTagSuggestionTreeViewBase()
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
            
            setStyle("defaultLeafIcon", tagIcon);
            
            var responder:Responder = new Responder(onResultGetSemanticTags, onFaultGetSemanticTags);
            semanticTagSuggestionTreePresModel.refresh(responder);
        }
        
        /**
         * Handler called when get categories service successfully completed
         * 
         * @param data category data returned
         */
        protected function onResultGetSemanticTags(data:Object):void
        {
            var result:SemanticTagTreeNode = data as SemanticTagTreeNode;
            
            semanticTagSuggestionTreePresModel.rootNode = result;

            // todo i18n
            semanticTagSuggestionTreePresModel.rootNode.label = "Semantic Categories/Tags";
            semanticTagSuggestionTreePresModel.rootNode.name = "Semantic Categories/Tags";                  
       
            for each (var category:SemanticTagTreeNode in semanticTagSuggestionTreePresModel.rootNode.children)
            {
                for each (var tag:SemanticTagTreeNode in category.children)
                {
                	setItemIcon(tag, tagIcon, null);                    	
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
			var isOpen:Boolean = isItemOpen(semanticTagSuggestionTreePresModel.rootNode);
			if (isOpen == false)
			{
        		expandItem(semanticTagSuggestionTreePresModel.rootNode, true, false);
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
			semanticTagSuggestionTreePresModel.selectedNode = selectedItem as SemanticTagTreeNode;        	
        }
                
    }
}
package org.integratedsemantics.flexspaces.component.semantictags.suggesttree
{
    import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.events.ListEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.SemanticTagsEvent;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.tree.SemanticTagTreeNode;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
   
   
    /**
     * Presents a view of all semantic tag categories and suggested semantic tags in a tree
     *  
     * Supervising Presenter/Controller of SemanticTagSuggestionTreeViewBase views 
     * 
     */
    public class SemanticTagSuggestionTreePresenter extends Presenter
    {
        protected var repoNode:IRepoNode;        

        [Bindable] protected var rootNode:TreeNode;
        
		[Embed(source="images/icons/add_category.gif")]
		private var tagIcon:Class;
		
		        
        /**
         * Constructor 
         * 
         * @param treeView tree view to control
         * 
         */
        public function SemanticTagSuggestionTreePresenter(treeView:SemanticTagSuggestionTreeViewBase, repoNode:IRepoNode)        
        {
            super(treeView);

            this.repoNode = repoNode;  

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
        protected function get treeView():SemanticTagSuggestionTreeViewBase
        {
            return this.view as SemanticTagSuggestionTreeViewBase;            
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
            
            treeView.setStyle("defaultLeafIcon", tagIcon);
            
            refresh();
        }
        
        /**
         * Refresh semantic tag tree with latest semantic tag data 
         * 
         */
        public function refresh():void
        {
            var responder:Responder = new Responder(onResultGetSemanticTags, onFaultGetSemanticTags);
            var semanticTagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.SUGGEST_SEMANTIC_TAGS, responder, repoNode); 
            semanticTagsEvent.dispatch();                                            
        }

        /**
         * Handler called when get categories service successfully completed
         * 
         * @param data category data returned
         */
        protected function onResultGetSemanticTags(data:Object):void
        {
            var result:XML = data as XML;
            
            // todo i18n
            rootNode = new TreeNode("Semantic Categories/Tags", "rootCategory");
            rootNode.nodeRef = "rootCategory";  
            rootNode.name = "Semantic Categories/Tags";                  
            treeView.dataProvider = rootNode;
       
            rootNode.children = new ArrayCollection();

            for each (var category:XML in result.type)
            {
            	var typeName:String = category.@name;
                var typeNode:SemanticTagTreeNode = new SemanticTagTreeNode(typeName, typeName);
                typeNode.name = typeName;    
                rootNode.children.addItem(typeNode);

                for each (var tag:XML in category.tag)
                {
                	var tagName:String = tag.name;
                	if (tag.normalized != "")
                	{
						tagName = tag.normalized;	                		
                	}
                    var tagNode:SemanticTagTreeNode = new SemanticTagTreeNode(tagName, tag.nameURI);
                    
                    tagNode.name = tag.name;    
                    tagNode.uri = tag.nameURI;
                    tagNode.relevance = tag.relevance;
                    tagNode.normalizedName = tag.normalized;
                    tagNode.latitude = tag.latitude;
                    tagNode.longitude = tag.longitude;
                    tagNode.website = tag.website;
                    tagNode.ticker = tag.ticker;
                    tagNode.semanticCategoryName = typeName;
                    
                    typeNode.children.addItem(tagNode);
                	treeView.setItemIcon(tagNode, tagIcon, null);                    	
                }

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
			var isOpen:Boolean = treeView.isItemOpen(rootNode);
			if (isOpen == false)
			{
        		treeView.expandItem(rootNode, true, false);
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
                    treeView.expandItem(treeView.selectedItem, false, false); 
                }
            } 
            else
            {
                treeView.expandItem(treeView.selectedItem, true, false); 
            }
            
            prevItem = treeView.selectedItem;
        }                                                            

    }   
}

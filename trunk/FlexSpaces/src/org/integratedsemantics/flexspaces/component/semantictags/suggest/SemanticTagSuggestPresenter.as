package org.integratedsemantics.flexspaces.component.semantictags.suggest
{
    import flash.events.MouseEvent;
    
    import mx.collections.XMLListCollection;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.semantictags.suggesttree.SemanticTagSuggestionTreePresenter;
    import org.integratedsemantics.flexspaces.control.event.SemanticTagsEvent;
    import org.integratedsemantics.flexspaces.framework.dialog.DialogPresenter;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;
    import org.integratedsemantics.flexspaces.model.tree.SemanticTagTreeNode;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;

    
    /**
     *  Presenter for semantic tag suggestion dialog that allows adding and deleting semantic tags
     *  suggested from analysis of content
     *  
     *  Presenter/Controller of SemanticTagSuggestViewBase views  
     * 
     */
    public class SemanticTagSuggestPresenter extends DialogPresenter
    {
        protected var repoNode:IRepoNode;        
        protected var semanticTagTreePresenter:SemanticTagSuggestionTreePresenter;
        protected var onComplete:Function;

               
        /**
         * Constructor 
         * 
         * @param semanticTagSuggestView  view for to control
         * @param repoNode  node to suggest/edit semantic tags on
         * @param onComplete  handler to call after renaming
         * 
         */
        public function SemanticTagSuggestPresenter(semanticTagSuggestView:SemanticTagSuggestViewBase, repoNode:IRepoNode, 
                                                    onComplete:Function=null)
        {
            super(semanticTagSuggestView);
            
            this.repoNode = repoNode;  

            this.onComplete = onComplete;            
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get semanticTagSuggestView():SemanticTagSuggestViewBase
        {
            return this.view as SemanticTagSuggestViewBase;            
        }       

        /**
         * Handle view creation complete by requesting name property data from server 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);

            var model:AppModelLocator = AppModelLocator.getInstance();

            // only setup semantic tags if Calias tagging features enabling has been configured
            if (model.enableCalias == true)
			{
	            semanticTagTreePresenter = new SemanticTagSuggestionTreePresenter(semanticTagSuggestView.semanticTagTreeView, repoNode);    
	                      
	            observeButtonClick(semanticTagSuggestView.addExistingCategoryBtn, onAddSuggestedTagBtn);
	            observeButtonClick(semanticTagSuggestView.removeCategoryBtn, onRemoveTagBtn);
	
	            // get updated list of semantic tags on node
	            var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);
	            var tagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.GET_NODE_SEMANTIC_TAGS, responder, repoNode); 
	            tagsEvent.dispatch();                                            
	            
	            // disable add/remove btns if don't have write permission 
	            var node:Node = repoNode as Node;
	            if (node.writePermission == false)
	            {
	                semanticTagSuggestView.addExistingCategoryBtn.enabled = false;
	                semanticTagSuggestView.addExistingCategoryBtn.visible = false;
	                semanticTagSuggestView.removeCategoryBtn.enabled = false;
	                semanticTagSuggestView.removeCategoryBtn.visible = false;
	            }  
        	}                                                             
        }
               
        /**
         * Handle close buttion click
         * (not for X close in title area)
         * 
         * @param click event
         * 
         */
        override protected function onCloseBtn(event:MouseEvent):void 
        {            
            PopUpManager.removePopUp(semanticTagSuggestView);
            if (onComplete != null)
            {
                onComplete();
            }                        
        }

        /**
         * Handler called when get tags service successfully completed
         * 
         * @param data category data returned
         */
        protected function onResultGetTags(data:Object):void
        {
            var categoryCollection:XMLListCollection = new XMLListCollection(data.tags.tag); 
            semanticTagSuggestView.categories = categoryCollection;
        }        
        
        /**
         * Handler called when server get tags returns fault
         *  
         * @param info fault info
         * 
         */
        protected function onFaultGetTags(info:Object):void
        {
            trace("onFaultGetTags" + info);            
        }   
        
        /**
         * Handle add existing tag buttion click
         * 
         * @param click event
         * 
         */
        protected function onAddSuggestedTagBtn(event:MouseEvent):void 
        {            
            if (semanticTagSuggestView.semanticTagTreeView.selectedItem != null)
            {
            	// only allow adding leaf tags, not tag categories
            	var treeNode:SemanticTagTreeNode = semanticTagSuggestView.semanticTagTreeView.selectedItem as SemanticTagTreeNode;
            	if ((treeNode.children == null) || (treeNode.children.length == 0))
            	{
	                var responder:Responder = new Responder(onResultAddTag, onFaultAddTag);                        
	                var semanticTagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.ADD_NEW_SEMANTIC_TAG, 
                                                          responder, repoNode, null, treeNode.semanticCategoryName, treeNode); 
	                semanticTagsEvent.dispatch();
                }
            }                                            
        }

        /**
         * Handler called when add new tag successfully completed
         * 
         * @param data  result data
         */
        protected function onResultAddTag(data:Object):void
        {
            // get updated list of semantic tags on node
            var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);
            var event:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.GET_NODE_SEMANTIC_TAGS, responder, repoNode); 
            event.dispatch();                                            
        }
        
        /**
         * Handler for add new tag fault 
         * 
         * @param info fault info
         * 
         */
        protected function onFaultAddTag(info:Object):void
        {
            trace("onFaultAddTag" + info);            
        }    

        /**
         * Handle remove tag buttion click
         * 
         * @param click event
         * 
         */
        protected function onRemoveTagBtn(event:MouseEvent):void 
        {      
            if (semanticTagSuggestView.categoryList.selectedItem != null)
            {      
                var responder:Responder = new Responder(onResultRemoveTag, onFaultRemoveTag);
                            
                var tagNode:RepoNode = new RepoNode();                
                tagNode.nodeRef = semanticTagSuggestView.categoryList.selectedItem.noderef;                
           
                var tagEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.REMOVE_SEMANTIC_TAG, responder, repoNode, tagNode); 
                tagEvent.dispatch();
            }
        }

        /**
         * Handler called when remove semantic tag successfully completed
         * 
         * @param data  result data
         */
        protected function onResultRemoveTag(data:Object):void
        {
            // get updated list of semantic tags on node
            var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);
            var event:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.GET_NODE_SEMANTIC_TAGS, responder, repoNode); 
            event.dispatch();                                            
        }
        
        /**
         * Handler for remove tag fault 
         * 
         * @param info fault info
         * 
         */
        protected function onFaultRemoveTag(info:Object):void
        {
            trace("onFaultRemoveTag" + info);            
        }            
        
    }
}
package org.integratedsemantics.flexspaces.component.semantictags.properties
{
    import flash.events.MouseEvent;
    
    import mx.collections.XMLListCollection;
    import mx.events.FlexEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.semantictags.tree.SemanticTagTreePresenter;
    import org.integratedsemantics.flexspaces.control.event.CategoriesEvent;
    import org.integratedsemantics.flexspaces.control.event.SemanticTagsEvent;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;

    
    /**
     *  Presenter for semantic tag properties panel for viewing/editing semantic tag properties
     *  on a doc/folder
     *  
     *  Presenter/Controller of SemanticTagPropertiesViewBase views  
     * 
     */
    public class SemanticTagPropertiesPresenter extends Presenter
    {
        protected var repoNode:IRepoNode;        
        protected var semanticTagTreePresenter:SemanticTagTreePresenter;

               
        /**
         * Constructor 
         * 
         * @param semanticTagPropertiesView  view for to control
         * @param repoNode  node to view/edit category properties on
         * 
         */
        public function SemanticTagPropertiesPresenter(semanticTagPropertiesView:SemanticTagPropertiesViewBase, repoNode:IRepoNode)
        {
            super(semanticTagPropertiesView);
            
            this.repoNode = repoNode;  

            if (semanticTagPropertiesView.initialized == true)
            {
                onCreationComplete(new FlexEvent(""));
            }
            else
            {
                observeCreation(semanticTagPropertiesView, onCreationComplete);            
            }                                      
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get semanticTagPropertiesView():SemanticTagPropertiesViewBase
        {
            return this.view as SemanticTagPropertiesViewBase;            
        }       

        /**
         * Handle view creation complete by requesting name property data from server 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
            semanticTagTreePresenter = new SemanticTagTreePresenter(semanticTagPropertiesView.semanticTagTreeView);    
                      
            observeButtonClick(semanticTagPropertiesView.addExistingCategoryBtn, onAddExistingTagBtn);
            observeButtonClick(semanticTagPropertiesView.removeCategoryBtn, onRemoveTagBtn);

            // get updated list of semantic tags on node
            var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);
            var tagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.GET_NODE_SEMANTIC_TAGS, responder, repoNode); 
            tagsEvent.dispatch();                                            
            
            // disable add/remove btns if don't have write permission 
            var node:Node = repoNode as Node;
            if (node.writePermission == false)
            {
                semanticTagPropertiesView.addExistingCategoryBtn.enabled = false;
                semanticTagPropertiesView.addExistingCategoryBtn.visible = false;
                semanticTagPropertiesView.removeCategoryBtn.enabled = false;
                semanticTagPropertiesView.removeCategoryBtn.visible = false;
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
            semanticTagPropertiesView.categories = categoryCollection;
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
        protected function onAddExistingTagBtn(event:MouseEvent):void 
        {            
            if (semanticTagPropertiesView.semanticTagTreeView.selectedItem != null)
            {
            	// only allow adding leaf tags, not tag categories
            	var treeNode:TreeNode = semanticTagPropertiesView.semanticTagTreeView.selectedItem as TreeNode;
            	if ((treeNode.children == null) || (treeNode.children.length == 0))
            	{
	                var tagNode:IRepoNode = semanticTagPropertiesView.semanticTagTreeView.selectedItem as IRepoNode;                
	                var responder:Responder = new Responder(onResultAddTag, onFaultAddTag);                        
	                var semanticTagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.ADD_SEMANTIC_TAG, responder, repoNode, tagNode); 
	                semanticTagsEvent.dispatch();
                }
            }                                            
        }

        /**
         * Handler called when add tag successfully completed
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
         * Handler for add tag fault 
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
            if (semanticTagPropertiesView.categoryList.selectedItem != null)
            {      
                var responder:Responder = new Responder(onResultRemoveTag, onFaultRemoveTag);
                            
                var tagNode:RepoNode = new RepoNode();                
                tagNode.nodeRef = semanticTagPropertiesView.categoryList.selectedItem.noderef;                
           
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
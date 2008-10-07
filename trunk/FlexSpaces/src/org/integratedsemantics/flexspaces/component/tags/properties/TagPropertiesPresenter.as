package org.integratedsemantics.flexspaces.component.tags.properties
{
    import flash.events.MouseEvent;
    
    import mx.collections.XMLListCollection;
    import mx.events.FlexEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.TagsEvent;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;

    
    /**
     *  Presenter for Tags properties panel for viewing/editing tags on a doc/folder
     *  
     *  Presenter/Controller of TagPropertiesViewBase views  
     * 
     */
    public class TagPropertiesPresenter extends Presenter
    {
        protected var repoNode:IRepoNode;        

               
        /**
         * Constructor 
         * 
         * @param tagsView  view for to control
         * @param repoNode  node to view/edit tag properties on
         * 
         */
        public function TagPropertiesPresenter(tagsView:TagPropertiesViewBase, repoNode:IRepoNode)
        {
            super(tagsView);
            
            this.repoNode = repoNode;        

            if (tagsView.initialized == true)
            {
                onCreationComplete(new FlexEvent(""));
            }
            else
            {
                observeCreation(tagsView, onCreationComplete);            
            }                
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get tagsView():TagPropertiesViewBase
        {
            return this.view as TagPropertiesViewBase;            
        }       

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {            
            observeButtonClick(tagsView.addNewTagBtn, onAddNewTagBtn);
            observeButtonClick(tagsView.addExistingTagBtn, onAddExistingTagBtn);
            observeButtonClick(tagsView.removeTagBtn, onRemoveTagBtn);

            // get tags on node            
            var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);
            var tagsEvent:TagsEvent = new TagsEvent(TagsEvent.GET_TAGS, responder, repoNode);
            tagsEvent.dispatch();
            
            // get all tags
            responder = new Responder(onResultGetAllTags, onFaultGetAllTags);
            tagsEvent = new TagsEvent(TagsEvent.GET_TAGS, responder, null);
            tagsEvent.dispatch();       
            
            // disable add/remove btns if don't have write permission 
            var node:Node = repoNode as Node;
            if (node.writePermission == false)
            {
                tagsView.addNewTagBtn.enabled = false;
                tagsView.addNewTagBtn.visible = false;                
                tagsView.addExistingTagBtn.enabled = false;
                tagsView.addExistingTagBtn.visible = false;                
                tagsView.removeTagBtn.enabled = false;
                tagsView.removeTagBtn.visible = false;
            }                                                                                    
        }
        

        /**
         * Handler called when get tags successfully completed
         * 
         * @param data  tags data 
         */
        protected function onResultGetTags(data:Object):void
        {
            var tagCollection:XMLListCollection = new XMLListCollection(data.tags.tag); 
            tagsView.tags = tagCollection;
        }
        
        /**
         * Handler for get tags fault 
         * 
         * @param info fault info
         * 
         */
        protected function onFaultGetTags(info:Object):void
        {
            trace("onFaultGetTags" + info);            
        }    
        
        /**
         * Handler called when get all tags successfully completed
         * 
         * @param data  tags data 
         */
        protected function onResultGetAllTags(data:Object):void
        {
            var tagCollection:XMLListCollection = new XMLListCollection(data.tags.tag); 
            tagsView.allTags = tagCollection;
        }
        
        /**
         * Handler for get all tags fault 
         * 
         * @param info fault info
         * 
         */
        protected function onFaultGetAllTags(info:Object):void
        {
            trace("onFaultGetAllTags" + info);            
        }    

        /**
         * Handle add new tag buttion click
         * 
         * @param click event
         * 
         */
        protected function onAddNewTagBtn(event:MouseEvent):void 
        {     
            if (tagsView.tagName.text != "")
            {       
                var responder:Responder = new Responder(onResultAddTag, onFaultAddTag);
                var tagsEvent:TagsEvent = new TagsEvent(TagsEvent.ADD_TAG, responder, repoNode, tagsView.tagName.text);
                tagsEvent.dispatch();
            }            
        }

        /**
         * Handle add existing tag buttion click
         * 
         * @param click event
         * 
         */
        protected function onAddExistingTagBtn(event:MouseEvent):void 
        {           
            if (tagsView.allTagsList.selectedItem != null)
            { 
                var responder:Responder = new Responder(onResultAddTag, onFaultAddTag);
                var tagsEvent:TagsEvent = new TagsEvent(TagsEvent.ADD_TAG, responder, repoNode, tagsView.allTagsList.selectedItem.name);
                tagsEvent.dispatch();
            }            
        }

        /**
         * Handler called when add tag successfully completed
         * 
         * @param data  result data
         */
        protected function onResultAddTag(data:Object):void
        {
            // get all tags for new tag case
            responder = new Responder(onResultGetAllTags, onFaultGetAllTags);
            tagsEvent = new TagsEvent(TagsEvent.GET_TAGS, responder, null);
            tagsEvent.dispatch();                                    

            // get updated list of tags on node
            var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);
            var tagsEvent:TagsEvent = new TagsEvent(TagsEvent.GET_TAGS, responder, repoNode);
            tagsEvent.dispatch();            
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
            if (tagsView.tagList.selectedItem != null)
            {
                var responder:Responder = new Responder(onResultRemoveTag, onFaultRemoveTag);
                var tagsEvent:TagsEvent = new TagsEvent(TagsEvent.REMOVE_TAG, responder, repoNode, tagsView.tagList.selectedItem.name);
                tagsEvent.dispatch();
            }            
        }

        /**
         * Handler called when remove tag successfully completed
         * 
         * @param data  result data
         */
        protected function onResultRemoveTag(data:Object):void
        {
            // get updated list of tags on node
            var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);
            var tagsEvent:TagsEvent = new TagsEvent(TagsEvent.GET_TAGS, responder, repoNode);
            tagsEvent.dispatch();            
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
package org.integratedsemantics.flexspaces.presmodel.tags.properties
{
    import mx.collections.ArrayCollection;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.TagsEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.vo.GetTagsVO;
    import org.integratedsemantics.flexspaces.model.vo.TagVO;

    
    /**
     *  Presentation model for Tags properties panel for viewing/editing tags on a doc/folder
     *  
     */
    [Bindable] 
    public class TagPropertiesPresModel extends PresModel
    {
        public var repoNode:IRepoNode;        

        public var tags:ArrayCollection;  
        public var selectedNodeTag:TagVO = null;
         
        public var allTags:ArrayCollection;   
        public var selectedExistingTag:TagVO = null;
        
        public var newTagText:String = "";

		public var enableAdd:Boolean = true;
		public var enableRemove:Boolean = true;
		public var enableNew:Boolean = true;
               
        /**
         * Constructor 
         * 
         * @param repoNode  node to view/edit tag properties on
         * 
         */
        public function TagPropertiesPresModel(repoNode:IRepoNode)
        {
            super();
            
            this.repoNode = repoNode;      
            
            // disable add/remove category btns if don't have write permission 
            var node:Node = repoNode as Node;
            if (node.writePermission == false)
            {
                enableAdd = false;
                enableRemove = false;
                enableNew = false;
            }                                                                                           
        }
        
        /**
         * Get tags on node
         * 
         */
        public function getNodeTags():void
        {            
            // get tags on node            
            var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);
            var tagsEvent:TagsEvent = new TagsEvent(TagsEvent.GET_TAGS, responder, repoNode);
            tagsEvent.dispatch();
        }
        
        /**
         * Get all existing tags available 
         * 
         */
        public function getAllTags():void
        {    
            // get all tags
            var responder:Responder = new Responder(onResultGetAllTags, onFaultGetAllTags);
            var tagsEvent:TagsEvent = new TagsEvent(TagsEvent.GET_TAGS, responder, null);
            tagsEvent.dispatch();       
        }
        

        /**
         * Handler called when get tags successfully completed
         * 
         * @param data  tags data 
         */
        protected function onResultGetTags(data:Object):void
        {
            var getTagsVO:GetTagsVO = data as GetTagsVO; 
            tags = getTagsVO.tags;
            getTagsVO.tags = null;
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
            var getTagsVO:GetTagsVO = data as GetTagsVO; 
            allTags = getTagsVO.tags;
            getTagsVO.tags = null;            
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

        public function addNewTag():void 
        {     
            if (newTagText != "")
            {       
                addTag(newTagText);
            }            
        }

		public function addExistingTag():void
		{
            if (selectedExistingTag != null)
            { 
                addTag(selectedExistingTag.name);
            }                        
		}
		
        /**
         * add (new or existing) tag to node
         * 
         * @param tagName name of tag to add to node
         * 
         */
        public function addTag(tagName:String):void 
        {   
            var responder:Responder = new Responder(onResultAddTag, onFaultAddTag);
            var tagsEvent:TagsEvent = new TagsEvent(TagsEvent.ADD_TAG, responder, repoNode, tagName);
            tagsEvent.dispatch();
        }
           
        /**
         * Handler called when add tag successfully completed
         * 
         * @param data  result data
         */
        protected function onResultAddTag(data:Object):void
        {
            // get all tags for new tag case
            getAllTags();                                  

            // get updated list of tags on node
            getNodeTags();         
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
         * Remove tag from node
         * 
         * @param tagName name of tag to remove from node
         * 
         */
        public function removeTag():void 
        {                    	
            if (selectedNodeTag != null)
            {
                var tagName:String = selectedNodeTag.name;
	            var responder:Responder = new Responder(onResultRemoveTag, onFaultRemoveTag);
	            var tagsEvent:TagsEvent = new TagsEvent(TagsEvent.REMOVE_TAG, responder, repoNode, tagName);
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
            getNodeTags();  
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
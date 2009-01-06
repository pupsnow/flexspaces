package org.integratedsemantics.flexspaces.presmodel.semantictags.suggest
{
    import mx.collections.ArrayCollection;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.SemanticTagsEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;
    import org.integratedsemantics.flexspaces.model.tree.SemanticTagTreeNode;
    import org.integratedsemantics.flexspaces.model.vo.CategoryVO;
    import org.integratedsemantics.flexspaces.presmodel.semantictags.suggesttree.SemanticTagSuggestionTreePresModel;

    
    /**
     *  Presentation model for semantic tag suggestion dialog that allows adding and deleting semantic tags
     *  suggested from analysis of content
     *  
     */
    [Bindable] 
    public class SemanticTagSuggestPresModel extends PresModel
    {
        public var repoNode:IRepoNode;
                
        public var categories:ArrayCollection;   

        public var semanticTagTreePresModel:SemanticTagSuggestionTreePresModel;
        public var selectedNodeSemanticTag:CategoryVO = null;

		public var enableAdd:Boolean = true;
		public var enableRemove:Boolean = true;

        public var model:AppModelLocator = AppModelLocator.getInstance();

               
        /**
         * Constructor 
         * 
         * @param repoNode  node to suggest/edit semantic tags on
         * 
         */
        public function SemanticTagSuggestPresModel(repoNode:IRepoNode)
        {
            super();
            
            this.repoNode = repoNode;  
            
            // disable add/remove semantic btns if don't have write permission 
            var node:Node = repoNode as Node;
            if (node.writePermission == false)
            {
                enableAdd = false;
                enableRemove = false;
            }                                                                               

            if (model.calaisConfig.enableCalias == true)
			{
	            semanticTagTreePresModel = new SemanticTagSuggestionTreePresModel(repoNode);    
			}            
        }
        
        /**
         * get node semantic tags 
         * 
         * @param creation complete event
         * 
         */
        public function getNodeSemanticTags():void
        {
            // get updated list of semantic tags on node
            var responder:Responder = new Responder(onResultGetTags, onFaultGetTags);
            var tagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.GET_NODE_SEMANTIC_TAGS, responder, repoNode); 
            tagsEvent.dispatch();                                            
        }
               
        /**
         * Handler called when get tags service successfully completed
         * 
         * @param data category data returned
         */
        protected function onResultGetTags(data:Object):void
        {
            categories = data as ArrayCollection;
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
         * Add new suggested semantic tag
         * 
         * @param treeNode semaantic tag tree node
         * 
         */
        public function addSuggestedTagFromTree():void 
        {            
          	var treeNode:SemanticTagTreeNode = semanticTagTreePresModel.selectedNode;

			if (treeNode != null)
			{        	
	        	// only allow adding leaf tags, not tag categories
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
            getNodeSemanticTags();                                         
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
         * remove semantic tag
         * 
         * @param nodeRef tag node node ref
         * 
         */
        public function removeSemanticTag():void 
        {   
        	if (selectedNodeSemanticTag != null)
        	{           	   
	            var responder:Responder = new Responder(onResultRemoveTag, onFaultRemoveTag);
	                        
	            var tagNode:RepoNode = new RepoNode();                
	            tagNode.nodeRef = selectedNodeSemanticTag.nodeRef;                
	       
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
            getNodeSemanticTags();                                       
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
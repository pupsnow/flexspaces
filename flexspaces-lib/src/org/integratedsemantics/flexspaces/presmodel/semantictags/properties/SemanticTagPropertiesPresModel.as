package org.integratedsemantics.flexspaces.presmodel.semantictags.properties
{
    import mx.collections.ArrayCollection;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.SemanticTagsEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.repo.RepoNode;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;
    import org.integratedsemantics.flexspaces.model.vo.CategoryVO;
    import org.integratedsemantics.flexspaces.presmodel.semantictags.tree.SemanticTagTreePresModel;

    
    /**
     *  Presentation model for semantic tag properties panel for viewing/editing semantic tag properties
     *  on a doc/folder
     *  
     */
    [Bindable] 
    public class SemanticTagPropertiesPresModel extends PresModel
    {
    	// doc/folder node to edit semantic tag properties on 
        public var repoNode:IRepoNode;        

        public var categories:ArrayCollection;   
        public var selectedNodeSemanticTag:CategoryVO = null;

        public var semanticTagTreePresModel:SemanticTagTreePresModel;

		public var enableAdd:Boolean = true;
		public var enableRemove:Boolean = true;

               
        /**
         * Constructor 
         * 
         * @param repoNode  node to view/edit category properties on
         * 
         */
        public function SemanticTagPropertiesPresModel(repoNode:IRepoNode)
        {
            super();
            
            this.repoNode = repoNode;  

            semanticTagTreePresModel = new SemanticTagTreePresModel();
            
            // disable add/remove semantic btns if don't have write permission 
            var node:Node = repoNode as Node;
            if (node.writePermission == false)
            {
                enableAdd = false;
                enableRemove = false;
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
         * Add existing semantic tag to node
         * 
         * @param tagNode  semantic tag node to add to node
         * 
         */
        public function addSemanticTagFromTree():void 
        {    
            if (semanticTagTreePresModel.selectedNode != null)
            {
            	// only allow adding leaf tags, not tag categories
            	var treeNode:TreeNode = semanticTagTreePresModel.selectedNode;
            	if ((treeNode.children == null) || (treeNode.children.length == 0))
            	{
	                var tagNode:IRepoNode = treeNode as IRepoNode;                
		            var responder:Responder = new Responder(onResultAddTag, onFaultAddTag);                        
		            var semanticTagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.ADD_SEMANTIC_TAG, responder, 
		                                                                            repoNode, tagNode); 
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
            getNodeSemanticTags();                                           
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
         * Remove semantic tag from node
         * 
         * @param click event
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
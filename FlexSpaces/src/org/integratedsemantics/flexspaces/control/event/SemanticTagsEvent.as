package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.tree.SemanticTagTreeNode;


	/**
	 * Event to request list of semantic tags, add/remove semantic tags
	 */
	public class SemanticTagsEvent extends UMEvent
	{
		/** Event name */
		public static const GET_SEMANTIC_TAGS:String = "getSemanticTags";
        public static const ADD_SEMANTIC_TAG:String = "addSemanticTag";
        public static const REMOVE_SEMANTIC_TAG:String = "removeSemanticTag";
        public static const AUTO_SEMANTIC_TAG:String = "autoSemanticTag";
        public static const GET_SEMANTIC_TAG_TREE:String = "getSemanticTagTree";
		public static const GET_NODE_SEMANTIC_TAGS:String = "getNodeSemanticTags";
		public static const SUGGEST_SEMANTIC_TAGS:String = "suggestSemanticTags";
		public static const ADD_NEW_SEMANTIC_TAG:String = "addNewSemanticTag";

        public var repoNode:IRepoNode;
        public var tagNode:IRepoNode;
        public var semanticCategory:String;
        public var semanticTagTreeNode:SemanticTagTreeNode;

        
        /**
         * Constructor 
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param repoNode node to get list of tags, null for all tags
         * @param tagNode semantic tag node to add/remove from node
         * @param semantic category of tags (or null for all semantic tags) 
         * @param semanticTagTreeNode info adding for a new semantic tag
         * 
         */
        public function SemanticTagsEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode, tagNode:IRepoNode=null, 
                                          semanticCategory:String=null, semanticTagTreeNode:SemanticTagTreeNode=null)
        {
            super(eventType, handlers);
            
            this.repoNode = repoNode;
            this.tagNode = tagNode;
            this.semanticCategory = semanticCategory;
            this.semanticTagTreeNode = semanticTagTreeNode;
        }       
				
	}
}
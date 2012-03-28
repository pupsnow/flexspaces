package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


	/**
	 * Event to request list of tags, add/remove tags
	 */
	public class TagsEvent extends UMEvent
	{
		/** Event name */
		public static const GET_TAGS:String = "getTags";
        public static const ADD_TAG:String = "addTag";
        public static const REMOVE_TAG:String = "removeTag";

        public var repoNode:IRepoNode;
        public var tagName:String;

        
        /**
         * Constructor 
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param repoNode node to get list of tags, null for all tags
         * @param tagName name of tag to add/remove
         * 
         */
        public function TagsEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode, tagName:String=null)
        {
            super(eventType, handlers);
            
            this.repoNode = repoNode;
            this.tagName = tagName;
        }       
				
	}
}
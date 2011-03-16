package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Event to request category tree data, by requesting one level
     * of sub-categories for a given category
     */
	public class CategoriesEvent extends UMEvent
	{
		/** Event name */
		public static const GET_CATEGORIES:String = "getCategories";
        public static const GET_CATEGORY_PROPERTIES:String = "getCategoryProperties";
        public static const ADD_CATEGORY:String = "addCategory";
        public static const REMOVE_CATEGORY:String = "removeCategory";

        public var repoNode:IRepoNode;
        public var categoryNode:IRepoNode;
        
                
        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers responder with result and fault handlers
         * @param repoNode parent category node or node with "rootCategory" nodeRef to get root categories
         * @param categoryNode category node to add or remove form the repoNode node
         * 
         */
        public function CategoriesEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode, categoryNode:IRepoNode=null)
        {
            super(eventType, handlers);
            
            this.repoNode = repoNode;
            this.categoryNode = categoryNode;
        }       
				
	}
}
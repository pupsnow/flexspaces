package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;

	/**
	 * Event to request a list of the versions of doc node
	 */
	public class VersionListEvent extends UMEvent
	{
		/** Event name */
		public static const VERSION_LIST:String = "versionList";

        public var repoNode:IRepoNode;
        
        		
        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param repoNode node to get version list for
         * 
         */
        public function VersionListEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode)
        {
            super(eventType, handlers);
            
            this.repoNode = repoNode;
        }       
				
	}
}
package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


	/**
	 * Event to request for checkin, checkout, cancelcheckout, make versionable
	 */
	public class CheckinEvent extends UMEvent
	{

		/** Event name */
		public static const CANCEL_CHECKOUT:String = "cancelCheckout";
        public static const CHECKOUT:String = "checkout";
        public static const CHECKIN:String = "checkin";
        public static const MAKE_VERSIONABLE:String = "makeVersionable";

		public var repoNode:IRepoNode;
		

		/**
		 * Constructor
		 *  
		 * @param eventType event name
		 * @param handlers handlers responder with result and fault handlers
         * @param repoNode repository node
		 * 
		 */
		public function CheckinEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode)
		{
            super(eventType, handlers);
			
			this.repoNode = repoNode;
		}		
		
	}
}
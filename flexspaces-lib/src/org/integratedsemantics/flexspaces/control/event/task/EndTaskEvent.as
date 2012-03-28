package org.integratedsemantics.flexspaces.control.event.task
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;


	/**
	 * Event to request ending (approve, reject, adhoc done,  etc.) a task
	 */
	public class EndTaskEvent extends UMEvent
	{
		/** Event name */
		public static const END_TASK:String = "endTask";

        public var taskId:String;
        public var transitionId:String;
        

		/**
		 * Constructor
		 *  
		 * @param eventType event name
		 * @param handlers responder with result and fault handlers
		 * @param taskId  task id
		 * @param transitionId transition id such as "approve", "reject", etc. (addhoc done empty string)
		 * 
		 */
		public function EndTaskEvent(eventType:String, handlers:IResponder, taskId:String, transitionId:String)
		{
            super(eventType, handlers);
			
            this.taskId = taskId;
            this.transitionId = transitionId;
		}
		
	}
}
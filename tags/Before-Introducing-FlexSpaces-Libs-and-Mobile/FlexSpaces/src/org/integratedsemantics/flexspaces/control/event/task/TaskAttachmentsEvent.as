package org.integratedsemantics.flexspaces.control.event.task
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;


	/**
	 * Event to request list of attachments on a task
	 */
	public class TaskAttachmentsEvent extends UMEvent
	{
		/** Event name */
		public static const TASK_ATTACHMENTS:String = "taskAttachments";

        public var taskId:String;
        
        
		/**
		 * Constructor
		 *  
		 * @param eventType event name
		 * @param handlers responder with result and fault handlers
		 * @param taskId task id to get attachments / resources list
		 * 
		 */
		public function TaskAttachmentsEvent(eventType:String, handlers:IResponder, taskId:String)
		{
            super(eventType, handlers);
            
            this.taskId = taskId;
		}
		
	}
}
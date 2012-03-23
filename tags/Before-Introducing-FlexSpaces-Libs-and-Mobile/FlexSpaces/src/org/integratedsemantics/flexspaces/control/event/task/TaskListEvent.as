package org.integratedsemantics.flexspaces.control.event.task
{
    import mx.rpc.IResponder;
    import com.universalmind.cairngorm.events.UMEvent;


	/**
	 * Event to request task list for the current user
	 */
	public class TaskListEvent extends UMEvent
	{
		/** Event name */
		public static const TASK_LIST:String = "taskList";


		/**
		 * Constructor
		 *  
		 * @param eventType event name
		 * @param handlers responder with result and fault handlers
		 * 
		 */
		public function TaskListEvent(eventType:String, handlers:IResponder)
		{
            super(eventType, handlers);			
		}
		
	}
}
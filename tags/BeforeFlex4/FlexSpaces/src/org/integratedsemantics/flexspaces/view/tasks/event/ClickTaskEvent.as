package org.integratedsemantics.flexspaces.view.tasks.event
{
	import flash.events.Event;

	/**
	 * Event fired when a task in task list is clicked on
	 */
	public class ClickTaskEvent extends Event
	{
		/** Event name */
		public static const CLICK_TASK:String = "clickTask";

		/** item double clicked */
		private var _item:Object;
		
		/**
		 * Constructor
		 * 
		 * @parm type event name
		 * @param item task item clicked on
		 */
		public function ClickTaskEvent(type:String, item:Object)
		{
			super(type);
			
			this._item = item;
		}
		
		/**
		 * Getter for item clicked
		 */
		public function get clickedItem():Object
		{
			return this._item;
		}
		
	}
}
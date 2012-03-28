package org.integratedsemantics.flexspaces.view.folderview.event
{
	import flash.events.Event;

	/**
	 * Double Click Doc event object
	 */
	public class DoubleClickDocEvent extends Event
	{
		/** Event name */
		public static const DOUBLE_CLICK_DOC:String = "doubleClickDoc";

		/** item double clicked */
		private var _item:Object;
		
		/**
		 * Constructor
		 * 
		 * @param type  event name
		 * @param item  node item double clicked
		 */
		public function DoubleClickDocEvent(type:String, item:Object)
		{
			super(type);
			
			this._item = item;
		}
		
		/**
		 * Getter item double clicked
		 */
		public function get doubleClickedItem():Object
		{
			return this._item;
		}
		
	}
}
package org.integratedsemantics.flexspaces.component.folderview.event
{
	import flash.events.Event;
	
	import org.integratedsemantics.flexspaces.component.folderview.NodeListViewPresenter;

	/**
	 * Click Node event object
	 */
	public class ClickNodeEvent extends Event
	{
		/** Event name */
		public static const CLICK_NODE:String = "clickNode";

		/** node clicked */
		private var _item:Object;
		
		public var folderViewPresenter:NodeListViewPresenter;
		
		/**
		 * Constructor
		 *   
		 * @param type  event name
		 * @param item  node item clicked
		 * @param folderViewPresenter presenter of folder view
		 * 
		 */
		public function ClickNodeEvent(type:String, item:Object, folderViewPresenter:NodeListViewPresenter)
		{
			super(type);
			
			this._item = item;
			this.folderViewPresenter = folderViewPresenter;
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
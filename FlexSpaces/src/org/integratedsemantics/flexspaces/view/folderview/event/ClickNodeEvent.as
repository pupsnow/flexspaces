package org.integratedsemantics.flexspaces.view.folderview.event
{
	import flash.events.Event;
	
	import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
	import org.integratedsemantics.flexspaces.view.folderview.NodeListViewBase;

	/**
	 * Click Node event object
	 */
	public class ClickNodeEvent extends Event
	{
		/** Event name */
		public static const CLICK_NODE:String = "clickNode";

		/** node clicked */
		private var _item:Object;
		
		public var folderView:Object;
		
		/**
		 * Constructor
		 *   
		 * @param type  event name
		 * @param item  node item clicked
		 * @param folderViewPresModel prese model of folder view
		 * 
		 */
		public function ClickNodeEvent(type:String, item:Object, folderView:Object)
		{
			super(type);
			
			this._item = item;
			this.folderView = folderView;
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
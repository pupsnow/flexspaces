package org.integratedsemantics.flexspaces.view.browser
{
	import flash.events.Event;


	/**
	 * Event to let containers know the repo browser has changed the folder path displayed
	 */
	public class RepoBrowserChangePathEvent extends Event
	{
		/** Event name */
		public static const REPO_BROWSER_CHANGE_PATH:String = "repoBrowserChangePath";

		/** data storing new path */
		private var newPath:String;
		
		/**
		 * Constructor
		 * 
		 * @param type     event name
		 * @param newPath  new path changed to
		 */
		public function RepoBrowserChangePathEvent(type:String, newPath:String)
		{
			super(type);
			
			this.newPath = newPath;
		}
		
		/**
		 * Getter for the new path
		 */
		public function get path():String
		{
			return this.newPath;
		}
		
	}
}
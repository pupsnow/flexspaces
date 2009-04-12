package org.integratedsemantics.flexspaces.view.folderview.event
{
	import flash.events.Event;

	/**
	 * Folder List Change Path event object
	 */
	public class FolderViewChangePathEvent extends Event
	{
		/** Event name */
		public static const FOLDERLIST_CHANGEPATH:String = "folderListChangePath";

		/** data storing new path */
		private var newPath:String;
				
		/**
		 * Constructor
		 * 
		 * @param type     event name
		 * @param newPath  new path changed to
		 */
		public function FolderViewChangePathEvent(type:String, newPath:String)
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
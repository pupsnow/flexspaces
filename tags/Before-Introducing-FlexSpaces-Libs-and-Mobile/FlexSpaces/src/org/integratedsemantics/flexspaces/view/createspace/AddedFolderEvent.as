package org.integratedsemantics.flexspaces.view.createspace
{
	import flash.events.Event;

	/**
	 * Added Folder event to notify rest of UI about folder add
	 */
	public class AddedFolderEvent extends Event
	{
		/** Event name */
		public static const ADDED_FOLDER:String = "addedFolder";

		public var parentPath:String;
		public var path:String;
		
		/**
		 * Constructor
		 * 
		 * @param type     event name
		 * @param parentPath  path of parent of new folder
		 * @param path	   path of new folder
		 */
		public function AddedFolderEvent(type:String, parentPath:String, path:String)
		{
			super(type);
			
			this.parentPath = parentPath;
			this.path = path;
		}
		
		
	}
}
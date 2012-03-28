package org.integratedsemantics.flexspaces.view.deletion
{
	import flash.events.Event;

	/**
	 * Deleted Folder event to notify rest of UI about folder removal
	 */
	public class DeletedFolderEvent extends Event
	{
		/** Event name */
		public static const DELETED_FOLDER:String = "deletedFolder";

		public var parentPath:String;
		
		/**
		 * Constructor
		 * 
		 * @param type     event name
		 * @param parentPath  path of parent of deleted folder
		 */
		public function DeletedFolderEvent(type:String, parentPath:String)
		{
			super(type);
			
			this.parentPath = parentPath;
		}		
		
	}
}
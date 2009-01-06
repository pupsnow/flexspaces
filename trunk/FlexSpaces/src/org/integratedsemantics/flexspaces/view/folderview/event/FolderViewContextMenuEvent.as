package org.integratedsemantics.flexspaces.view.folderview.event
{
	import flash.events.Event;
	
	import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;

	/**
	 * Folder List context menu selected event object
	 */
	public class FolderViewContextMenuEvent extends Event
	{
		/** Event name */
		public static const FOLDERLIST_CONTEXTMENU:String = "folderListContextMenu";

		/** data storing menu command name not label*/
		private var cmdName:String;
		
		public var folderViewPresModel:PresModel;
		
		/**
		 * Constructor
		 * 
		 * @param type        event name
		 * @param commandName name of menu command
		 * @param folderViewPresModel pres model of view
		 */
		public function FolderViewContextMenuEvent(type:String, commandName:String, folderViewPresModel:PresModel)
		{
			super(type);
			
			this.cmdName = commandName;
			this.folderViewPresModel = folderViewPresModel;
		}
		
		/**
		 * Getter for the result object instance
		 */
		public function get commandName():String
		{
			return this.cmdName;
		}
		
	}
}
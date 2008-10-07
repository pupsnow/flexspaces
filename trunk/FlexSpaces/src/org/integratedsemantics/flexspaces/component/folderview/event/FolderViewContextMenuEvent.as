package org.integratedsemantics.flexspaces.component.folderview.event
{
	import flash.events.Event;
	
	import org.integratedsemantics.flexspaces.component.folderview.NodeListViewPresenter;

	/**
	 * Folder List context menu selected event object
	 */
	public class FolderViewContextMenuEvent extends Event
	{
		/** Event name */
		public static const FOLDERLIST_CONTEXTMENU:String = "folderListContextMenu";

		/** data storing menu command name not label*/
		private var cmdName:String;
		
		public var folderViewPresenter:NodeListViewPresenter;
		
		/**
		 * Constructor
		 * 
		 * @param type        event name
		 * @param commandName name of menu command
		 * @param folderViewPresenter presenter of view
		 */
		public function FolderViewContextMenuEvent(type:String, commandName:String, folderViewPresenter:NodeListViewPresenter)
		{
			super(type);
			
			this.cmdName = commandName;
			this.folderViewPresenter = folderViewPresenter;
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
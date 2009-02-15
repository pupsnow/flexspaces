package org.integratedsemantics.flexspaces.view.folderview.event
{
	import flash.events.Event;
	
	import mx.core.DragSource;
	
	import org.integratedsemantics.flexspaces.view.folderview.NodeListViewBase;

	/**
	 * Folder List OnDrop complete event object
	 */
	public class FolderViewOnDropEvent extends Event
	{
		/** Event name */
		public static const FOLDERLIST_ONDROP:String = "folderListOnDrop";

        /** DragManager.COPY, LINK, MOVE, or NONE */
        private var action:String;
        
		/** array of drag source data */
		private var dragsource:DragSource;
	
		/** drag target folder list */
		private var targetfolderlist:NodeListViewBase;
		
		/**
		 * Constructor
		 *  
		 * @param type        event name
		 * @param action      drag action (DragManager.COPY, LINK, MOVE, or NONE)
		 * @param dragSource  drag source
		 * @param targetFolderList folder list target of drop
		 * 
		 */
		public function FolderViewOnDropEvent(type:String, action:String, dragSource:DragSource, targetFolderList:NodeListViewBase)
		{
			super(type);
			
			this.action = action;
            this.dragsource = dragSource;
            this.targetfolderlist = targetFolderList; 
		}
				
        /**
         * Getter for the drag action
         */
        public function get dragAction():String
        {
            return this.action;
        }

        /**
         * Getter for the drag source
         */
        public function get dragSource():Object
        {
            return this.dragsource;
        }

        /**
         * Getter for the target folder list
         */
        public function get targetFolderList():NodeListViewBase
        {
            return this.targetfolderlist;
        }
	}
}
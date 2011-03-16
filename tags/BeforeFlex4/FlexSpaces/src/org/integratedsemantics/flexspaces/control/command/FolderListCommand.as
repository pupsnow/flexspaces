package org.integratedsemantics.flexspaces.control.command
{	
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.FolderListDelegate;
    import org.integratedsemantics.flexspaces.control.event.FolderListEvent;

	
	/**
	 * Folder List Command provides getting list of folder contents operation
	 */
	public class FolderListCommand extends Command
	{
        /**
         * Constructor
         */
        public function FolderListCommand()
        {
            super();
        }

        /**
         * Execute command for the given event
         *  
         * @param event event calling command
         * 
         */
        override public function execute(event:CairngormEvent):void
        {
            // always call the super.execute() method which allows the 
            // callBack information to be cached.
            super.execute(event);
 
            switch(event.type)
            {
                case FolderListEvent.FOLDER_LIST:
                    getFolderList(event as FolderListEvent);  
                    break;
            }
        }       
		
		/**
		 * Gets folder list data for path 
		 * 
		 * @param event folder list event
		 */
		public function getFolderList(event:FolderListEvent):void
		{
            var handlers:Callbacks = new Callbacks(onFolderListSuccess, onFault);
            var delegate:FolderListDelegate = new FolderListDelegate(handlers);
            delegate.getFolderList(event.path, event.pageSize, event.pageNum);                  
		}
		
		/**
		 * onFolderListSuccess event handler
		 * 
		 * @param event success event
		 */
		protected function onFolderListSuccess(event:*):void
		{
            this.result(event.result);
		}
	}
	
}
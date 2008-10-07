package org.integratedsemantics.flexspaces.control.command.wcm
{	
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.wcm.WcmFolderListDelegate;
    import org.integratedsemantics.flexspaces.control.event.wcm.WcmFolderListEvent;
	
	
	/**
	 * WCM Folder List Command provides an operation to list the contents of a avm folder
	 */
	public class WcmFolderListCommand extends Command
	{
        /**
         * Constructor 
         */
        public function WcmFolderListCommand()
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
                case WcmFolderListEvent.WCM_FOLDER_LIST:
                    getFolderList(event as WcmFolderListEvent);  
                    break;
            }
        }       

		/**
		 * Gets folder listing for a wcm folder
		 * 
		 * @param event  wcm folder list event
		 */
		public function getFolderList(event:WcmFolderListEvent):void
		{
            var handlers:Callbacks = new Callbacks(onFolderListSuccess, onFault);
            var delegate:WcmFolderListDelegate = new WcmFolderListDelegate(handlers);
            delegate.getFolderList(event.storeId, event.path);                  
		}
		
		/**
		 * onFolderListSuccess event handler
		 * @param event success event
		 */
		protected function onFolderListSuccess(event:*):void
		{
            this.result(event.result);
		}
	}
	
}
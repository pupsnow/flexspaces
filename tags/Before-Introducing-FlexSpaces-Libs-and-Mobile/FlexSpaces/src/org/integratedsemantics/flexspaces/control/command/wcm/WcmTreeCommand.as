package org.integratedsemantics.flexspaces.control.command.wcm
{	
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.wcm.WcmTreeDelegate;
    import org.integratedsemantics.flexspaces.control.event.wcm.WcmTreeDataEvent;
	

	/**
	 * Wcm Tree command provides operation to get one level of folder children for a given avm folder
	 */
	public class WcmTreeCommand extends Command
	{
        /**
         * Constructor 
         */
        public function WcmTreeCommand()
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
                case WcmTreeDataEvent.WCM_TREE_DATA:
                    getFolders(event as WcmTreeDataEvent);  
                    break;
                case WcmTreeDataEvent.WCM_STORES_DATA:
                    getStores(event as WcmTreeDataEvent);  
                    break;
            }
        }       
        

		/**
		 * Gets wcm folder tree data for path (one level of children)
		 *  
         * @param event wcm tree data event
		 */
		public function getFolders(event:WcmTreeDataEvent):void
		{
            var handlers:Callbacks = new Callbacks(onTreeDataSuccess, onFault);
            var delegate:WcmTreeDelegate = new WcmTreeDelegate(handlers);
            delegate.getFolders(event.storeId, event.path);                  
		}
		
		/**
		 * onTreeDataSuccess event handler
		 * @param event success event
		 */
		protected function onTreeDataSuccess(event:*):void
		{
            this.result(event.result);
		}

        /**
         * Gets list of avm stores
         * 
         * @param event wcm tree data event         *  
         */
        public function getStores(event:WcmTreeDataEvent):void
        {
            var handlers:Callbacks = new Callbacks(onStoresSuccess, onFault);
            var delegate:WcmTreeDelegate = new WcmTreeDelegate(handlers);
            delegate.getStores();                  
        }
        
        /**
         * onStoresSuccess event handler
         * 
         * @param event success event
         */
        protected function onStoresSuccess(event:*):void
        {
            this.result(event.result);
        }

	}
	
}
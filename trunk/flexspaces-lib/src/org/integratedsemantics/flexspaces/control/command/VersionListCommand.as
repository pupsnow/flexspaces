package org.integratedsemantics.flexspaces.control.command
{	
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.VersionListDelegate;
    import org.integratedsemantics.flexspaces.control.event.VersionListEvent;

	
	/**
	 * Version List Command provides getting version history list for a doc node
	 */
	public class VersionListCommand extends Command
	{
        /**
         * Constructor
         */
        public function VersionListCommand()
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
                case VersionListEvent.VERSION_LIST:
                    getVersionList(event as VersionListEvent);  
                    break;
            }
        }       
		
		/**
		 * Gets version list for doc node 
		 * 
		 * @param event folder list event
		 */
		public function getVersionList(event:VersionListEvent):void
		{
            var handlers:Callbacks = new Callbacks(onVersionListSuccess, onFault);
            var delegate:VersionListDelegate = new VersionListDelegate(handlers);
            delegate.getVersionList(event.repoNode);                  
		}
		
		/**
		 * onVersionListSuccess event handler
		 * 
		 * @param event success event
		 */
		protected function onVersionListSuccess(event:*):void
		{
            this.result(event.result);
		}
	}
	
}
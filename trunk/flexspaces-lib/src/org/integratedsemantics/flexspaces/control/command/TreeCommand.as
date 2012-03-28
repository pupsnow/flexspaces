package org.integratedsemantics.flexspaces.control.command
{	
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.TreeDelegate;
    import org.integratedsemantics.flexspaces.control.event.TreeDataEvent;
	
	
	/**
	 * Tree command provides operation to get one level of folder children for a given adm folder
	 */
	public class TreeCommand extends Command
	{
        /**
         * Constructor
         */
        public function TreeCommand()
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
                case TreeDataEvent.TREE_DATA:
                    getFolders(event as TreeDataEvent);  
                    break;
            }
        }       
        
		/**
		 * Gets folder tree data for path (one level of children) 
		 * 
		 * @param event tree data event
		 */
		public function getFolders(event:TreeDataEvent):void
		{
            var handlers:Callbacks = new Callbacks(onTreeDataSuccess, onFault);
            var delegate:TreeDelegate = new TreeDelegate(handlers);
            delegate.getFolders(event.path);                  
		}
		
		/**
		 * onTreeDataSuccess event handler
		 * 
		 * @param event success event
		 */
		protected function onTreeDataSuccess(event:*):void
		{
            this.result(event.result);
		}
	}
	
}
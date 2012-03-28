package org.integratedsemantics.flexspaces.control.command
{	
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.CheckinDelegate;
    import org.integratedsemantics.flexspaces.control.event.CheckinEvent;

	
	/**
	 * Checkin Command provides checkin, checkout, cancel checkout, make versionable operations
	 */
	public class CheckinCommand extends Command
	{
        /**
         * Constructor
         */        
        public function CheckinCommand()
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
                case CheckinEvent.CANCEL_CHECKOUT:
                    cancelCheckout(event as CheckinEvent);  
                    break;
                case CheckinEvent.CHECKOUT:
                    checkout(event as CheckinEvent);  
                    break;
                case CheckinEvent.CHECKIN:
                    checkin(event as CheckinEvent);  
                    break;
                case CheckinEvent.MAKE_VERSIONABLE:
                    makeVersionable(event as CheckinEvent);  
                    break;
            }
        }       

		/**
		 * Perform Cancel Checkout
		 * 
		 * @param event checkin event
		 */
		public function cancelCheckout(event:CheckinEvent):void
		{
            var handlers:Callbacks = new Callbacks(onDocActionSuccess, onFault);
            var delegate:CheckinDelegate = new CheckinDelegate(handlers);
            delegate.cancelCheckout(event.repoNode);         		    
		}
		
        /**
         * Perform Checkout
         * 
         * @param event checkin event
         */
        public function checkout(event:CheckinEvent):void
        {
            var handlers:Callbacks = new Callbacks(onDocActionSuccess, onFault);
            var delegate:CheckinDelegate = new CheckinDelegate(handlers);
            delegate.checkout(event.repoNode);                  
        }
        
        /**
         * Perform Checkin
         * 
         * @param event checkin event
         */
        public function checkin(event:CheckinEvent):void
        {
            var handlers:Callbacks = new Callbacks(onDocActionSuccess, onFault);
            var delegate:CheckinDelegate = new CheckinDelegate(handlers);
            delegate.checkin(event.repoNode);                  
        }
                
        /**
         * Perform Make Versionable
         * 
         * @param event checkin event
         */
        public function makeVersionable(event:CheckinEvent):void
        {
            var handlers:Callbacks = new Callbacks(onDocActionSuccess, onFault);
            var delegate:CheckinDelegate = new CheckinDelegate(handlers);
            delegate.makeVersionable(event.repoNode);                  
        }
        
		/**
		 * onDocActionSuccess event handler
		 * 
		 * @param event success event
		 */
		protected function onDocActionSuccess(event:*):void
		{
            this.result(event.result);
		}
        
	}
	
}
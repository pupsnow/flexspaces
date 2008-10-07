package org.integratedsemantics.flexspaces.control.command
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.LogoutDelegate;
    import org.integratedsemantics.flexspaces.control.event.LogoutEvent;


    /**
     * Logout Command provides the operatio to logout a user from alfresco 
     * 
     */
    public class LogoutCommand extends Command
    {
        /**
         * Constructor
         */
        public function LogoutCommand()
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
                case LogoutEvent.LOGOUT:
                    logout(event as LogoutEvent);  
                    break;
            }
        } 
        
        /**
         * Perform Logout
         * 
         * @param event logout event
         */
        public function logout(event:LogoutEvent):void
        {
            var handlers:Callbacks = new Callbacks(onLogoutSuccess, onFault);
            var delegate:LogoutDelegate = new LogoutDelegate(handlers);
            delegate.logout();                  
        }

        /**
         * onLogoutSuccess event handler
         * 
         * @param event success event
         */
        protected function onLogoutSuccess(event:*):void
        {
            this.result("success");
        }               
        
    }
}
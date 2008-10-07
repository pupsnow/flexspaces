package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.authentication.AuthenticationService;
    import org.alfresco.framework.service.authentication.LogoutCompleteEvent;


    /**
     * Logout user with alfresco via web script 
     * 
     */
    public class LogoutDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function LogoutDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }
        
        /**
         * Logout user
         *  
         */
        public function logout():void
        {
            // Register interest in the authentication service logout success event
            AuthenticationService.instance.addEventListener(LogoutCompleteEvent.LOGOUT_COMPLETE, onLogoutSuccess);

            // Make call to authentication service to logout user
            AuthenticationService.instance.logout();
        }

        /**
         * onLogoutSuccess event handler
         * 
         * @param event success event
         */
        protected function onLogoutSuccess(event:LogoutCompleteEvent):void
        {
            AuthenticationService.instance.removeEventListener(LogoutCompleteEvent.LOGOUT_COMPLETE, onLogoutSuccess);
            
            notifyCaller(null, event);
        }        
        
    }
}
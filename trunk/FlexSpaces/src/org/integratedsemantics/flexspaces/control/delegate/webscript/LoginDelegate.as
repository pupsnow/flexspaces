package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    import org.alfresco.framework.service.authentication.AuthenticationService;
    import org.alfresco.framework.service.authentication.InvalidCredentialsError;
    import org.alfresco.framework.service.authentication.LoginCompleteEvent;
    import org.alfresco.framework.service.error.ErrorRaisedEvent;
    import org.alfresco.framework.service.error.ErrorService;


    /**
     * Login user with alfresco via web script 
     * 
     */
    public class LoginDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function LoginDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }
        
        /**
         * Login user
         *  
         * @param userName user name of user to login
         * @param password password of user to login
         * 
         */
        public function login(userName:String, password:String):void
        {
            // Register interest with the error service
            ErrorService.instance.addEventListener(ErrorRaisedEvent.ERROR_RAISED, onErrorRaised);   
            
            // Register interest in the authentication service login success event
            AuthenticationService.instance.addEventListener(LoginCompleteEvent.LOGIN_COMPLETE, onLoginSuccess);
            
            // Call authentication service to log user in
            AuthenticationService.instance.login(userName, password);        
        }
        
        /**
         * onLoginSuccess event handler
         * 
         * @param event success event
         */
        protected function onLoginSuccess(event:LoginCompleteEvent):void
        {
            ErrorService.instance.removeEventListener(ErrorRaisedEvent.ERROR_RAISED, onErrorRaised);   
            AuthenticationService.instance.removeEventListener(LoginCompleteEvent.LOGIN_COMPLETE, onLoginSuccess);
            
            var resultEvent:ResultEvent = new ResultEvent("");
            notifyCaller(event.ticket, resultEvent);
        }
        
        /**
         * On error raised event handler
         */
        protected function onErrorRaised(event:ErrorRaisedEvent):void
        {
            ErrorService.instance.removeEventListener(ErrorRaisedEvent.ERROR_RAISED, onErrorRaised);   
            AuthenticationService.instance.removeEventListener(LoginCompleteEvent.LOGIN_COMPLETE, onLoginSuccess);

            if (event.errorType == InvalidCredentialsError.INVALID_CREDENTIALS)
            {
                var faultEvent:FaultEvent = new FaultEvent(event.error.message);
                this.onFault(faultEvent);
            }
        }
        
    }
}
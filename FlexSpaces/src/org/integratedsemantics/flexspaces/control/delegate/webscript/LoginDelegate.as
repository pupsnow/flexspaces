package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.resources.ResourceManager;
    import mx.rpc.IResponder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.event.FailureEvent;
    import org.integratedsemantics.flexspaces.control.delegate.webscript.event.SuccessEvent;
    import org.integratedsemantics.flexspaces.control.error.ErrorMgr;
    import org.integratedsemantics.flexspaces.control.error.ErrorRaisedEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;


    /**
     * Login user with alfresco via web script 
     * 
     */
    public class LoginDelegate extends Delegate
    {
        private var ticket:String = null;      
        private var userName:String = null;

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
            ErrorMgr.getInstance().addEventListener(ErrorRaisedEvent.ERROR_RAISED, onErrorRaised);   
            
            // Store the user name
            this.userName = userName;

            var url:String = "/api/login";
            var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onLoginSuccess, onLoginFailure, false);
            
            var model:AppModelLocator = AppModelLocator.getInstance();
            
            if (model.ecmServerConfig.isLiveCycleContentServices == true)
            {
                webScript.resultFormat = HTTPService.RESULT_FORMAT_E4X;
            }
            else
            {
                webScript.resultFormat = HTTPService.RESULT_FORMAT_OBJECT;
            }
            
            // Build the parameter object
            var params:Object = new Object();
            params.u = userName;
            params.pw = password;
        
            // Execute the web script
            webScript.execute(params);                  
        }
        
        public function onLoginSuccess(event:SuccessEvent):void
        {
            var model:AppModelLocator = AppModelLocator.getInstance();
            if (model.ecmServerConfig.isLiveCycleContentServices == true)
            {
                ticket = event.result.toString();
            }
            else
            {
                ticket = event.result.ticket;
            }
            
            ErrorMgr.getInstance().removeEventListener(ErrorRaisedEvent.ERROR_RAISED, onErrorRaised);   
            
            var resultEvent:ResultEvent = new ResultEvent("");
            notifyCaller(ticket, resultEvent);
        }
        
        public function onLoginFailure(event:FailureEvent):void
        {
            // Clear the user name
            userName = null;
            
            // Get the error details from the failure event
            var code:String = event.fault.faultCode;
            var message:String = event.fault.faultString;
            var details:String = event.fault.faultDetail;
            
            message = ResourceManager.getInstance().getString('Services', 'login_error_message');
            
            ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, new Error(message));
        }
        
        /**
         * On error raised event handler
         */
        protected function onErrorRaised(event:ErrorRaisedEvent):void
        {
            ErrorMgr.getInstance().removeEventListener(ErrorRaisedEvent.ERROR_RAISED, onErrorRaised);   

            if (event.getErrorType() == "InvalidCredentials")
            {
                var faultEvent:FaultEvent = new FaultEvent(event.getError().message);
                this.onFault(faultEvent);
            }
        }
        
    }
}
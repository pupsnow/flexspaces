package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    import mx.rpc.http.HTTPService;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.event.SuccessEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;


    /**
     * Logout user with alfresco via web script 
     * 
     */
    public class LogoutDelegate extends Delegate
    {
        private var model:AppModelLocator = AppModelLocator.getInstance();
        
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
            if (model.ecmServerConfig.isLiveCycleContentServices == false)
            {
                var url:String = "/api/login/ticket/" + model.userInfo.loginTicket;             
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.DELETE, onLogoutSuccess);
                
                webScript.resultFormat = HTTPService.RESULT_FORMAT_OBJECT;
                
                webScript.execute();
            }   
            else
            {
                model.userInfo.loginTicket = null;
                model.userInfo.loginUserName = "";
                model.userInfo.loginPassword = "";
                notifyCaller(null, null);
            }                                   
        }

        /**
         * On logout success event handler
         */
        public function onLogoutSuccess(event:SuccessEvent):void
        {
            // Clear the current ticket information
            model.userInfo.loginTicket = null;
            model.userInfo.loginUserName = "";
            model.userInfo.loginPassword = "";
            
            notifyCaller(null, event);
        }        
        
    }
}
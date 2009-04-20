package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.event.SuccessEvent;
    import org.integratedsemantics.flexspaces.control.error.ErrorMgr;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;


    /**
     * Validates login ticket via web script 
     * 
     */
    public class ValidateTicketDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function ValidateTicketDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }
        
        /**
         * Validates ticket
         * 
         * @param ticket ticket to validate  
         */
        public function validateTicket(ticket:String):void
        {
            try
            {                   
                var url:String = "/api/login/ticket/" + ticket;
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onSuccess);
                
                var params:Object = new Object();
                                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }
        }
        
        /**
         * onSuccess event handler
         * 
         * @param event success event
         */
        protected function onSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }

    }
}
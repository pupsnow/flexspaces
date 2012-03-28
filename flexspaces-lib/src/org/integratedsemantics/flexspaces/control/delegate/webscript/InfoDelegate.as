package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.event.SuccessEvent;
    import org.integratedsemantics.flexspaces.control.error.ErrorMgr;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;


    /**
     * Gets info on server and user via web script 
     * 
     */
    public class InfoDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function InfoDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }
        
        /**
         * Gets info on server and user
         * 
         */
        public function getInfo():void
        {
            try
            {                   
                var url:String = "/flexspaces/info";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onGetInfoSuccess);
                
                var params:Object = new Object();
                                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }
        }
        
        /**
         * onGetInfoSuccess event handler
         * 
         * @param event success event
         */
        protected function onGetInfoSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }

    }
}
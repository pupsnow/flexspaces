package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;


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
                var url:String = ConfigService.instance.url +  "/flexspaces/info";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onGetInfoSuccess);
                
                var params:Object = new Object();
                                
                // using e4x not default object result format
                webScript.resultFormat ="e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
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
package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;


    /**
     * Gets list of adm folders within folder one level at a time for trees, etc. via web script 
     * 
     */
    public class TreeDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function TreeDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }
        
        /**
         * Gets list of folder childen for given adm folder (one level)
         * 
         * @param path adm folder path  
         */
        public function getFolders(path:String):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/tree";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onTreeDataSuccess);
                
                var params:Object = new Object();
                
                params.path = path;
                
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
         * onTreeDataSuccess event handler
         * 
         * @param event success event
         */
        protected function onTreeDataSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }

    }
}
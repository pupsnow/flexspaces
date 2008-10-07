package org.integratedsemantics.flexspaces.control.delegate.webscript.wcm
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;


    /**
     * Gets avm tree data: stores for first level, folders at next levels, via web scripts
     * 
     */
    public class WcmTreeDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function WcmTreeDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }

        /**
         * Gets folder tree data for path (one level of children)
         *  
         * @storeId   store id of avm store (i.e. "test--admin", etc.)
         * @path      path including /www/avm_webapps 
         */
        public function getFolders(storeId:String, path:String):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/wcm/tree";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onTreeDataSuccess);
                
                var params:Object = new Object();
                
                params.storeid = storeId;
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


        /**
         * Gets list of avm stores
         *  
         */
        public function getStores():void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/wcm/avmStores";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onStoresSuccess);
                
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
         * onStoresSuccess event handler
         * 
         * @param event success event
         */
        protected function onStoresSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }
        
    }
}
package org.integratedsemantics.flexspaces.control.delegate.webscript.wcm
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;


    /**
     * Gets list of the contents of an avm folder via web script
     * 
     */
    public class WcmFolderListDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function WcmFolderListDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }

        /**
         * Gets folder listing for a avmfolder
         * 
         * @storeId   store id of avm store (i.e. "test--admin", etc.)
         * @path      path including /www/avm_webapps but without store id
         */
        public function getFolderList(storeId:String, path:String):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/wcm/folderlist";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onFolderListDataSuccess);
                
                var params:Object = new Object();
                
                params.storeid = storeId;
                params.path = path;
                
                // using e4x result format not default object format
                webScript.resultFormat ="e4x";
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error);
            }
        }
        
        /**
         * onFolderListDataSuccess event handler
         * 
         * @param event success event
         */
        protected function onFolderListDataSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }
        
    }
}
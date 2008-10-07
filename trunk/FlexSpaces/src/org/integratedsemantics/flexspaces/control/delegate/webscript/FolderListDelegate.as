package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;


    /**
     *  Lists contents of an adm folder visa web script
     * 
     */
    public class FolderListDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function FolderListDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }

        /**
         * Gets list of nodes for given adm folder path
         * 
         * @param path adm folder path to list contents 
         */
        public function getFolderList(path:String):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/folderlist";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onFolderListDataSuccess);
                
                var params:Object = new Object();
                
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
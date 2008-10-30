package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     *  Lists version history of an adm doc via web script
     * 
     */
    public class VersionListDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function VersionListDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }

        /**
         * Gets list of version history nodes for given adm doc node
         * 
         * @param repoNode adm node to get version list on
         */
        public function getVersionList(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/versionlist";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onVersionListSuccess);
                
                var params:Object = new Object();
                
                params.nodeid = repoNode.getId();
                
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
         * onVersionListSuccess event handler
         * 
         * @param event success event
         */
        protected function onVersionListSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }
        
    }
}
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
     *  Provides make flash preview and lookup flash preview for adm node docs
     * 
     */
    public class PreviewDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function PreviewDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }
        
        /**
         * Get preview (if it has already been created) for adm node doc
         * 
         * @param repoNode adm node doc to get the flash preview node for
         */
        public function getPreview(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/getPreview";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onGetPreviewSuccess);
                
                var params:Object = new Object();
                
                params.nodeid = repoNode.getId()
                
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
         * onGetPreviewSuccess event handler
         * 
         * @param event success event
         */
        protected function onGetPreviewSuccess(event:SuccessEvent):void
        {            
            try
            {   
                if (event.result is XML)
                {
                    var result:XML = event.result as XML;
                    var previewId:String = result.previewid;
                    var previewURL:String = result.previewurl;
                    notifyCaller(event.result, event);
                    //trace("onGetPreviewSuccess");
                }
            }
            catch (error:Error)
            {
                // ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error.message);    
                trace("onGetPreviewSuccess error");
            }                       
        }
        
        /**
         * Make flash preview rendition of adm node doc
         * 
         * @param repoNode adm doc to make flash preview for via transform
         * @param parentNode folder to create the flash preview node in
         */
        public function makeFlashPreview(repoNode:IRepoNode, parentNode:IRepoNode):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/makePreviewRendition";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onMakePreviewRenditionSuccess);
                
                var params:Object = new Object();
                
                params.nodeid = repoNode.getId();
                params.folderpath = parentNode.getPath();
                
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
         * onMakePreviewRenditionSuccess event handler
         * 
         * @param event success event
         */
        protected function onMakePreviewRenditionSuccess(event:SuccessEvent):void
        {
            try
            {   
                notifyCaller(event.result, event);
                //trace("onMakePreviewRenditionSuccess");
            }
            catch (error:Error)
            {
                //ErrorService.instance.raiseError(ErrorService.APPLICATION_ERROR, error.message);    
                trace("onMakePreviewRenditionSuccess error");
            }                       
        }
                
    }
}
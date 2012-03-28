package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.event.SuccessEvent;
    import org.integratedsemantics.flexspaces.control.error.ErrorMgr;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Makes a PDF version of a document via web script 
     * 
     */
    public class MakePdfDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function MakePdfDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }
        
        /**
         *  Creates new node with pdf transform of the given adm node doc
         * 
         * @param repoNode adm node to transform
         */
        public function makePDF(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = "/flexspaces/makePDF";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onDocActionSuccess);
                
                var params:Object = new Object();
                
                params.nodeid = repoNode.getId();
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }
        }

        /**
         * onDocActionSuccess event handler
         * 
         * @param event success event
         */
        protected function onDocActionSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }

    }
}
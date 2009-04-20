package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.event.SuccessEvent;
    import org.integratedsemantics.flexspaces.control.error.ErrorMgr;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Provides deletion of adm and avm nodes via web scripts 
     * 
     */
    public class DeleteDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function DeleteDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }
        
        /**
         * Delete adm document or folder
         * 
         * @param repoNode adm node to delete
         */
        public function deleteNode(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = "/flexspaces/deleteNode";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.DELETE, onDeleteActionSuccess);
                
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
         * Delete avm file or folder 
         * 
         * @param repoNode adm node to delete
         * 
         */
        public function deleteAvmNode(repoNode:IRepoNode):void
        {
            try
            {                   
                var url:String = "/flexspaces/deleteNode";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.DELETE, onDeleteActionSuccess);
                
                var params:Object = new Object();
                                
                params.storeid = repoNode.getStoreId();
                params.path = repoNode.getPath();

                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }
        }
        
        /**
         * onDeleteActionSuccess event handler
         * 
         * @param event success event
         */
        protected function onDeleteActionSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);            
        }        
        
    }
}
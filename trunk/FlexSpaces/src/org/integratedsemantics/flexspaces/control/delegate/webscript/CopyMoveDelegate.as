package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.event.SuccessEvent;
    import org.integratedsemantics.flexspaces.control.error.ErrorMgr;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    

    /**
     * Provides copy and move actions for adm and avm nodes via web scripts 
     * 
     */
    public class CopyMoveDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function CopyMoveDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }

        /**
         * Copies adm node to target adm path
         * 
         * @param sourceNode node to copy
         * @param targetFolderNode target parent folder to copy to
         * 
         */
        public function copy(sourceNode:IRepoNode, targetFolderNode:IRepoNode):void
        {
            try
            {                   
                var url:String = "/flexspaces/copy";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onCopySuccess);
                
                var params:Object = new Object();
                
                params.nodeid = sourceNode.getId();
                
                params.path = targetFolderNode.getPath();
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }
        }
        
        /**
         * Copies avm node to target avm store / avm path
         *  
         * @param sourceNode node to copy
         * @param targetFolderNode target parent folder to copy to
         * 
         */
        public function wcmCopy(sourceNode:IRepoNode, targetFolderNode:IRepoNode):void
        {
            try
            {                   
                var url:String = "/flexspaces/wcm/copy";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onCopySuccess);
                
                var params:Object = new Object();
                
                params.sourcestoreid = sourceNode.getStoreId();
                params.sourcepath = sourceNode.getPath();
                
                params.targetstoreid = targetFolderNode.getStoreId();
                params.targetpath = targetFolderNode.getPath();
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }
        }
      
        /**
         * Moves adm node to target adm path
         *  
         * @param sourceNode node to move
         * @param targetFolderNode target parent folder to move to
         * 
         */
        public function move(sourceNode:IRepoNode, targetFolderNode:IRepoNode):void
        {
            try
            {                   
                var url:String = "/flexspaces/move";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onMoveSuccess);
                
                var params:Object = new Object();
                
                params.nodeid = sourceNode.getId();
                
                params.path = targetFolderNode.getPath();
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }
        }


        /**
         * Moves avm node to target avm store / avm path
         *  
         * @param sourceNode node to move
         * @param targetFolderNode target parent folder to move to
         * 
         */
        public function wcmMove(sourceNode:IRepoNode, targetFolderNode:IRepoNode):void
        {
            try
            {                   
                var url:String = "/flexspaces/wcm/move";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onCopySuccess);
                
                var params:Object = new Object();
                
                params.sourcestoreid = sourceNode.getStoreId();
                params.sourcepath = sourceNode.getPath();
                
                params.targetstoreid = targetFolderNode.getStoreId();
                params.targetpath = targetFolderNode.getPath();
                                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }
        }

        /**
         * Copies avm node to target adm path
         *  
         * @param sourceNode node to copy
         * @param targetFolderNode target parent folder to copy to
         * 
         */
        public function copyAvmToAdm(sourceNode:IRepoNode, targetFolderNode:IRepoNode):void
        {
            try
            {                   
                var url:String = "/flexspaces/wcm/crossRepoCopy";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onCopySuccess);
                
                var params:Object = new Object();
                
                params.sourcestoreid = sourceNode.getStoreId();
                params.sourceavmpath = sourceNode.getPath();

                params.targetadmpath = targetFolderNode.getPath();
                
                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }
        }

        /**
         * Copies adm node to target avm store / avm path
         *  
         * @param sourceNode node to copy
         * @param targetFolderNode target parent folder to copy to
         * 
         */
        public function copyAdmToAvm(sourceNode:IRepoNode, targetFolderNode:IRepoNode):void
        {
            try
            {                   
                var url:String = "/flexspaces/wcm/crossRepoCopy";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.POST, onCopySuccess);
                
                var params:Object = new Object();
                
                params.sourcenodeid = sourceNode.getId();
                
                params.targetstoreid = targetFolderNode.getStoreId();
                params.targetavmpath = targetFolderNode.getPath();

                webScript.execute(params);
            }
            catch (error:Error)
            {
                ErrorMgr.getInstance().raiseError(ErrorMgr.APPLICATION_ERROR, error);
            }
        }

        /**
         * onCopyActionSuccess event handler
         * 
         * @param success event
         */
        protected function onCopySuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }

        /**
         * onMoveActionSuccess event handler
         * 
         * @param success event
         */
        protected function onMoveSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }
    }        
}

package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.collections.ArrayCollection;
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;
    import org.integratedsemantics.flexspaces.model.tree.TreeNode;


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
            var result:XML = event.result as XML;               

            var currentNode:TreeNode = new TreeNode(result.folder.name, result.folder.id);
            
            currentNode.name = result.folder.name;                    

            currentNode.nodeRef = result.folder.noderef;                    

            currentNode.storeProtocol = result.folder.storeProtocol;                    
            currentNode.storeId = result.folder.storeId;                    
            currentNode.id = result.folder.id;                    

            currentNode.path = result.folder.path;
            currentNode.displayPath = result.folder.path;
            currentNode.parentPath = result.folder.parentPath;
                            
            currentNode.qnamePath = result.folder.qnamePath;                

            currentNode.readPermission = (result.folder.readPermission == "true");
            currentNode.writePermission = (result.folder.writePermission == "true");
            currentNode.deletePermission = (result.folder.deletePermission == "true");
            currentNode.createChildrenPermission = (result.folder.createChildrenPermission == "true");

            currentNode.children = new ArrayCollection();

            for each (var folder:XML in result.folder.children.folder)
            {
                var childNode:TreeNode = new TreeNode(folder.name, folder.id);
                
                childNode.name = folder.name;                    

                childNode.nodeRef = folder.noderef;                    

                childNode.storeProtocol = folder.storeProtocol;                    
                childNode.storeId = folder.storeId;                    
                childNode.id = folder.id;                    

                childNode.path = folder.path;
                childNode.displayPath = folder.path;                    
                childNode.parentPath = folder.parentPath;                                        

                childNode.qnamePath = folder.qnamePath;                
                
                childNode.readPermission = (folder.readPermission == "true");
                childNode.writePermission = (folder.writePermission == "true");
                childNode.deletePermission = (folder.deletePermission == "true");
                childNode.createChildrenPermission = (folder.createChildrenPermission == "true");

                currentNode.children.addItem(childNode);
            }
            
            currentNode.hasBeenLoaded = true; 
            
            notifyCaller(currentNode, event);                           
        }        
        
    }
}
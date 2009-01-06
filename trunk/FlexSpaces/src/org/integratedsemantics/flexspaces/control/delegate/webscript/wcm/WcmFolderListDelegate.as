package org.integratedsemantics.flexspaces.control.delegate.webscript.wcm
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.wcm.folder.WcmFolder;
    import org.integratedsemantics.flexspaces.model.wcm.folder.WcmNode;


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
            var result:XML = event.result as XML;
            var model:AppModelLocator = AppModelLocator.getInstance();
            
            var wcmFolder:WcmFolder = new WcmFolder();
            
            wcmFolder.folderNode = new WcmNode();
            
            wcmFolder.folderNode.name = String(result.name); 
            
            wcmFolder.folderNode.nodeRef = String(result.noderef);
            
            wcmFolder.folderNode.storeProtocol = String(result.storeProtocol);
            wcmFolder.folderNode.storeId = String(result.storeId);
            wcmFolder.folderNode.id = String(result.id);

            wcmFolder.folderNode.parentPath = String(result.parentPath);
            wcmFolder.folderNode.path = String(result.path);
            
            wcmFolder.folderNode.readPermission = (result.readPermission == "true");
            wcmFolder.folderNode.writePermission = (result.writePermission == "true");
            wcmFolder.folderNode.deletePermission = (result.deletePermission == "true");
            wcmFolder.folderNode.createChildrenPermission = (result.createChildrenPermission == "true");

            var nodeXMLCollection:XMLListCollection = new XMLListCollection(result.node);
            
            wcmFolder..nodeCollection = new ArrayCollection();
            
            for each (var xmlNode:XML in nodeXMLCollection)
            {
                var node:WcmNode = new WcmNode();
                
                node.name = xmlNode.name;
                
                node.nodeRef = xmlNode.noderef;

                node.storeProtocol = xmlNode.storeProtocol;
                node.storeId = xmlNode.storeId;
                node.id = xmlNode.id;
                
                node.parentPath = xmlNode.parentPath;
                node.path = xmlNode.path;
                //node.displayPath = curPath + "/" + xmlNode.name;
                
               // strip off initial slash. add src path, so local icons will be found
                node.icon16 = xmlNode.icon16;
                node.icon16 = model.appConfig.srcPath + node.icon16.substr(1);
                node.icon32 = xmlNode.icon32;
                node.icon32 = model.appConfig.srcPath + node.icon32.substr(1);
                node.icon64 = xmlNode.icon64;
                node.icon64 = model.appConfig.srcPath + node.icon64.substr(1);
                
                node.isFolder = xmlNode.isFolder == "true";
                node.type = xmlNode.type;
                
                node.desc = xmlNode.desc;
                node.size = xmlNode.size;
                
                node.created = xmlNode.created;
                node.modified = xmlNode.modified;
                
                node.viewurl = xmlNode.viewurl;
                
                node.readPermission = (xmlNode.readPermission == "true");
                node.writePermission = (xmlNode.writePermission == "true");
                node.deletePermission = (xmlNode.deletePermission == "true");
                node.createChildrenPermission = (xmlNode.createChildrenPermission == "true");

                if (node.isFolder == true)
                {
                    node.thumbnailUrl = node.icon64;
                }
                else
                {
                    node.thumbnailUrl = wcmFolder.getThumbnailUrl(node);    
                }

                wcmFolder.nodeCollection.addItem(node);
            }
   	
            notifyCaller(wcmFolder, event);
        }
        
    }
}
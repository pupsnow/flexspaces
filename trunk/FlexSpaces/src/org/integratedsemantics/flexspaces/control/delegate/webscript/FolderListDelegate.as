package org.integratedsemantics.flexspaces.control.delegate.webscript
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
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.folder.Node;


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
         * @param pageSize num of items in each page (0 for no paging)
         * @param pageNum  0 based page number to return
         */
        public function getFolderList(path:String, pageSize:int=0, pageNum:int=0):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/folderlist";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onFolderListDataSuccess);
                
                var params:Object = new Object();
                
                params.path = path;
                
                if (pageSize != 0)
                {
                    params.pagesize = pageSize;
                    params.pagenum = pageNum;
                }

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
        	
            var folder:Folder = new Folder();
 
            folder.totalSize = result.totalSize;
            folder.pageSize = result.pageSize;
            folder.pageNum = result.pageNum;            
 
            folder.folderNode = new Node();
            
            folder.folderNode.name = String(result.name); 
            
            folder.folderNode.nodeRef = String(result.noderef);

            folder.folderNode.storeProtocol = String(result.storeProtocol);
            folder.folderNode.storeId = String(result.storeId);
            folder.folderNode.id = String(result.id);
            
            folder.folderNode.parentPath = String(result.parentPath);
            folder.folderNode.path = String(result.path);
            
            folder.folderNode.readPermission = (result.readPermission == "true");
            folder.folderNode.writePermission = (result.writePermission == "true");
            folder.folderNode.deletePermission = (result.deletePermission == "true");
            folder.folderNode.createChildrenPermission = (result.createChildrenPermission == "true");
                                                         
            var nodeXMLCollection:XMLListCollection = new XMLListCollection(result.node);
            
            folder.nodeCollection = new ArrayCollection();
            
            for each (var xmlNode:XML in nodeXMLCollection)
            {
                var node:Node = new Node();
                
                node.name = xmlNode.name;
                
                node.nodeRef = xmlNode.noderef;
                
                node.storeProtocol = xmlNode.storeProtocol;
                node.storeId = xmlNode.storeId;
                node.id = xmlNode.id;
                
                node.parentPath = xmlNode.parentPath;
                node.path = xmlNode.path;
                node.displayPath = xmlNode.path;

                // strip off initial slash. add src path, so local icons will be found
                node.icon16 = xmlNode.icon16;
                node.icon16 = model.appConfig.srcPath + node.icon16.substr(1);
                node.icon32 = xmlNode.icon32;
                node.icon32 = model.appConfig.srcPath + node.icon32.substr(1);
                node.icon64 = xmlNode.icon64;
                node.icon64 = model.appConfig.srcPath + node.icon64.substr(1);

                node.isFolder = xmlNode.isFolder == "true";
                node.type = xmlNode.type;
                node.mimetype = xmlNode.mimetype;
                
                node.desc = xmlNode.desc;
                
                node.size = xmlNode.size;
                
                node.created = xmlNode.created;
                node.modified = xmlNode.modified;
                
                node.viewurl = xmlNode.viewurl;
                
                node.isLocked = (xmlNode.islocked == "true");
                node.isWorkingCopy = (xmlNode.isWorkingCopy == "true");
                
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
                    node.thumbnailUrl = folder.getThumbnailUrl(node);
                }

                folder.nodeCollection.addItem(node);
            }
                    	
            notifyCaller(folder, event);
        }
        
    }
}
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
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.searchresults.SearchResultsCollection;


    /**
     * Provides basic and advanced search query support via web scripts 
     * 
     */
    public class SearchDelegate extends Delegate
    {
        /**
         * Constructor
         * 
         * @param commandHandlers responder with result and fault handlers to respond to
         * @param serviceName  service name
         * 
         */
        public function SearchDelegate(commandHandlers:IResponder=null, serviceName:String="")
        {
            super(commandHandlers, serviceName);
        }

        /**
         * Searches adm with simple text query
         * 
         * @param searchText word or phase to search for 
         */
        public function search(searchText:String):void
        {
            try
            {                   
                var url:String = ConfigService.instance.url +  "/flexspaces/search";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onSearchSuccess);
                
                var params:Object = new Object();
                params.text= searchText;
                
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
         * Perform advanced adm search with alfresco lucene format query
         * 
         * @param luceneQuery  alfresco lucene format query
         */
        public function advancedSearch(luceneQuery:String):void
        {
            try
            {                
                var url:String = ConfigService.instance.url +  "/flexspaces/search";
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onSearchSuccess);
                
                var params:Object = new Object();
                params.lucenequery = luceneQuery;
                
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
         * onSearchSuccess event handler
         * 
         * @param event success event
         */
        protected function onSearchSuccess(event:SuccessEvent):void
        {
            var xmlData:XML = event.result as XML;
            
            var model:AppModelLocator = AppModelLocator.getInstance();            
            
            var searchResultsCollection:SearchResultsCollection = new SearchResultsCollection();
            
            searchResultsCollection.totalResults = xmlData.totalResults;
            
            var nodeXMLCollection:XMLListCollection = new XMLListCollection(xmlData.node);
            
            searchResultsCollection.nodeCollection = new ArrayCollection();
            
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
                
                // strip off initial slash, add src path, so local icons will be found.
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
                    node.thumbnailUrl = searchResultsCollection.getThumbnailUrl(node);    
                }

                searchResultsCollection.nodeCollection.addItem(node);
            }
        	
            notifyCaller(searchResultsCollection, event);
        }
        
    }
}
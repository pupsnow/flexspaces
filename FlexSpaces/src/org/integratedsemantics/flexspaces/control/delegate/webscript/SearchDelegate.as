package org.integratedsemantics.flexspaces.control.delegate.webscript
{
    import com.universalmind.cairngorm.business.Delegate;
    
    import mx.rpc.IResponder;
    
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.alfresco.framework.service.webscript.SuccessEvent;
    import org.alfresco.framework.service.webscript.WebScriptService;


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
         * onSearchSuccess event handler
         * 
         * @param event success event
         */
        protected function onSearchSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
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
                
                var webScript:WebScriptService = new WebScriptService(url, WebScriptService.GET, onAdvancedSearchSuccess);
                
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
         * onAdvancedSearchSuccess event handler
         * 
         * @param event success event
         */
        protected function onAdvancedSearchSuccess(event:SuccessEvent):void
        {
            notifyCaller(event.result, event);
        }
        
    }
}
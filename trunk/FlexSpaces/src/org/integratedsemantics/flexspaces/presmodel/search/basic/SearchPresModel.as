package org.integratedsemantics.flexspaces.presmodel.search.basic
{
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.command.search.QueryBuilder;
    import org.integratedsemantics.flexspaces.control.event.SearchEvent;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
	
	
    /**
     * One box Search Presentation model
     * 
     */	
    [Bindable] 	 
    public class SearchPresModel extends PresModel
    {		
        public var searchText:String = "";
        		
        /**
         * Constructor
         *  
         */
        public function SearchPresModel()
        {
            super();            
        }
        
        /**
          *  Run a search
          * 
          * @param search text to search on 
          * 
          */
        public function search(responder:Responder):void
        {		    
            if ((searchText != null) && (searchText.length > 2))
            {
                var model:AppModelLocator = AppModelLocator.getInstance();
                var pageSize:int = model.flexSpacesPresModel.searchPageSize;
            
                // use query builder used for advanced search for basic seaarch to leverage parsing
            
                if  (model.appConfig.cmisMode == false)
                {
                    // construct the query builder (like SearchContext bean)
                    var queryBuilder:QueryBuilder = new QueryBuilder();
                  
                    // set the full-text/name field value 
                    queryBuilder.setText(searchText);
                  
                    // set whether to force AND operation on text terms
                    queryBuilder.setForceAndTerms(false);
                  
                    queryBuilder.setMode(QueryBuilder.SEARCH_ALL);
            
                    var query:String = queryBuilder.buildQuery(3);
                    
                    var searchEvent:SearchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, query, pageSize, 0);
                }
                else
                {
                    // cmis: todo use new query builder
                   searchEvent = new SearchEvent(SearchEvent.SEARCH, responder, searchText, pageSize, 0);
                }
                searchEvent.dispatch();
            }                                 
        }
			
        public function updateSearchText(text:String):void
        {
        	this.searchText = text;	
        }		
				
	}
}
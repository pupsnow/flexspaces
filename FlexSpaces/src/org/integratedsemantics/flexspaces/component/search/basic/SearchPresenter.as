package org.integratedsemantics.flexspaces.component.search.basic
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.component.search.advanced.AdvancedSearchEvent;
    import org.integratedsemantics.flexspaces.component.search.event.SearchResultsEvent;
    import org.integratedsemantics.flexspaces.control.command.search.QueryBuilder;
    import org.integratedsemantics.flexspaces.control.event.SearchEvent;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
	
	
	/**
	 * One box Search Presenter
	 * 
	 * Presenter/Controller of SearchViewBase views
	 * 
	 */		 
	public class SearchPresenter extends Presenter
	{		
		
		/**
		 * Constructor
		 *  
		 * @param searchView view to control
		 * 
		 */
		public function SearchPresenter(searchView:SearchViewBase)
		{
            super(searchView);
            
            if (searchView.initialized == true)
            {
                onCreationComplete(new Event(""));
            }
            else
            {
                observeCreation(searchView, onCreationComplete);            
            }
		}
		
        /**
         * Getter for the view
         *  
         * @return view
         * 
         */
        protected function get searchView():SearchViewBase
        {
            return this.view as SearchViewBase;            
        }       

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
		{			
			// Focus the user input box
			searchView.focusManager.setFocus(searchView.searchTextInput);
			
            // add search btn, adv search link, and enter key handlers
            observeButtonClick(searchView.searchBtn, onSearchBtn);            
            searchView.searchTextInput.addEventListener(FlexEvent.ENTER, onSearchBtn);         
			searchView.advancedLink.addEventListener(MouseEvent.CLICK, onAdvancedSearchLink);
		}
		
        /**
         * Request starting advanced search when advanced link is clicked on
         * 
         * @param event click event
         * 
         */
        protected function onAdvancedSearchLink(event:Event):void
        {
            var advSearchEvent:AdvancedSearchEvent = new AdvancedSearchEvent(AdvancedSearchEvent.ADVANCED_SEARCH_REQUEST);
            var dispatched:Boolean = searchView.dispatchEvent(advSearchEvent);                        
        }

		/**
	 	* Handle search button click and enter by requesting search to be performed
	 	* 
	 	* @param event mouse click or enter event  
	 	*/
		protected function onSearchBtn(event:Event):void
		{
		    var searchText:String = searchView.searchTextInput.text;
		    
		    // use query builder used for advanced search for basic seaarch to leverage parsing

            // construct the query builder (like SearchContext bean)
            var queryBuilder:QueryBuilder = new QueryBuilder();
          
            // set the full-text/name field value 
            queryBuilder.setText(searchText);
          
            // set whether to force AND operation on text terms
            queryBuilder.setForceAndTerms(false);
          
            queryBuilder.setMode(QueryBuilder.SEARCH_ALL);

            var query:String = queryBuilder.buildQuery(3);
            
            var responder:Responder = new Responder(onResultSearch, onFaultSearch);
            var searchEvent:SearchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, query);
            searchEvent.dispatch();                                 
		}
		
        /**
         * Handle successful search service result by sending search results available event to rest of UI
         *  
         * @param data search results data
         * 
         */
        protected function onResultSearch(data:Object):void
        {
            var searchResultsEvent:SearchResultsEvent = new SearchResultsEvent(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, data);
            var dispatched:Boolean = searchView.dispatchEvent(searchResultsEvent);                        
        }

        /**
         * Handle search service fault
         *  
         * @param info fault info
         * 
         */
        protected function onFaultSearch(info:Object):void
        {
            trace("onFaultSearch " + info);     
        }
		
	}
}
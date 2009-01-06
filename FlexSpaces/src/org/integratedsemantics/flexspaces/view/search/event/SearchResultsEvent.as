package org.integratedsemantics.flexspaces.view.search.event
{
    import flash.events.Event;

    /**
     * Event to let rest of UI know seaarch results are available and to provide the results 
     * 
     */
    public class SearchResultsEvent extends Event
    {
        /** Event name */
        public static const SEARCH_RESULTS_AVAILABLE:String = "searchResultsAvailable";

        /** search results data */
        public var  searchResults:Object;
        
        /**
         * Constructor
         *  
         * @param type  event name
         * @param searchResults search result data
         * 
         */
        public function SearchResultsEvent(type:String, searchResults:Object)
        {
            super(type);
            this.searchResults = searchResults;
        }
        
    }
}
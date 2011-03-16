package org.integratedsemantics.flexspaces.view.search.basic
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.containers.Box;
    import mx.controls.Button;
    import mx.controls.LinkButton;
    import mx.controls.TextInput;
    import mx.events.FlexEvent;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.presmodel.search.basic.SearchPresModel;
    import org.integratedsemantics.flexspaces.util.ObserveUtil;
    import org.integratedsemantics.flexspaces.view.search.advanced.AdvancedSearchEvent;
    import org.integratedsemantics.flexspaces.view.search.event.SearchResultsEvent;
    
        
    /**
     * Base class for one box basic search views  
     * 
     */
    public class SearchViewBase extends Box
    {
        public var searchTextInput:TextInput;
        public var searchBtn:Button;
        public var advancedLink:LinkButton
        
        [Bindable]
        public var searchPresModel:SearchPresModel;

        /**
         * Constructor 
         */
        public function SearchViewBase()
        {
            super();
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
			focusManager.setFocus(searchTextInput);
			
            // add search btn, adv search link, and enter key handlers
            ObserveUtil.observeButtonClick(searchBtn, onSearchBtn);            
            searchTextInput.addEventListener(FlexEvent.ENTER, onSearchBtn);         
			advancedLink.addEventListener(MouseEvent.CLICK, onAdvancedSearchLink);
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
            var dispatched:Boolean = dispatchEvent(advSearchEvent);                        
        }

		/**
	 	 * Handle search button click and enter
	 	 * 
	 	 * @param event mouse click or enter event  
	 	 */
		protected function onSearchBtn(event:Event):void
		{		    
            var responder:Responder = new Responder(onResultSearch, onFaultSearch);

		    searchPresModel.search(responder);                             
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
            var dispatched:Boolean = dispatchEvent(searchResultsEvent);                        
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
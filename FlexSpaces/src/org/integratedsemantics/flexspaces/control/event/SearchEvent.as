package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;


	/**
	 * Event to request a simple search with a text string or an advanced search with an alfresco/lucene format query
	 */
	public class SearchEvent extends UMEvent
	{
		/** Event name */
        public static const ADVANCED_SEARCH:String = "advancedSearch";
		public static const SEARCH:String = "search";
		
		public var searchText:String;

		
        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param searchText simple text phrase or alfresco/lucene format query
         * 
         */
        public function SearchEvent(eventType:String, handlers:IResponder, searchText:String)
        {
            super(eventType, handlers);
            
            this.searchText = searchText;
        }       
						
	}
}
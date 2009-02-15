 
package org.integratedsemantics.flexspaces.presmodel.search.results
{
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.SearchEvent;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.searchresults.SearchResultsCollection;
    import org.integratedsemantics.flexspaces.presmodel.folderview.NodeListViewPresModel;


	/**
	 * Presentation of search results with folder like view display (icons/details modes)
	 * 
	 */	 	
	[Bindable] 
	public class SearchResultsPresModel extends NodeListViewPresModel
	{	    		    
	    public var resultsCountLabel:String;

	    /**
	     * Constructor 
	     * 
	     */
	    public function SearchResultsPresModel()
	    {
	        super();
        }
     	
        /**
         * Initialize model 
         * 
         */
        override public function initModel():void
        {
            this.nodeCollection = new SearchResultsCollection();  
            
            resultsCountLabel = "";     
        }

        /**
		 * Initialize with new search results data
		 * 
		 * @param data search results data
		 */
		public function initResultsData(data:Object):void
		{
		    var resultsCollection:SearchResultsCollection = this.nodeCollection as SearchResultsCollection; 
		    resultsCollection.initData(data);
		    
            // update result count readout
            // todo i18n
            resultsCountLabel = resultsCollection.totalSize + " results";		
            
            // set showThumbnail flags on nodes
            for each (var node:Node in nodeCollection)
            {
                node.showThumbnail = showThumbnails;
            }                                
		}
		
		public function requery(responder:Responder, pageSize:int, pageNum:int):void
		{
		    var resultsCollection:SearchResultsCollection = this.nodeCollection as SearchResultsCollection; 
            if (resultsCollection.query != "")
            {
                var searchEvent:SearchEvent = new SearchEvent(SearchEvent.ADVANCED_SEARCH, responder, resultsCollection.query, pageSize, pageNum);
                searchEvent.dispatch();
            }
		}		    		
		
     }
}
 
package org.integratedsemantics.flexspaces.presmodel.search.results
{
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
            resultsCountLabel = resultsCollection.totalResults + " results";		
            
            // set showThumbnail flags on nodes
            for each (var node:Node in nodeCollection)
            {
                node.showThumbnail = showThumbnails;
            }                                
		}		
		
     }
}
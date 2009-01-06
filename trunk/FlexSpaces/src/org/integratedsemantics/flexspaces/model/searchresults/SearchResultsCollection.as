package org.integratedsemantics.flexspaces.model.searchresults
{
    import org.integratedsemantics.flexspaces.model.folder.NodeCollection;    
    
    
    /**
     * Collection of nodes in search results 
     * Used as the model fro the search results view
     * 
     */
    [Bindable] 
    public class SearchResultsCollection extends NodeCollection
    {   
    	public var totalResults:int;
    	    
        /**
         * Constructor
         * 
         */
        public function SearchResultsCollection()
        {
            super();
        }
        
        /**
         * Inits with search results data
         * 
         * @data   search results data
         */
        public function initData(data:Object):void
        {
            var result:SearchResultsCollection = data as SearchResultsCollection;

            this.totalResults = result.totalResults;

			this.nodeCollection = result.nodeCollection;                
            result.nodeCollection = null;   
                     
            this.source = nodeCollection.source;
            this.refresh();
        }
                       
    }
}

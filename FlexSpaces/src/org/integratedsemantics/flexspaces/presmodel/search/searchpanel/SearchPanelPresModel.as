package org.integratedsemantics.flexspaces.presmodel.search.searchpanel
{
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.presmodel.categories.tree.CategoryTreePresModel;
    import org.integratedsemantics.flexspaces.presmodel.favorites.FavoritesPresModel;
    import org.integratedsemantics.flexspaces.presmodel.search.basic.SearchPresModel;
    import org.integratedsemantics.flexspaces.presmodel.search.results.SearchResultsPresModel;
    import org.integratedsemantics.flexspaces.presmodel.semantictags.map.SemanticTagMapPresModel;
    import org.integratedsemantics.flexspaces.presmodel.semantictags.semantictagcloud.SemanticTagCloudPresModel;
    import org.integratedsemantics.flexspaces.presmodel.tags.tagcloud.TagCloudPresModel;


    /**
     * Presentation model for panel with tag cloud, category tree, advanced search panel, and
     * search results 
     * 
     */
    [Bindable] 
    public class SearchPanelPresModel extends PresModel
    {       
        public var searchResultsPresModel:SearchResultsPresModel;

        public var tagCloudPresModel:TagCloudPresModel;
        public var categoryTreePresModel:CategoryTreePresModel;
        
        public var semanticTagCloudPresModel:SemanticTagCloudPresModel;
        public var companySemanticTagCloudPresModel:SemanticTagCloudPresModel;
        public var personSemanticTagCloudPresModel:SemanticTagCloudPresModel;
        public var mapPresModel:SemanticTagMapPresModel;
        
        public var searchPresModel:SearchPresModel;

        public var model:AppModelLocator = AppModelLocator.getInstance();

        public var favoritesPresModel:FavoritesPresModel;                         

                
        public function SearchPanelPresModel()
        {
            super();
            
            setupSubViews();
        }
        
        /**
         * Setup sub view presentation models
         * 
         */
        protected function setupSubViews():void
        {
            // setup category tree
            categoryTreePresModel = new CategoryTreePresModel();
            categoryTreePresModel.doSearchOnClick = true;    
            
            // setup search results
            searchResultsPresModel = new SearchResultsPresModel();           

			// basic search
	        searchPresModel = new SearchPresModel();

            var version:Number = model.ecmServerConfig.serverVersionNum();
            
            // only setup tag cloud if 2.9 or greater since tagging content model added in 2.9
            if (version >= 2.9)
            {
                tagCloudPresModel = new TagCloudPresModel();            
                tagCloudPresModel.doSearchOnClick = true;
            }
            
            if (model.calaisConfig.enableCalias == true)
            {    
                semanticTagCloudPresModel = new SemanticTagCloudPresModel(null);            
                semanticTagCloudPresModel.doSearchOnClick = true;                                    
                
                companySemanticTagCloudPresModel = new SemanticTagCloudPresModel("Company");            
                companySemanticTagCloudPresModel.doSearchOnClick = true;                                    

                personSemanticTagCloudPresModel = new SemanticTagCloudPresModel("Person");            
                personSemanticTagCloudPresModel.doSearchOnClick = true;      
                
                if (model.googleMapConfig.enableGoogleMap == true)
                {
	                mapPresModel = new SemanticTagMapPresModel();                              
	                mapPresModel.doSearchOnClick = true;
                } 
            } 
            
            favoritesPresModel = new FavoritesPresModel();
        }
        
        /**
         * Initialize with new search results data
         * 
         * @param data search results data
         */
        public function initResultsData(data:Object):void
        {
            searchResultsPresModel.initResultsData(data);
        }        
                                                
    }
}
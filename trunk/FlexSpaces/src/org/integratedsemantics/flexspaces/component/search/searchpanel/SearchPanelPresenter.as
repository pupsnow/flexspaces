package org.integratedsemantics.flexspaces.component.search.searchpanel
{
    import mx.events.FlexEvent;
    
    import org.integratedsemantics.flexspaces.component.categories.tree.CategoryTreePresenter;
    import org.integratedsemantics.flexspaces.component.search.event.SearchResultsEvent;
    import org.integratedsemantics.flexspaces.component.search.results.SearchResultsPresenter;
    import org.integratedsemantics.flexspaces.component.semantictags.map.SemanticTagMapPresenter;
    import org.integratedsemantics.flexspaces.component.semantictags.map.SemanticTagMapView;
    import org.integratedsemantics.flexspaces.component.semantictags.semantictagcloud.SemanticTagCloudPresenter;
    import org.integratedsemantics.flexspaces.component.tags.tagcloud.TagCloudPresenter;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;


    /**
     * Presenter for panel with tag cloud, category tree, advanced search panel, and
     * search results 
     * 
     * Presenter/Controller for SearchPanelBase base views
     */
    public class SearchPanelPresenter extends Presenter
    {       
        public var searchResultsPresenter:SearchResultsPresenter;

        protected var tagCloudPresenter:TagCloudPresenter;
        protected var categoryTreePresenter:CategoryTreePresenter;
        
        protected var semanticTagCloudPresenter:SemanticTagCloudPresenter;
        protected var companySemanticTagCloudPresenter:SemanticTagCloudPresenter;
        protected var personSemanticTagCloudPresenter:SemanticTagCloudPresenter;
        protected var mapPresenter:SemanticTagMapPresenter;

        
        public function SearchPanelPresenter(searchPanel:SearchPanelBase)
        {
            super(searchPanel);

            if (searchPanel.initialized == true)
            {
                onCreationComplete(new FlexEvent(""));
            }
            else
            {
                observeCreation(searchPanel, onCreationComplete);            
            }            
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get searchPanel():SearchPanelBase
        {
            return this.view as SearchPanelBase;            
        }        
        
        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
            // setup category tree
            categoryTreePresenter = new CategoryTreePresenter(searchPanel.categoriesTreeView);
            searchPanel.categoriesTreeView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);      
            categoryTreePresenter.doSearchOnClick = true;    
            
            // setup search results
            searchResultsPresenter = new SearchResultsPresenter(searchPanel.searchResultsView);           

            var model:AppModelLocator = AppModelLocator.getInstance();
            var version:Number = model.serverVersionNum();
            
            // only setup tag cloud if 2.9 or greater since tagging content model added in 2.9
            if (version >= 2.9)
            {
                tagCloudPresenter = new TagCloudPresenter(searchPanel.tagCloudView);            
                searchPanel.tagCloudView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);                             
                tagCloudPresenter.doSearchOnClick = true;
            }
            
            if (model.enableCalias == true)
            {    
                semanticTagCloudPresenter = new SemanticTagCloudPresenter(searchPanel.semanticTagCloudView, null);            
                searchPanel.semanticTagCloudView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);                             
                semanticTagCloudPresenter.doSearchOnClick = true;                                    
                
                companySemanticTagCloudPresenter = new SemanticTagCloudPresenter(searchPanel.companySemanticTagCloudView, "Company");            
                searchPanel.companySemanticTagCloudView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);                             
                companySemanticTagCloudPresenter.doSearchOnClick = true;                                    

                personSemanticTagCloudPresenter = new SemanticTagCloudPresenter(searchPanel.personSemanticTagCloudView, "Person");            
                searchPanel.personSemanticTagCloudView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);                             
                personSemanticTagCloudPresenter.doSearchOnClick = true;      
                
                if (model.enableGoogleMap == true)
                {
					searchPanel.semanticTagMapView = new SemanticTagMapView();
					searchPanel.semanticTagMapView.id = "semanticTagMapView";
					searchPanel.semanticTagMapView.percentHeight = 100;
					searchPanel.semanticTagMapView.percentWidth = 100;
					searchPanel.mapSection.addChild(searchPanel.semanticTagMapView);					                	
	                mapPresenter = new SemanticTagMapPresenter(searchPanel.semanticTagMapView);                              
	                searchPanel.semanticTagMapView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);                             
	                mapPresenter.doSearchOnClick = true;
                } 
            }                                                    
        }

        /**
         * Handler called when search results data is available
         * from tag cloud or categories
         * 
         * @param event search results event with results data
         */
        protected function onSearchResults(event:SearchResultsEvent):void
        {
            initResultsData(event.searchResults);  
        }
        
        /**
         * Refresh tag cloud, categories
         * 
         */
        public function refresh():void
        {
            if (tagCloudPresenter != null)
            {
                tagCloudPresenter.refresh();
            }
            
            categoryTreePresenter.refresh();
            
            if (semanticTagCloudPresenter != null)
            {
                semanticTagCloudPresenter.refresh();
            }
            if (companySemanticTagCloudPresenter != null)
            {
                companySemanticTagCloudPresenter.refresh();
            }
            if (personSemanticTagCloudPresenter != null)
            {
                personSemanticTagCloudPresenter.refresh();
            }       
            if (mapPresenter != null)
            {
            	mapPresenter.refresh();
            }     
        }
        
        /**
         * Initialize with new search results data
         * 
         * @param data search results data
         */
        public function initResultsData(data:Object):void
        {
            searchResultsPresenter.initResultsData(data);
        }        
        
        /**
         * Clear selection in all view modes 
         * 
         */
        public function clearSelection():void
        {
            searchResultsPresenter.clearSelection();
        }        

        /**
         * Clear selection if not selected folder presenter/view 
         * 
         * @param selectedFolderList selected folder presenter/view
         * 
         */
        public function clearOtherSelections(selectedFolderList:Presenter):void
        {
            searchResultsPresenter.clearOtherSelections(selectedFolderList);
        }    
        
        /**
         * Toggle show / hide of thumbnails  
         * (icons shown when thumbnails hidden)
         * 
         */
        public function showHideThumbnails():void
        {
            searchResultsPresenter.showHideThumbnails();
        }
            
                    
    }
}
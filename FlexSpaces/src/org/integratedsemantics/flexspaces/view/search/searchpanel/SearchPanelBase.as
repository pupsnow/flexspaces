package org.integratedsemantics.flexspaces.view.search.searchpanel
{
    import mx.containers.Box;
    import mx.containers.HDividedBox;
    import mx.events.FlexEvent;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.presmodel.search.searchpanel.SearchPanelPresModel;
    import org.integratedsemantics.flexspaces.view.categories.tree.CategoryTreeViewBase;
    import org.integratedsemantics.flexspaces.view.favorites.FavoritesViewBase;
    import org.integratedsemantics.flexspaces.view.search.basic.SearchViewBase;
    import org.integratedsemantics.flexspaces.view.search.event.SearchResultsEvent;
    import org.integratedsemantics.flexspaces.view.search.results.SearchResultsViewBase;
    import org.integratedsemantics.flexspaces.view.semantictags.map.SemanticTagMapView;
    import org.integratedsemantics.flexspaces.view.semantictags.map.SemanticTagMapViewBase;
    import org.integratedsemantics.flexspaces.view.semantictags.semantictagcloud.SemanticTagCloudViewBase;
    import org.integratedsemantics.flexspaces.view.tags.tagcloud.TagCloudViewBase;


    public class SearchPanelBase extends HDividedBox
    {
        public var searchView2:SearchViewBase;
        public var tagCloudView:TagCloudViewBase;
        public var categoriesTreeView:CategoryTreeViewBase;
               
        public var semanticTagCloudView:SemanticTagCloudViewBase;
        public var companySemanticTagCloudView:SemanticTagCloudViewBase;
        public var personSemanticTagCloudView:SemanticTagCloudViewBase;
       
		public var mapSection:Box;       
        public var semanticTagMapView:SemanticTagMapViewBase;

        public var searchResultsView:SearchResultsViewBase;
        
        public var favoritesView:FavoritesViewBase;

        [Bindable]
        public var searchPanelPresModel:SearchPanelPresModel;
        
        
        public function SearchPanelBase()
        {
            super();
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
            categoriesTreeView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);      
            
            // setup search results

            var version:Number = searchPanelPresModel.model.ecmServerConfig.serverVersionNum();
            
            // only setup tag cloud if 2.9 or greater since tagging content model added in 2.9
            if ((version >= 2.9) && (tagCloudView != null))
            {
                tagCloudView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);                             
            }
            
            if (searchPanelPresModel.model.calaisConfig.enableCalias == true)
            {    
                semanticTagCloudView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);                             
                
                companySemanticTagCloudView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);                             

                personSemanticTagCloudView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);                             
                
                if (searchPanelPresModel.model.googleMapConfig.enableGoogleMap == true)
                {
					semanticTagMapView = new SemanticTagMapView();
					semanticTagMapView.semanticTagMapPresModel = searchPanelPresModel.mapPresModel;
					semanticTagMapView.id = "semanticTagMapView";
					semanticTagMapView.percentHeight = 100;
					semanticTagMapView.percentWidth = 100;
					mapSection.addChild(semanticTagMapView);					                	
	                semanticTagMapView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);                             
                } 
            }                                                    
        }

        /**
         * Refresh tag cloud, categories
         * 
         */
        public function refresh():void
        {
            if (tagCloudView != null)
            {
                tagCloudView.refresh();
            }
            
            categoriesTreeView.refresh();
            
            if (semanticTagCloudView != null)
            {
                semanticTagCloudView.refresh();
            }
            if (companySemanticTagCloudView != null)
            {
                companySemanticTagCloudView.refresh();
            }
            if (personSemanticTagCloudView != null)
            {
                personSemanticTagCloudView.refresh();
            }       
            if (semanticTagMapView != null)
            {
            	semanticTagMapView.refresh();
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
            searchPanelPresModel.initResultsData(event.searchResults);  
        }
        
        /**
         * Toggle show / hide of thumbnails  
         * (icons shown when thumbnails hidden)
         * 
         */
        public function showHideThumbnails():void
        {
            searchResultsView.showHideThumbnails();
        }
        
        /**
         * Clear selection in all view modes 
         * 
         */
        public function clearSelection():void
        {
           searchResultsView.clearSelection();
        }        

        /**
         * Clear selection if not selected folder PresModel/view 
         * 
         * @param selectedFolderList selected folder PresModel/view
         * 
         */
        public function clearOtherSelections(selectedFolderList:PresModel):void
        {
            searchResultsView.clearOtherSelections(selectedFolderList);
        }   
        
        public function redraw():void
        {
            // todo need to have search results redraw only if use rename 
            // searchResultsView.requery();    
            
            if (favoritesView.favoritesPresModel != null)
            {
                favoritesView.favoritesPresModel.redraw();
            }                     
        }        
    }
}
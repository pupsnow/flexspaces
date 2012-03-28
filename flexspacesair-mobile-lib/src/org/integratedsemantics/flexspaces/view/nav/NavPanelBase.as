package org.integratedsemantics.flexspaces.view.nav
{
    import flash.events.Event;
    import flash.events.FocusEvent;
    
    import mx.containers.Accordion;
    import mx.containers.Box;
    import mx.events.FlexEvent;
    import mx.events.IndexChangedEvent;
    import mx.events.ListEvent;
    
    import org.integratedsemantics.flexspaces.presmodel.navpanel.NavPanelPresModel;
    import org.integratedsemantics.flexspaces.view.categories.tree.CategoryTreeViewBase;
    import org.integratedsemantics.flexspaces.view.createspace.AddedFolderEvent;
    import org.integratedsemantics.flexspaces.view.deletion.DeletedFolderEvent;
    import org.integratedsemantics.flexspaces.view.favorites.FavoritesViewBase;
    import org.integratedsemantics.flexspaces.view.search.event.SearchResultsEvent;
    import org.integratedsemantics.flexspaces.view.semantictags.map.SemanticTagMapView;
    import org.integratedsemantics.flexspaces.view.semantictags.map.SemanticTagMapViewBase;
    import org.integratedsemantics.flexspaces.view.semantictags.semantictagcloud.SemanticTagCloudViewBase;
    import org.integratedsemantics.flexspaces.view.tags.tagcloud.TagCloudViewBase;
    import org.integratedsemantics.flexspaces.view.tree.TreeViewBase;


    public class NavPanelBase extends Accordion
    {
        public var companyHomeTreeView:TreeViewBase;
        public var userHomeTreeView:TreeViewBase;

        public var categoriesTreeView:CategoryTreeViewBase;
               
        public var tagCloudView:TagCloudViewBase;

        public var semanticSection:Accordion;       
        public var semanticTagCloudView:SemanticTagCloudViewBase;
        public var companySemanticTagCloudView:SemanticTagCloudViewBase;
        public var personSemanticTagCloudView:SemanticTagCloudViewBase;      
		public var mapSection:Box;       
        public var semanticTagMapView:SemanticTagMapViewBase;
        
        public var favoritesView:FavoritesViewBase;

        [Bindable]
        public var navPanelPresModel:NavPanelPresModel;
        
        public var companyHomeTreeActive:Boolean = false;
        public var userHomeTreeActive:Boolean = true;

        private var onSearchResults:Function;

        
        public function NavPanelBase()
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
            // setup category tree search results handling
            if (onSearchResults != null)
            {
                categoriesTreeView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults); 
            }
            
            // setup tag clouds, map

            var version:Number = navPanelPresModel.model.ecmServerConfig.serverVersionNum();
            
            // only setup tag cloud if 2.9 or greater since tagging content model added in 2.9
            if ((version >= 2.9) && (tagCloudView != null) && (onSearchResults != null))
            {
                tagCloudView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);                             
            }
            
            if (navPanelPresModel.model.calaisConfig.enableCalais == true)
            {    
                if (onSearchResults != null)
                {
                    semanticTagCloudView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);                                                 
                    companySemanticTagCloudView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);                                
                    personSemanticTagCloudView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);                             
                }
                
                if (navPanelPresModel.model.googleMapConfig.enableGoogleMap == true)
                {
                    // create semantic tag google map view
					semanticTagMapView = new SemanticTagMapView();
					semanticTagMapView.semanticTagMapPresModel = navPanelPresModel.mapPresModel;
					semanticTagMapView.id = "semanticTagMapView";
					semanticTagMapView.percentHeight = 100;
					semanticTagMapView.percentWidth = 100;
					mapSection.addChild(semanticTagMapView);	
                    if (onSearchResults != null)
                    {									                	
	                   semanticTagMapView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults); 
                    }
                } 
            }  
            
            // setup trees
            companyHomeTreeView.addEventListener(ListEvent.CHANGE, companyHomeTreeChanged);
            userHomeTreeView.addEventListener(ListEvent.CHANGE, userHomeTreeChanged);                                                              
            companyHomeTreeView.addEventListener(FocusEvent.FOCUS_IN, companyHomeTreeFocusIn);
            userHomeTreeView.addEventListener(FocusEvent.FOCUS_IN, userHomeTreeFocusIn);   
            parentApplication.addEventListener(AddedFolderEvent.ADDED_FOLDER, onAddRemoveFolder);
            parentApplication.addEventListener(DeletedFolderEvent.DELETED_FOLDER, onAddRemoveFolder);                                                                       
        }

        /**
         * Setup external handler for available "search" results from categories, tag clouds
         *  
         * @param searchResultAvailableHandler
         * 
         */
        public function initSearchResultsHandler(searchResultAvailableHandler:Function):void
        {
            onSearchResults = searchResultAvailableHandler; 
        }

        /**
         * Refresh tag clouds, categories, favorites
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

            if ((favoritesView != null) && (favoritesView.favoritesPresModel != null) )
            {
                favoritesView.favoritesPresModel.redraw();
            }                     
        }

        public function redraw():void
        {
            refresh();
        }     
        
        /**
         * Handle company home tree changed event
         *  
         * @param event tree changed event
         * 
         */
        protected function companyHomeTreeChanged(event:Event):void
        {        
            var path:String = companyHomeTreeView.getPath();
           
            // fire event to let container know about to new folder path selected in tree
            var changePathEvent:TreeChangePathEvent = new TreeChangePathEvent(TreeChangePathEvent.COMPANY_HOME_TREE_CHANGE_PATH, path);
            var dispatched:Boolean = dispatchEvent(changePathEvent);                                        
        }
           
        /**
         * Handle user home tree changed event
         *  
         * @param event tree changed event
         * 
         */
        protected function userHomeTreeChanged(event:Event):void
        {        
            var path:String = userHomeTreeView.getPath();
           
            // fire event to let container know about to new folder path selected in tree
            var changePathEvent:TreeChangePathEvent = new TreeChangePathEvent(TreeChangePathEvent.USER_HOME_TREE_CHANGE_PATH, path);
            var dispatched:Boolean = dispatchEvent(changePathEvent);                                        
        }

        /**
         * Handle company home tree gains focus
         *  
         * @param event tree changed event
         * 
         */
        private function companyHomeTreeFocusIn(event:Event):void
        {
            if (companyHomeTreeActive == false)
            {
                companyHomeTreeActive = true;
                userHomeTreeActive = false;

                // send a change event in case user switches trees but selects the current selected tree node 
                //(and thus tree won't send onChange)
                var path:String = companyHomeTreeView.getPath();
                var changePathEvent:TreeChangePathEvent = new TreeChangePathEvent(TreeChangePathEvent.COMPANY_HOME_TREE_CHANGE_PATH, path);
                var dispatched:Boolean = dispatchEvent(changePathEvent);                                        
            }   
        }
        
        /**
         * Handle user home tree gains focus
         *  
         * @param event tree changed event
         * 
         */
        private function userHomeTreeFocusIn(event:Event):void
        {
            if (userHomeTreeActive == false)
            {
                companyHomeTreeActive = false;
                userHomeTreeActive = true;

                // send a change event in case user switches trees but selects the current selected tree node 
                //(and thus tree won't send onChange)
                var path:String = userHomeTreeView.getPath();
                var changePathEvent:TreeChangePathEvent = new TreeChangePathEvent(TreeChangePathEvent.USER_HOME_TREE_CHANGE_PATH, path);
                var dispatched:Boolean = dispatchEvent(changePathEvent);                                        
            }   

        }

        /**
         * Set folder path displayed in company home tree
         *  
         * @param path path
         * 
         */
        public function setCompanyHomePath(path:String):void
        {
            // select folder in company home tree
            companyHomeTreeView.setPath(path);              
        }        

        /**
         * Set folder path displayed in user home tree
         *  
         * @param path path
         * 
         */
        public function setUserHomePath(path:String):void
        {
            // select folder in user home tree
            userHomeTreeView.setPath(path);              
        }

        /**
         * Set folder path in active tree
         *  
         * @param path path
         * 
         */
        public function setPath(path:String):void
        {
            if (companyHomeTreeActive == true)
            {
                companyHomeTreeView.setPath(path);              
            }
            if (userHomeTreeActive == true)
            {
                userHomeTreeView.setPath(path);              
            }            
        }

        /**
         * Get folder path in active tree
         *  
         * @param path path
         * 
         */
        public function getPath():String
        {
            var path:String = null;
            if (companyHomeTreeActive == true)
            {
                path = companyHomeTreeView.getPath();              
            }
            if (userHomeTreeActive == true)
            {
                path = userHomeTreeView.getPath();              
            }  
            return path;          
        }


        /**
         * Handle add remove folder event by also refreshing selected folder parent in tree(s)
         *  
         * @param event add or remove folder event
         * 
         */
        protected function onAddRemoveFolder(event:Event):void
        {
            companyHomeTreeView.refreshCurrentFolder();
            userHomeTreeView.refreshCurrentFolder();
        }  
        
        public function onChange(event:IndexChangedEvent):void
        {
            if ( (event.newIndex == 2) || (event.newIndex ==3) )
            {
                // let UI know search is starting so can start initing search results view for first search
                var searchResultsEvent:SearchResultsEvent = new SearchResultsEvent(SearchResultsEvent.SEARCH_STARTING, null);
                var dispatched:Boolean = dispatchEvent(searchResultsEvent);    
            }
        }
        
    }
}
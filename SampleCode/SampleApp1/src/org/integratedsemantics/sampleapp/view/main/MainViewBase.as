package org.integratedsemantics.sampleapp.view.main
{
    import flash.events.KeyboardEvent;
    
    import flexlib.containers.SuperTabNavigator;
    import flexlib.controls.tabBarClasses.SuperTab;
    import flexlib.events.SuperTabEvent;
    
    import mx.events.FlexEvent;
    import mx.events.IndexChangedEvent;
    import mx.events.MenuEvent;
    
    import org.integratedsemantics.flexspaces.view.browser.RepoBrowserChangePathEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.ClickNodeEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.DoubleClickDocEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.FolderViewContextMenuEvent;
    import org.integratedsemantics.flexspaces.view.logout.LogoutDoneEvent;
    import org.integratedsemantics.flexspaces.view.main.FlexSpacesViewBase;
    import org.integratedsemantics.flexspaces.view.menu.event.MenuConfiguredEvent;
    import org.integratedsemantics.flexspaces.view.search.advanced.AdvancedSearchEvent;
    import org.integratedsemantics.flexspaces.view.search.basic.SearchViewBase;
    import org.integratedsemantics.flexspaces.view.search.event.SearchResultsEvent;
    import org.integratedsemantics.sampleapp.presmodel.main.SampleAppPresModel;


    public class MainViewBase extends FlexSpacesViewBase
    {
        public function MainViewBase()
        {
            super();
        }
        
        [Bindable]
        public function get sampleAppPresModel():SampleAppPresModel
        {
            return this.flexSpacesPresModel as SampleAppPresModel;
        }

        public function set sampleAppPresModel(sampleAppPresModel:SampleAppPresModel):void
        {
            this.flexSpacesPresModel = sampleAppPresModel;            
        }               
        
        /**
         * Handle creation complete of repository browser after login
         *  
         * @param event on create complete event
         * 
         */
        override protected function onRepoBrowserCreated(event:FlexEvent):void
        {            
            searchView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);
            searchView.addEventListener(AdvancedSearchEvent.ADVANCED_SEARCH_REQUEST, advancedSearch);   
            
            logoutView.addEventListener(LogoutDoneEvent.LOGOUT_DONE, onLogoutDone);              

            // keyboard handlers
            this.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);  
            
            // init tab navigator
            tabNav.addEventListener(IndexChangedEvent.CHANGE, tabChange);   
            tabNav.popUpButtonPolicy = SuperTabNavigator.POPUPPOLICY_OFF;
            // prevent closing of doclib, search results
            tabNav.setClosePolicyForTab(DOC_LIB_TAB_INDEX, SuperTab.CLOSE_NEVER);                    
            tabNav.setClosePolicyForTab(SEARCH_TAB_INDEX, SuperTab.CLOSE_NEVER);  
            // todo: for now to avoid tab drag drop error in air app, disable drag/drop of tabs
            // due to bug in supertabnavigator
            tabNav.dragEnabled = false;
            tabNav.dropEnabled = false; 
            tabNav.addEventListener(SuperTabEvent.TAB_CLOSE, onTabClose);

            // init doclib view
            browserView.viewActive(true);
            browserView.setContextMenuHandler(onContextMenu);
            browserView.setOnDropHandler(onFolderViewOnDrop);
            browserView.setDoubleClickDocHandler(onDoubleClickDoc);
            browserView.setClickNodeHandler(onClickNode);                                    
            browserView.addEventListener(RepoBrowserChangePathEvent.REPO_BROWSER_CHANGE_PATH, onBrowserChangePath);
            
            // init search view
            searchResultsView.addEventListener(FolderViewContextMenuEvent.FOLDERLIST_CONTEXTMENU, onContextMenu);
            searchResultsView.addEventListener(DoubleClickDocEvent.DOUBLE_CLICK_DOC, onDoubleClickDoc);
            searchResultsView.addEventListener(ClickNodeEvent.CLICK_NODE, onClickNode);   

            // select the first enabled main view tab
            var tabIndex:int = 0;
            tabIndex = DOC_LIB_TAB_INDEX;
            tabNav.invalidateDisplayList();
            tabNav.selectedIndex = tabIndex;            
        }
        
        /**
         * Handle switching tabs between doc lib, search, task, wcm lib
         *  
         * @param event index change event
         * 
         */
        override protected function tabChange(event:IndexChangedEvent):void
        {
            if (event.newIndex != event.oldIndex)
            {
                clearSelection();   
                
                if (event.newIndex == DOC_LIB_TAB_INDEX)
                {
                    if (browserView != null)
                    {
                        browserView.viewActive(true);
                    }
                }
                else if (event.newIndex == SEARCH_TAB_INDEX) 
                {
                    sampleAppPresModel.currentNodeList = null;
                    if (browserView != null)
                    {
                        browserView.viewActive(false);
                    }
                }
                
                enableMenusAfterTabChange(event.newIndex);                
            }    
        }
        
        /**
         * Switch on menu data to method for both main menu bar
         * and context menus
         *  
         * @param data menu command
         * 
         */
        override protected function handleBothKindsOfMenus(data:String):void
        {    
            var selectedItem:Object = sampleAppPresModel.selectedItem;   
            var selectedItems:Array = sampleAppPresModel.selectedItems; 
            
            switch(data)
            {
                default:
                    super.handleBothKindsOfMenus(data);
                    break;            
            }
        }    
        
       override protected function enableMenusAfterTabChange(tabIndex:int):void
       {
       }     
        
       override protected function enableMenusAfterSelection(selectedItem:Object):void
       {          
       }
        
    }
}
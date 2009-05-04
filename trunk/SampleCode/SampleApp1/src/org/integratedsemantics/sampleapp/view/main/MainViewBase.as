package org.integratedsemantics.sampleapp.view.main
{
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    
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
            // init header section
            searchView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);
            searchView.addEventListener(AdvancedSearchEvent.ADVANCED_SEARCH_REQUEST, advancedSearch);   
            logoutView.addEventListener(LogoutDoneEvent.LOGOUT_DONE, onLogoutDone);              

            // init main menu
            mainMenu.addEventListener(MenuConfiguredEvent.MENU_CONFIGURED, onMainMenuConfigured);
            mainMenu.addEventListener(MenuEvent.ITEM_CLICK, menuHandler); 
                      
            // keyboard handlers
            this.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);  
            
            // init toolbar
            this.cutBtn.addEventListener(MouseEvent.CLICK, onCutBtn);
            this.copyBtn.addEventListener(MouseEvent.CLICK, onCopyBtn);
            this.pasteBtn.addEventListener(MouseEvent.CLICK, onPasteBtn);
            this.deleteBtn.addEventListener(MouseEvent.CLICK, onDeleteBtn);
            this.createSpaceBtn.addEventListener(MouseEvent.CLICK, onCreateSpaceBtn);
            this.uploadFileBtn.addEventListener(MouseEvent.CLICK, onUploadFileBtn);                    
            this.tagsBtn.addEventListener(MouseEvent.CLICK, onTagsBtn);     

            // get index values of tabs
            docLibTabIndex = tabNav.getChildIndex(docLibTab);
            searchTabIndex = tabNav.getChildIndex(searchTab);

            // init tab navigator
            tabNav.addEventListener(IndexChangedEvent.CHANGE, tabChange);   
            tabNav.popUpButtonPolicy = SuperTabNavigator.POPUPPOLICY_OFF;
            // prevent closing of doclib, search results, tasks, wcm tabs
            tabNav.setClosePolicyForTab(docLibTabIndex, SuperTab.CLOSE_NEVER);                    
            tabNav.setClosePolicyForTab(searchTabIndex, SuperTab.CLOSE_NEVER);  
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
            // init for serverside paging 
            browserView.initPaging();                
            
            // init search view
            searchResultsView.addEventListener(FolderViewContextMenuEvent.FOLDERLIST_CONTEXTMENU, onContextMenu);
            searchResultsView.addEventListener(DoubleClickDocEvent.DOUBLE_CLICK_DOC, onDoubleClickDoc);
            searchResultsView.addEventListener(ClickNodeEvent.CLICK_NODE, onClickNode);   
                                
            // select doclib tab
            var tabIndex:int = docLibTabIndex;
            tabNav.invalidateDisplayList();
            tabNav.selectedIndex = tabIndex;                          
        }
                

        /**
         * Handle switching tabs between doc lib, search, 
         *  
         * @param event index change event
         * 
         */
        override protected function tabChange(event:IndexChangedEvent):void
        {
            if (event.newIndex != event.oldIndex)
            {
                clearSelection();   
                
                if (event.newIndex == docLibTabIndex)
                {
                    if (browserView != null)
                    {
                        browserView.viewActive(true);
                    }
                }
                else if (event.newIndex == searchTabIndex) 
                {
                    flexSpacesPresModel.currentNodeList = null;
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
            var selectedItem:Object = flexSpacesPresModel.selectedItem;   
            var selectedItems:Array = flexSpacesPresModel.selectedItems; 
            
            switch(data)
            {
                default:
                    super.handleBothKindsOfMenus(data);
                    break;            
            }
        }            
        
    }
}
package org.integratedsemantics.flexspaces.view.main
{
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;
    
    import flexlib.containers.DockableToolBar;
    import flexlib.containers.Docker;
    import flexlib.containers.SuperTabNavigator;
    import flexlib.controls.tabBarClasses.SuperTab;
    import flexlib.events.SuperTabEvent;
    
    import mx.binding.utils.ChangeWatcher;
    import mx.containers.Box;
    import mx.containers.HBox;
    import mx.containers.VBox;
    import mx.containers.VDividedBox;
    import mx.containers.ViewStack;
    import mx.controls.Button;
    import mx.events.FlexEvent;
    import mx.events.IndexChangedEvent;
    import mx.events.MenuEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.alfresco.framework.service.authentication.AuthenticationService;
    import org.integratedsemantics.flexspaces.control.event.GetInfoEvent;
    import org.integratedsemantics.flexspaces.control.event.ui.*;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.model.vo.CheckoutVO;
    import org.integratedsemantics.flexspaces.presmodel.folderview.FolderViewPresModel;
    import org.integratedsemantics.flexspaces.presmodel.folderview.NodeListViewPresModel;
    import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
    import org.integratedsemantics.flexspaces.presmodel.playvideo.PlayVideoPresModel;
    import org.integratedsemantics.flexspaces.presmodel.preview.PreviewPresModel;
    import org.integratedsemantics.flexspaces.presmodel.search.advanced.AdvancedSearchPresModel;
    import org.integratedsemantics.flexspaces.presmodel.semantictags.suggest.SemanticTagSuggestPresModel;
    import org.integratedsemantics.flexspaces.presmodel.versions.versionlist.VersionListPresModel;
    import org.integratedsemantics.flexspaces.view.browser.RepoBrowserChangePathEvent;
    import org.integratedsemantics.flexspaces.view.browser.RepoBrowserViewBase;
    import org.integratedsemantics.flexspaces.view.checkedout.CheckedOutViewBase;
    import org.integratedsemantics.flexspaces.view.folderview.FolderViewBase;
    import org.integratedsemantics.flexspaces.view.folderview.NodeListViewBase;
    import org.integratedsemantics.flexspaces.view.folderview.event.ClickNodeEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.DoubleClickDocEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.FolderViewContextMenuEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.FolderViewOnDropEvent;
    import org.integratedsemantics.flexspaces.view.login.LoginDoneEvent;
    import org.integratedsemantics.flexspaces.view.login.LoginViewBase;
    import org.integratedsemantics.flexspaces.view.logout.LogoutDoneEvent;
    import org.integratedsemantics.flexspaces.view.logout.LogoutViewBase;
    import org.integratedsemantics.flexspaces.view.menu.event.MenuConfiguredEvent;
    import org.integratedsemantics.flexspaces.view.menu.menubar.ConfigurableMenuBar;
    import org.integratedsemantics.flexspaces.view.playvideo.PlayVideoView;
    import org.integratedsemantics.flexspaces.view.preview.PreviewView;
    import org.integratedsemantics.flexspaces.view.search.advanced.AdvancedSearchEvent;
    import org.integratedsemantics.flexspaces.view.search.advanced.AdvancedSearchView;
    import org.integratedsemantics.flexspaces.view.search.basic.SearchViewBase;
    import org.integratedsemantics.flexspaces.view.search.event.SearchResultsEvent;
    import org.integratedsemantics.flexspaces.view.search.results.SearchResultsViewBase;
    import org.integratedsemantics.flexspaces.view.search.searchpanel.SearchPanelBase;
    import org.integratedsemantics.flexspaces.view.semantictags.suggest.SemanticTagSuggestView;
    import org.integratedsemantics.flexspaces.view.tasks.taskspanel.TasksPanelViewBase;
    import org.integratedsemantics.flexspaces.view.versions.versionlist.VersionListViewBase;
    import org.integratedsemantics.flexspaces.view.wcm.browser.WcmRepoBrowserViewBase;


    /**
     * Base view class for flexspaces view 
     * 
     */
    public class FlexSpacesViewBase extends VDividedBox
    {
        // view modes
        public static const GET_CONFIG_MODE_INDEX:int = 0;
        public static const LOGIN_MODE_INDEX:int = 1;
        public static const GET_INFO_MODE_INDEX:int = 2;
        public static const MAIN_VIEW_MODE_INDEX:int = 3;

        // index of tabs for views
        public static const DOC_LIB_TAB_INDEX:int = 0;
        public static const SEARCH_TAB_INDEX:int = 1;
        //cmis added checked out tab view
        public static const CHECKED_OUT_TAB_INDEX:int = 2;        
        public static const TASKS_TAB_INDEX:int = 3;
        public static const WCM_TAB_INDEX:int = 4;
             
        public var flexspacesviews:VBox;
        
        public var loginPage:VBox;
        public var header:HBox;
        
        public var searchView:SearchViewBase;
        public var logoutView:LogoutViewBase;
        
        public var mainMenu:ConfigurableMenuBar;
        
        public var viewStack:ViewStack;
        
        public var loginPanel:Box;
        public var loginView:LoginViewBase;
        
        public var tabNav:SuperTabNavigator;
        
        public var browserTab:VBox;
        public var browserView:RepoBrowserViewBase;
        
        public var searchTab:VBox;
        public var searchPanel:SearchPanelBase;
        
        public var tasksTab:VBox;
        public var tasksPanelView:TasksPanelViewBase;
        
        public var wcmTab:VBox;
        public var wcmBrowserView:WcmRepoBrowserViewBase;
        
        public var checkedOutView:CheckedOutViewBase;
     
        public var docker:Docker;
        public var menuToolbar:DockableToolBar;
        public var toolbar1:DockableToolBar;
        
        public var cutBtn:Button;
        public var copyBtn:Button;
        public var pasteBtn:Button;
        public var deleteBtn:Button;
        public var createSpaceBtn:Button;
        public var uploadFileBtn:Button;
        public var tagsBtn:Button;
                
        [Bindable]
        protected var model:AppModelLocator = AppModelLocator.getInstance();
        
        [Bindable]
        public var flexSpacesPresModel:FlexSpacesPresModel;
        
        public var searchResultsView:SearchResultsViewBase;               
        protected var advSearchView:AdvancedSearchView = null;

        // embedded mode when passed login ticket
        protected var embeddedMode:Boolean = false;
      
                          
        /**
         * Constructor 
         * 
         */
        public function FlexSpacesViewBase()
        {
            super();                        
        }
                
        /**
         * Handle creation complete of the main view
         *  
         * @param event on create complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
            this.viewStack = this.viewStack;   
            
            if ((model.userInfo.loginTicket != null) && (model.userInfo.loginTicket.length != 0))
            {
                embeddedMode = true;
                flexSpacesPresModel.showHeader = false;
                AuthenticationService.instance.ticket = model.userInfo.loginTicket;                
                onLoginDone(new LoginDoneEvent(LoginDoneEvent.LOGIN_DONE));
            }
            else if (model.configComplete == true)
            {			         
                viewStack.selectedIndex = LOGIN_MODE_INDEX;         
            }              
            else
            {
                ChangeWatcher.watch(model, "configComplete", onConfigComplete);
            }
            
            if (flexSpacesPresModel != null)
            {
            	flexSpacesPresModel.updateFunction = redraw;
            }         
        }        
        
        /**
         * Handle login view creation complete
         *  
         * @param event on create complete event
         * 
         */
        protected function onLoginViewCreated(event:FlexEvent):void
        {
            loginView.addEventListener(LoginDoneEvent.LOGIN_DONE, onLoginDone);            
        }
         
        protected function onConfigComplete(event:Event):void
        {
            viewStack.selectedIndex = LOGIN_MODE_INDEX;                        
        }
                         
        /**
         * Handler called when login is successfully completed
         * 
         * @param   event   login done event
         */
        public function onLoginDone(event:LoginDoneEvent):void
        {
            viewStack.selectedIndex = GET_INFO_MODE_INDEX;  
       
            var responder:Responder = new Responder(onGetInfoDone, flexSpacesPresModel.onFaultAction);
            var getInfoEvent:GetInfoEvent = new GetInfoEvent(GetInfoEvent.GET_INFO, responder);
            getInfoEvent.dispatch();                                
        }        

        /**
         * Handler called when get info is successfully completed
         * 
         * @param   event   get info event
         */
        public function onGetInfoDone(info:Object):void
        {
            // Switch from get info to (main view in view stack 
            viewStack.selectedIndex = MAIN_VIEW_MODE_INDEX;                 
        }
                
        /**
         * Handle creation complete of repository browser after login
         *  
         * @param event on create complete event
         * 
         */
        protected function onRepoBrowserCreated(event:FlexEvent):void
        {            
            this.searchResultsView = this.searchPanel.searchResultsView;

            // init header section
            if (flexSpacesPresModel.showHeader == false)
            {
                this.header.visible = false;
                this.header.includeInLayout = false;
            }
            else
            {
                if (flexSpacesPresModel.showSearch == true)
                {
                    searchView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);
                    searchView.addEventListener(AdvancedSearchEvent.ADVANCED_SEARCH_REQUEST, advancedSearch);   
                }    
                
                logoutView.addEventListener(LogoutDoneEvent.LOGOUT_DONE, onLogoutDone);              
            }

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

            // init tab navigator
            tabNav.addEventListener(IndexChangedEvent.CHANGE, tabChange);   
            tabNav.popUpButtonPolicy = SuperTabNavigator.POPUPPOLICY_OFF;
            // prevent closing of doclib, search results, tasks, wcm tabs
            tabNav.setClosePolicyForTab(DOC_LIB_TAB_INDEX, SuperTab.CLOSE_NEVER);                    
            tabNav.setClosePolicyForTab(SEARCH_TAB_INDEX, SuperTab.CLOSE_NEVER);  
            tabNav.setClosePolicyForTab(CHECKED_OUT_TAB_INDEX, SuperTab.CLOSE_NEVER);  
            tabNav.setClosePolicyForTab(TASKS_TAB_INDEX, SuperTab.CLOSE_NEVER);  
            tabNav.setClosePolicyForTab(WCM_TAB_INDEX, SuperTab.CLOSE_NEVER);  
            // todo: for now to avoid tab drag drop error in air app, disable drag/drop of tabs
            // due to bug in supertabnavigator
            tabNav.dragEnabled = false;
            tabNav.dropEnabled = false; 
            tabNav.addEventListener(SuperTabEvent.TAB_CLOSE, onTabClose);

            // hide checked out tab for now
            tabNav.getTabAt(CHECKED_OUT_TAB_INDEX).visible = false;
            tabNav.getTabAt(CHECKED_OUT_TAB_INDEX).includeInLayout = false;            

            // init doclib view
            if (flexSpacesPresModel.showDocLib == true)
            {
                browserView.viewActive(true);
                browserView.setContextMenuHandler(onContextMenu);
                browserView.setOnDropHandler(onFolderViewOnDrop);
                browserView.setDoubleClickDocHandler(onDoubleClickDoc);
                browserView.setClickNodeHandler(onClickNode);                                    
                browserView.addEventListener(RepoBrowserChangePathEvent.REPO_BROWSER_CHANGE_PATH, onBrowserChangePath);
                // init for serverside paging 
                browserView.initPaging();                
            }
            
            // init wcm view
            if (flexSpacesPresModel.showWCM == true)
            {
                wcmBrowserView.setContextMenuHandler(onContextMenu);
                wcmBrowserView.setOnDropHandler(onFolderViewOnDrop);
                wcmBrowserView.setDoubleClickDocHandler(onDoubleClickDoc);
                wcmBrowserView.setClickNodeHandler(onClickNode);            
                wcmBrowserView.addEventListener(RepoBrowserChangePathEvent.REPO_BROWSER_CHANGE_PATH, onBrowserChangePath);
            }

            // init search view
            if (flexSpacesPresModel.showSearch == true)
            {
                searchResultsView.addEventListener(FolderViewContextMenuEvent.FOLDERLIST_CONTEXTMENU, onContextMenu);
                searchResultsView.addEventListener(DoubleClickDocEvent.DOUBLE_CLICK_DOC, onDoubleClickDoc);
                searchResultsView.addEventListener(ClickNodeEvent.CLICK_NODE, onClickNode);   
                                
                var searchView2:SearchViewBase = searchPanel.searchView2;
                searchView2.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);
                searchView2.addEventListener(AdvancedSearchEvent.ADVANCED_SEARCH_REQUEST, advancedSearch);
                
                // favorites
                searchPanel.favoritesView.addEventListener(FolderViewContextMenuEvent.FOLDERLIST_CONTEXTMENU, onContextMenu);
                searchPanel.favoritesView.addEventListener(DoubleClickDocEvent.DOUBLE_CLICK_DOC, onDoubleClickDoc);
                searchPanel.favoritesView.addEventListener(ClickNodeEvent.CLICK_NODE, onClickNode);     
                searchPanel.favoritesView.addEventListener(FolderViewOnDropEvent.FOLDERLIST_ONDROP, onFavoritesOnDrop);                      
                // get initial display of favorites
                if (searchPanel.searchPanelPresModel.favoritesPresModel != null)
                {
                    searchPanel.searchPanelPresModel.favoritesPresModel.redraw();
                }                                                             
            }

            // init wcm view
            if (flexSpacesPresModel.showTasks == true)
            {
                tasksPanelView.setContextMenuHandler(onContextMenu);
                tasksPanelView.setDoubleClickDocHandler(onDoubleClickDoc);
                tasksPanelView.setClickNodeHandler(onClickNode);                                    
            }
              
            // hide tabs for views not to show
            if (flexSpacesPresModel.showDocLib == false)
            {
                tabNav.getTabAt(DOC_LIB_TAB_INDEX).visible = false;
                tabNav.getTabAt(DOC_LIB_TAB_INDEX).includeInLayout = false;
            }   
            if (flexSpacesPresModel.showSearch == false)
            {
                tabNav.getTabAt(SEARCH_TAB_INDEX).visible = false;
                tabNav.getTabAt(SEARCH_TAB_INDEX).includeInLayout = false;
                searchView.visible = false;
                this.header.invalidateDisplayList();
            }   
            if (flexSpacesPresModel.showTasks == false)
            {
                tabNav.getTabAt(TASKS_TAB_INDEX).visible = false;
                tabNav.getTabAt(TASKS_TAB_INDEX).includeInLayout = false;
            }   
            if (flexSpacesPresModel.showWCM == false)
            {
                tabNav.getTabAt(WCM_TAB_INDEX).visible = false;
                tabNav.getTabAt(WCM_TAB_INDEX).includeInLayout = false;
            } 

            // select the first enabled main view tab
            var tabIndex:int = 0;
            if (flexSpacesPresModel.showDocLib == true)
            {
                tabIndex = DOC_LIB_TAB_INDEX;
            }
            else if (flexSpacesPresModel.showSearch == true)
            {
                tabIndex = SEARCH_TAB_INDEX;
            }
            else if (flexSpacesPresModel.showTasks == true)
            {
                tabIndex = TASKS_TAB_INDEX;
            }
            else if (flexSpacesPresModel.showWCM == true)
            {
                tabIndex = WCM_TAB_INDEX;
            }            
            tabNav.invalidateDisplayList();
            tabNav.selectedIndex = tabIndex;                          
        }
                
        /**
         * Handle any initial menu enabling/disable after menu config loaded
         *  
         * @param event menu configured event
         * 
         */
        protected function onMainMenuConfigured(event:MenuConfiguredEvent):void
        {
            // disable advanced search menu if no search tab
            mainMenu.menuBarCollection[3].menuitem[5].@enabled = flexSpacesPresModel.showSearch;
            // disable show tree, show second folder if no doclib tab      
            mainMenu.menuBarCollection[2].menuitem[0].@enabled = flexSpacesPresModel.showDocLib;
            mainMenu.menuBarCollection[2].menuitem[1].@enabled = flexSpacesPresModel.showDocLib;
            // disable show wcm tree, show second wcm folder if no wcm tab                  
            mainMenu.menuBarCollection[2].menuitem[3].@enabled = flexSpacesPresModel.showWCM;
            mainMenu.menuBarCollection[2].menuitem[4].@enabled = flexSpacesPresModel.showWCM;

            // dissable thumbnails menu if not at least 3.0
            var version:Number = model.ecmServerConfig.serverVersionNum();
            if (version < 3.0)
            {
                mainMenu.menuBarCollection[2].menuitem[6].@enabled = false;    
            }            

            // do other menu setup
            enableMenusAfterTabChange(tabNav.selectedIndex);                
        }

        /**
         * Handle close of a document tab in super tab navigator
         *  
         * @param event tab close event
         * 
         */
        protected function onTabClose(event:SuperTabEvent):void
        {
            // select the first enabled main view tab
            var tabIndex:int = 0;
            if (flexSpacesPresModel.showDocLib == true)
            {
                tabIndex = DOC_LIB_TAB_INDEX;
            }
            else if (flexSpacesPresModel.showSearch == true)
            {
                tabIndex = SEARCH_TAB_INDEX;
            }
            else if (flexSpacesPresModel.showTasks == true)
            {
                tabIndex = TASKS_TAB_INDEX;
            }
            else if (flexSpacesPresModel.showWCM == true)
            {
                tabIndex = WCM_TAB_INDEX;
            }
            
            tabNav.invalidateDisplayList();
            tabNav.selectedIndex = tabIndex;            
        }

        /**
         * Handle switching tabs between doc lib, search, task, wcm lib
         *  
         * @param event index change event
         * 
         */
        protected function tabChange(event:IndexChangedEvent):void
        {
            if (event.newIndex != event.oldIndex)
            {
                clearSelection();   
                
                if (event.newIndex == DOC_LIB_TAB_INDEX)
                {
                    flexSpacesPresModel.wcmMode = false;
                    if (browserView != null)
                    {
                    	browserView.viewActive(true);
                    }
                    if (wcmBrowserView != null)
                    {
                    	wcmBrowserView.viewActive(false);
                    }
                }
                else if (event.newIndex == WCM_TAB_INDEX)
                { 
                    flexSpacesPresModel.wcmMode = true;
                    if (browserView != null)
                    {
                    	browserView.viewActive(false);
                    }
                    if (wcmBrowserView != null)
                    {
                    	wcmBrowserView.viewActive(true);
                    }
                }       
                else if (event.newIndex == SEARCH_TAB_INDEX) 
                {
                    flexSpacesPresModel.wcmMode = false;
                    flexSpacesPresModel.currentNodeList = null;
                    searchPanel.refresh();
                    if (browserView != null)
                    {
                    	browserView.viewActive(false);
                    }
                    if (wcmBrowserView != null)
                    {
                    	wcmBrowserView.viewActive(false);
                    }
                }
                else if (event.newIndex == TASKS_TAB_INDEX) 
                {
                    flexSpacesPresModel.wcmMode = false;
                    flexSpacesPresModel.currentNodeList = null;
                    if (browserView != null)
                    {
                    	browserView.viewActive(false);
                    }
                    if (wcmBrowserView != null)
                    {
                    	wcmBrowserView.viewActive(false);
                    }
                }
                
                enableMenusAfterTabChange(event.newIndex);                
            }    
        }

        /**
         * Handler when doclib browser or wcm browser changes path
         * 
         * @param event change path evnet
         * 
         */
        protected function onBrowserChangePath(event:RepoBrowserChangePathEvent):void
        {
            // enable/disable menus dependent on user permissions in folder
            // independent of selections since selection is cleared after path change
            this.enableMenusAfterTabChange(tabNav.selectedIndex);                
        }
                
        /**
         * Handler called when logout is successfully completed
         * 
         * @param   event   logout done event
         */
        public function onLogoutDone(event:LogoutDoneEvent):void
        {
            // Switch from view 1 (main view) back to view 0 (login) in view stack 
            viewStack.selectedIndex = LOGIN_MODE_INDEX;
            
            flexSpacesPresModel.cut = null;
            flexSpacesPresModel.copy = null;      
        }
        
        /**
         * Handler called when search results data is available
         * Switch to search results tab and update with results data
         * 
         * @param event search results event with results data
         */
        public function onSearchResults(event:SearchResultsEvent):void
        {
            tabNav.selectedIndex = SEARCH_TAB_INDEX;
            flexSpacesPresModel.searchPanelPresModel.initResultsData(event.searchResults);  
            // reset page index since new user query,  not requery to page
            searchResultsView.resetPaging();
        }
           
        /**
         * Handle results are available from advanced search
         *  
         * @param data search results
         * 
         */
        public function advancedSearchResultsAvailable(data:Object):void
        {
            var searchResultsEvent:SearchResultsEvent = new SearchResultsEvent(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, data);
            this.onSearchResults(searchResultsEvent);                   
        }
            
        /**
         * Display the containing folder for the selected item
         * (for items in task attachments and search results)
         * note: not for avm files
         *  
         * @param selectedItem selected node
         * 
         */
        public function gotoParentFolder(selectedItem:Object):void
        {
            if (selectedItem != null)
            {            
                // set the path of the  tree and left pane 
                browserView.setPath(selectedItem.parentPath);
            
                // switch to the doc lib tab 
                tabNav.selectedIndex = DOC_LIB_TAB_INDEX;
            }
        }
                
        /**
         * Redraw folder views after menu operations
         *  
         */
        public function redraw():void
        {
            var tabIndex:int = tabNav.selectedIndex;
            if (tabIndex == DOC_LIB_TAB_INDEX)
            {
                browserView.redraw();
            }
            else if (tabIndex == WCM_TAB_INDEX)
            { 
                wcmBrowserView.redraw();
            }       
            else if (tabIndex == SEARCH_TAB_INDEX)
            {
                searchPanel.redraw();
            }
            else if (tabIndex == TASKS_TAB_INDEX) 
            {
                tasksPanelView.taskAttachmentsView.redraw();
            }            
        }

        /**
         * Handle double click on a document/file node in a folder view by viewing it
         *  
         * @param event double doc event
         * 
         */
        public function onDoubleClickDoc(event:DoubleClickDocEvent):void
        {
            flexSpacesPresModel.selectedItem = event.doubleClickedItem;
            
            viewNode(event.doubleClickedItem); 
        }        

        /**
         * Handle click on doc/folder node in a folder view by updating selection information kept
         *  
         * @param event click node event
         * 
         */
        public function onClickNode(event:ClickNodeEvent):void
        {
            flexSpacesPresModel.selectedItem = event.clickedItem;
            
            if (event.folderView != null)
            {
                if ( (event.folderView is VersionListViewBase) == true )
                {
                	var versionListView:VersionListViewBase = event.folderView as VersionListViewBase;
                	var versionListPresModel:VersionListPresModel = versionListView.versionListPresModel;                 	
	                flexSpacesPresModel.currentNodeList = versionListPresModel.nodeCollection;
	                flexSpacesPresModel.selectedItems = versionListView.getSelectedItems();
	                clearOtherSelections(versionListPresModel);                         	

		            enableMenusAfterTabChange(tabNav.selectedIndex);
		            enableMenusAfterVersionSelection(flexSpacesPresModel.selectedItem);                	
                }
                else if ( (event.folderView is NodeListViewBase) == true )
                {
                	var nodeListView:NodeListViewBase = event.folderView as NodeListViewBase;
                	var nodeListPresModel:NodeListViewPresModel = nodeListView.nodeListViewPresModel;                 	
	                flexSpacesPresModel.currentNodeList = nodeListPresModel.nodeCollection;
	                flexSpacesPresModel.selectedItems = nodeListView.getSelectedItems();
	                clearOtherSelections(nodeListPresModel);                         	

	                // init version list when a main folder view node is selected
	                if ( (flexSpacesPresModel.wcmMode == false) && (flexSpacesPresModel.browserPresModel != null) )
	                {
                		browserView.initVersionList(flexSpacesPresModel.selectedItem);
	                }
                	
		            enableMenusAfterTabChange(tabNav.selectedIndex);
		            enableMenusAfterSelection(flexSpacesPresModel.selectedItem);                	
                }
            }            
        }        

        /**
         * Clear selections in all folder views 
         * 
         */
        public function clearSelection():void
        {
            flexSpacesPresModel.clearSelection(); 
            if (browserView != null)
            {  
                browserView.clearSelection();
            }
            if (searchPanel != null)
            {  
                searchPanel.clearSelection();
            }
            if (tasksPanelView != null)
            {  
                tasksPanelView.clearSelection();
            }
            if (wcmBrowserView != null)
            {  
                wcmBrowserView.clearSelection();
            }
            if (checkedOutView != null)
            {  
                checkedOutView.clearSelection();
            }            
        }

        /**
         * Clear selections in folder views other than the current/selected folder view
         *  
         * @param selectedFolderView current/selected folder ivew
         * 
         */
        public function clearOtherSelections(selectedFolderView:PresModel):void
        {
            if (browserView != null)
            {  
                browserView.clearOtherSelections(selectedFolderView);
            }            
            if (searchPanel != null)
            {  
                searchPanel.clearOtherSelections(selectedFolderView);
            }
            if (tasksPanelView != null)
            {  
                tasksPanelView.clearOtherSelections(selectedFolderView);
            }
            if (wcmBrowserView != null)
            {  
                wcmBrowserView.clearOtherSelections(selectedFolderView);
            }
            if (checkedOutView != null)
            {  
                checkedOutView.clearOtherSelections(selectedFolderView);
            }            
        }

        /**
         * Handler for good result from cairngorm checkout event/cmd
         * for edit, now kickoff download of working copy
         * 
         * @param info result info
         * 
         */
        public function onResultCheckoutForEdit(info:Object):void
        {
            redraw(); 
            
            var result:CheckoutVO = info as CheckoutVO;
            
            var workingCopy:Node = new Node();
            
            workingCopy.name = result.name;
            workingCopy.nodeRef = result.nodeRef;
            workingCopy.id = result.id;
            workingCopy.viewurl = result.viewUrl;
            
            flexSpacesPresModel.downloadFile(workingCopy, this);                  
        }

        /**
         * Cut selected node items to internal clipboard (not removed (moved) until paste)
         *  
         * @param selectedItems selected nodes
         * 
         */
        public function cutNodes(selectedItems:Array):void
        {
            flexSpacesPresModel.cutNodes(selectedItems);    
            
            // enable paste menu                                        
            var tabIndex:int = tabNav.selectedIndex;
            if ((tabIndex == DOC_LIB_TAB_INDEX) || (tabIndex == WCM_TAB_INDEX))
            {
                mainMenu.menuBarCollection[1].menuitem[2].@enabled = true;                    
            }                                                    
        }

        /**
         * Copy selected node items to internal clipboard
         *  
         * @param selectedItems selected nodes
         * 
         */
        public function copyNodes(selectedItems:Array):void
        {
            flexSpacesPresModel.copyNodes(selectedItems);    

            // enable paste menu                                        
            var tabIndex:int = tabNav.selectedIndex;
            if ((tabIndex == DOC_LIB_TAB_INDEX) || (tabIndex == WCM_TAB_INDEX))
            {
                mainMenu.menuBarCollection[1].menuitem[2].@enabled = true;                    
            }                                                    
        }

        /**
         * view document node
         *  
         * @param selectedItem selected doc node
         * 
         */
        protected function viewNode(selectedItem:Object):void
        { 
        	flexSpacesPresModel.viewNode(selectedItem);
        }

        /**
         * Display flash preview for a doc if a preview already has been created
         *  
         * @param selectedItem selected node
         * 
         */
        protected function previewNode(selectedItem:Object):void
        {
            if (selectedItem != null && selectedItem.isFolder == false)
            {
                if (flexSpacesPresModel.wcmMode == false)
                {
                    // add tab for file
                    var count:int = tabNav.numChildren;
                    var tab:VBox = new VBox();
                    tab.percentHeight = 100;
                    tab.percentWidth = 100;
                    tab.label = selectedItem.name;
                    tab.id = selectedItem.name;
                    tab.setStyle("backgroundColor", 0x000000);
                    tabNav.addChild(tab);                       
                    tabNav.selectedIndex = count;            
                            
                    // setup preview class to display flash preivew
                    var previewView:PreviewView = new PreviewView();
                    var previewPresModel:PreviewPresModel = new PreviewPresModel(selectedItem as IRepoNode);
                    previewView.previewPresModel = previewPresModel;
                    previewView.percentWidth = 100;
                    previewView.percentHeight = 100;
                    tab.addChild(previewView);
                }
                else
                {
                    viewNode(selectedItem);
                }                        
            }            
        }

        /**
         * Play video
         *  
         * @param selectedItem selected node
         * 
         */
        public function playVideo(selectedItem:Object):void
        {
            if (selectedItem != null && selectedItem.isFolder == false)
            {
                if (flexSpacesPresModel.wcmMode == false)
                {
                    // add tab for file
                    var count:int = tabNav.numChildren;
                    var tab:VBox = new VBox();
                    tab.percentHeight = 100;
                    tab.percentWidth = 100;
                    tab.label = selectedItem.name;
                    tab.id = selectedItem.name;
                    tab.setStyle("backgroundColor", 0x000000);
                    tabNav.addChild(tab);                       
                    tabNav.selectedIndex = count;            
                            
                    // setup play video view in tab
                    var view:PlayVideoView = new PlayVideoView();
                    var presModel:PlayVideoPresModel = new PlayVideoPresModel(selectedItem as Node);
                    view.playVideoPresModel = presModel; 
                    view.percentWidth = 100;
                    view.percentHeight = 100;
                    tab.addChild(view);
                }
            }            
        }

        /**
         * Display the Advanced Search UI
         *  
         * @param event called with event when "advanced" link clicked on, null if from menu
         * 
         */
        public function advancedSearch(event:Event=null):void
        {
            if (advSearchView == null)
            {
                advSearchView = new AdvancedSearchView();
                var advSearchPresModel:AdvancedSearchPresModel = new AdvancedSearchPresModel();
                advSearchView.advancedSearchPresModel = advSearchPresModel;
                advSearchView.onComplete = advancedSearchResultsAvailable;
            }

            PopUpManager.addPopUp(advSearchView, this);                
        }

        /**
         * Display UI for semantic tag suggestions add/edit
         *  
         * @param selectedItem selected node
         * 
         */
        public function suggestTags(selectedItem:Object):void
        {
            if (selectedItem != null)
            {
                var view:SemanticTagSuggestView = SemanticTagSuggestView(PopUpManager.createPopUp(this, SemanticTagSuggestView, false));
                var presModel:SemanticTagSuggestPresModel = new SemanticTagSuggestPresModel(selectedItem as IRepoNode);
                view.semanticTagSuggestPresModel = presModel;                               
                view.onComplete = redraw;     
            }            
        }

        /**
         * Toggle whether the adm repository tree is displayed 
         * 
         */
        public function showHideRepoTree():void
        {
            flexSpacesPresModel.browserPresModel.showHideRepoTree();
            tabNav.invalidateDisplayList();
        }

        /**
         * Toggle whether the second adm folder pane is displayed 
         * 
         */
        public function showHideSecondRepoFolder():void
        {
            browserView.showHideSecondRepoFolder();
            tabNav.invalidateDisplayList();
        }
        
        /**
         * Toggle whether the avm repository tree is displayed 
         * 
         */
        public function showHideWcmRepoTree():void
        {
            flexSpacesPresModel.wcmBrowserPresModel.showHideRepoTree();
            tabNav.invalidateDisplayList();
        }

        /**
         * Toggle whether the second avm folder pane is displayed 
         * 
         */
        public function showHideWcmSecondRepoFolder():void
        {
            wcmBrowserView.showHideSecondRepoFolder();
            tabNav.invalidateDisplayList();
        }   
        
        /**
         * Toggle show / hide of thumbnails  
         * (icons shown when thumbnails hidden)
         * 
         */
        public function showHideThumbnails():void
        {
            if (browserView != null)
            {  
                browserView.showHideThumbnails();
            }
            if (searchPanel != null)
            {  
                searchPanel.showHideThumbnails();
            }
            if (tasksPanelView != null)
            {  
                tasksPanelView.taskAttachmentsView.showHideThumbnails();
            }
            if (wcmBrowserView != null)
            {  
                wcmBrowserView.showHideThumbnails();
            }            
            
            tabNav.invalidateDisplayList();
        }     


        /**
         * Toggle show / hide of version history list panel
         * 
         */
        public function showHideVersionHistory():void
        {
            if (browserView != null)
            {  
                browserView.showHideVersionHistory();
            }

            if (wcmBrowserView != null)
            {  
                wcmBrowserView.showHideVersionHistory();
            }            
            
            tabNav.invalidateDisplayList();
        }     

        /**
         * Handle chosen context menu item
         *  
         * @param event menu event
         * 
         */
        protected function onContextMenu(event:FolderViewContextMenuEvent):void
        {
            var cmd:String = event.commandName;
            
            handleBothKindsOfMenus(cmd);            
        }
        
        /**
         * Handle menu chosen in main menubar
         *  
         * @param event menu event
         * 
         */
        protected function menuHandler(event:MenuEvent):void
        {
            var data:String = event.item.@data;
            
            handleBothKindsOfMenus(data);
        }            
         
        /**
         * Switch on menu data to method for both main menu bar
         * and context menus
         *  
         * @param data menu command
         * 
         */
        protected function handleBothKindsOfMenus(data:String):void
        {    
            var selectedItem:Object = flexSpacesPresModel.selectedItem;   
            var selectedItems:Array = flexSpacesPresModel.selectedItems; 
            
            switch(data)
            {
                case "preview":
                    previewNode(selectedItem);
                    break;                     
                case 'view':
                   viewNode(selectedItem);
                   break;
                case 'edit':
                   flexSpacesPresModel.editNode(selectedItem, onResultCheckoutForEdit);
                   break;
                case 'cut':
                   cutNodes(selectedItems);
                   break;
                case 'copy':
                   copyNodes(selectedItems);
                   break;
                case 'paste':
                   flexSpacesPresModel.pasteNodes();
                   break;
                case 'newspace':
                    flexSpacesPresModel.createSpace(this);
                    break;
                case 'upload':
                    flexSpacesPresModel.uploadFiles(this);
                    break;
                case 'download':
                    flexSpacesPresModel.downloadFile(selectedItem, this);
                    break;
                case 'rename':
                    flexSpacesPresModel.rename(selectedItem, this);
                    break;
                case 'properties':
                    flexSpacesPresModel.properties(selectedItem, this);
                    break;
                case 'tags':
                    flexSpacesPresModel.tags(selectedItem, this);
                    break;
                case 'delete':
                    flexSpacesPresModel.deleteNodes(selectedItems, this);
                    break;
                case 'checkin':
                    flexSpacesPresModel.checkin(selectedItem);
                    break;
                case 'checkout':
                    flexSpacesPresModel.checkout(selectedItem);
                    break;
                case 'cancelcheckout':
                    flexSpacesPresModel.cancelCheckout(selectedItem);
                    break;
                case 'makeversion':
                    flexSpacesPresModel.makeVersionable(selectedItem);
                    break;
                case 'update':
                    flexSpacesPresModel.updateNode(selectedItem, this);
                    break;
                case 'startworkflow':
                    flexSpacesPresModel.startWorkflow(selectedItem, this);
                    break;
                case 'makepdf':
                    flexSpacesPresModel.makePDFs(selectedItems);
                    break;
                case "makepreview":
                    flexSpacesPresModel.makeFlashPreviews(selectedItems);
                    break;
                case "secondrepofolder":
                    showHideSecondRepoFolder();
                    break;    
                case "repotree":
                    showHideRepoTree();
                    break;  
                case "wcmsecondrepofolder":
                    showHideWcmSecondRepoFolder();
                    break;    
                case "wcmrepotree":
                    showHideWcmRepoTree();
                    break; 
                case "thumbnails":
                    showHideThumbnails();
                    break; 
                case "advancedsearch":
                    advancedSearch();
                    break;
                case "gotoParent":
                    gotoParentFolder(selectedItem);
                    break;
                case "versionhistory":
                    showHideVersionHistory();
                    break; 
                case 'playVideo':
                    playVideo(selectedItem);
                    break;                    
                case 'autoTag':
                    flexSpacesPresModel.autoTag(selectedItems);
                    break;                    
                case 'suggestTags':
                    suggestTags(selectedItem);
                    break;                    
                case 'addfavorite':
                    flexSpacesPresModel.newFavorite(selectedItem);
                    break;
                case 'deletefavorite':
                    flexSpacesPresModel.deleteFavorite(selectedItem);
                    break;
                default:
                    break;
            }   
        }
        
        /**
        * Handle keyboard command
        * 
        * @param event keyboard event
        */
        protected function onKeyDown(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.DELETE)
            {
                flexSpacesPresModel.deleteNodes(flexSpacesPresModel.selectedItems, this);
            }
        }                                

        //
        // Drag Drop
        //

        /**
         *  DragDrop event handler for  target folder list as the drop target
         *  (used in Flex when no Air native drag / drop)
         * 
         * @event folder view on drop event
         */         
        protected function onFolderViewOnDrop(event:FolderViewOnDropEvent):void
        {
            var targetFolderList:FolderViewBase = event.targetFolderList as FolderViewBase;
            var source:Array = event.dragSource.dataForFormat("items");
            onDropItems(targetFolderList.folderViewPresModel, event.dragAction, source);
        }
                
        /**
         * Handle dropping node items
         * (used in Flex and Air)
         *  
         * @param targetFolderList target folder view
         * @param action move ar copy 
         * @param items items to drop
         * 
         */
        protected function onDropItems(targetFolderList:FolderViewPresModel, action:String, items:Array):void
        {    
            var folderNode:IRepoNode = targetFolderList.currentFolderNode;
            var responder:Responder = new Responder(flexSpacesPresModel.onResultAction, flexSpacesPresModel.onFaultAction);
            var event:DropNodesUIEvent = new DropNodesUIEvent(DropNodesUIEvent.DROP_NODES, responder, folderNode, action, items);
            event.dispatch();                    
        }
        
        //
        // Menu Enabling / Disabling
        //
        
        /**
         * Enable / Disable menus after a node is selected
         *  
         * @param selectedItem node selected
         * 
         */
        protected function enableMenusAfterSelection(selectedItem:Object):void
        {              
            var tabIndex:int = tabNav.selectedIndex;
            
            if ((selectedItem != null) && (mainMenu.configurationDone == true))
            {
                var node:Node = selectedItem as Node;                
                var isLocked:Boolean = node.isLocked;
                var isWorkingCopy:Boolean = node.isWorkingCopy;

                var readPermission:Boolean = node.readPermission;                
                var writePermission:Boolean = node.writePermission;                
                var deletePermission:Boolean = node.deletePermission;                                
                
                var createChildrenPermission:Boolean = false;                                       
                if ( (flexSpacesPresModel.currentNodeList != null) && (flexSpacesPresModel.currentNodeList is Folder))
                {
                    var folder:Folder = flexSpacesPresModel.currentNodeList as Folder;
                    var parentNode:Node = folder.folderNode;
                    if (parentNode != null)
                    {
                        createChildrenPermission = parentNode.createChildrenPermission;
                    }                
                }                
                var enablePaste:Boolean = createChildrenPermission && ((flexSpacesPresModel.cut != null) || (flexSpacesPresModel.copy != null));
                
                var fileContextMenu:Boolean;

                // disable file operations if folder selected
                if (node.isFolder == true)
                {
                    // download, edit, view, preview
                    mainMenu.menuBarCollection[0].menuitem[4].@enabled = false;
                    mainMenu.menuBarCollection[0].menuitem[5].@enabled = false;
                    mainMenu.menuBarCollection[0].menuitem[6].@enabled = false;
                    mainMenu.menuBarCollection[0].menuitem[7].@enabled = false;
                    // checkin menus, update
                    mainMenu.menuBarCollection[1].menuitem[5].@enabled = false;
                    mainMenu.menuBarCollection[1].menuitem[6].@enabled = false;
                    mainMenu.menuBarCollection[1].menuitem[7].@enabled = false;
                    mainMenu.menuBarCollection[1].menuitem[8].@enabled = false;
                    mainMenu.menuBarCollection[1].menuitem[9].@enabled = false;
                    
                    // make pdf, make flash, startworkflow    
                    mainMenu.menuBarCollection[3].menuitem[0].@enabled = false;
                    mainMenu.menuBarCollection[3].menuitem[1].@enabled = false;
                    mainMenu.menuBarCollection[3].menuitem[3].@enabled = false;

                    fileContextMenu = false;
                }
                else
                {
                    // download, view, preview
                    mainMenu.menuBarCollection[0].menuitem[4].@enabled = readPermission;
                    mainMenu.menuBarCollection[0].menuitem[6].@enabled = readPermission;
                    mainMenu.menuBarCollection[0].menuitem[7].@enabled = readPermission;                                        

                    fileContextMenu = true;
                    // view, play video context  menus 
                    if (browserView != null)
                    {  
                        browserView.enableContextMenuItem("view", readPermission, fileContextMenu);
                        browserView.enableContextMenuItem("playVideo", readPermission, fileContextMenu);
                    }  
                    if (wcmBrowserView != null)
                    {  
                        wcmBrowserView.enableContextMenuItem("view", readPermission, fileContextMenu);
                        wcmBrowserView.enableContextMenuItem("playVideo", readPermission, fileContextMenu);
                    } 
                    if (searchPanel != null)
                    {  
                        searchPanel.searchResultsView.enableContextMenuItem("view", readPermission, fileContextMenu);
                        searchPanel.searchResultsView.enableContextMenuItem("playVideo", readPermission, fileContextMenu);
                    }
                    if (tasksPanelView != null)
                    {  
                        tasksPanelView.taskAttachmentsView.enableContextMenuItem("view", readPermission, fileContextMenu);
                        tasksPanelView.taskAttachmentsView.enableContextMenuItem("playVideo", readPermission, fileContextMenu);
                    }                    
                }
                
                // view specific         
                switch(tabIndex)
                {
                    case DOC_LIB_TAB_INDEX:       
                        // cut, copy, paste, delete   
                        mainMenu.menuBarCollection[1].menuitem[0].@enabled = deletePermission;
                        mainMenu.menuBarCollection[1].menuitem[1].@enabled = readPermission;
                        mainMenu.menuBarCollection[1].menuitem[2].@enabled = enablePaste;
                        mainMenu.menuBarCollection[1].menuitem[3].@enabled = deletePermission;
                        this.cutBtn.enabled = deletePermission;
                        this.copyBtn.enabled = readPermission;
                        this.pasteBtn.enabled = enablePaste;                    
                        this.deleteBtn.enabled = deletePermission;
                        browserView.enableContextMenuItem("cut", deletePermission, fileContextMenu);  
                        browserView.enableContextMenuItem("copy", readPermission, fileContextMenu);  
                        browserView.enableContextMenuItem("paste", enablePaste, fileContextMenu);  
                        browserView.enableContextMenuItem("delete", deletePermission, fileContextMenu);  

                        // rename, properties, tags
                        mainMenu.menuBarCollection[1].menuitem[11].@enabled = writePermission;                        
                        mainMenu.menuBarCollection[1].menuitem[12].@enabled = readPermission;                        
                        mainMenu.menuBarCollection[1].menuitem[13].@enabled = readPermission;    
                        this.tagsBtn.enabled = readPermission;                        
                        browserView.enableContextMenuItem("rename", writePermission, fileContextMenu);  
                        browserView.enableContextMenuItem("properties", readPermission, fileContextMenu);  
                        browserView.enableContextMenuItem("tags", readPermission, fileContextMenu);
                                                                    
                        if (selectedItem.isFolder != true)
                        {                            
                            // checkin
                            var canCheckin:Boolean = writePermission && isWorkingCopy;
                            mainMenu.menuBarCollection[1].menuitem[5].@enabled = canCheckin;
                            browserView.enableContextMenuItem("checkin", canCheckin, fileContextMenu);  
                            
                            // checkout, edit
                            var canCheckout:Boolean = writePermission && !isLocked && !isWorkingCopy;
                            mainMenu.menuBarCollection[1].menuitem[6].@enabled = canCheckout;
                            mainMenu.menuBarCollection[0].menuitem[5].@enabled = canCheckout;
                            browserView.enableContextMenuItem("checkout", canCheckout, fileContextMenu);  
                            
                            // cancel checkout
                            var canCancelCheckout:Boolean = writePermission && isWorkingCopy;
                            mainMenu.menuBarCollection[1].menuitem[7].@enabled = canCancelCheckout;
                            browserView.enableContextMenuItem("cancelcheckout", canCancelCheckout, fileContextMenu);  
                            
                            // make versionable
                            var canMakeVersionable:Boolean = writePermission && !isLocked;
                            mainMenu.menuBarCollection[1].menuitem[8].@enabled = canMakeVersionable;
                            
                            // update
                            var canUpdate:Boolean = writePermission && !isLocked;
                            mainMenu.menuBarCollection[1].menuitem[9].@enabled = canUpdate;

                            // make pdf, make flash, startworkflow
                            mainMenu.menuBarCollection[3].menuitem[0].@enabled = createChildrenPermission;
                            mainMenu.menuBarCollection[3].menuitem[1].@enabled = createChildrenPermission;
                            mainMenu.menuBarCollection[3].menuitem[3].@enabled = readPermission;  
                            
                            // auto-tag, suggest tags
                            if ((model.calaisConfig.enableCalias == true) && (writePermission == true))
                            {
                                if (model.appConfig.airMode == false)
                                {
                                    mainMenu.menuBarCollection[3].menuitem[7].@enabled = true;                  
                                    mainMenu.menuBarCollection[3].menuitem[8].@enabled = true;
                                }
                                else
                                {
                                    mainMenu.menuBarCollection[3].menuitem[10].@enabled = true;                 
                                    mainMenu.menuBarCollection[3].menuitem[11].@enabled = true;                         
                                }                   
                            }                                                                                  
                        }
                        break;        
                                     
                    case SEARCH_TAB_INDEX:
                    case TASKS_TAB_INDEX:
                        // cut, copy, paste, delete   
                        mainMenu.menuBarCollection[1].menuitem[0].@enabled = false;
                        mainMenu.menuBarCollection[1].menuitem[1].@enabled = readPermission;
                        mainMenu.menuBarCollection[1].menuitem[2].@enabled = false;
                        mainMenu.menuBarCollection[1].menuitem[3].@enabled = false;
                        this.cutBtn.enabled = false;
                        this.copyBtn.enabled = readPermission;
                        this.pasteBtn.enabled = false;                    
                        this.deleteBtn.enabled = false;
                        if (searchPanel != null)
                        {
                            searchPanel.searchResultsView.enableContextMenuItem("copy", readPermission, fileContextMenu);
                        }  
                        if (tasksPanelView != null)
                        {
                            tasksPanelView.taskAttachmentsView.enableContextMenuItem("copy", readPermission, fileContextMenu);
                        }  

                        // rename, properties, tags
                        mainMenu.menuBarCollection[1].menuitem[11].@enabled = writePermission;                        
                        mainMenu.menuBarCollection[1].menuitem[12].@enabled = readPermission;                        
                        mainMenu.menuBarCollection[1].menuitem[13].@enabled = readPermission;                        
                        this.tagsBtn.enabled = readPermission;            
                        
                        if (searchPanel != null)
                        {
                            searchPanel.searchResultsView.enableContextMenuItem("rename", writePermission, fileContextMenu);
                            searchPanel.searchResultsView.enableContextMenuItem("properties", readPermission, fileContextMenu);
                            searchPanel.searchResultsView.enableContextMenuItem("tags", readPermission, fileContextMenu);
                            searchPanel.searchResultsView.enableContextMenuItem( "gotoParent", flexSpacesPresModel.showDocLib, fileContextMenu);
                        }        
                        if (tasksPanelView != null)
                        {
                            tasksPanelView.taskAttachmentsView.enableContextMenuItem("rename", writePermission, fileContextMenu);
                            tasksPanelView.taskAttachmentsView.enableContextMenuItem("properties", readPermission, fileContextMenu);
                            tasksPanelView.taskAttachmentsView.enableContextMenuItem("tags", readPermission, fileContextMenu);
                            tasksPanelView.taskAttachmentsView.enableContextMenuItem( "gotoParent", flexSpacesPresModel.showDocLib, fileContextMenu);
                        }        
                        // checkin menus
                        mainMenu.menuBarCollection[1].menuitem[5].@enabled = false;
                        mainMenu.menuBarCollection[1].menuitem[6].@enabled = false;
                        mainMenu.menuBarCollection[1].menuitem[7].@enabled = false;
                        mainMenu.menuBarCollection[1].menuitem[8].@enabled = false;
                        // make pdf, make flash, startworkflow    
                        mainMenu.menuBarCollection[3].menuitem[0].@enabled = false;
                        mainMenu.menuBarCollection[3].menuitem[1].@enabled = false;
                        mainMenu.menuBarCollection[3].menuitem[3].@enabled = false;                        
                        break;
                                        
                    case WCM_TAB_INDEX:
                        // cut, copy, paste, delete   
                        mainMenu.menuBarCollection[1].menuitem[0].@enabled = deletePermission;
                        mainMenu.menuBarCollection[1].menuitem[1].@enabled = readPermission;
                        mainMenu.menuBarCollection[1].menuitem[2].@enabled = enablePaste;
                        mainMenu.menuBarCollection[1].menuitem[3].@enabled = deletePermission;
                        this.cutBtn.enabled = deletePermission;
                        this.copyBtn.enabled = readPermission;
                        this.pasteBtn.enabled = enablePaste;                    
                        this.deleteBtn.enabled = deletePermission;
                        wcmBrowserView.enableContextMenuItem("cut", deletePermission, fileContextMenu);  
                        wcmBrowserView.enableContextMenuItem("copy", readPermission, fileContextMenu);  
                        wcmBrowserView.enableContextMenuItem("paste", enablePaste, fileContextMenu);  
                        wcmBrowserView.enableContextMenuItem("delete", deletePermission, fileContextMenu);  

                        // rename, properties
                        mainMenu.menuBarCollection[1].menuitem[11].@enabled = writePermission;                        
                        mainMenu.menuBarCollection[1].menuitem[12].@enabled = readPermission;                        
                        wcmBrowserView.enableContextMenuItem("rename", writePermission, fileContextMenu);  
                        wcmBrowserView.enableContextMenuItem("properties", readPermission, fileContextMenu);  

                        if (selectedItem.isFolder != true)
                        {                                                    
                            // checkin menus
                            mainMenu.menuBarCollection[1].menuitem[5].@enabled = false;
                            mainMenu.menuBarCollection[1].menuitem[6].@enabled = false;
                            mainMenu.menuBarCollection[1].menuitem[7].@enabled = false;
                            mainMenu.menuBarCollection[1].menuitem[8].@enabled = false;
    
                            // update
                            canUpdate = writePermission && !isLocked;
                            mainMenu.menuBarCollection[1].menuitem[9].@enabled = canUpdate;
    
                            // make pdf, make flash, startworkflow    
                            mainMenu.menuBarCollection[3].menuitem[0].@enabled = false;
                            mainMenu.menuBarCollection[3].menuitem[1].@enabled = false;
                            mainMenu.menuBarCollection[3].menuitem[3].@enabled = false;  
                        }
                                              
                        break;     
                }                                                                                              
            }
        }
        
        /**
         * Enable / Disable menus after a version is selected in the version history panel
         *  
         * @param selectedItem node selected
         * 
         */
        protected function enableMenusAfterVersionSelection(selectedItem:Object):void
        {              
            if ((selectedItem != null) && (mainMenu.configurationDone == true))
            {
                var node:Node = selectedItem as Node;                

                var readPermission:Boolean = node.readPermission;                
                                
                // download, view, preview
                mainMenu.menuBarCollection[0].menuitem[4].@enabled = readPermission;
                mainMenu.menuBarCollection[0].menuitem[6].@enabled = readPermission;
                mainMenu.menuBarCollection[0].menuitem[7].@enabled = false;                                        

                if ( (browserView != null) && (browserView.versionListView != null) )
                {  
                    browserView.versionListView.enableContextMenuItem("view", readPermission, true);
                }  
                
                // cut, copy, paste, delete   
                mainMenu.menuBarCollection[1].menuitem[0].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[1].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[2].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[3].@enabled = false;
                this.cutBtn.enabled = false;
                this.copyBtn.enabled = false;
                this.pasteBtn.enabled = false;                    
                this.deleteBtn.enabled = false;

                // rename, properties, tags
                mainMenu.menuBarCollection[1].menuitem[11].@enabled = false;                        
                mainMenu.menuBarCollection[1].menuitem[12].@enabled = false;                        
                mainMenu.menuBarCollection[1].menuitem[13].@enabled = false;                        
                this.tagsBtn.enabled = false;            
                
                // checkin menus
                mainMenu.menuBarCollection[1].menuitem[5].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[6].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[7].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[8].@enabled = false;
                // make pdf, make flash, startworkflow    
                mainMenu.menuBarCollection[3].menuitem[0].@enabled = false;
                mainMenu.menuBarCollection[3].menuitem[1].@enabled = false;
                mainMenu.menuBarCollection[3].menuitem[3].@enabled = false;                        
            }
        }               
        
        /**
         * Enable / Disable menus after view switch with tabs
         *  
         * @param tabIndex index of tab switched to
         * 
         */
        protected function enableMenusAfterTabChange(tabIndex:int):void
        {
            if (mainMenu.configurationDone == true)
            {
                var createChildrenPermission:Boolean = false;                                       
                if ( (flexSpacesPresModel.currentNodeList != null) && (flexSpacesPresModel.currentNodeList is Folder))
                {
                    var folder:Folder = flexSpacesPresModel.currentNodeList as Folder;
                    var parentNode:Node = folder.folderNode;
                    if (parentNode != null)
                    {
                        createChildrenPermission = parentNode.createChildrenPermission;
                    }                
                }                
                var enablePaste:Boolean = createChildrenPermission && ((flexSpacesPresModel.cut != null) || (flexSpacesPresModel.copy != null));
    
                // initially disable menus requiring a selection
    
                // download, edit, view, preview
                mainMenu.menuBarCollection[0].menuitem[4].@enabled = false;
                mainMenu.menuBarCollection[0].menuitem[5].@enabled = false;
                mainMenu.menuBarCollection[0].menuitem[6].@enabled = false;
                mainMenu.menuBarCollection[0].menuitem[7].@enabled = false;
                // cut, copy, delete
                mainMenu.menuBarCollection[1].menuitem[0].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[1].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[3].@enabled = false;
                this.cutBtn.enabled = false;
                this.copyBtn.enabled = false;
                this.deleteBtn.enabled = false;
                
                // rename, properties, tags
                mainMenu.menuBarCollection[1].menuitem[11].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[12].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[13].@enabled = false;
                this.tagsBtn.enabled = false;                        
    
                // checkin menus, update
                mainMenu.menuBarCollection[1].menuitem[5].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[6].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[7].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[8].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[9].@enabled = false;
                
                // make pdf, make flash, startworkflow    
                mainMenu.menuBarCollection[3].menuitem[0].@enabled = false;
                mainMenu.menuBarCollection[3].menuitem[1].@enabled = false;
                mainMenu.menuBarCollection[3].menuitem[3].@enabled = false;
                
                // auto-tag, suggest tags
            	if (model.appConfig.airMode == false)
                {
	                mainMenu.menuBarCollection[3].menuitem[7].@enabled = false;                	
	                mainMenu.menuBarCollection[3].menuitem[8].@enabled = false;
				}
				else
				{
	                mainMenu.menuBarCollection[3].menuitem[10].@enabled = false;                	
	                mainMenu.menuBarCollection[3].menuitem[11].@enabled = false;							
				}                	
    
                switch(tabIndex)
                {
                    case DOC_LIB_TAB_INDEX:          
                        // create space, upload          
                        mainMenu.menuBarCollection[0].menuitem[0].@enabled = createChildrenPermission;
                        mainMenu.menuBarCollection[0].menuitem[3].@enabled = createChildrenPermission;  
                        this.createSpaceBtn.enabled = createChildrenPermission;
                        this.uploadFileBtn.enabled = createChildrenPermission;                                      
                        // paste
                        mainMenu.menuBarCollection[1].menuitem[2].@enabled = enablePaste;
                        this.pasteBtn.enabled = enablePaste;                    
                        // tree, dual panes, wcm tree, dual wcm panes
                        mainMenu.menuBarCollection[2].menuitem[0].@enabled = true;
                        // disable dual panes in cmis
                        if (model.appConfig.cmisMode == true)
                        {
                            mainMenu.menuBarCollection[2].menuitem[1].@enabled = false;                            
                        }
                        else
                        {
                            mainMenu.menuBarCollection[2].menuitem[1].@enabled = true;                            
                        }
                        mainMenu.menuBarCollection[2].menuitem[3].@enabled = false;
                        mainMenu.menuBarCollection[2].menuitem[4].@enabled = false;
                        break;                     
                    case CHECKED_OUT_TAB_INDEX:
                    case SEARCH_TAB_INDEX:
                    case TASKS_TAB_INDEX:
                        // create space, upload          
                        mainMenu.menuBarCollection[0].menuitem[0].@enabled = false;
                        mainMenu.menuBarCollection[0].menuitem[3].@enabled = false;
                        this.createSpaceBtn.enabled = false;
                        this.uploadFileBtn.enabled = false;
                        // paste
                        mainMenu.menuBarCollection[1].menuitem[2].@enabled = false;
                        this.pasteBtn.enabled = false;                    
                        // tree, dual panes, wcm tree, dual wcm panes
                        mainMenu.menuBarCollection[2].menuitem[0].@enabled = false;
                        mainMenu.menuBarCollection[2].menuitem[1].@enabled = false;
                        mainMenu.menuBarCollection[2].menuitem[3].@enabled = false;
                        mainMenu.menuBarCollection[2].menuitem[4].@enabled = false;
                        break;                
                    case WCM_TAB_INDEX:
                        // create folder, upload          
                        mainMenu.menuBarCollection[0].menuitem[0].@enabled = createChildrenPermission;
                        mainMenu.menuBarCollection[0].menuitem[3].@enabled = createChildrenPermission;
                        this.createSpaceBtn.enabled = createChildrenPermission;
                        this.uploadFileBtn.enabled = createChildrenPermission;
                        // paste
                        mainMenu.menuBarCollection[1].menuitem[2].@enabled = enablePaste;
                        this.pasteBtn.enabled = enablePaste;                    
                        // tree, dual panes, wcm tree, dual wcm panes
                        mainMenu.menuBarCollection[2].menuitem[0].@enabled = false;
                        mainMenu.menuBarCollection[2].menuitem[1].@enabled = false;
                        mainMenu.menuBarCollection[2].menuitem[3].@enabled = true;
                        mainMenu.menuBarCollection[2].menuitem[4].@enabled = true;
                        break;     
                }     
            }          
        } 
        
        //
        // Toolbar Button Handlers
        //
        
        /**
         * Handle cut toolbar button
         * 
         * @param event click event
         * 
         */
        protected function onCutBtn(event:MouseEvent):void
        {
            var selectedItems:Array = flexSpacesPresModel.selectedItems; 
            flexSpacesPresModel.cutNodes(selectedItems);            
        }               
                                       
        /**
         * Handle copy toolbar button
         * 
         * @param event click event
         * 
         */
        protected function onCopyBtn(event:MouseEvent):void
        {
            var selectedItems:Array = flexSpacesPresModel.selectedItems; 
            flexSpacesPresModel.copyNodes(selectedItems);                        
        }               
        
        /**
         * Handle paste toolbar button
         * 
         * @param event click event
         * 
         */
        protected function onPasteBtn(event:MouseEvent):void
        {
            flexSpacesPresModel.pasteNodes();                        
        }               
        
        /**
         * Handle delete toolbar button
         * 
         * @param event click event
         * 
         */
        protected function onDeleteBtn(event:MouseEvent):void
        {
            var selectedItems:Array = flexSpacesPresModel.selectedItems; 
            flexSpacesPresModel.deleteNodes(selectedItems, this);
        }               
        
        /**
         * Handle create space toolbar button
         * 
         * @param event click event
         * 
         */
        protected function onCreateSpaceBtn(event:MouseEvent):void
        {
            flexSpacesPresModel.createSpace(this);
        }               
        
        /**
         * Handle upload file toolbar button
         * 
         * @param event click event
         * 
         */
        protected function onUploadFileBtn(event:MouseEvent):void
        {
            flexSpacesPresModel.uploadFiles(this);   
        }               

        /**
         * Handle tags toolbar button
         * 
         * @param event click event
         * 
         */
        protected function onTagsBtn(event:MouseEvent):void
        {
            flexSpacesPresModel.tags(flexSpacesPresModel.selectedItem, this);
        }     
        
        /**
         *  DragDrop event handler for favorites as the drop target
         * 
         * @event folder view on drop event
         */         
        protected function onFavoritesOnDrop(event:FolderViewOnDropEvent):void
        {
            var items:Array = event.dragSource.dataForFormat("items");
            for each (var item:Object in items)
            {
                if (item is IRepoNode)
                {
                    flexSpacesPresModel.newFavorite(item);
                }
            }
        }                   

    }
}
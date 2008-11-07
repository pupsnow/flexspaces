package org.integratedsemantics.flexspaces.view
{
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;
    
    import flexlib.containers.SuperTabNavigator;
    import flexlib.controls.tabBarClasses.SuperTab;
    import flexlib.events.SuperTabEvent;
    
    import mx.containers.VBox;
    import mx.containers.ViewStack;
    import mx.events.FlexEvent;
    import mx.events.IndexChangedEvent;
    import mx.events.MenuEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.alfresco.framework.service.authentication.AuthenticationService;
    import org.alfresco.framework.service.error.ErrorRaisedEvent;
    import org.alfresco.framework.service.error.ErrorService;
    import org.alfresco.framework.service.webscript.ConfigCompleteEvent;
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.integratedsemantics.flexspaces.component.browser.RepoBrowserChangePathEvent;
    import org.integratedsemantics.flexspaces.component.browser.RepoBrowserPresenter;
    import org.integratedsemantics.flexspaces.component.browser.RepoBrowserViewBase;
    import org.integratedsemantics.flexspaces.component.error.ErrorDialogPresenter;
    import org.integratedsemantics.flexspaces.component.error.ErrorDialogView;
    import org.integratedsemantics.flexspaces.component.folderview.FolderViewBase;
    import org.integratedsemantics.flexspaces.component.folderview.FolderViewPresenter;
    import org.integratedsemantics.flexspaces.component.folderview.NodeListViewPresenter;
    import org.integratedsemantics.flexspaces.component.folderview.event.ClickNodeEvent;
    import org.integratedsemantics.flexspaces.component.folderview.event.DoubleClickDocEvent;
    import org.integratedsemantics.flexspaces.component.folderview.event.FolderViewContextMenuEvent;
    import org.integratedsemantics.flexspaces.component.folderview.event.FolderViewOnDropEvent;
    import org.integratedsemantics.flexspaces.component.login.LoginDoneEvent;
    import org.integratedsemantics.flexspaces.component.login.LoginPresenter;
    import org.integratedsemantics.flexspaces.component.login.LoginViewBase;
    import org.integratedsemantics.flexspaces.component.logout.LogoutDoneEvent;
    import org.integratedsemantics.flexspaces.component.logout.LogoutPresenter;
    import org.integratedsemantics.flexspaces.component.logout.LogoutViewBase;
    import org.integratedsemantics.flexspaces.component.menu.event.MenuConfiguredEvent;
    import org.integratedsemantics.flexspaces.component.menu.menubar.ConfigurableMenuBar;
    import org.integratedsemantics.flexspaces.component.playvideo.PlayVideoPresenter;
    import org.integratedsemantics.flexspaces.component.playvideo.PlayVideoView;
    import org.integratedsemantics.flexspaces.component.preview.PreviewPresenter;
    import org.integratedsemantics.flexspaces.component.preview.PreviewView;
    import org.integratedsemantics.flexspaces.component.search.advanced.AdvancedSearchEvent;
    import org.integratedsemantics.flexspaces.component.search.advanced.AdvancedSearchPresenter;
    import org.integratedsemantics.flexspaces.component.search.advanced.AdvancedSearchView;
    import org.integratedsemantics.flexspaces.component.search.basic.SearchPresenter;
    import org.integratedsemantics.flexspaces.component.search.basic.SearchViewBase;
    import org.integratedsemantics.flexspaces.component.search.event.SearchResultsEvent;
    import org.integratedsemantics.flexspaces.component.search.searchpanel.SearchPanelPresenter;
    import org.integratedsemantics.flexspaces.component.tasks.taskspanel.TasksPanelPresenter;
    import org.integratedsemantics.flexspaces.component.tasks.taskspanel.TasksPanelViewBase;
    import org.integratedsemantics.flexspaces.component.versions.versionlist.VersionListPresenter;
    import org.integratedsemantics.flexspaces.component.wcm.browser.WcmRepoBrowserPresenter;
    import org.integratedsemantics.flexspaces.control.event.CheckinEvent;
    import org.integratedsemantics.flexspaces.control.event.GetInfoEvent;
    import org.integratedsemantics.flexspaces.control.event.MakePdfEvent;
    import org.integratedsemantics.flexspaces.control.event.preview.MakePreviewEvent;
    import org.integratedsemantics.flexspaces.control.event.ui.*;
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.view.event.LoginViewCreatedEvent;
    import org.integratedsemantics.flexspaces.view.event.RepoBrowserCreatedEvent;


    /**
     * Presenter for FlexSpaces overall main view 
     * 
     * Supervising Presenter/Controller of FlexSpaceViewBase type views
     * 
     */
    public class FlexSpacesPresenter extends Presenter
    {
        // views, controls
        protected var mainMenu:ConfigurableMenuBar;
        protected var loginView:LoginViewBase;
        protected var logoutView:LogoutViewBase;       
        protected var searchView:SearchViewBase;  
        protected var viewStack:ViewStack;        
        protected var tabNav:SuperTabNavigator;
        protected var browserView:RepoBrowserViewBase;
        protected var searchResultsView:FolderViewBase;               
        protected var tasksPanelView:TasksPanelViewBase;        
        protected var wcmBrowserView:RepoBrowserViewBase;        
       
        // Cairngorm model locator                
        [Bindable] protected var model : AppModelLocator = AppModelLocator.getInstance();

        // presenters of views 
        protected var browserPresenter:RepoBrowserPresenter; 
        protected var searchPanelPresenter:SearchPanelPresenter;
        protected var tasksPanelPresenter:TasksPanelPresenter;               
        protected var wcmBrowserPresenter:WcmRepoBrowserPresenter;  

        // view modes
        protected static const GET_CONFIG_MODE_INDEX:int = 0;
        protected static const LOGIN_MODE_INDEX:int = 1;
        protected static const GET_INFO_MODE_INDEX:int = 2;
        protected static const MAIN_VIEW_MODE_INDEX:int = 3;

        // index of tabs for views
        protected static const DOC_LIB_TAB_INDEX:int = 0;
        protected static const SEARCH_TAB_INDEX:int = 1;
        protected static const TASKS_TAB_INDEX:int = 2;
        protected static const WCM_TAB_INDEX:int = 3;
     
        // advanced search dialog
        protected var advSearchView:AdvancedSearchView = null;
        protected var advSearchPresenter:AdvancedSearchPresenter = null; 
        
        // embedded mode when passed login ticket
        protected var embeddedMode:Boolean = false;
        
     
        /**
         * Constructor
         *  
         * @param mainView FlexSpacesView main view
         * 
         */
        public function FlexSpacesPresenter(mainView:FlexSpacesViewBase)
        {
            super(mainView);

            // Register interest in the error service events
            ErrorService.instance.addEventListener(ErrorRaisedEvent.ERROR_RAISED, onErrorRaised);            

            // make sure config service initialization is started soon so alfresco-config.xml loaded by
            // time first webscript is called
            var configService:ConfigService = ConfigService.instance;  
            
            configService.addEventListener(ConfigCompleteEvent.CONFIG_COMPLETE, onConfigComplete);
        }   
        
        /**
         * Getter for the view
         *  
         * @return view
         * 
         */
        protected function get mainView():FlexSpacesViewBase
        {
            return this.view as FlexSpacesViewBase;            
        }       

        /**
         * Handle alfresco-config.xml config read done
         *  
         * @param event config complete event
         * 
         */
        protected function onConfigComplete(event:Event):void
        {
            if (mainView.initialized == true)
            {
                onCreationComplete(new FlexEvent(""));
            }
            else
            {
                observeCreation(mainView, onCreationComplete);            
            }     
            
            if (model.isLiveCycleContentServices == true)
            {
            	model.showTasks = false;
            	model.showWCM = false;
            }       
        }
        
        /**
         * Handle creation complete of the main view
         *  
         * @param event on create complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
            this.viewStack = mainView.viewStack;   
            
            if ((model.loginTicket != null) && (model.loginTicket.length != 0))
            {
                embeddedMode = true;
                AuthenticationService.instance.ticket = model.loginTicket;                
                onLoginDone(new LoginDoneEvent(LoginDoneEvent.LOGIN_DONE));
            }
            else  
            {
                mainView.addEventListener(LoginViewCreatedEvent.CREATION_COMPLETE, onLoginViewCreated);            
                viewStack.selectedIndex = LOGIN_MODE_INDEX;         
            }              
            mainView.addEventListener(RepoBrowserCreatedEvent.CREATION_COMPLETE, onRepoBrowserCreated);            
        }        
        
        /**
         * Handle login view creation complete
         *  
         * @param event on create complete event
         * 
         */
        protected function onLoginViewCreated(event:LoginViewCreatedEvent):void
        {
            this.loginView = mainView.loginView;
            var loginPresenter:LoginPresenter = new LoginPresenter(loginView);
            loginView.addEventListener(LoginDoneEvent.LOGIN_DONE, onLoginDone);            
        }
        
        /**
         * Handle creation complete of repository browser after login
         *  
         * @param event on create complete event
         * 
         */
        protected function onRepoBrowserCreated(event:RepoBrowserCreatedEvent):void
        {            
            this.logoutView = mainView.logoutView;
            this.searchView = mainView.searchView;
            this.mainMenu = mainView.mainMenu;
            this.tabNav = mainView.tabNav;
            this.browserView = mainView.browserView;
            this.searchResultsView = mainView.searchPanel.searchResultsView;
            this.tasksPanelView = mainView.tasksPanelView;
            this.wcmBrowserView = mainView.wcmBrowserView;

            // init header section
            if (embeddedMode == true)
            {
                mainView.header.visible = false;
                mainView.header.includeInLayout = false;
            }
            else
            {
                if (model.showSearch == true)
                {
                    var searchPresenter:SearchPresenter = new SearchPresenter(searchView);
                    searchView.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);
                    searchView.addEventListener(AdvancedSearchEvent.ADVANCED_SEARCH_REQUEST, advancedSearch);   
                }    
                
                var logoutPresenter:LogoutPresenter = new LogoutPresenter(logoutView);
                logoutView.addEventListener(LogoutDoneEvent.LOGOUT_DONE, onLogoutDone);              
            }

            // init main menu
            mainMenu.addEventListener(MenuConfiguredEvent.MENU_CONFIGURED, onMainMenuConfigured);
            mainMenu.addEventListener(MenuEvent.ITEM_CLICK, menuHandler); 
                      
            // keyboard handlers
            mainView.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);  
            
            // init toolbar
            mainView.cutBtn.addEventListener(MouseEvent.CLICK, onCutBtn);
            mainView.copyBtn.addEventListener(MouseEvent.CLICK, onCopyBtn);
            mainView.pasteBtn.addEventListener(MouseEvent.CLICK, onPasteBtn);
            mainView.deleteBtn.addEventListener(MouseEvent.CLICK, onDeleteBtn);
            mainView.createSpaceBtn.addEventListener(MouseEvent.CLICK, onCreateSpaceBtn);
            mainView.uploadFileBtn.addEventListener(MouseEvent.CLICK, onUploadFileBtn);                    
            mainView.tagsBtn.addEventListener(MouseEvent.CLICK, onTagsBtn);     

            // init tab navigator
            tabNav.addEventListener(IndexChangedEvent.CHANGE, tabChange);   
            tabNav.popUpButtonPolicy = SuperTabNavigator.POPUPPOLICY_OFF;
            // prevent closing of doclib, search results, tasks, wcm tabs
            tabNav.setClosePolicyForTab(DOC_LIB_TAB_INDEX, SuperTab.CLOSE_NEVER);                    
            tabNav.setClosePolicyForTab(SEARCH_TAB_INDEX, SuperTab.CLOSE_NEVER);  
            tabNav.setClosePolicyForTab(TASKS_TAB_INDEX, SuperTab.CLOSE_NEVER);  
            tabNav.setClosePolicyForTab(WCM_TAB_INDEX, SuperTab.CLOSE_NEVER);  
            // todo: for now to avoid tab drag drop error in air app, disable drag/drop of tabs
            // due to bug in supertabnavigator
            tabNav.dragEnabled = false;
            tabNav.dropEnabled = false; 
            tabNav.addEventListener(SuperTabEvent.TAB_CLOSE, onTabClose);

            // init doclib view
            if (model.showDocLib == true)
            {
                this.browserPresenter = new RepoBrowserPresenter(browserView);
                this.browserPresenter.viewActive(true);
                browserPresenter.setContextMenuHandler(onContextMenu);
                browserPresenter.setOnDropHandler(onFolderViewOnDrop);
                browserPresenter.setDoubleClickDocHandler(onDoubleClickDoc);
                browserPresenter.setClickNodeHandler(onClickNode);                                    
                browserView.addEventListener(RepoBrowserChangePathEvent.REPO_BROWSER_CHANGE_PATH, onBrowserChangePath);
            }
            
            // init wcm view
            if (model.showWCM == true)
            {
                this.wcmBrowserPresenter = new WcmRepoBrowserPresenter(wcmBrowserView);            
                wcmBrowserPresenter.setContextMenuHandler(onContextMenu);
                wcmBrowserPresenter.setOnDropHandler(onFolderViewOnDrop);
                wcmBrowserPresenter.setDoubleClickDocHandler(onDoubleClickDoc);
                wcmBrowserPresenter.setClickNodeHandler(onClickNode);            
                wcmBrowserView.addEventListener(RepoBrowserChangePathEvent.REPO_BROWSER_CHANGE_PATH, onBrowserChangePath);
            }

            // init search view
            if (model.showSearch == true)
            {
                this.searchPanelPresenter = new SearchPanelPresenter(mainView.searchPanel);             
                searchResultsView.addEventListener(FolderViewContextMenuEvent.FOLDERLIST_CONTEXTMENU, onContextMenu);
                searchResultsView.addEventListener(DoubleClickDocEvent.DOUBLE_CLICK_DOC, onDoubleClickDoc);
                searchResultsView.addEventListener(ClickNodeEvent.CLICK_NODE, onClickNode);   
                                
                var searchView2:SearchViewBase = mainView.searchPanel.searchView2;
                var searchPresenter2:SearchPresenter = new SearchPresenter(searchView2);
                searchView2.addEventListener(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, onSearchResults);
                searchView2.addEventListener(AdvancedSearchEvent.ADVANCED_SEARCH_REQUEST, advancedSearch);
            }

            // init wcm view
            if (model.showTasks == true)
            {
                this.tasksPanelPresenter = new TasksPanelPresenter(tasksPanelView);                                                           
                tasksPanelPresenter.setContextMenuHandler(onContextMenu);
                tasksPanelPresenter.setDoubleClickDocHandler(onDoubleClickDoc);
                tasksPanelPresenter.setClickNodeHandler(onClickNode);                                    
            }
              
            // hide tabs for views not to show
            if (model.showDocLib == false)
            {
                tabNav.getTabAt(DOC_LIB_TAB_INDEX).visible = false;
                tabNav.getTabAt(DOC_LIB_TAB_INDEX).includeInLayout = false;
            }   
            if (model.showSearch == false)
            {
                tabNav.getTabAt(SEARCH_TAB_INDEX).visible = false;
                tabNav.getTabAt(SEARCH_TAB_INDEX).includeInLayout = false;
                searchView.visible = false;
                mainView.header.invalidateDisplayList();
            }   
            if (model.showTasks == false)
            {
                tabNav.getTabAt(TASKS_TAB_INDEX).visible = false;
                tabNav.getTabAt(TASKS_TAB_INDEX).includeInLayout = false;
            }   
            if (model.showWCM == false)
            {
                tabNav.getTabAt(WCM_TAB_INDEX).visible = false;
                tabNav.getTabAt(WCM_TAB_INDEX).includeInLayout = false;
            } 

            // select the first enabled main view tab
            var tabIndex:int = 0;
            if (model.showDocLib == true)
            {
                tabIndex = DOC_LIB_TAB_INDEX;
            }
            else if (model.showSearch == true)
            {
                tabIndex = SEARCH_TAB_INDEX;
            }
            else if (model.showTasks == true)
            {
                tabIndex = TASKS_TAB_INDEX;
            }
            else if (model.showWCM == true)
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
            mainMenu.menuBarCollection[3].menuitem[5].@enabled = model.showSearch;
            // disable show tree, show second folder if no doclib tab      
            mainMenu.menuBarCollection[2].menuitem[0].@enabled = model.showDocLib;
            mainMenu.menuBarCollection[2].menuitem[1].@enabled = model.showDocLib;
            // disable show wcm tree, show second wcm folder if no wcm tab                  
            mainMenu.menuBarCollection[2].menuitem[3].@enabled = model.showWCM;
            mainMenu.menuBarCollection[2].menuitem[4].@enabled = model.showWCM;

            // dissable thumbnails menu if not at least 3.0
            var version:Number = model.serverVersionNum();
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
            if (model.showDocLib == true)
            {
                tabIndex = DOC_LIB_TAB_INDEX;
            }
            else if (model.showSearch == true)
            {
                tabIndex = SEARCH_TAB_INDEX;
            }
            else if (model.showTasks == true)
            {
                tabIndex = TASKS_TAB_INDEX;
            }
            else if (model.showWCM == true)
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
                    model.wcmMode = false;
                    if (browserPresenter != null)
                    {
                    	browserPresenter.viewActive(true);
                    }
                    if (wcmBrowserPresenter != null)
                    {
                    	this.wcmBrowserPresenter.viewActive(false);
                    }
                }
                else if (event.newIndex == WCM_TAB_INDEX)
                { 
                    model.wcmMode = true;
                    if (browserPresenter != null)
                    {
                    	this.browserPresenter.viewActive(false);
                    }
                    if (wcmBrowserPresenter != null)
                    {
                    	this.wcmBrowserPresenter.viewActive(true);
                    }
                }       
                else if (event.newIndex == SEARCH_TAB_INDEX) 
                {
                    model.wcmMode = false;
                    model.currentNodeList = null;
                    searchPanelPresenter.refresh();
                    if (browserPresenter != null)
                    {
                    	this.browserPresenter.viewActive(false);
                    }
                    if (wcmBrowserPresenter != null)
                    {
                    	this.wcmBrowserPresenter.viewActive(false);
                    }
                }
                else if (event.newIndex == TASKS_TAB_INDEX) 
                {
                    model.wcmMode = false;
                    model.currentNodeList = null;
                    if (browserPresenter != null)
                    {
                    	this.browserPresenter.viewActive(false);
                    }
                    if (wcmBrowserPresenter != null)
                    {
                    	this.wcmBrowserPresenter.viewActive(false);
                    }
                }
                
                enableMenusAfterTabChange(event.newIndex);                
            }    
        }
            
        /**
         * Handler called when login is successfully completed
         * 
         * @param   event   login done event
         */
        protected function onLoginDone(event:LoginDoneEvent):void
        {
            viewStack.selectedIndex = GET_INFO_MODE_INDEX;  
       
            var responder:Responder = new Responder(onGetInfoDone, onFaultAction);
            var getInfoEvent:GetInfoEvent = new GetInfoEvent(GetInfoEvent.GET_INFO, responder);
            getInfoEvent.dispatch();                                
        }        

        /**
         * Handler called when get info is successfully completed
         * 
         * @param   event   get info event
         */
        protected function onGetInfoDone(info:Object):void
        {
            // Switch from get info to (main view in view stack 
            viewStack.selectedIndex = MAIN_VIEW_MODE_INDEX;         
        }

        /**
         * Handler called when logout is successfully completed
         * 
         * @param   event   logout done event
         */
        protected function onLogoutDone(event:LogoutDoneEvent):void
        {
            // Switch from view 1 (main view) back to view 0 (login) in view stack 
            viewStack.selectedIndex = LOGIN_MODE_INDEX;
            
            model.cut = null;
            model.copy = null;      
        }
        
        /**
         * Handler called when search results data is available
         * Switch to search results tab and update with results data
         * 
         * @param event search results event with results data
         */
        protected function onSearchResults(event:SearchResultsEvent):void
        {
            tabNav.selectedIndex = SEARCH_TAB_INDEX;
            this.searchPanelPresenter.initResultsData(event.searchResults);  
        }
        
        /**
         * Handler called when error is raised when making web script calls
         * 
         * @param event error raised vent
         */
        protected function onErrorRaised(event:ErrorRaisedEvent):void
        {
            if (event.errorType == ErrorService.APPLICATION_ERROR)
            {
                var msg:String = event.error.message;
                var errorDialogView:ErrorDialogView = new ErrorDialogView();
                var errorDialogPresenter:ErrorDialogPresenter = new ErrorDialogPresenter(errorDialogView, msg, event.error.getStackTrace() ); 
                PopUpManager.addPopUp(errorDialogView, mainView);                                
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
         * Display the containing folder for the selected item
         * (for items in task attachments and search results)
         * note: not for avm files
         *  
         * @param selectedItem selected node
         * 
         */
        protected function gotoParentFolder(selectedItem:Object):void
        {
            if (selectedItem != null)
            {            
                // set the path of the  tree and left pane 
                this.browserPresenter.setPath(selectedItem.parentPath);
            
                // switch to the doc lib tab 
                tabNav.selectedIndex = DOC_LIB_TAB_INDEX;
            }
        }

        /**
         * Handle double click on a document/file node in a folder view by viewing it
         *  
         * @param event double doc event
         * 
         */
        protected function onDoubleClickDoc(event:DoubleClickDocEvent):void
        {
            model.selectedItem = event.doubleClickedItem;
            
            viewNode(event.doubleClickedItem); 
        }        

        /**
         * Handle click on doc/folder node in a folder view by updating selection information kept
         *  
         * @param event click node event
         * 
         */
        protected function onClickNode(event:ClickNodeEvent):void
        {
            model.selectedItem = event.clickedItem;
            
            if (event.folderViewPresenter != null)
            {
                if ( (event.folderViewPresenter is VersionListPresenter) == true )
                {
                	var versionListPresenter:VersionListPresenter = event.folderViewPresenter as VersionListPresenter;                 	
	                model.currentNodeList = versionListPresenter.nodeCollection;
	                model.selectedItems = versionListPresenter.getSelectedItems();
	                clearOtherSelections(versionListPresenter);                         	

		            enableMenusAfterTabChange(tabNav.selectedIndex);
		            enableMenusAfterVersionSelection(model.selectedItem);                	
                }
                else if ( (event.folderViewPresenter is NodeListViewPresenter) == true )
                {
                	var nodeListPresenter:NodeListViewPresenter = event.folderViewPresenter as NodeListViewPresenter;                 	
	                model.currentNodeList = nodeListPresenter.nodeCollection;
	                model.selectedItems = nodeListPresenter.getSelectedItems();
	                clearOtherSelections(nodeListPresenter);                         	

	                // init version list when a main folder view node is selected
	                if ( (model.wcmMode == false) && (browserPresenter != null) )
	                {
                		browserPresenter.initVersionList(model.selectedItem);
	                }
                	
		            enableMenusAfterTabChange(tabNav.selectedIndex);
		            enableMenusAfterSelection(model.selectedItem);                	
                }
            }            
        }        

        /**
         * Clear selections in all folder views 
         * 
         */
        protected function clearSelection():void
        {
            model.clearSelection(); 
            if (browserPresenter != null)
            {  
                browserPresenter.clearSelection();
            }
            if (searchPanelPresenter != null)
            {  
                searchPanelPresenter.clearSelection();
            }
            if (tasksPanelPresenter != null)
            {  
                tasksPanelPresenter.clearSelection();
            }
            if (wcmBrowserPresenter != null)
            {  
                wcmBrowserPresenter.clearSelection();
            }
        }

        /**
         * Clear selections in folder views other than the current/selected folder view
         *  
         * @param selectedFolderView current/selected folder ivew
         * 
         */
        protected function clearOtherSelections(selectedFolderView:Presenter):void
        {
            if (browserPresenter != null)
            {  
                browserPresenter.clearOtherSelections(selectedFolderView);
            }            
            if (searchPanelPresenter != null)
            {  
                searchPanelPresenter.clearOtherSelections(selectedFolderView);
            }
            if (tasksPanelPresenter != null)
            {  
                tasksPanelPresenter.clearOtherSelections(selectedFolderView);
            }
            if (wcmBrowserPresenter != null)
            {  
                wcmBrowserPresenter.clearOtherSelections(selectedFolderView);
            }
        }
                
        /**
         * Redraw folder views after menu operations
         *  
         */
        protected function redraw():void
        {
            var tabIndex:int = tabNav.selectedIndex;
            if (tabIndex == DOC_LIB_TAB_INDEX)
            {
                browserPresenter.redraw();
            }
            else if (tabIndex == WCM_TAB_INDEX)
            { 
                wcmBrowserPresenter.redraw();
            }       
            else if (tabIndex == SEARCH_TAB_INDEX) 
            {
                // todo searchPanelPresenter.searchResultsPresenter.redraw();
            }
            else if (tabIndex == TASKS_TAB_INDEX) 
            {
                //todo tasksPanelPresenter.taskAttachmentsPresenter.redraw();
            }
        }

        /**
         * Handler for good result from cairngorm event/cmd
         *  
         * @param info result info
         * 
         */
        protected function onResultAction(info:Object):void
        {
            redraw();      
        }
                
        /**
         * Handler for error from cairngorm event/cmd
         *  
         * @param info fault info
         * 
         */
        protected function onFaultAction(info:Object):void
        {
            trace("onFaultAction " + info);     
        }        

        /**
         * Handler for good result from cairngorm checkout event/cmd
         * for edit, now kickoff download of working copy
         * 
         * @param info result info
         * 
         */
        protected function onResultCheckoutForEdit(info:Object):void
        {
            redraw(); 
            
            var result:XML = info as XML;
            var workingCopy:Node = new Node();
            
            workingCopy.name = result.workingCopy.name;
            workingCopy.nodeRef = result.workingCopy.noderef;
            workingCopy.id = result.workingCopy.id;
            workingCopy.viewurl = result.workingCopy.viewurl;
            
            downloadFile(workingCopy);                  
        }

        //
        // Menu Handlers
        //    

        /**
         * Display UI for renaming a doc/folder node
         *  
         * @param selectedItem selected node
         * 
         */
        protected function rename(selectedItem:Object):void
        {
            var event:RenameNodeUIEvent = new RenameNodeUIEvent(RenameNodeUIEvent.RENAME_NODE_UI, null, selectedItem, mainView, redraw);
            event.dispatch();                                
        }
        
        /**
         * Display properties UI for a doc/folder node
         *  
         * @param selectedItem selected node
         * 
         */
        protected function properties(selectedItem:Object):void
        {
            var event:PropertiesUIEvent = new PropertiesUIEvent(PropertiesUIEvent.PROPERTIES_UI, null, selectedItem, mainView, redraw);
            event.dispatch();                                                
        }

        /**
         * Display UI for editing tags in a doc/folder node
         *  
         * @param selectedItem selected node
         * 
         */
        protected function tags(selectedItem:Object):void
        {
            var event:TagsCategoriesUIEvent = new TagsCategoriesUIEvent(TagsCategoriesUIEvent.TAGS_CATEGORIES_UI, null, selectedItem, mainView, redraw);
            event.dispatch();                                
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
                if (model.wcmMode == false)
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
                    var previewPresenter:PreviewPresenter = new PreviewPresenter(previewView, selectedItem as IRepoNode);
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
         *  View a document node in a separate window
         *  
         * @param selectedItem selected node
         * 
         */
        protected function viewNode(selectedItem:Object):void
        {
            var event:ViewNodeUIEvent = new ViewNodeUIEvent(ViewNodeUIEvent.VIEW_NODE, null, selectedItem);
            event.dispatch();                    
        }
                
        /**
         * Play video
         *  
         * @param selectedItem selected node
         * 
         */
        protected function playVideo(selectedItem:Object):void
        {
            if (selectedItem != null && selectedItem.isFolder == false)
            {
                if (model.wcmMode == false)
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
                    var presenter:PlayVideoPresenter = new PlayVideoPresenter(view, selectedItem as Node);
                    view.percentWidth = 100;
                    view.percentHeight = 100;
                    tab.addChild(view);
                }
            }            
        }

        /**
         *  Edit a document node (checkout, then download
         *  
         * @param selectedItem selected node
         * 
         */
        protected function editNode(selectedItem:Object):void
        {
            if (selectedItem != null)
            {
                if (selectedItem.isFolder != true)
                {   
                    // checkout, then will kickoff download of working copy in result handler
                    var responder:Responder = new Responder(onResultCheckoutForEdit, onFaultAction);
                    var checkinEvent:CheckinEvent = new CheckinEvent(CheckinEvent.CHECKOUT, responder, selectedItem as IRepoNode);
                    checkinEvent.dispatch();                    
                }
            }
        }

        /**
         * Cut selected node items to internal clipboard (not removed (moved) until paste)
         *  
         * @param selectedItems selected nodes
         * 
         */
        protected function cutNodes(selectedItems:Array):void
        {
            var event:ClipboardUIEvent = new ClipboardUIEvent(ClipboardUIEvent.CLIPBOARD_CUT, null, selectedItems);
            event.dispatch();    
            
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
        protected function copyNodes(selectedItems:Array):void
        {
            var event:ClipboardUIEvent = new ClipboardUIEvent(ClipboardUIEvent.CLIPBOARD_COPY, null, selectedItems);
            event.dispatch();                                            

            // enable paste menu                                        
            var tabIndex:int = tabNav.selectedIndex;
            if ((tabIndex == DOC_LIB_TAB_INDEX) || (tabIndex == WCM_TAB_INDEX))
            {
                mainMenu.menuBarCollection[1].menuitem[2].@enabled = true;                    
            }                                                    
        }

        /**
         * Paste node items from internal clipboard
         * 
         */
        protected function pasteNodes():void
        {
            var responder:Responder = new Responder(onResultAction, onFaultAction);
            var event:ClipboardUIEvent = new ClipboardUIEvent(ClipboardUIEvent.CLIPBOARD_PASTE, responder, null);
            event.dispatch();                 
        }

        /**
         * Display UI for creating a space/folder 
         * 
         */
        protected function createSpace():void
        {            
            if (model.currentNodeList is Folder)
            {
                var folder:Folder = model.currentNodeList as Folder; 
                var parentNode:IRepoNode = folder.folderNode;
                var event:CreateSpaceUIEvent = new CreateSpaceUIEvent(CreateSpaceUIEvent.CREATE_SPACE_UI, null, parentNode, mainView, redraw);
                event.dispatch();            
            }                                                                                
        }
        
        /**
         * Display UI for confirming deletion of selected nodes
         *   
         * @param selectedItems selected nodes
         * 
         */
        protected function deleteNodes(selectedItems:Array):void
        {
            var event:DeleteNodesUIEvent = new DeleteNodesUIEvent(DeleteNodesUIEvent.DELETE_NODES_UI, null, selectedItems, mainView, redraw);
            event.dispatch();                                                            
        }

        /**
         * Checkin the selected node
         *  
         * @param selectedItem selected node
         * 
         * 
         */
        protected function checkin(selectedItem:Object):void
        {
            if (selectedItem != null)
            {
                if (selectedItem.isFolder != true)
                {
                    var responder:Responder = new Responder(onResultAction, onFaultAction);
                    var checkinEvent:CheckinEvent = new CheckinEvent(CheckinEvent.CHECKIN, responder, selectedItem as IRepoNode);
                    checkinEvent.dispatch();                    
                }
            }
        }
        
        /**
         * Checkout the selected node
         *  
         * @param selectedItem selected node
         * 
         */
        protected function checkout(selectedItem:Object):void
        {
            if (selectedItem != null)
            {
                if (selectedItem.isFolder != true)
                {
                    var responder:Responder = new Responder(onResultAction, onFaultAction);
                    var checkinEvent:CheckinEvent = new CheckinEvent(CheckinEvent.CHECKOUT, responder, selectedItem as IRepoNode);
                    checkinEvent.dispatch();                    
                }
            }
        }
        
        /**
         * Cancel the checkout of the selected node
         *  
         * @param selectedItem selected node
         * 
         */
        protected function cancelCheckout(selectedItem:Object):void
        {
            if (selectedItem != null)
            {
                if (selectedItem.isFolder != true)
                {
                    var responder:Responder = new Responder(onResultAction, onFaultAction);
                    var checkinEvent:CheckinEvent = new CheckinEvent(CheckinEvent.CANCEL_CHECKOUT, responder, selectedItem as IRepoNode);
                    checkinEvent.dispatch();                    
                }
            }                        
        }
        
        /**
         * Make the selected node versionable
         *  
         * @param selectedItem selected node
         * 
         */
        protected function makeVersionable(selectedItem:Object):void
        {
            if (selectedItem != null)
            {
                if (selectedItem.isFolder != true)
                {
                    var responder:Responder = new Responder(onResultAction, onFaultAction);
                    var checkinEvent:CheckinEvent = new CheckinEvent(CheckinEvent.MAKE_VERSIONABLE, responder, selectedItem as IRepoNode);
                    checkinEvent.dispatch();                    
                }
            }
        }
        
        /**
         * Display the Start Workflow UI for starting a workflow on the selected node
         *  
         * @param selectedItem selected node
         * 
         */
        protected function startWorkflow(selectedItem:Object):void
        {
            var event:StartWorkflowUIEvent = new StartWorkflowUIEvent(StartWorkflowUIEvent.START_WORKFLOW_UI, null, selectedItem, mainView, startWorkflowComplete);
            event.dispatch();                                            
        }
        
        /**
         * Refresh the task list after a new task has been added by start workflow 
         * 
         */
        protected function startWorkflowComplete():void
        {
            if (tasksPanelPresenter != null)
            {  
                tasksPanelPresenter.refreshTaskList();
            }
        }

        /**
         * Make PDF transform versions of the selected document nodes
         *  
         * @param selectedItems selected nodes
         * 
         */
        protected function makePDFs(selectedItems:Array):void
        {
            if (selectedItems != null && selectedItems.length > 0)
            {
                for each (var selectedItem:Object in selectedItems)
                {
                    if (selectedItem != null && selectedItem.isFolder != true)
                    {
                        var responder:Responder = new Responder(onResultAction, onFaultAction);
                        var makePdfEvent:MakePdfEvent = new MakePdfEvent(MakePdfEvent.MAKE_PDF, responder, selectedItem as IRepoNode);
                        makePdfEvent.dispatch();                    
                    }
                }                   
            }            
        }

        /**
         * Make Flash preview transform versions of the selected document nodes
         *  
         * @param selectedItems selected nodes
         * 
         */
        protected function makeFlashPreviews(selectedItems:Array):void
        {
            if (model.currentNodeList is Folder)
            {
                var folder:Folder = model.currentNodeList as Folder;
                
                if (selectedItems != null && selectedItems.length > 0)
                {
                    var parentNode:IRepoNode = folder.folderNode;
                    for each (var selectedItem:Object in selectedItems)
                    {
                        if (selectedItem != null && selectedItem.isFolder != true)
                        {
                            var responder:Responder = new Responder(onResultAction, onFaultAction);
                            var makePreviewEvent:MakePreviewEvent = new MakePreviewEvent(MakePreviewEvent.MAKE_PREVIEW, responder, 
                                                                                         selectedItem as IRepoNode, parentNode);
                            makePreviewEvent.dispatch();                    
                        }
                    }                   
                }            
            }                                                                                            
        }

        /**
         * Display the Advanced Search UI
         *  
         * @param event called with event when "advanced" link clicked on, null if from menu
         * 
         */
        protected function advancedSearch(event:Event=null):void
        {
            if (advSearchView == null)
            {
                advSearchView = new AdvancedSearchView();
                advSearchPresenter = new AdvancedSearchPresenter(advSearchView, advancedSearchResultsAvailable); 
            }

            PopUpManager.addPopUp(advSearchView, mainView);                
        }

        /**
         * Handle results are available from advanced search
         *  
         * @param data search results
         * 
         */
        protected function advancedSearchResultsAvailable(data:Object):void
        {
            var searchResultsEvent:SearchResultsEvent = new SearchResultsEvent(SearchResultsEvent.SEARCH_RESULTS_AVAILABLE, data);
            this.onSearchResults(searchResultsEvent);                   
        }

        /**
         * Display multiple file upload dialog and upload files 
         * to the current folder in the current folder view 
         * 
         */
        protected function uploadFiles():void
        {
            if (model.currentNodeList is Folder)
            {
                var folder:Folder = model.currentNodeList as Folder;
                var parentNode:IRepoNode = folder.folderNode;
    
                var responder:Responder = new Responder(onResultAction, onFaultAction);
                var event:UploadFilesUIEvent = new UploadFilesUIEvent(UploadFilesUIEvent.UPLOAD_FILES_UI, responder, parentNode, mainView);
                event.dispatch();
            }                    
        }
        
        /**
         * Display single file upload dialog and update selected node with new content
         * 
         * @param selectedItem selected node
         * 
         */
        protected function updateNode(selectedItem:Object):void
        {
            var responder:Responder = new Responder(onResultAction, onFaultAction);
            var event:UpdateNodeUIEvent = new UpdateNodeUIEvent(UpdateNodeUIEvent.UPDATE_NODE_UI, responder, selectedItem as IRepoNode, mainView);
            event.dispatch();
        }

        /**
         * Download the selected document node (single selection)
         * A file location dialog will be displayed to choose the local location
         *  
         * @param selectedItem selected node
         * 
         */
        protected function downloadFile(selectedItem:Object):void
        {
            var event:DownloadUIEvent = new DownloadUIEvent(DownloadUIEvent.DOWNLOAD_UI, null, selectedItem, mainView, false);
            event.dispatch();                    
        }

        /**
         * Toggle whether the adm repository tree is displayed 
         * 
         */
        protected function showHideRepoTree():void
        {
            browserPresenter.showHideRepoTree();
            tabNav.invalidateDisplayList();
        }

        /**
         * Toggle whether the second adm folder pane is displayed 
         * 
         */
        protected function showHideSecondRepoFolder():void
        {
            browserPresenter.showHideSecondRepoFolder();
            tabNav.invalidateDisplayList();
        }
        
        /**
         * Toggle whether the avm repository tree is displayed 
         * 
         */
        protected function showHideWcmRepoTree():void
        {
            wcmBrowserPresenter.showHideRepoTree();
            tabNav.invalidateDisplayList();
        }

        /**
         * Toggle whether the second avm folder pane is displayed 
         * 
         */
        protected function showHideWcmSecondRepoFolder():void
        {
            wcmBrowserPresenter.showHideSecondRepoFolder();
            tabNav.invalidateDisplayList();
        }   
        
        /**
         * Toggle show / hide of thumbnails  
         * (icons shown when thumbnails hidden)
         * 
         */
        public function showHideThumbnails():void
        {
            if (browserPresenter != null)
            {  
                browserPresenter.showHideThumbnails();
            }
            if (searchPanelPresenter != null)
            {  
                searchPanelPresenter.showHideThumbnails();
            }
            if (tasksPanelPresenter != null)
            {  
                tasksPanelPresenter.taskAttachmentsPresenter.showHideThumbnails();
            }
            if (wcmBrowserPresenter != null)
            {  
                wcmBrowserPresenter.showHideThumbnails();
            }            
            
            tabNav.invalidateDisplayList();
        }     


        /**
         * Toggle show / hide of version history list panel
         * 
         */
        public function showHideVersionHistory():void
        {
            if (browserPresenter != null)
            {  
                browserPresenter.showHideVersionHistory();
            }

            if (wcmBrowserPresenter != null)
            {  
                // todo wcmBrowserPresenter.showHideVersionHistory();
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
            var selectedItem:Object = model.selectedItem;   
            var selectedItems:Array = model.selectedItems; 
            
            switch(data)
            {
                case "preview":
                    previewNode(selectedItem);
                    break;                     
                case 'view':
                   viewNode(selectedItem);
                   break;
                case 'edit':
                   editNode(selectedItem);
                   break;
                case 'cut':
                   cutNodes(selectedItems);
                   break;
                case 'copy':
                   copyNodes(selectedItems);
                   break;
                case 'paste':
                   pasteNodes();
                   break;
                case 'newspace':
                    createSpace();
                    break;
                case 'upload':
                    uploadFiles();
                    break;
                case 'download':
                    downloadFile(selectedItem);
                    break;
                case 'rename':
                    rename(selectedItem);
                    break;
                case 'properties':
                    properties(selectedItem);
                    break;
                case 'tags':
                    tags(selectedItem);
                    break;
                case 'delete':
                    deleteNodes(selectedItems);
                    break;
                case 'checkin':
                    checkin(selectedItem);
                    break;
                case 'checkout':
                    checkout(selectedItem);
                    break;
                case 'cancelcheckout':
                    cancelCheckout(selectedItem);
                    break;
                case 'makeversion':
                    makeVersionable(selectedItem);
                    break;
                case 'update':
                    updateNode(selectedItem);
                    break;
                case 'startworkflow':
                    startWorkflow(selectedItem);
                    break;
                case 'makepdf':
                    makePDFs(selectedItems);
                    break;
                case "makepreview":
                    makeFlashPreviews(selectedItems);
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
                this.deleteNodes(model.selectedItems);
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
            var targetFolderList:FolderViewPresenter = event.targetFolderList;
            var source:Array = event.dragSource.dataForFormat("items");
            onDropItems(targetFolderList, event.dragAction, source);
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
        protected function onDropItems(targetFolderList:FolderViewPresenter, action:String, items:Array):void
        {    
            var folderNode:IRepoNode = targetFolderList.currentFolderNode;
            var responder:Responder = new Responder(onResultAction, onFaultAction);
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
                if ( (model.currentNodeList != null) && (model.currentNodeList is Folder))
                {
                    var folder:Folder = model.currentNodeList as Folder;
                    var parentNode:Node = folder.folderNode;
                    if (parentNode != null)
                    {
                        createChildrenPermission = parentNode.createChildrenPermission;
                    }                
                }                
                var enablePaste:Boolean = createChildrenPermission && ((model.cut != null) || (model.copy != null));
                
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
                    if (browserPresenter != null)
                    {  
                        browserPresenter.enableContextMenuItem("view", readPermission, fileContextMenu);
                    }  
                    if (wcmBrowserPresenter != null)
                    {  
                        wcmBrowserPresenter.enableContextMenuItem("view", readPermission, fileContextMenu);
                    } 
                    if (searchPanelPresenter != null)
                    {  
                        searchPanelPresenter.searchResultsPresenter.enableContextMenuItem("view", readPermission, fileContextMenu);
                    }
                    if (tasksPanelPresenter != null)
                    {  
                        tasksPanelPresenter.taskAttachmentsPresenter.enableContextMenuItem("view", readPermission, fileContextMenu);
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
                        mainView.cutBtn.enabled = deletePermission;
                        mainView.copyBtn.enabled = readPermission;
                        mainView.pasteBtn.enabled = enablePaste;                    
                        mainView.deleteBtn.enabled = deletePermission;
                        browserPresenter.enableContextMenuItem("cut", deletePermission, fileContextMenu);  
                        browserPresenter.enableContextMenuItem("copy", readPermission, fileContextMenu);  
                        browserPresenter.enableContextMenuItem("paste", enablePaste, fileContextMenu);  
                        browserPresenter.enableContextMenuItem("delete", deletePermission, fileContextMenu);  

                        // rename, properties, tags
                        mainMenu.menuBarCollection[1].menuitem[11].@enabled = writePermission;                        
                        mainMenu.menuBarCollection[1].menuitem[12].@enabled = readPermission;                        
                        mainMenu.menuBarCollection[1].menuitem[13].@enabled = readPermission;    
                        mainView.tagsBtn.enabled = readPermission;                        
                        browserPresenter.enableContextMenuItem("rename", writePermission, fileContextMenu);  
                        browserPresenter.enableContextMenuItem("properties", readPermission, fileContextMenu);  
                        browserPresenter.enableContextMenuItem("tags", readPermission, fileContextMenu);
                                                                    
                        if (selectedItem.isFolder != true)
                        {                            
                            // checkin
                            var canCheckin:Boolean = writePermission && isWorkingCopy;
                            mainMenu.menuBarCollection[1].menuitem[5].@enabled = canCheckin;
                            browserPresenter.enableContextMenuItem("checkin", canCheckin, fileContextMenu);  
                            
                            // checkout, edit
                            var canCheckout:Boolean = writePermission && !isLocked && !isWorkingCopy;
                            mainMenu.menuBarCollection[1].menuitem[6].@enabled = canCheckout;
                            mainMenu.menuBarCollection[0].menuitem[5].@enabled = canCheckout;
                            browserPresenter.enableContextMenuItem("checkout", canCheckout, fileContextMenu);  
                            
                            // cancel checkout
                            var canCancelCheckout:Boolean = writePermission && isWorkingCopy;
                            mainMenu.menuBarCollection[1].menuitem[7].@enabled = canCancelCheckout;
                            browserPresenter.enableContextMenuItem("cancelcheckout", canCancelCheckout, fileContextMenu);  
                            
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
                        }
                        break;        
                                     
                    case SEARCH_TAB_INDEX:
                    case TASKS_TAB_INDEX:
                        // cut, copy, paste, delete   
                        mainMenu.menuBarCollection[1].menuitem[0].@enabled = false;
                        mainMenu.menuBarCollection[1].menuitem[1].@enabled = readPermission;
                        mainMenu.menuBarCollection[1].menuitem[2].@enabled = false;
                        mainMenu.menuBarCollection[1].menuitem[3].@enabled = false;
                        mainView.cutBtn.enabled = false;
                        mainView.copyBtn.enabled = readPermission;
                        mainView.pasteBtn.enabled = false;                    
                        mainView.deleteBtn.enabled = false;
                        if (searchPanelPresenter != null)
                        {
                            searchPanelPresenter.searchResultsPresenter.enableContextMenuItem("copy", readPermission, fileContextMenu);
                        }  
                        if (tasksPanelPresenter != null)
                        {
                            tasksPanelPresenter.taskAttachmentsPresenter.enableContextMenuItem("copy", readPermission, fileContextMenu);
                        }  

                        // rename, properties, tags
                        mainMenu.menuBarCollection[1].menuitem[11].@enabled = writePermission;                        
                        mainMenu.menuBarCollection[1].menuitem[12].@enabled = readPermission;                        
                        mainMenu.menuBarCollection[1].menuitem[13].@enabled = readPermission;                        
                        mainView.tagsBtn.enabled = readPermission;            
                        
                        if (searchPanelPresenter != null)
                        {
                            searchPanelPresenter.searchResultsPresenter.enableContextMenuItem("rename", writePermission, fileContextMenu);
                            searchPanelPresenter.searchResultsPresenter.enableContextMenuItem("properties", readPermission, fileContextMenu);
                            searchPanelPresenter.searchResultsPresenter.enableContextMenuItem("tags", readPermission, fileContextMenu);
                            searchPanelPresenter.searchResultsPresenter.enableContextMenuItem( "gotoParent", model.showDocLib, fileContextMenu);
                        }        
                        if (tasksPanelPresenter != null)
                        {
                            tasksPanelPresenter.taskAttachmentsPresenter.enableContextMenuItem("rename", writePermission, fileContextMenu);
                            tasksPanelPresenter.taskAttachmentsPresenter.enableContextMenuItem("properties", readPermission, fileContextMenu);
                            tasksPanelPresenter.taskAttachmentsPresenter.enableContextMenuItem("tags", readPermission, fileContextMenu);
                            tasksPanelPresenter.taskAttachmentsPresenter.enableContextMenuItem( "gotoParent", model.showDocLib, fileContextMenu);
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
                        mainView.cutBtn.enabled = deletePermission;
                        mainView.copyBtn.enabled = readPermission;
                        mainView.pasteBtn.enabled = enablePaste;                    
                        mainView.deleteBtn.enabled = deletePermission;
                        wcmBrowserPresenter.enableContextMenuItem("cut", deletePermission, fileContextMenu);  
                        wcmBrowserPresenter.enableContextMenuItem("copy", readPermission, fileContextMenu);  
                        wcmBrowserPresenter.enableContextMenuItem("paste", enablePaste, fileContextMenu);  
                        wcmBrowserPresenter.enableContextMenuItem("delete", deletePermission, fileContextMenu);  

                        // rename, properties
                        mainMenu.menuBarCollection[1].menuitem[11].@enabled = writePermission;                        
                        mainMenu.menuBarCollection[1].menuitem[12].@enabled = readPermission;                        
                        wcmBrowserPresenter.enableContextMenuItem("rename", writePermission, fileContextMenu);  
                        wcmBrowserPresenter.enableContextMenuItem("properties", readPermission, fileContextMenu);  

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

                if ( (browserPresenter != null) && (browserPresenter.versionListPresenter != null) )
                {  
                    browserPresenter.versionListPresenter.enableContextMenuItem("view", readPermission, true);
                }  
                
                // cut, copy, paste, delete   
                mainMenu.menuBarCollection[1].menuitem[0].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[1].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[2].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[3].@enabled = false;
                mainView.cutBtn.enabled = false;
                mainView.copyBtn.enabled = false;
                mainView.pasteBtn.enabled = false;                    
                mainView.deleteBtn.enabled = false;

                // rename, properties, tags
                mainMenu.menuBarCollection[1].menuitem[11].@enabled = false;                        
                mainMenu.menuBarCollection[1].menuitem[12].@enabled = false;                        
                mainMenu.menuBarCollection[1].menuitem[13].@enabled = false;                        
                mainView.tagsBtn.enabled = false;            
                
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
                if ( (model.currentNodeList != null) && (model.currentNodeList is Folder))
                {
                    var folder:Folder = model.currentNodeList as Folder;
                    var parentNode:Node = folder.folderNode;
                    if (parentNode != null)
                    {
                        createChildrenPermission = parentNode.createChildrenPermission;
                    }                
                }                
                var enablePaste:Boolean = createChildrenPermission && ((model.cut != null) || (model.copy != null));
    
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
                mainView.cutBtn.enabled = false;
                mainView.copyBtn.enabled = false;
                mainView.deleteBtn.enabled = false;
                
                // rename, properties, tags
                mainMenu.menuBarCollection[1].menuitem[11].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[12].@enabled = false;
                mainMenu.menuBarCollection[1].menuitem[13].@enabled = false;
                mainView.tagsBtn.enabled = false;                        
    
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
    
                switch(tabIndex)
                {
                    case DOC_LIB_TAB_INDEX:          
                        // create space, upload          
                        mainMenu.menuBarCollection[0].menuitem[0].@enabled = createChildrenPermission;
                        mainMenu.menuBarCollection[0].menuitem[3].@enabled = createChildrenPermission;  
                        mainView.createSpaceBtn.enabled = createChildrenPermission;
                        mainView.uploadFileBtn.enabled = createChildrenPermission;                                      
                        // paste
                        mainMenu.menuBarCollection[1].menuitem[2].@enabled = enablePaste;
                        mainView.pasteBtn.enabled = enablePaste;                    
                        // tree, dual panes, wcm tree, dual wcm panes
                        mainMenu.menuBarCollection[2].menuitem[0].@enabled = true;
                        mainMenu.menuBarCollection[2].menuitem[1].@enabled = true;
                        mainMenu.menuBarCollection[2].menuitem[3].@enabled = false;
                        mainMenu.menuBarCollection[2].menuitem[4].@enabled = false;
                        break;                     
                    case SEARCH_TAB_INDEX:
                    case TASKS_TAB_INDEX:
                        // create space, upload          
                        mainMenu.menuBarCollection[0].menuitem[0].@enabled = false;
                        mainMenu.menuBarCollection[0].menuitem[3].@enabled = false;
                        mainView.createSpaceBtn.enabled = false;
                        mainView.uploadFileBtn.enabled = false;
                        // paste
                        mainMenu.menuBarCollection[1].menuitem[2].@enabled = false;
                        mainView.pasteBtn.enabled = false;                    
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
                        mainView.createSpaceBtn.enabled = createChildrenPermission;
                        mainView.uploadFileBtn.enabled = createChildrenPermission;
                        // paste
                        mainMenu.menuBarCollection[1].menuitem[2].@enabled = enablePaste;
                        mainView.pasteBtn.enabled = enablePaste;                    
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
            var selectedItems:Array = model.selectedItems; 
            cutNodes(selectedItems);            
        }               
                                       
        /**
         * Handle copy toolbar button
         * 
         * @param event click event
         * 
         */
        protected function onCopyBtn(event:MouseEvent):void
        {
            var selectedItems:Array = model.selectedItems; 
            copyNodes(selectedItems);                        
        }               
        
        /**
         * Handle paste toolbar button
         * 
         * @param event click event
         * 
         */
        protected function onPasteBtn(event:MouseEvent):void
        {
            pasteNodes();                        
        }               
        
        /**
         * Handle delete toolbar button
         * 
         * @param event click event
         * 
         */
        protected function onDeleteBtn(event:MouseEvent):void
        {
            var selectedItems:Array = model.selectedItems; 
            deleteNodes(selectedItems);
        }               
        
        /**
         * Handle create space toolbar button
         * 
         * @param event click event
         * 
         */
        protected function onCreateSpaceBtn(event:MouseEvent):void
        {
            createSpace();
        }               
        
        /**
         * Handle upload file toolbar button
         * 
         * @param event click event
         * 
         */
        protected function onUploadFileBtn(event:MouseEvent):void
        {
            uploadFiles();   
        }               

        /**
         * Handle tags toolbar button
         * 
         * @param event click event
         * 
         */
        protected function onTagsBtn(event:MouseEvent):void
        {
            tags(model.selectedItem);
        }               
    }
}


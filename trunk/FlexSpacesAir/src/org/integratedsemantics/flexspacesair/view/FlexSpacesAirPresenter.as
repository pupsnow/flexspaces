package org.integratedsemantics.flexspacesair.view
{
    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;
    import flash.desktop.NativeDragActions;
    import flash.desktop.NativeDragManager;
    import flash.events.Event;
    import flash.events.NativeDragEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    import flexlib.controls.tabBarClasses.SuperTab;
    
    import mx.containers.VBox;
    import mx.managers.DragManager;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.alfresco.framework.service.webscript.ConfigService;
    import org.integratedsemantics.flexspaces.component.folderview.FolderView;
    import org.integratedsemantics.flexspaces.component.folderview.FolderViewPresenter;
    import org.integratedsemantics.flexspaces.component.menu.event.MenuConfiguredEvent;
    import org.integratedsemantics.flexspaces.component.upload.UploadStatusPresenter;
    import org.integratedsemantics.flexspaces.component.upload.UploadStatusView;
    import org.integratedsemantics.flexspaces.control.event.ui.*;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.view.FlexSpacesPresenter;
    import org.integratedsemantics.flexspaces.view.FlexSpacesViewBase;
    import org.integratedsemantics.flexspaces.view.event.RepoBrowserCreatedEvent;
    import org.integratedsemantics.flexspacesair.component.ajaxwebscript.AjaxWebScriptPresenter;
    import org.integratedsemantics.flexspacesair.component.ajaxwebscript.AjaxWebScriptView;
    import org.integratedsemantics.flexspacesair.component.browser.Browser;
    import org.integratedsemantics.flexspacesair.component.create.html.CreateHtmlPresenter;
    import org.integratedsemantics.flexspacesair.component.create.html.CreateHtmlView;
    import org.integratedsemantics.flexspacesair.component.create.text.CreateTextPresenter;
    import org.integratedsemantics.flexspacesair.component.create.text.CreateTextView;
    import org.integratedsemantics.flexspacesair.component.create.xml.CreateXmlPresenter;
    import org.integratedsemantics.flexspacesair.component.create.xml.CreateXmlView;
    import org.integratedsemantics.flexspacesair.component.localfiles.LocalFilesBrowserPresenter;
    import org.integratedsemantics.flexspacesair.component.localfiles.LocalFilesBrowserView;
    import org.integratedsemantics.flexspacesair.control.command.UploadAir;
    import org.integratedsemantics.flexspacesair.control.event.*;
    import org.integratedsemantics.flexspacesair.util.AirOfflineUtil;


    /**
     * Presenter for FlexSpacesAir overall main view 
     * 
     * Supervising Presenter/Controller of FlexSpaceViewBase type views
     * 
     */
    public class FlexSpacesAirPresenter extends FlexSpacesPresenter
    {
        // local files browser
        protected var localFilesView:LocalFilesBrowserView;
        
        // ajax web script ui example
        protected var ajaxWebScriptView:AjaxWebScriptView;
        
        // create html content dialog (keep after first use to avoid recreation errors with
        // tinymce and webkit html air control)
        protected var createHtmlView:CreateHtmlView;
        protected var createHtmlPresenter:CreateHtmlPresenter;

        protected var shareTabIndex:int = -1;
        
                
        /**
         * Constructor 
         * 
         * @mainView view to control
         */
        public function FlexSpacesAirPresenter(mainView:FlexSpacesViewBase)
        {
            super(mainView);
        }
        
        /**
         * Handle creation complete with doc library 
         * 
         */
        override protected function onRepoBrowserCreated(event:RepoBrowserCreatedEvent):void
        {      
            super.onRepoBrowserCreated(event);
            
            // swap in different menu for FlexSpacesAir
            mainMenu.configPath = model.srcPath + "config/menubar/mainMenuAir.xml";
            mainMenu.addEventListener(MenuConfiguredEvent.MENU_CONFIGURED, onMenuConfigured);
            mainMenu.load();
                                                
            //Native Drag-and-drop listeners
            
            if (model.showDocLib == true)
            {
                var folderView1:FolderView = browserPresenter.folderViewPresenter1.getView() as FolderView;
                folderView1.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragIn1);
                folderView1.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER,onDragOver);
                folderView1.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop1);
    
                var folderView2:FolderView = browserPresenter.folderViewPresenter2.getView() as FolderView;
                folderView2.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragIn2);
                folderView2.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER,onDragOver);
                folderView2.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop2);           
            }

            if (model.showWCM == true)
            {
                var wcmFolderView1:FolderView = wcmBrowserPresenter.folderViewPresenter1.getView() as FolderView;
                wcmFolderView1.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onWcmDragIn1);
                wcmFolderView1.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER,onDragOver);
                wcmFolderView1.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onWcmDrop1);
                
                var wcmFolderView2:FolderView = wcmBrowserPresenter.folderViewPresenter2.getView() as FolderView;
                wcmFolderView2.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onWcmDragIn2);
                wcmFolderView2.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER,onDragOver);
                wcmFolderView2.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onWcmDrop2);
            }           
                        
            // tab for share 3.0
            if ((model.serverVersionNum() >= 3.0) && (model.showShare == true))
            {
                // add tab after other tabs
                this.shareTabIndex = tabNav.numChildren;
                var tab:VBox = new VBox();
                tab.percentHeight = 100;
                tab.percentWidth = 100;
                tab.label = "Share";
                tab.id = "ShareTab";
                tab.setStyle("backgroundColor", 0x000000);
                tabNav.addChild(tab); 
                tabNav.setClosePolicyForTab(shareTabIndex, SuperTab.CLOSE_NEVER);                        
                        
                // setup tab to dislay share
                var browser:Browser = new Browser();
                browser.percentWidth = 100;
                browser.percentHeight = 100;
                var urlBegin:String;
                urlBegin = ConfigService.instance.protocol + "://" + ConfigService.instance.domain + ":" + ConfigService.instance.port + "/share/";
                browser.location = urlBegin + "login?username=" + model.loginUserName + "&password=" + model.loginPassword + "&success=" + urlBegin + "&failure=" + urlBegin;
                tab.addChild(browser);
                browser.visible = true;
                browser.includeInLayout = true;
                tab.invalidateDisplayList();
            }                                   
        }

        /**
         * After menu bar is configured,  init state of menus beyond what is in config file 
         * 
         * @param event menu configured event
         * 
         */
        protected function onMenuConfigured(event:Event):void
        {
            // enable paste right away if user has copied files to native external clipboard
            // before starting flexspacesair
            var enablePaste:Boolean = formatToPaste();
            mainMenu.menuBarCollection[1].menuitem[2].@enabled = enablePaste;
            mainView.pasteBtn.enabled = enablePaste;                    

            // TODO: also need to add check for formatToPaste when switching/activating the flexpacesair window 
            // for now have to switch tabs or select nodes for the paste menu enabling to be updated            
        }        
        
        
        //
        // Native Clipboard Handling
        //
        
        /**
         * Cut selected node items to internal clipboard (not removed (moved) until paste)
         * Override to add flexspaces format flag to native clipboard
         *  
         * @param selectedItems selected nodes
         * 
         */
        override protected function cutNodes(selectedItems:Array):void
        {
            var event:AirClipboardUIEvent = new AirClipboardUIEvent(AirClipboardUIEvent.AIR_CLIPBOARD_CUT, null, mainView, selectedItems);
            event.dispatch();                                            
        }
        
        /**
         * Copy selected node items to internal clipboard
         * Override to add flexspaces format flag to native clipboard
         *  
         * @param selectedItems selected nodes
         * 
         */
        override protected function copyNodes(selectedItems:Array):void
        {
            var event:AirClipboardUIEvent = new AirClipboardUIEvent(AirClipboardUIEvent.AIR_CLIPBOARD_COPY, null, mainView, selectedItems);
            event.dispatch();                                            
        }        
            
        /**
         * Paste node items from internal clipboard 
         * or files from native clipboard
         * 
         */
        override protected function pasteNodes():void
        {
            var responder:Responder = new Responder(onResultAction, onFaultAction);
            var event:AirClipboardUIEvent = new AirClipboardUIEvent(AirClipboardUIEvent.AIR_CLIPBOARD_PASTE, responder, mainView, null, redraw);
            event.dispatch();                                            
        }

        
        //
        // AIR View Doc (Automatic Make Available Offline, Webkit tab)
        //

        /**
         * View a document node  in tab if webkit html browser supports
         * format, otherwise view in separate window
         * 
         * Currently this downloads local copy first, thus doing
         * an automatic make available offline for viewed files
         *  
         * @param selectedItem selected node
         * 
         */
        override protected function viewNode(selectedItem:Object):void
        {           
            var event:AirViewNodeUIEvent = new AirViewNodeUIEvent(AirViewNodeUIEvent.AIR_VIEW_NODE, null, selectedItem, tabNav);
            event.dispatch();                                                                     
        }
        
        
        //
        // Native Drag Drop
        //                

        /**
         * Native drag in event handler for folder list 1
         * 
         * @param event native drag event
         * 
         */
        protected function onDragIn1(event:NativeDragEvent):void
        {
            onDragIn(event, browserPresenter.folderViewPresenter1);    
        }
                
        /**
         * Native drag in event handler for folder list 2
         * 
         * @param event native drag event
         * 
         */
        protected function onDragIn2(event:NativeDragEvent):void
        {
            onDragIn(event, browserPresenter.folderViewPresenter2);    
        }

        /**
         * Native drag in event handler for wcm folder list 1
         * 
         * @param event native drag event
         * 
         */
        protected function onWcmDragIn1(event:NativeDragEvent):void
        {
            onDragIn(event, wcmBrowserPresenter.folderViewPresenter1);    
        }
                
        /**
         * Native drag in event handler for wcm folder list 2
         * 
         * @param event native drag event
         * 
         */
        protected function onWcmDragIn2(event:NativeDragEvent):void
        {
            onDragIn(event, wcmBrowserPresenter.folderViewPresenter2);    
        }

       /**
        * On drag-in, check the data formats. If it is a supported format,
        * tell the Native Drag Manager that the component can take the drop.
        * 
        * @param event native drag event
        * @param targetFolderList target folder view presenter
        * 
        */  
        protected function onDragIn(event:NativeDragEvent, targetFolderList:FolderViewPresenter):void
        {
            //trace("Drag enter event.");
            var transferable:Clipboard = event.clipboard;
                        
            if (transferable.hasFormat(ClipboardFormats.FILE_LIST_FORMAT) ||
                transferable.hasFormat("items") )
            {
                NativeDragManager.acceptDragDrop(targetFolderList.getView() as FolderView );
                NativeDragManager.dropAction = NativeDragActions.COPY
            } 
            else 
            {
                //trace("Unrecognized format");
            }     
        }        
        
        /**
         * Native drag over event
         * 
         * @param event native drag event
         */
        protected function onDragOver(event:NativeDragEvent):void
        {
            if (event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT) ||
                event.clipboard.hasFormat("items"))
            {
                if (event.shiftKey == true)
                {
                    NativeDragManager.dropAction = NativeDragActions.MOVE;
                } 
                else 
                {
                    NativeDragManager.dropAction = NativeDragActions.COPY;
                }  
            }
        }
      
        /**
         * Native on drop event handler for folder list 1 
         * 
         * @param event native drag event
         * 
         */
        protected function onDrop1(event:NativeDragEvent):void
        {
            onDrop(event, browserPresenter.folderViewPresenter1);
        }
        
        /**
         * Native on drop event handler for folder list 2 
         * 
         * @param event native drag event
         * 
         */
        protected function onDrop2(event:NativeDragEvent):void
        {
            onDrop(event, browserPresenter.folderViewPresenter2);
        }

        /**
         * Native on drop event handler for wcm folder list 1 
         * 
         * @param event native drag event
         * 
         */
        protected function onWcmDrop1(event:NativeDragEvent):void
        {
            onDrop(event, wcmBrowserPresenter.folderViewPresenter1);
        }
        
        /**
         * Native on drop event handler for wcm folder list 2 
         * 
         * @param event native drag event
         * 
         */
        protected function onWcmDrop2(event:NativeDragEvent):void
        {
            onDrop(event, wcmBrowserPresenter.folderViewPresenter2);
        }

        /**
         * Handler for onDrop event
         * 
         * @param event native drag event
         * @param targetFolderList target folder view presenter
         */
        protected function onDrop(event:NativeDragEvent, targetFolderList:FolderViewPresenter):void
        {
            //trace("Drag drop event.");
            var data:Clipboard = event.clipboard;
            if (data.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
            {
                var dropfiles:Array = data.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
                
                var uploadStatusView:UploadStatusView = UploadStatusView(PopUpManager.createPopUp(mainView, UploadStatusView, false));
                var uploadStatusPresenter:UploadStatusPresenter = new UploadStatusPresenter(uploadStatusView, dropfiles);
                
                for each (var file:File in dropfiles)
                {
                    var uploadAir:UploadAir = new UploadAir(uploadStatusPresenter);
                    uploadAir.uploadAir(file, targetFolderList.currentFolderNode, redraw);
                }
            }
            else if (data.hasFormat("items"))
            {
                var action:String = DragManager.COPY;
                if (event.shiftKey == true)
                {
                    action = DragManager.MOVE;
                }          
                
                var dropItems:Array = data.getData("items") as Array;
                onDropItems(targetFolderList, action, dropItems);
            }
        }
              
        /**
         * Handle dropping internal node items or 
         * external files from desktop into flexspacesair 
         *  
         * @param targetFolderList target folder view presenter
         * @param action move ar copy 
         * @param items items to drop
         * 
         */
        override protected function onDropItems(targetFolderList:FolderViewPresenter, action:String, items:Array):void
        {    
            for each (var item:Object in items)
            {
                if (item is File)
                {
                    var file:File = item as File;
                    var uploadAir:UploadAir = new UploadAir();
                    uploadAir.uploadAir(file, targetFolderList.currentFolderNode, redraw);
                }
                else if (item is Node)
                {
                    var items2:Array = new Array;
                    items2.push(item);
                    super.onDropItems(targetFolderList, action, items2);                    
                }            
            }
        }

        // 
        // Menu Handlers
        //                
        
        /**
         * Switch on menu data to method for both main menu bar
         * and context menus
         *  
         * @param data menu command
         * 
         */
        override protected function handleBothKindsOfMenus(data:String):void
        {    
            switch(data)
            {
                case "webscriptui":
                    showHideWebScriptAjaxUI();
                    break;
                case "localfiles":
                    showHideLocalFilesBrowser();
                    break;                    
                case "availoffline":
                    makeAvailOffline();
                    break; 
                case "offlineupload":
                    offlineUpload(false);
                    break;    
                case "offlinecheckin":
                    offlineUpload(true);
                    break;    
                case "createtext":
                    createText();
                    break;
                case "createxml":
                    createXML();
                    break;                        
                case "createhtml":
                    createHTML();
                    break;   
                default:
                    super.handleBothKindsOfMenus(data);
                    break;
            }              
        } 
        
        /**
         * Toggle showing web script / ajax UI example pane 
         * 
         */
        protected function showHideWebScriptAjaxUI():void
        {
            if ( (ajaxWebScriptView != null) && (ajaxWebScriptView.visible == true) )
            {
                ajaxWebScriptView.visible = false;
                ajaxWebScriptView.includeInLayout = false;
                mainView.flexspacesviews.percentHeight = 100;
            }    
            else
            {
                if (ajaxWebScriptView == null)
                {
                    this.ajaxWebScriptView = new AjaxWebScriptView();
                    ajaxWebScriptView.percentWidth = 100;
                    ajaxWebScriptView.percentHeight = 30;
                    mainView.addChild(ajaxWebScriptView);
                    var ajaxWebScriptPresenter:AjaxWebScriptPresenter = new AjaxWebScriptPresenter(ajaxWebScriptView);                    
                }
                ajaxWebScriptView.visible = true;
                ajaxWebScriptView.includeInLayout = true;
                mainView.flexspacesviews.percentHeight = 70;
                ajaxWebScriptView.percentHeight = 30;            
            }
            mainView.invalidateDisplayList();
        }

        /**
         * Toggle showing local files browser pane 
         * 
         */
        protected function showHideLocalFilesBrowser():void
        {
            if ( (localFilesView != null) && (localFilesView.visible == true) )
            {
                localFilesView.visible = false;
                localFilesView.includeInLayout = false;
                mainView.flexspacesviews.percentHeight = 100;
            }    
            else
            {
                if (localFilesView == null)
                {
                    this.localFilesView = new LocalFilesBrowserView();
                    localFilesView.percentWidth = 100;
                    localFilesView.percentHeight = 20;
                    mainView.addChild(localFilesView);
                    var localFilesPresenter:LocalFilesBrowserPresenter = new LocalFilesBrowserPresenter(localFilesView);                         
                }
                localFilesView.visible = true;
                localFilesView.includeInLayout = true;
                mainView.flexspacesviews.percentHeight = 80;
                localFilesView.percentHeight = 20;            
            }
            mainView.invalidateDisplayList();
        }
        

        //
        // Make Available Offline support
        //                
        
        /**
         * Make multiple selection of files and folders available offline
         * 
         * Note: selected folders themselves are made offline, not their contents
         *  
         * Nodes are made available offline by downloading them without a download dialog
         * to the flexpaces area in documents folder within folders mirroring the
         * repository folder / filenames. 
         * 
         */
        protected function makeAvailOffline():void
        {
            var selectedItems:Array = model.selectedItems;  

            var event:AirMakeAvailOfflineUIEvent = new AirMakeAvailOfflineUIEvent(AirMakeAvailOfflineUIEvent.AIR_MAKE_AVAIL_OFFLINE, null, selectedItems, mainView);
            event.dispatch();                                                                    
        }
        

        //
        // Offline Upload: without browse dialog to existing repository doc
        //

        /**
         * Upload file (without file chooser dialog) from standard local flexspaces documents area
         * in local folder path / file name mirroring repository path / filename into an existing
         * document in the repository
         *  
         * @param checkin whether to checkin also
         * 
         */
        protected function offlineUpload(checkin:Boolean):void
        {
            var selectedItem:Object = model.selectedItem;
            var event:AirOfflineUploadUIEvent = new AirOfflineUploadUIEvent(AirOfflineUploadUIEvent.AIR_OFFLINE_UPLOAD, null, selectedItem, checkin, mainView, redraw);
            event.dispatch();                                                                    
        }
        
        //
        // Special AIR handling for Download File
        //
        
        /**
         * Download a selected document to local system with a download dialog
         * Overriden to pass air mode flag to  download ui command event
         * 
         * @param selectedItem selected node item
         *  
         */
        override protected function downloadFile(selectedItem:Object):void
        {
            var event:DownloadUIEvent = new DownloadUIEvent(DownloadUIEvent.DOWNLOAD_UI, null, selectedItem, mainView, true);
            event.dispatch();                    
        }                
        
        //
        // Create  HTML, XML, Text Content Dialogs
        //
        
        /**
         * Display the create text content dialog 
         * 
         */
        protected function createText():void
        {
            var createTextView:CreateTextView = CreateTextView(PopUpManager.createPopUp(mainView, CreateTextView, false));
            var createTextPresenter:CreateTextPresenter = new CreateTextPresenter(createTextView, createContentDialogComplete);
        }
        
        /**
         * Display the create xml content dialog 
         * 
         */
        protected function createXML():void
        {
            var createXmlView:CreateXmlView = CreateXmlView(PopUpManager.createPopUp(mainView, CreateXmlView, false));
            var createXmlPresenter:CreateXmlPresenter = new CreateXmlPresenter(createXmlView, createContentDialogComplete);
        }
        
        /**
         * Display the create html content dialog 
         * Note: dialog is saved and reused after first time to avoid recreation problems with tinymce files
         * 
         */
        protected function createHTML():void
        {
            if (this.createHtmlView == null)
            {
                createHtmlView = CreateHtmlView(PopUpManager.createPopUp(mainView, CreateHtmlView, false));
                createHtmlPresenter = new CreateHtmlPresenter(createHtmlView, createContentDialogComplete);
            }   
            else
            {
               PopUpManager.addPopUp(createHtmlView, mainView);
               createHtmlPresenter.setContent("");
            }
        }

        /**
         * On ok from create content dialogs, upload local file with content to a new 
         * document in repository
         *  
         * @param filename filename chosen for file
         * @param content content for file
         * 
         */
        protected function createContentDialogComplete(filename:String, content:String):void
        {
            if (model.currentNodeList is Folder)
            {
                var folder:Folder = model.currentNodeList as Folder;
                var parentNode:IRepoNode = folder.folderNode;
            
                var localDir:File = AirOfflineUtil.makeOfflineDirForPath(folder.currentPath);
                var file:File = localDir.resolvePath(filename);
                var stream:FileStream = new FileStream();
                stream.open(file, FileMode.WRITE);
                stream.writeUTFBytes(content);
                stream.close();
                var uploadAir:UploadAir = new UploadAir();
                uploadAir.uploadAir(file, parentNode, redraw);
            }
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
        override protected function enableMenusAfterSelection(selectedItem:Object):void
        {     
            super.enableMenusAfterSelection(selectedItem);
                     
            var tabIndex:int = tabNav.selectedIndex;
            
            if ((selectedItem != null) && (mainMenu.configurationDone == true))
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
                var enablePaste:Boolean = createChildrenPermission && formatToPaste();
            
                var node:Node = selectedItem as Node;                
                var readPermission:Boolean = node.readPermission;                
                var writePermission:Boolean = node.writePermission;                
                var deletePermission:Boolean = node.deletePermission;                                

                // view specific         
                switch(tabIndex)
                {
                    case DOC_LIB_TAB_INDEX:  
                        // paste                        
                        mainMenu.menuBarCollection[1].menuitem[2].@enabled = enablePaste;
                        browserPresenter.enableContextMenuItem("paste", enablePaste, true);  
                        mainView.pasteBtn.enabled = enablePaste;                    
                        // make avail offline, offline upload
                        mainMenu.menuBarCollection[3].menuitem[7].@enabled = readPermission;
                        mainMenu.menuBarCollection[3].menuitem[8].@enabled = writePermission;                         
                        break;                     
                    case SEARCH_TAB_INDEX:
                    case TASKS_TAB_INDEX:
                        // make avail offline, offline upload
                        mainMenu.menuBarCollection[3].menuitem[7].@enabled = false;
                        mainMenu.menuBarCollection[3].menuitem[8].@enabled = false;                         
                        break;                
                    case WCM_TAB_INDEX:
                        // paste
                        mainMenu.menuBarCollection[1].menuitem[2].@enabled = enablePaste;
                        wcmBrowserPresenter.enableContextMenuItem("paste", enablePaste, true);  
                        mainView.pasteBtn.enabled = enablePaste;                    
                        // make avail offline, offline upload
                        mainMenu.menuBarCollection[3].menuitem[7].@enabled = readPermission;
                        mainMenu.menuBarCollection[3].menuitem[8].@enabled = writePermission;                         
                        break;     
                }                                                                                              
            }
        }
        
        /**
         * Enable / Disable menus after view switch with tabs
         *  
         * @param tabIndex index of tab switched to
         * 
         */
        override protected function enableMenusAfterTabChange(tabIndex:int):void
        {
            super.enableMenusAfterTabChange(tabIndex);
            
            if (mainMenu.configurationDone == true)
            {
                // make avail offline, offline upload
                mainMenu.menuBarCollection[3].menuitem[7].@enabled = false;
                mainMenu.menuBarCollection[3].menuitem[8].@enabled = false;
    
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
                var enablePaste:Boolean = createChildrenPermission && formatToPaste();
    
                switch(tabIndex)
                {
                    case DOC_LIB_TAB_INDEX:
                        // create content          
                        mainMenu.menuBarCollection[0].menuitem[1].@enabled = createChildrenPermission;
                        // paste
                        mainMenu.menuBarCollection[1].menuitem[2].@enabled = enablePaste;
                        browserPresenter.enableContextMenuItem("paste", enablePaste, true);  
                        mainView.pasteBtn.enabled = enablePaste;                    
                        break;                     
                    case SEARCH_TAB_INDEX:
                    case TASKS_TAB_INDEX:
                        // create content          
                        mainMenu.menuBarCollection[0].menuitem[1].@enabled = false;
                        break;                
                    case WCM_TAB_INDEX:
                        // create content          
                        mainMenu.menuBarCollection[0].menuitem[1].@enabled = false;
                        // paste
                        mainMenu.menuBarCollection[1].menuitem[2].@enabled = enablePaste;
                        wcmBrowserPresenter.enableContextMenuItem("paste", enablePaste, true);  
                        mainView.pasteBtn.enabled = enablePaste;                    
                        break;  
                    case this.shareTabIndex:
                        // create content          
                        mainMenu.menuBarCollection[0].menuitem[1].@enabled = false;
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
                }   
            }            
        }                
        
        /**
         * Determine if there is something that can be pasted into flexspacesair
         * Either node items on the internal clipboard or files on the native
         * external clipboard
         * 
         * @return true if have a format to paste 
         * 
         */
        protected function formatToPaste():Boolean
        {
            var data:Clipboard = Clipboard.generalClipboard;
            if ( data.hasFormat(ClipboardFormats.FILE_LIST_FORMAT) || data.hasFormat(AppModelLocator.FLEXSPACES_FORMAT) )
            {
                return true;
            }                
            else 
            {
                return false;
            }           
        }        

    }       
}

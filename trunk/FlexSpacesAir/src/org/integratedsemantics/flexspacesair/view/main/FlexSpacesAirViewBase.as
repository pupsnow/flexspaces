package org.integratedsemantics.flexspacesair.view.main
{
    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;
    import flash.desktop.NativeDragActions;
    import flash.desktop.NativeDragManager;
    import flash.events.MouseEvent;
    import flash.events.NativeDragEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    import flexlib.controls.tabBarClasses.SuperTab;
    
    import mx.containers.VBox;
    import mx.controls.Button;
    import mx.events.FlexEvent;
    import mx.managers.DragManager;
    import mx.managers.PopUpManager;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.ui.*;
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.presmodel.folderview.FolderViewPresModel;
    import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
    import org.integratedsemantics.flexspaces.presmodel.upload.UploadStatusPresModel;
    import org.integratedsemantics.flexspaces.view.folderview.FolderViewBase;
    import org.integratedsemantics.flexspaces.view.main.FlexSpacesViewBase;
    import org.integratedsemantics.flexspaces.view.menu.event.MenuConfiguredEvent;
    import org.integratedsemantics.flexspaces.view.upload.UploadStatusView;
    import org.integratedsemantics.flexspacesair.control.command.UploadAir;
    import org.integratedsemantics.flexspacesair.control.event.*;
    import org.integratedsemantics.flexspacesair.presmodel.create.CreateHtmlPresModel;
    import org.integratedsemantics.flexspacesair.presmodel.create.CreateTextPresModel;
    import org.integratedsemantics.flexspacesair.presmodel.create.CreateXmlPresModel;
    import org.integratedsemantics.flexspacesair.presmodel.localfiles.LocalFilesBrowserPresModel;
    import org.integratedsemantics.flexspacesair.util.AirOfflineUtil;
    import org.integratedsemantics.flexspacesair.view.browser.Browser;
    import org.integratedsemantics.flexspacesair.view.create.html.CreateHtmlView;
    import org.integratedsemantics.flexspacesair.view.create.text.CreateTextView;
    import org.integratedsemantics.flexspacesair.view.create.xml.CreateXmlView;
    import org.integratedsemantics.flexspacesair.view.localfiles.LocalFilesBrowserView;


    /**
     * Base for FlexSpacesAir overall main view 
     * 
     */
    public class FlexSpacesAirViewBase extends FlexSpacesViewBase
    {
        // local files browser
        protected var localFilesView:LocalFilesBrowserView;
        
        // create html content dialog (keep after first use to avoid recreation errors with
        // tinymce and webkit html air control)
        protected var createHtmlView:CreateHtmlView;
        protected var createHtmlPresModel:CreateHtmlPresModel;

        protected var shareTabIndex:int = -1;
        
               
        /**
         * Constructor 
         * 
         */
        public function FlexSpacesAirViewBase()
        {
            super();
        }
        
		[Bindable]
        public function get flexSpacesAirPresModel():FlexSpacesPresModel
        {
        	return this.flexSpacesPresModel as FlexSpacesPresModel;
        }

    	public function set flexSpacesAirPresModel(flexSpacesAirPresModel:FlexSpacesPresModel):void
        {
            this.flexSpacesPresModel = flexSpacesAirPresModel;            
        }               
        
        /**
         * Handle creation complete with doc library 
         * 
         */
        override protected function onRepoBrowserCreated(event:FlexEvent):void
        {      
            super.onRepoBrowserCreated(event);
            
            //Native Drag-and-drop listeners
            
            if ( (flexSpacesAirPresModel.showDocLib == true) && (browserView != null) )
            {
                var folderView1:FolderViewBase = browserView.fileView1;                
                folderView1.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragIn1);
                folderView1.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER,onDragOver);
                folderView1.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop1);
    
                var folderView2:FolderViewBase = browserView.fileView2;        
                if (folderView2 != null)
                {                        
                    folderView2.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragIn2);
                    folderView2.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER,onDragOver);
                    folderView2.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop2);
                }           
            }

            if ( (flexSpacesAirPresModel.showWCM == true) && (wcmBrowserView != null) )
            {
                var wcmFolderView1:FolderViewBase = wcmBrowserView.fileView1;                
                wcmFolderView1.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onWcmDragIn1);
                wcmFolderView1.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER,onDragOver);
                wcmFolderView1.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onWcmDrop1);
                
                var wcmFolderView2:FolderViewBase = wcmBrowserView.fileView2;                
                if (wcmFolderView2 != null)
                {                        
                    wcmFolderView2.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onWcmDragIn2);
                    wcmFolderView2.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER,onDragOver);
                    wcmFolderView2.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onWcmDrop2);
                }
            }           
                        
            // tab for share 3.0
            if ((model.ecmServerConfig.serverVersionNum() >= 3.0) && (flexSpacesAirPresModel.showShare == true))
            {
                // add tab after other tabs
                var tab:VBox = new VBox();
                tab.percentHeight = 100;
                tab.percentWidth = 100;
                tab.label = "Share";
                tab.id = "shareTab";
                tab.setStyle("backgroundColor", 0x000000);
                tabNav.addChild(tab); 
                this.shareTabIndex = tabNav.getChildIndex(tab);
                tabNav.setClosePolicyForTab(shareTabIndex, SuperTab.CLOSE_NEVER);                        
                        
                // setup tab to dislay share
                var browser:Browser = new Browser();
                browser.percentWidth = 100;
                browser.percentHeight = 100;
                var urlBegin:String;
                urlBegin = model.ecmServerConfig.protocol + "://" + model.ecmServerConfig.domain + ":" + model.ecmServerConfig.port + "/share/";
                browser.location = urlBegin + "login?username=" + model.userInfo.loginUserName + "&password=" + model.userInfo.loginPassword + "&success=" + urlBegin + "&failure=" + urlBegin;
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
        override protected function onMainMenuConfigured(event:MenuConfiguredEvent):void
        {
        	super.onMainMenuConfigured(event);
        	
            // enable paste right away if user has copied files to native external clipboard
            // before starting flexspacesair
            var enablePaste:Boolean = formatToPaste();
            mainMenu.enableMenuItem("edit", "paste", enablePaste);
            
            if (this.toolbar1 != null)
            {
                this.pasteBtn.enabled = enablePaste;                    
            }
            
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
        override public function cutNodes(selectedItems:Array):void
        {
            var event:AirClipboardUIEvent = new AirClipboardUIEvent(AirClipboardUIEvent.AIR_CLIPBOARD_CUT, null, this, selectedItems);
            event.dispatch(); 

            // enable paste menu and btn                                       
            var tabIndex:int = tabNav.selectedIndex;
            if ((tabIndex == docLibTabIndex) || (tabIndex == wcmTabIndex))
            {
                if (mainMenu != null)
                {
                    mainMenu.enableMenuItem("edit", "paste", true);
                }
                if (pasteBtn != null)
                {
                    pasteBtn.enabled = true;                    
                }                
            }                                                                                                           
        }
        
        /**
         * Copy selected node items to internal clipboard
         * Override to add flexspaces format flag to native clipboard
         *  
         * @param selectedItems selected nodes
         * 
         */
        override public function copyNodes(selectedItems:Array):void
        {
            var event:AirClipboardUIEvent = new AirClipboardUIEvent(AirClipboardUIEvent.AIR_CLIPBOARD_COPY, null, this, selectedItems);
            event.dispatch(); 
            
            // enable paste menu and btn                                      
            var tabIndex:int = tabNav.selectedIndex;
            if ((tabIndex == docLibTabIndex) || (tabIndex == wcmTabIndex))
            {
                if (mainMenu != null)
                {
                    mainMenu.enableMenuItem("edit", "paste", true);
                }
                if (pasteBtn != null)
                {
                    pasteBtn.enabled = true;                    
                }                
            }                                                                                                           
        }        
            
        /**
         * Paste node items from internal clipboard 
         * or files from native clipboard
         * 
         */
        public function pasteNodes():void
        {
            var responder:Responder = new Responder(flexSpacesAirPresModel.onResultAction, flexSpacesAirPresModel.onFaultAction);
            var event:AirClipboardUIEvent = new AirClipboardUIEvent(AirClipboardUIEvent.AIR_CLIPBOARD_PASTE, responder, this, null, redraw);
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
            onDragIn(event, browserView.fileView1);    
        }
                
        /**
         * Native drag in event handler for folder list 2
         * 
         * @param event native drag event
         * 
         */
        protected function onDragIn2(event:NativeDragEvent):void
        {
            onDragIn(event, browserView.fileView2);    
        }

        /**
         * Native drag in event handler for wcm folder list 1
         * 
         * @param event native drag event
         * 
         */
        protected function onWcmDragIn1(event:NativeDragEvent):void
        {
            onDragIn(event, wcmBrowserView.fileView1);    
        }
                
        /**
         * Native drag in event handler for wcm folder list 2
         * 
         * @param event native drag event
         * 
         */
        protected function onWcmDragIn2(event:NativeDragEvent):void
        {
            onDragIn(event, wcmBrowserView.fileView2);    
        }

       /**
        * On drag-in, check the data formats. If it is a supported format,
        * tell the Native Drag Manager that the component can take the drop.
        * 
        * @param event native drag event
        * @param targetFolderView target folder view
        * 
        */  
        protected function onDragIn(event:NativeDragEvent, targetFolderView:FolderViewBase):void
        {
            //trace("Drag enter event.");
            var transferable:Clipboard = event.clipboard;
                        
            if (transferable.hasFormat(ClipboardFormats.FILE_LIST_FORMAT) ||
                transferable.hasFormat("items") )
            {
                NativeDragManager.acceptDragDrop(targetFolderView);
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
            onDrop(event, browserView.fileView1);
        }
        
        /**
         * Native on drop event handler for folder list 2 
         * 
         * @param event native drag event
         * 
         */
        protected function onDrop2(event:NativeDragEvent):void
        {
            onDrop(event, browserView.fileView2);
        }

        /**
         * Native on drop event handler for wcm folder list 1 
         * 
         * @param event native drag event
         * 
         */
        protected function onWcmDrop1(event:NativeDragEvent):void
        {
            onDrop(event, wcmBrowserView.fileView1);
        }
        
        /**
         * Native on drop event handler for wcm folder list 2 
         * 
         * @param event native drag event
         * 
         */
        protected function onWcmDrop2(event:NativeDragEvent):void
        {
            onDrop(event, wcmBrowserView.fileView2);
        }

        /**
         * Handler for onDrop event
         * 
         * @param event native drag event
         * @param targetFolderView target folder view
         */
        protected function onDrop(event:NativeDragEvent, targetFolderView:FolderViewBase):void
        {
            //trace("Drag drop event.");
            var data:Clipboard = event.clipboard;
            if (data.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
            {
                var dropfiles:Array = data.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
                
                var uploadStatusView:UploadStatusView = UploadStatusView(PopUpManager.createPopUp(this, UploadStatusView, false));
                var uploadStatusPresModel:UploadStatusPresModel = new UploadStatusPresModel(dropfiles);
                uploadStatusView.uploadStatusPresModel = uploadStatusPresModel;
                
                for each (var file:File in dropfiles)
                {
                    var uploadAir:UploadAir = new UploadAir(uploadStatusView);
                    uploadAir.uploadAir(file, targetFolderView.folderViewPresModel.currentFolderNode, redraw);
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
                onDropItems(targetFolderView.folderViewPresModel, action, dropItems);
            }
        }
              
        /**
         * Handle dropping internal node items or 
         * external files from desktop into flexspacesair 
         *  
         * @param targetFolderList target folder view
         * @param action move ar copy 
         * @param items items to drop
         * 
         */
        override protected function onDropItems(targetFolderList:FolderViewPresModel, action:String, items:Array):void
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
            var selectedItem:Object = flexSpacesPresModel.selectedItem;   
            var selectedItems:Array = flexSpacesPresModel.selectedItems; 

            switch(data)
            {
                case 'paste':
                   pasteNodes();
                   break;
                case 'view':
                   viewNode(selectedItem);
                   break;
                case 'download':
                    downloadFile(selectedItem);
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
         * Toggle showing local files browser pane 
         * 
         */
        protected function showHideLocalFilesBrowser():void
        {
            if ( (localFilesView != null) && (localFilesView.visible == true) )
            {
                localFilesView.visible = false;
                localFilesView.includeInLayout = false;
                this.flexspacesviews.percentHeight = 100;
            }    
            else
            {
                if (localFilesView == null)
                {
                    this.localFilesView = new LocalFilesBrowserView();
                    localFilesView.percentWidth = 100;
                    localFilesView.percentHeight = 20;
                    this.addChild(localFilesView);
                    var localFilesPresModel:LocalFilesBrowserPresModel = new LocalFilesBrowserPresModel();
                    localFilesView.presModel = localFilesPresModel;                         
                }
                localFilesView.visible = true;
                localFilesView.includeInLayout = true;
                this.flexspacesviews.percentHeight = 80;
                localFilesView.percentHeight = 20;            
            }
            this.invalidateDisplayList();
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
            var selectedItems:Array = flexSpacesAirPresModel.selectedItems;  

            var event:AirMakeAvailOfflineUIEvent = new AirMakeAvailOfflineUIEvent(AirMakeAvailOfflineUIEvent.AIR_MAKE_AVAIL_OFFLINE, null, selectedItems, this);
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
            var selectedItem:Object = flexSpacesAirPresModel.selectedItem;
            var event:AirOfflineUploadUIEvent = new AirOfflineUploadUIEvent(AirOfflineUploadUIEvent.AIR_OFFLINE_UPLOAD, null, selectedItem, checkin, this, redraw);
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
        protected function downloadFile(selectedItem:Object):void
        {
            var event:DownloadUIEvent = new DownloadUIEvent(DownloadUIEvent.DOWNLOAD_UI, null, selectedItem, this, true);
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
            var createTextView:CreateTextView = CreateTextView(PopUpManager.createPopUp(this, CreateTextView, false));
            var createTextPresModel:CreateTextPresModel = new CreateTextPresModel();
            createTextView.presModel = createTextPresModel;
            createTextView.onComplete = createContentDialogComplete;
        }
        
        /**
         * Display the create xml content dialog 
         * 
         */
        protected function createXML():void
        {
            var createXmlView:CreateXmlView = CreateXmlView(PopUpManager.createPopUp(this, CreateXmlView, false));
            var createXmlPresModel:CreateXmlPresModel = new CreateXmlPresModel();
            createXmlView.presModel = createXmlPresModel;
            createXmlView.onComplete = createContentDialogComplete
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
                createHtmlView = CreateHtmlView(PopUpManager.createPopUp(this, CreateHtmlView, false));
                createHtmlPresModel = new CreateHtmlPresModel();
                createHtmlView.presModel = createHtmlPresModel;
                createHtmlView.onComplete = createContentDialogComplete;
            }   
            else
            {
               PopUpManager.addPopUp(createHtmlView, this);
               createHtmlView.setContent("");
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
            if (flexSpacesAirPresModel.currentNodeList is Folder)
            {
                var folder:Folder = flexSpacesAirPresModel.currentNodeList as Folder;
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
            
            if ((selectedItem != null) && (mainMenu != null) && (mainMenu.configurationDone == true) && (toolbar1 != null) )
            {
                var createChildrenPermission:Boolean = false;                                       
                if ( (flexSpacesAirPresModel.currentNodeList != null) && (flexSpacesAirPresModel.currentNodeList is Folder))
                {
                    var folder:Folder = flexSpacesAirPresModel.currentNodeList as Folder;
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
                    case docLibTabIndex:  
                        // paste                        
                        mainMenu.enableMenuItem("edit", "paste", enablePaste);
                        browserView.enableContextMenuItem("paste", enablePaste, true);  
                        this.pasteBtn.enabled = enablePaste;                    
                        // make avail offline, offline upload
                        mainMenu.enableMenuItem("tools", "availoffline", readPermission);
                        mainMenu.enableMenuItem("tools", "offlineupload", writePermission);
                        break;                     
                    case searchTabIndex:
                    case tasksTabIndex:
                        // make avail offline, offline upload
                        mainMenu.enableMenuItem("tools", "availoffline", false);
                        mainMenu.enableMenuItem("tools", "offlineupload", false);
                        break;                
                    case wcmTabIndex:
                        // paste
                        mainMenu.enableMenuItem("edit", "paste", enablePaste);
                        wcmBrowserView.enableContextMenuItem("paste", enablePaste, true);  
                        this.pasteBtn.enabled = enablePaste;                    
                        // make avail offline, offline upload
                        mainMenu.enableMenuItem("tools", "availoffline", readPermission);
                        mainMenu.enableMenuItem("tools", "offlineupload", writePermission);
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
            
            if ( (mainMenu != null) && (mainMenu.configurationDone == true) && (toolbar1 != null) )
            {
                // make avail offline, offline upload
                mainMenu.enableMenuItem("tools", "availoffline", false);
                mainMenu.enableMenuItem("tools", "offlineupload", false);

                var createChildrenPermission:Boolean = false;                                       
                if ( (flexSpacesAirPresModel.currentNodeList != null) && (flexSpacesAirPresModel.currentNodeList is Folder))
                {
                    var folder:Folder = flexSpacesAirPresModel.currentNodeList as Folder;
                    var parentNode:Node = folder.folderNode;
                    if (parentNode != null)
                    {
                        createChildrenPermission = parentNode.createChildrenPermission;
                    }                
                }                
                var enablePaste:Boolean = createChildrenPermission && formatToPaste();
    
                switch(tabIndex)
                {
                    case docLibTabIndex:
                        // create content          
                        mainMenu.enableMenuItem("file", "createcontent", createChildrenPermission);
                        // paste
                        mainMenu.enableMenuItem("edit", "paste", enablePaste);
                        browserView.enableContextMenuItem("paste", enablePaste, true);  
                        this.pasteBtn.enabled = enablePaste;                    
                        break;                     
                    case searchTabIndex:
                    case tasksTabIndex:
                        // create content          
                        mainMenu.enableMenuItem("file", "createcontent", false);
                        break;                
                    case wcmTabIndex:
                        // create content          
                        mainMenu.enableMenuItem("file", "createcontent", false);
                        // paste
                        mainMenu.enableMenuItem("edit", "paste", enablePaste);
                        wcmBrowserView.enableContextMenuItem("paste", enablePaste, true);  
                        this.pasteBtn.enabled = enablePaste;                    
                        break;  
                    case this.shareTabIndex:
                        // create content          
                        mainMenu.enableMenuItem("file", "createcontent", false);
                        // create space, upload          
                        mainMenu.enableMenuItem("file", "newspace", false);
                        mainMenu.enableMenuItem("file", "upload", false);                        
                        this.createSpaceBtn.enabled = false;
                        this.uploadFileBtn.enabled = false;
                        // paste
                        mainMenu.enableMenuItem("edit", "paste", false);
                        this.pasteBtn.enabled = false;                    
                        // tree, dual panes, wcm tree, dual wcm panes
                        mainMenu.enableMenuItem("view", "repotree", false);
                        mainMenu.enableMenuItem("view", "secondrepofolder", false);
                        mainMenu.enableMenuItem("view", "wcmrepotree", false);
                        mainMenu.enableMenuItem("view", "wcmsecondrepofolder", false);
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
            if ( data.hasFormat(ClipboardFormats.FILE_LIST_FORMAT) || data.hasFormat(FlexSpacesPresModel.FLEXSPACES_FORMAT) )
            {
                return true;
            }                
            else 
            {
                return false;
            }           
        }        

        protected function offlineEdit():void
        {
            var selectedItem:Object = flexSpacesAirPresModel.selectedItem;
            var event:AirOfflineEditUIEvent = new AirOfflineEditUIEvent(AirOfflineEditUIEvent.AIR_OFFLINE_EDIT, null, selectedItem, tabNav);
            event.dispatch();                                                                    
        }

        override protected function onEditBtn(event:MouseEvent):void
        {   
            if (model.appConfig.useLessStepsEdit == true)
            {
                offlineEdit();  
            }
            else
            {
                var selectedItem:Object = flexSpacesAirPresModel.selectedItem;                
                flexSpacesAirPresModel.downloadFile(selectedItem, this);
            }
        }               

        override protected function onUpdateBtn(event:MouseEvent):void
        {
            if (model.appConfig.useLessStepsEdit == true)
            {
                offlineUpload(false); 
            }
            else
            {
                var selectedItem:Object = flexSpacesAirPresModel.selectedItem;                
                flexSpacesAirPresModel.updateNode(selectedItem, this);
            }
        }   

    }       
}

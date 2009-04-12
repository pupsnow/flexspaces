package org.integratedsemantics.flexspaces.presmodel.main
{
    import flash.display.DisplayObject;
    
    import mx.collections.ArrayCollection;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.CheckinEvent;
    import org.integratedsemantics.flexspaces.control.event.FavoritesEvent;
    import org.integratedsemantics.flexspaces.control.event.MakePdfEvent;
    import org.integratedsemantics.flexspaces.control.event.SemanticTagsEvent;
    import org.integratedsemantics.flexspaces.control.event.preview.MakePreviewEvent;
    import org.integratedsemantics.flexspaces.control.event.ui.*;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.folder.NodeCollection;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.presmodel.browser.RepoBrowserPresModel;
    import org.integratedsemantics.flexspaces.presmodel.checkedout.CheckedOutPresModel;
    import org.integratedsemantics.flexspaces.presmodel.login.LoginPresModel;
    import org.integratedsemantics.flexspaces.presmodel.logout.LogoutPresModel;
    import org.integratedsemantics.flexspaces.presmodel.search.advanced.AdvancedSearchPresModel;
    import org.integratedsemantics.flexspaces.presmodel.search.basic.SearchPresModel;
    import org.integratedsemantics.flexspaces.presmodel.search.searchpanel.SearchPanelPresModel;
    import org.integratedsemantics.flexspaces.presmodel.tasks.taskspanel.TasksPanelPresModel;
    import org.integratedsemantics.flexspaces.presmodel.wcm.browser.WcmRepoBrowserPresModel;


    /**
     * Presention model for FlexSpaces overall main view 
     * 
     */
    [Bindable] 
    public class FlexSpacesPresModel extends PresModel
    {
        // handle avm files in wcm browser special vs adm files
        public var wcmMode:Boolean = false;

        // selected item, items in current folder view
        public var selectedItem:Object = null;      
        public var selectedItems:Array = null;
        
        // model of current folder view
        public var currentNodeList:NodeCollection;
        
        // whether to have various views
        public var showDocLib:Boolean = true;
        public var showSearch:Boolean = true;
        public var showTasks:Boolean = true;
        public var showWCM:Boolean = true;
        public var showShare:Boolean = true;
        
        public var showHeader:Boolean = true;

        // clipboard format flag for doc/folder nodes within flexspaces (air only)
        public static const FLEXSPACES_FORMAT:String = "FLEXSPACES";

		// clipboard
        public var cut:Array;
        public var copy:Array;
        public var wcmCutCopy:Boolean = false;

        // subview presenation models 
        public var browserPresModel:RepoBrowserPresModel; 
        public var searchPanelPresModel:SearchPanelPresModel;
        public var tasksPanelPresModel:TasksPanelPresModel;               
        public var wcmBrowserPresModel:WcmRepoBrowserPresModel;  
        public var advSearchPresModel:AdvancedSearchPresModel;

        // cmis
        public var checkedOutPresModel:CheckedOutPresModel = new CheckedOutPresModel(); 
        
        public var loginPresModel:LoginPresModel = new LoginPresModel();
        public var searchPresModel:SearchPresModel = new SearchPresModel();
        public var logoutPresModel:LogoutPresModel = new LogoutPresModel();
                            
        // update / redraw function;
        public var updateFunction:Function;
        
        // page sizes for views
        public var docLibPageSize:int = 10;
        public var wcmPageSize:int = 10;
        public var searchPageSize:int = 10;
        public var taskAttachmentsPageSize:int = 10;
        public var versionsPageSize:int = 10;
        public var favoritesPageSize:int = 10;
        public var checkedOutPageSize:int = 10;
        // list of pages sizes, todo make configurable
        public var pageSizeList:ArrayCollection = new ArrayCollection(new Array("10", "20", "30", "40", "50"));
        
        /**
         * Constructor
         *  
         * @param mainView FlexSpacesView main view
         * 
         */
        public function FlexSpacesPresModel()
        {
        	super();
        	setupSubPresModels();
        }   
        
        protected function setupSubPresModels():void
        {
            browserPresModel = new RepoBrowserPresModel(); 
            searchPanelPresModel = new SearchPanelPresModel();
            tasksPanelPresModel = new TasksPanelPresModel();               
            wcmBrowserPresModel = new WcmRepoBrowserPresModel();  
            advSearchPresModel = new AdvancedSearchPresModel();
        }
        
        public function clearSelection():void
        {
            selectedItem = null;
            selectedItems = null;    
        }
                    
        /**
         * Handler for good result from cairngorm event/cmd
         *  
         * @param info result info
         * 
         */
        public function onResultAction(info:Object):void
        {
            redraw();      
        }
        
        protected function redraw():void
        {
        	if (updateFunction != null)
        	{
        		updateFunction();
        	}
        }
                
        /**
         * Handler for error from cairngorm event/cmd
         *  
         * @param info fault info
         * 
         */
        public function onFaultAction(info:Object):void
        {
            trace("onFaultAction " + info);     
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
        public function rename(selectedItem:Object, parent:DisplayObject):void
        {
            var event:RenameNodeUIEvent = new RenameNodeUIEvent(RenameNodeUIEvent.RENAME_NODE_UI, null, selectedItem, parent, redraw);
            event.dispatch();                                
        }
        
        /**
         * Display properties UI for a doc/folder node
         *  
         * @param selectedItem selected node
         * 
         */
        public function properties(selectedItem:Object, parent:DisplayObject):void
        {
            var event:PropertiesUIEvent = new PropertiesUIEvent(PropertiesUIEvent.PROPERTIES_UI, null, selectedItem, parent, redraw);
            event.dispatch();                                                
        }

        /**
         * Display UI for editing tags in a doc/folder node
         *  
         * @param selectedItem selected node
         * 
         */
        public function tags(selectedItem:Object, parent:DisplayObject):void
        {
            var event:TagsCategoriesUIEvent = new TagsCategoriesUIEvent(TagsCategoriesUIEvent.TAGS_CATEGORIES_UI, null, selectedItem, parent, redraw);
            event.dispatch();                                
        }
        
        /**
         *  View a document node in a separate window
         *  
         * @param selectedItem selected node
         * 
         */
        public function viewNode(selectedItem:Object):void
        {
            var event:ViewNodeUIEvent = new ViewNodeUIEvent(ViewNodeUIEvent.VIEW_NODE, null, selectedItem);
            event.dispatch();                    
        }
                
        /**
         *  Edit a document node (checkout, then download
         *  
         * @param selectedItem selected node
         * 
         */
        public function editNode(selectedItem:Object, onResultCheckoutForEdit:Function):void
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
        public function cutNodes(selectedItems:Array):void
        {
            var event:ClipboardUIEvent = new ClipboardUIEvent(ClipboardUIEvent.CLIPBOARD_CUT, null, selectedItems);
            event.dispatch();                
        }

        /**
         * Copy selected node items to internal clipboard
         *  
         * @param selectedItems selected nodes
         * 
         */
        public function copyNodes(selectedItems:Array):void
        {
            var event:ClipboardUIEvent = new ClipboardUIEvent(ClipboardUIEvent.CLIPBOARD_COPY, null, selectedItems);
            event.dispatch();                                            
        }

        /**
         * Paste node items from internal clipboard
         * 
         */
        public function pasteNodes():void
        {
            var responder:Responder = new Responder(onResultAction, onFaultAction);
            var event:ClipboardUIEvent = new ClipboardUIEvent(ClipboardUIEvent.CLIPBOARD_PASTE, responder, null);
            event.dispatch();                 
        }

        /**
         * Display UI for creating a space/folder 
         * 
         */
        public function createSpace(parent:DisplayObject):void
        {            
            if (currentNodeList is Folder)
            {
                var folder:Folder = currentNodeList as Folder; 
                var parentNode:IRepoNode = folder.folderNode;
                var event:CreateSpaceUIEvent = new CreateSpaceUIEvent(CreateSpaceUIEvent.CREATE_SPACE_UI, null, parentNode, parent, redraw);
                event.dispatch();            
            }                                                                                
        }
        
        /**
         * Display UI for confirming deletion of selected nodes
         *   
         * @param selectedItems selected nodes
         * 
         */
        public function deleteNodes(selectedItems:Array, parent:DisplayObject):void
        {
            var event:DeleteNodesUIEvent = new DeleteNodesUIEvent(DeleteNodesUIEvent.DELETE_NODES_UI, null, selectedItems, parent, redraw);
            event.dispatch();                                                            
        }

        /**
         * Checkin the selected node
         *  
         * @param selectedItem selected node
         * 
         * 
         */
        public function checkin(selectedItem:Object):void
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
        public function checkout(selectedItem:Object):void
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
        public function cancelCheckout(selectedItem:Object):void
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
        public function makeVersionable(selectedItem:Object):void
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
        public function startWorkflow(selectedItem:Object, parent:DisplayObject):void
        {
            var event:StartWorkflowUIEvent = new StartWorkflowUIEvent(StartWorkflowUIEvent.START_WORKFLOW_UI, null, selectedItem, parent, startWorkflowComplete);
            event.dispatch();                                            
        }
        
        /**
         * Refresh the task list after a new task has been added by start workflow 
         * 
         */
        public function startWorkflowComplete():void
        {
            if (tasksPanelPresModel != null)
            {  
                tasksPanelPresModel.refreshTaskList();
            }
        }

        /**
         * Make PDF transform versions of the selected document nodes
         *  
         * @param selectedItems selected nodes
         * 
         */
        public function makePDFs(selectedItems:Array):void
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
        public function makeFlashPreviews(selectedItems:Array):void
        {
            if (currentNodeList is Folder)
            {
                var folder:Folder = currentNodeList as Folder;
                
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
         * Display multiple file upload dialog and upload files 
         * to the current folder in the current folder view 
         * 
         */
        public function uploadFiles(parent:DisplayObject):void
        {
            if (currentNodeList is Folder)
            {
                var folder:Folder = currentNodeList as Folder;
                var parentNode:IRepoNode = folder.folderNode;
    
                var responder:Responder = new Responder(onResultAction, onFaultAction);
                var event:UploadFilesUIEvent = new UploadFilesUIEvent(UploadFilesUIEvent.UPLOAD_FILES_UI, responder, parentNode, parent);
                event.dispatch();
            }                    
        }
        
        /**
         * Display single file upload dialog and update selected node with new content
         * 
         * @param selectedItem selected node
         * 
         */
        public function updateNode(selectedItem:Object, parent:DisplayObject):void
        {
            var responder:Responder = new Responder(onResultAction, onFaultAction);
            var event:UpdateNodeUIEvent = new UpdateNodeUIEvent(UpdateNodeUIEvent.UPDATE_NODE_UI, responder, selectedItem as IRepoNode, parent);
            event.dispatch();
        }

        /**
         * Download the selected document node (single selection)
         * A file location dialog will be displayed to choose the local location
         *  
         * @param selectedItem selected node
         * @param parent parent for dialog
         * 
         */
        public function downloadFile(selectedItem:Object, parent:DisplayObject):void
        {
            var event:DownloadUIEvent = new DownloadUIEvent(DownloadUIEvent.DOWNLOAD_UI, null, selectedItem, parent, false);
            event.dispatch();                    
        }

        /**
         * Auto-Tag selected documents using Calias 
         *  
         * @param selectedItems selected nodes
         * 
         */
        public function autoTag(selectedItems:Array):void
        {
            if (selectedItems != null && selectedItems.length > 0)
            {
                for each (var selectedItem:Object in selectedItems)
                {
                    if (selectedItem != null && selectedItem.isFolder != true)
                    {
		                if (wcmMode == false)
		                {
				            var responder:Responder = new Responder(onResultAction, onFaultAction);
				            var tagsEvent:SemanticTagsEvent = new SemanticTagsEvent(SemanticTagsEvent.AUTO_SEMANTIC_TAG, responder, selectedItem as IRepoNode);
				            tagsEvent.dispatch();                        		                	
		                }
                    }
                }                   
            }            
        }
        
        /**
         * Add favorite/shortcut for the current user for the selected node
         *  
         * @param selectedItem selected node
         * 
         * 
         */
        public function newFavorite(selectedItem:Object):void
        {
            if (selectedItem != null)
            {
                // currently the add favorite webscript may be using javascript
                // api added in alfresco 3.0
                var model:AppModelLocator = AppModelLocator.getInstance();
                if (model.ecmServerConfig.serverVersionNum() >= 3.0)
                {
                    var responder:Responder = new Responder(onResultAction, onFaultAction);
                    var favoritesEvent:FavoritesEvent = new FavoritesEvent(FavoritesEvent.NEW_FAVORITE, responder, selectedItem as IRepoNode);
                    favoritesEvent.dispatch();
                }                    
            }
        }
        
        /**
         * Delete favorite/shortcut for current user for the selected node
         *  
         * @param selectedItem selected node
         * 
         * 
         */
        public function deleteFavorite(selectedItem:Object):void
        {
            if (selectedItem != null)
            {
                var responder:Responder = new Responder(onResultAction, onFaultAction);
                var favoritesEvent:FavoritesEvent = new FavoritesEvent(FavoritesEvent.DELETE_FAVORITE, responder, selectedItem as IRepoNode);
                favoritesEvent.dispatch();                    
            }
        }
                
    }
}


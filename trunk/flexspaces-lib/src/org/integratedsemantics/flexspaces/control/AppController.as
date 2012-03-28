package org.integratedsemantics.flexspaces.control
{
    import com.universalmind.cairngorm.control.FrontController;
    
    import org.integratedsemantics.flexspaces.control.command.*;
    import org.integratedsemantics.flexspaces.control.command.search.SearchCommand;
    import org.integratedsemantics.flexspaces.control.command.ui.*;
    import org.integratedsemantics.flexspaces.control.command.wcm.*;
    import org.integratedsemantics.flexspaces.control.event.*;
    import org.integratedsemantics.flexspaces.control.event.preview.*;
    import org.integratedsemantics.flexspaces.control.event.properties.*;
    import org.integratedsemantics.flexspaces.control.event.task.*;
    import org.integratedsemantics.flexspaces.control.event.ui.*;
    import org.integratedsemantics.flexspaces.control.event.wcm.*;
    
    
    /**
     * FlexSpaces Cairngorm/UM front controller
     *  
     * Handles routing cairngorm events to call registered commands
     * 
     */
    public class AppController extends FrontController
    {        
        
        /**
         * Constructor 
         * 
         */
        public function AppController()
        {
            super();
            
            registerAllCommands();
        }
        
        /**
         * Register each cairngorm event with command 
         * 
         */
        protected function registerAllCommands():void
        {   
            // alfresco server commands
                      
            addCommand(CategoriesEvent.GET_CATEGORIES, CategoriesCommand);
            addCommand(CategoriesEvent.GET_CATEGORY_PROPERTIES, CategoriesCommand);
            addCommand(CategoriesEvent.ADD_CATEGORY, CategoriesCommand);
            addCommand(CategoriesEvent.REMOVE_CATEGORY, CategoriesCommand);
            
            addCommand(CheckinEvent.CANCEL_CHECKOUT, CheckinCommand);            
            addCommand(CheckinEvent.CHECKOUT, CheckinCommand);            
            addCommand(CheckinEvent.CHECKIN, CheckinCommand);            
            addCommand(CheckinEvent.MAKE_VERSIONABLE, CheckinCommand);            

            addCommand(CopyMoveEvent.COPY, CopyMoveCommand);            
            addCommand(CopyMoveEvent.MOVE, CopyMoveCommand);            
            addCommand(CopyMoveEvent.AVM_COPY, CopyMoveCommand);            
            addCommand(CopyMoveEvent.AVM_MOVE, CopyMoveCommand);            
            addCommand(CopyMoveEvent.ADM_TO_AVM_COPY, CopyMoveCommand);            
            addCommand(CopyMoveEvent.AVM_TO_ADM_COPY, CopyMoveCommand);            
                        
            addCommand(DeleteEvent.DELETE, DeleteCommand);            
            addCommand(DeleteEvent.DELETE_AVM, DeleteCommand);            

            addCommand(FolderEvent.CREATE_SPACE, FolderCommand);            
            addCommand(FolderEvent.SPACE_TEMPLATES, FolderCommand);            
            addCommand(FolderEvent.CREATE_AVM_FOLDER, FolderCommand);            

            addCommand(FavoritesEvent.LIST_FAVORITES, FavoritesCommand);            
            addCommand(FavoritesEvent.NEW_FAVORITE, FavoritesCommand);            
            addCommand(FavoritesEvent.DELETE_FAVORITE, FavoritesCommand);            

            addCommand(FolderListEvent.FOLDER_LIST, FolderListCommand);            

            addCommand(GetInfoEvent.GET_INFO, GetInfoCommand);
            
            addCommand(LoginEvent.LOGIN, LoginCommand);            
            
            addCommand(LogoutEvent.LOGOUT, LogoutCommand);            

            addCommand(MakePdfEvent.MAKE_PDF, MakePdfCommand);            
            
            addCommand(GetPreviewEvent.GET_PREVIEW, PreviewCommand);            
            addCommand(MakePreviewEvent.MAKE_PREVIEW, PreviewCommand);            

            addCommand(GetPropertiesEvent.GET_PROPERTIES, PropertiesCommand);
            addCommand(SetPropertiesEvent.SET_PROPERTIES, PropertiesCommand);            
            addCommand(GetPropertiesEvent.GET_AVM_PROPERTIES, PropertiesCommand);
            addCommand(SetPropertiesEvent.SET_AVM_PROPERTIES, PropertiesCommand);            

            addCommand(SemanticTagsEvent.GET_SEMANTIC_TAGS, SemanticTagsCommand);            
            addCommand(SemanticTagsEvent.ADD_SEMANTIC_TAG, SemanticTagsCommand);            
            addCommand(SemanticTagsEvent.REMOVE_SEMANTIC_TAG, SemanticTagsCommand);            
            addCommand(SemanticTagsEvent.AUTO_SEMANTIC_TAG, SemanticTagsCommand);            
            addCommand(SemanticTagsEvent.GET_SEMANTIC_TAG_TREE, SemanticTagsCommand);            
            addCommand(SemanticTagsEvent.GET_NODE_SEMANTIC_TAGS, SemanticTagsCommand);            
            addCommand(SemanticTagsEvent.SUGGEST_SEMANTIC_TAGS, SemanticTagsCommand);            
            addCommand(SemanticTagsEvent.ADD_NEW_SEMANTIC_TAG, SemanticTagsCommand);            

            addCommand(SearchEvent.ADVANCED_SEARCH, SearchCommand);            
            addCommand(SearchEvent.SEARCH, SearchCommand);            

            addCommand(TagsEvent.GET_TAGS, TagsCommand);            
            addCommand(TagsEvent.ADD_TAG, TagsCommand);            
            addCommand(TagsEvent.REMOVE_TAG, TagsCommand);            

            addCommand(StartWorkflowEvent.START_WORKFLOW, TaskCommand);            
            addCommand(TaskListEvent.TASK_LIST, TaskCommand);            
            addCommand(TaskAttachmentsEvent.TASK_ATTACHMENTS, TaskCommand);            
            addCommand(EndTaskEvent.END_TASK, TaskCommand);            

            addCommand(TreeDataEvent.TREE_DATA, TreeCommand);            

            addCommand(UpdateNodeEvent.UPDATE_NODE, UploadFilesCommand);
            addCommand(UpdateNodeEvent.UPDATE_AVM_NODE, UploadFilesCommand);

            addCommand(UploadFilesEvent.UPLOAD_FILES, UploadFilesCommand);
            addCommand(UploadFilesEvent.UPLOAD_AVM_FILES, UploadFilesCommand);
            
            addCommand(VersionListEvent.VERSION_LIST, VersionListCommand);    
            
            addCommand(WcmFolderListEvent.WCM_FOLDER_LIST, WcmFolderListCommand);            
            addCommand(WcmTreeDataEvent.WCM_TREE_DATA, WcmTreeCommand);            
            addCommand(WcmTreeDataEvent.WCM_STORES_DATA, WcmTreeCommand);       
            
            // UI commands     

            addCommand(AdvancedSearchUIEvent.ADVANCED_SEARCH_UI, AdvancedSearchUICommand);

            addCommand(ClipboardUIEvent.CLIPBOARD_CUT, ClipboardUICommand);
            addCommand(ClipboardUIEvent.CLIPBOARD_COPY, ClipboardUICommand);
            addCommand(ClipboardUIEvent.CLIPBOARD_PASTE, ClipboardUICommand);

            addCommand(CreateSpaceUIEvent.CREATE_SPACE_UI, CreateSpaceUICommand);

            addCommand(DeleteNodesUIEvent.DELETE_NODES_UI, DeleteUICommand);

            addCommand(DownloadUIEvent.DOWNLOAD_UI, DownloadUICommand);

            addCommand(DropNodesUIEvent.DROP_NODES, DragDropUICommand);

            addCommand(PropertiesUIEvent.PROPERTIES_UI, PropertiesUICommand);

            addCommand(RenameNodeUIEvent.RENAME_NODE_UI, RenameUICommand);

            addCommand(StartWorkflowUIEvent.START_WORKFLOW_UI, StartWorkflowUICommand);
            
            addCommand(TagsCategoriesUIEvent.TAGS_CATEGORIES_UI, TagsCategoriesUICommand);

            addCommand(UpdateNodeUIEvent.UPDATE_NODE_UI, UpdateNodeUICommand);

            addCommand(UploadFilesUIEvent.UPLOAD_FILES_UI, UploadFilesUICommand);

            addCommand(ViewNodeUIEvent.VIEW_NODE, ViewNodeUICommand);
        }
    }
}
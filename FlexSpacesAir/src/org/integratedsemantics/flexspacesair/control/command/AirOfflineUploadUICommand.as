package org.integratedsemantics.flexspacesair.control.command
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.filesystem.File;
    
    import mx.controls.Alert;
    import mx.events.CloseEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
    import org.integratedsemantics.flexspaces.presmodel.upload.UploadStatusPresModel;
    import org.integratedsemantics.flexspaces.view.upload.UploadStatusView;
    import org.integratedsemantics.flexspacesair.control.event.AirOfflineUploadUIEvent;


    /**
     * Command to upload a file (without file chooser dialog) from offline area 
     * from standard local flexspaces area in user's documents folder (with
     *  local folder path / file name mirroring repository path / filename
     *  into an existing  document in the repository)
     *  
     * Note: files will be placed in this area by make available offline
     * 
     */
    public class AirOfflineUploadUICommand extends Command
    {
        protected var flexSpacesPresModel:FlexSpacesPresModel = AppModelLocator.getInstance().flexSpacesPresModel;
        
        protected var selectedItem:Object;
        protected var checkin:Boolean;
        protected var onComplete:Function;
        public var parent:DisplayObject;
        
        /** Icon used in the confirmation dialog */
        protected var confirmIcon:Class;


        /**
         * Constructor
         */
        public function AirOfflineUploadUICommand()
        {
            super();
        }

        /**
         * Execute command for the given event
         *  
         * @param event event calling command
         * 
         */
        override public function execute(event:CairngormEvent):void
        {
            // always call the super.execute() method which allows the 
            // callBack information to be cached.
            super.execute(event);
 
            switch(event.type)
            {
                case AirOfflineUploadUIEvent.AIR_OFFLINE_UPLOAD:
                    airOfflineUpload(event as AirOfflineUploadUIEvent);  
                    break;
            }
        }       

        /**
         * Air Offline Upload
         * 
         * @param event air offline uploade event
         */
        public function airOfflineUpload(event:AirOfflineUploadUIEvent):void
        {            
            if (flexSpacesPresModel.currentNodeList is Folder)
            {
                this.selectedItem = event.selectedItem;
                this.checkin = event.checkin;
                this.onComplete = event.onComplete;
                this.parent = event.parent;
    
                if (selectedItem != null && selectedItem.isFolder != true)
                {
                    // confirm with user
                    var flexspacesDocDir:File = File.documentsDirectory.resolvePath("FlexSpaces");
                    var docRepoPath:String = selectedItem.displayPath;              
                    var offlineFile:File = flexspacesDocDir.resolvePath( docRepoPath.substr(1));
                    var msg:String = "Ok to update content of selected file with content from " + offlineFile.nativePath + " ?";
                    var a:Alert = Alert.show(msg, "Confirmation",  Alert.YES|Alert.NO, event.parent as Sprite, onConfirm, confirmIcon, Alert.NO);                                                    
                }          
            }  
        }
        
        /**
         * Handle completion of confirm dialog with yes or no result 
         * 
         * @param close event
         * 
         */
        protected function onConfirm(event:CloseEvent):void 
        {
            if (event.detail == Alert.YES) 
            {
                var folder:Folder = flexSpacesPresModel.currentNodeList as Folder;
                var parentNode:IRepoNode = folder.folderNode;

                // get offline file
                var flexspacesDocDir:File = File.documentsDirectory.resolvePath("FlexSpaces");
                var docRepoPath:String = selectedItem.displayPath;                
                var offlineFile:File = flexspacesDocDir.resolvePath( docRepoPath.substr(1));
                
                var fileReferences:Array = new Array();
                fileReferences.push(offlineFile);
                var uploadStatusView:UploadStatusView = UploadStatusView(PopUpManager.createPopUp(parent, UploadStatusView, false));
                var uploadStatusPresModel:UploadStatusPresModel = new UploadStatusPresModel(fileReferences);
                uploadStatusView.uploadStatusPresModel = uploadStatusPresModel;
                
                // upload offline file into existing object
                var uploadAir:UploadAir = new UploadAir(uploadStatusView);
                uploadAir.uploadAir(offlineFile, parentNode, onComplete, selectedItem as IRepoNode, checkin);
            }
        }        
                
    }
}
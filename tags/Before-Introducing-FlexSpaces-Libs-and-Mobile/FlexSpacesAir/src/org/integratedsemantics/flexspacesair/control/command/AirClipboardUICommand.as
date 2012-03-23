package org.integratedsemantics.flexspacesair.control.command
{
    import com.adobe.cairngorm.control.CairngormEvent;
    
    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;
    import flash.display.DisplayObject;
    import flash.filesystem.File;
    
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.control.command.ui.ClipboardUICommand;
    import org.integratedsemantics.flexspaces.model.folder.Folder;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
    import org.integratedsemantics.flexspaces.presmodel.upload.UploadStatusPresModel;
    import org.integratedsemantics.flexspaces.view.upload.UploadStatusView;
    import org.integratedsemantics.flexspacesair.control.event.AirClipboardUIEvent;
    

    /**
     * AirClipboardUICommand provides cut/copy/paste of multiple selected doc/folder 
     * repository node items with internal clipoard and native air clipboard support
     * for copy/paste of shell desktop files into the repository folders
     * 
     */
    public class AirClipboardUICommand extends ClipboardUICommand
    {

        /**
         * Constructor
         */
        public function AirClipboardUICommand()
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
                case AirClipboardUIEvent.AIR_CLIPBOARD_CUT:
                    airCut(event as AirClipboardUIEvent);  
                    break;
                case AirClipboardUIEvent.AIR_CLIPBOARD_COPY:
                    airCopy(event as AirClipboardUIEvent);  
                    break;
                case AirClipboardUIEvent.AIR_CLIPBOARD_PASTE:
                    airPaste(event as AirClipboardUIEvent);  
                    break;
            }
        }       

        /**
         * Air Cut
         * 
         * @param event air clipboard ui event
         * 
         */
        public function airCut(event:AirClipboardUIEvent):void
        {            
            super.cut(event);
            
            var selectedItems:Array = event.selectedItems;
            if (selectedItems.length > 0)
            {
                // add token to clipboard to indicate last cut/copy was flexspaces internal operation
                addFlexSpacesFormat(event.view);
            }
        }
        
        /**
         * Add FlexSpaces format flag to native clipboard  
         * 
         */
        protected function addFlexSpacesFormat(view:DisplayObject):void
        { 
            var transferObject:Clipboard = new Clipboard;
            // todo: check if mainView is the right thing to register
            transferObject.setData(FlexSpacesPresModel.FLEXSPACES_FORMAT, view, false); 
            for each(var format:String in transferObject.formats)
            {
                Clipboard.generalClipboard.setData(format, transferObject.getData(format), false);
            }
        }     

        /**
         * Air Copy
         * 
         * @param event air clipboard ui event
         * 
         */
        public function airCopy(event:AirClipboardUIEvent):void
        {            
            super.copy(event);

            var selectedItems:Array = event.selectedItems;
            if (selectedItems.length > 0)
            {
                // add token to clipboard to indicate last cut/copy was flexspaces internal operation
                addFlexSpacesFormat(event.view);
            }
        }

        /**
         * Air Paste
         * 
         * @param event air clipboard ui event
         * 
         */
        public function airPaste(event:AirClipboardUIEvent):void
        {            
            if (flexSpacesPresModel.currentNodeList is Folder)
            {
                var folder:Folder = flexSpacesPresModel.currentNodeList as Folder;
                var parentNode:IRepoNode = folder.folderNode;
                                
                var data:Clipboard = Clipboard.generalClipboard;
                if (data.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
                {
                    var files:Array = data.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;

                    var uploadStatusView:UploadStatusView = UploadStatusView(PopUpManager.createPopUp(event.view, UploadStatusView, false));
                    var uploadStatusPresModel:UploadStatusPresModel = new UploadStatusPresModel(files);
                    uploadStatusView.uploadStatusPresModel = uploadStatusPresModel;
                    
                    for each (var file:File in files)
                    {
                        var uploadAir:UploadAir = new UploadAir(uploadStatusView);
                        uploadAir.uploadAir(file, parentNode, event.onComplete);
                    }
                }                
                else if (data.hasFormat(FlexSpacesPresModel.FLEXSPACES_FORMAT))
                {
                    super.paste(event);  
                }  
            }          
        }

    }
}
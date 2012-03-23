package org.integratedsemantics.flexspaces.control.command.ui
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.net.FileReferenceList;
    
    import mx.managers.PopUpManager;
    import mx.rpc.IResponder;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.UploadFilesEvent;
    import org.integratedsemantics.flexspaces.control.event.ui.UploadFilesUIEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
    import org.integratedsemantics.flexspaces.presmodel.upload.UploadStatusPresModel;
    import org.integratedsemantics.flexspaces.view.upload.UploadStatusView;
    

    /**
     * Display the UI for upload files and progress UI
     * 
     */
    public class UploadFilesUICommand extends Command
    {
        protected var model:FlexSpacesPresModel = AppModelLocator.getInstance().flexSpacesPresModel;
        protected var parentNode:IRepoNode;
        protected var fileRefList:FileReferenceList;
        protected var handlers:IResponder;
        public var parent:DisplayObject;


        /**
         * Constructor
         */
        public function UploadFilesUICommand()
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
                case UploadFilesUIEvent.UPLOAD_FILES_UI:
                    uploadFilesUI(event as UploadFilesUIEvent); 
                    break;
            }
        }       

        /**
         * Upload Files UI
         * 
         * @param upload files UI event
         */
        public function uploadFilesUI(event:UploadFilesUIEvent):void
        {
            parentNode = event.parentNode;
            handlers = event.responder;
            parent = event.parent;
            
            // start process off with with browse for multiple files
            this.fileRefList = new FileReferenceList();
            fileRefList.addEventListener(Event.SELECT, selectHandler);
            fileRefList.addEventListener(Event.CANCEL, cancelHandler);
            fileRefList.browse(null);            
        }
        
        /**
         * Handle dealing with files selected in browse dialog
         * 
         * @param event select event
         * 
         */
        protected function selectHandler(event:Event):void
        {
            //trace("selectHandler: " + this.fileRefList.fileList.length + " files");

          var uploadStatusView:UploadStatusView = UploadStatusView(PopUpManager.createPopUp(parent, UploadStatusView, false));
          var uploadStatusPresModel:UploadStatusPresModel = new UploadStatusPresModel(fileRefList.fileList);
          uploadStatusView.uploadStatusPresModel = uploadStatusPresModel;
          
          if (model.wcmMode == false)
            {
                var responder:Responder = new Responder(handlers.result, handlers.fault);
                var uploadFilesEvent:UploadFilesEvent = new UploadFilesEvent(UploadFilesEvent.UPLOAD_FILES, responder, parentNode, fileRefList, uploadStatusView);
                uploadFilesEvent.dispatch();                                    
            }                        
            else
            {
                responder = new Responder(handlers.result, handlers.fault);
                uploadFilesEvent = new UploadFilesEvent(UploadFilesEvent.UPLOAD_AVM_FILES, responder, parentNode, fileRefList, uploadStatusView);
                uploadFilesEvent.dispatch();                                    
            }
        }
     
        /**
         * Cancel browse dialog handler
         * 
         * @param event cancel event
         * 
         */
        protected function cancelHandler(event:Event):void
        {
            //trace("cancelHandler:");
        }        
        
    }
}
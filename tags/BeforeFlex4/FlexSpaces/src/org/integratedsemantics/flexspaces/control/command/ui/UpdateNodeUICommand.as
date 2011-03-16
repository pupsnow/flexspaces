package org.integratedsemantics.flexspaces.control.command.ui
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.net.FileReference;
    
    import mx.managers.PopUpManager;
    import mx.rpc.IResponder;
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.UpdateNodeEvent;
    import org.integratedsemantics.flexspaces.control.event.ui.UpdateNodeUIEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
    import org.integratedsemantics.flexspaces.presmodel.upload.UploadStatusPresModel;
    import org.integratedsemantics.flexspaces.view.upload.UploadStatusView;
    

    /**
     * Display single file upload dialog and update selected node with new content
     * while displaying upload progress bar dialog
     * 
     */
    public class UpdateNodeUICommand extends Command
    {
        protected var model:FlexSpacesPresModel = AppModelLocator.getInstance().flexSpacesPresModel;
        protected var repoNode:IRepoNode;
        protected var fileRef:FileReference
        protected var handlers:IResponder;
        public var parent:DisplayObject;


        /**
         * Constructor
         */
        public function UpdateNodeUICommand()
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
                case UpdateNodeUIEvent.UPDATE_NODE_UI:
                    updateNodeUI(event as UpdateNodeUIEvent); 
                    break;
            }
        }       

        /**
         * Upload Files UI
         * 
         * @param upload files UI event
         */
        public function updateNodeUI(event:UpdateNodeUIEvent):void
        {
            repoNode = event.repoNode;
            handlers = event.responder;
            parent = event.parent;
            
            // start process off with with browse for multiple files
            this.fileRef = new FileReference();
            fileRef.addEventListener(Event.SELECT, selectHandler);
            fileRef.addEventListener(Event.CANCEL, cancelHandler);
            fileRef.browse(null);            
        }
        
        /**
         * Handle dealing with files selected in browse dialog
         * 
         * @param event select event
         * 
         */
        protected function selectHandler(event:Event):void
        {
            trace("selectHandler: " + fileRef.name);

            var fileReferences:Array = new Array();
            fileReferences.push(this.fileRef);
            var uploadStatusView:UploadStatusView = UploadStatusView(PopUpManager.createPopUp(parent, UploadStatusView, false));
            var uploadStatusPresModel:UploadStatusPresModel = new UploadStatusPresModel(fileReferences);
            uploadStatusView.uploadStatusPresModel = uploadStatusPresModel;
                      
            if (model.wcmMode == false)
            {
                var responder:Responder = new Responder(handlers.result, handlers.fault);
                var updateNodeEvent:UpdateNodeEvent = new UpdateNodeEvent(UpdateNodeEvent.UPDATE_NODE, responder, repoNode, fileRef, uploadStatusView);
                updateNodeEvent.dispatch();                                    
            }                        
            else
            {
                responder = new Responder(handlers.result, handlers.fault);
                updateNodeEvent = new UpdateNodeEvent(UpdateNodeEvent.UPDATE_AVM_NODE, responder, repoNode, fileRef, uploadStatusView);
                updateNodeEvent.dispatch();                                    
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
            trace("cancelHandler:");
        }        
        
    }
}
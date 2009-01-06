package org.integratedsemantics.flexspaces.control.command.ui
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.control.event.ui.CreateSpaceUIEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.presmodel.createspace.CreateSpacePresModel;
    import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
    import org.integratedsemantics.flexspaces.presmodel.wcm.createfolder.WcmCreateFolderPresModel;
    import org.integratedsemantics.flexspaces.view.createspace.CreateSpaceView;
    import org.integratedsemantics.flexspaces.view.wcm.createfolder.WcmCreateFolderView;
    

    /**
     * Display the UI for creating a space/folder
     * 
     */
    public class CreateSpaceUICommand extends Command
    {
        protected var model:FlexSpacesPresModel = AppModelLocator.getInstance().flexSpacesPresModel;

        /**
         * Constructor
         */
        public function CreateSpaceUICommand()
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
                case CreateSpaceUIEvent.CREATE_SPACE_UI:
                    createSpaceUI(event as CreateSpaceUIEvent); 
                    break;
            }
        }       

        /**
         * Create Spaace UI
         * 
         * @param event  create space UI event
         */
        public function createSpaceUI(event:CreateSpaceUIEvent):void
        {
            var parentNode:IRepoNode = event.parentNode;
            
            if (model.wcmMode == false)
            {
                var createSpaceView:CreateSpaceView = CreateSpaceView(PopUpManager.createPopUp(event.parent, CreateSpaceView, false));
                var createSpacePresModel:CreateSpacePresModel = new CreateSpacePresModel(parentNode);
                createSpaceView.createSpacePresModel = createSpacePresModel; 
                createSpaceView.onComplete = event.onComplete;
            }                        
            else
            {
                var wcmCreateFolderView:WcmCreateFolderView = WcmCreateFolderView(PopUpManager.createPopUp(event.parent, WcmCreateFolderView, false));
                var wcmCreateFolderPresModel:WcmCreateFolderPresModel = new WcmCreateFolderPresModel(parentNode);
                wcmCreateFolderView.wcmCreateFolderPresModel = wcmCreateFolderPresModel; 
                wcmCreateFolderView.onComplete = event.onComplete;
            }                   
        }
        
    }
}
package org.integratedsemantics.flexspaces.control.command.ui
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.component.createspace.CreateSpacePresenter;
    import org.integratedsemantics.flexspaces.component.createspace.CreateSpaceView;
    import org.integratedsemantics.flexspaces.component.wcm.createfolder.WcmCreateFolderPresenter;
    import org.integratedsemantics.flexspaces.component.wcm.createfolder.WcmCreateFolderView;
    import org.integratedsemantics.flexspaces.control.event.ui.CreateSpaceUIEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    

    /**
     * Display the UI for creating a space/folder
     * 
     */
    public class CreateSpaceUICommand extends Command
    {
        protected var model : AppModelLocator = AppModelLocator.getInstance();

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
                var createSpacePresenter:CreateSpacePresenter = new CreateSpacePresenter(createSpaceView, parentNode, event.onComplete);
            }                        
            else
            {
                var createFolderView:WcmCreateFolderView = WcmCreateFolderView(PopUpManager.createPopUp(event.parent, WcmCreateFolderView, false));
                var createFolderPresenter:WcmCreateFolderPresenter = new WcmCreateFolderPresenter(createFolderView, parentNode, event.onComplete);
            }                   
        }
        
    }
}
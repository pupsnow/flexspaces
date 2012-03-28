package org.integratedsemantics.flexspaces.control.command.ui
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.presmodel.tasks.startworkflow.StartWorkflowPresModel;
    import org.integratedsemantics.flexspaces.view.tasks.startworkflow.StartWorkflowView;
    import org.integratedsemantics.flexspaces.control.event.ui.StartWorkflowUIEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    

    /**
     * Display the UI for Start Workflow on a document
     * 
     */
    public class StartWorkflowUICommand extends Command
    {
        protected var model : AppModelLocator = AppModelLocator.getInstance();

        /**
         * Constructor
         */
        public function StartWorkflowUICommand()
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
                case StartWorkflowUIEvent.START_WORKFLOW_UI:
                    startWorkflowUI(event as StartWorkflowUIEvent); 
                    break;
            }
        }       

        /**
         * Start Workflow UI
         * 
         * @param event start workflow UI event
         */
        public function startWorkflowUI(event:StartWorkflowUIEvent):void
        {
            var selectedItem:Object = event.selectedItem;
            
            if (selectedItem != null)
            {
                if (selectedItem.isFolder != true)
                {
                    var startWorkflowView:StartWorkflowView = StartWorkflowView(PopUpManager.createPopUp(event.parent, StartWorkflowView, false));
                    var startWorkflowPresModel:StartWorkflowPresModel = new StartWorkflowPresModel(selectedItem  as IRepoNode);
                    startWorkflowView.startWorkflowPresModel = startWorkflowPresModel;
                    startWorkflowView.onComplete = event.onComplete;
                }
            }
        }
        
    }
}
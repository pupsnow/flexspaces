package org.integratedsemantics.flexspaces.control.command.ui
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.control.event.ui.DeleteNodesUIEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.presmodel.deletion.DeletePresModel;
    import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
    import org.integratedsemantics.flexspaces.view.deletion.DeleteView;
    

    /**
     * Display the UI for confirming deletion of multiple deleting multiple doc/folder nodes
     * 
     */
    public class DeleteUICommand extends Command
    {
        protected var model:FlexSpacesPresModel = AppModelLocator.getInstance().flexSpacesPresModel;

        /**
         * Constructor
         */
        public function DeleteUICommand()
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
                case DeleteNodesUIEvent.DELETE_NODES_UI:
                    deleteNodesUI(event as DeleteNodesUIEvent); 
                    break;
            }
        }       

        /**
         *  delete Nodes UI
         * 
         * @param event  delete nodes UI event
         */
        public function deleteNodesUI(event:DeleteNodesUIEvent):void
        {
            var selectedItems:Array = event.selectedItems;
            
            if (selectedItems != null && selectedItems.length > 0)
            {
                var deletePresModel:DeletePresModel = new DeletePresModel(selectedItems, model.wcmMode);
                var deleteView:DeleteView = DeleteView(PopUpManager.createPopUp(event.parent, DeleteView, false));
                deleteView.deletePresModel = deletePresModel;
                deleteView.onComplete = event.onComplete;
            }
        }
        
    }
}
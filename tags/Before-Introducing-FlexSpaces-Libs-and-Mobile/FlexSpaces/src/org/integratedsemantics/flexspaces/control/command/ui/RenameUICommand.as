package org.integratedsemantics.flexspaces.control.command.ui
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.control.event.ui.RenameNodeUIEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;
    import org.integratedsemantics.flexspaces.presmodel.rename.RenamePresModel;
    import org.integratedsemantics.flexspaces.view.rename.RenameView;

    

    /**
     * Display the UI for renaming a document/folder node
     * 
     */
    public class RenameUICommand extends Command
    {
        protected var model:FlexSpacesPresModel = AppModelLocator.getInstance().flexSpacesPresModel;

        /**
         * Constructor
         */
        public function RenameUICommand()
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
                case RenameNodeUIEvent.RENAME_NODE_UI:
                    renameUI(event as RenameNodeUIEvent); 
                    break;
            }
        }       

        /**
         * Rename Node UI
         * 
         * @param event rename node UI event
         */
        public function renameUI(event:RenameNodeUIEvent):void
        {
            var selectedItem:Object = event.selectedItem;
            if (selectedItem != null)
            {
                var renameView:RenameView = RenameView(PopUpManager.createPopUp(event.parent, RenameView, false));
                var renamePresModel:RenamePresModel = new RenamePresModel(selectedItem as IRepoNode, model.wcmMode);
                renameView.renamePresModel = renamePresModel;                                      
                renameView.onComplete = event.onComplete;
            }            
        }
        
    }
}
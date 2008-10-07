package org.integratedsemantics.flexspaces.control.command.ui
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.component.properties.basic.PropertiesPresenter;
    import org.integratedsemantics.flexspaces.component.properties.basic.PropertiesView;
    import org.integratedsemantics.flexspaces.control.event.ui.PropertiesUIEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Display the properties UI for a document/folder node
     * 
     */
    public class PropertiesUICommand extends Command
    {
        protected var model : AppModelLocator = AppModelLocator.getInstance();

        /**
         * Constructor
         */
        public function PropertiesUICommand()
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
                case PropertiesUIEvent.PROPERTIES_UI:
                    propertiesUI(event as PropertiesUIEvent); 
                    break;
            }
        }       

        /**
         * Properties UI
         * 
         * @param event properties UI event
         */
        public function propertiesUI(event:PropertiesUIEvent):void
        {
            var selectedItem:Object = event.selectedItem;
            
            if (selectedItem != null)
            {
                var propertiesView:PropertiesView = PropertiesView(PopUpManager.createPopUp(event.parent, PropertiesView, false));
                var propertiesPresenter:PropertiesPresenter = new PropertiesPresenter(propertiesView, selectedItem as IRepoNode, model.wcmMode, event.onComplete);
            }
                       
        }
        
    }
}
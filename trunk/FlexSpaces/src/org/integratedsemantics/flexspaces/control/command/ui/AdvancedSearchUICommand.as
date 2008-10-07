package org.integratedsemantics.flexspaces.control.command.ui
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.component.search.advanced.AdvancedSearchPresenter;
    import org.integratedsemantics.flexspaces.component.search.advanced.AdvancedSearchView;
    import org.integratedsemantics.flexspaces.control.event.ui.AdvancedSearchUIEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    

    /**
     * Display the UI for advanced search
     * 
     */
    public class AdvancedSearchUICommand extends Command
    {
        protected var model : AppModelLocator = AppModelLocator.getInstance();

        /**
         * Constructor
         */
        public function AdvancedSearchUICommand()
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
                case AdvancedSearchUIEvent.ADVANCED_SEARCH_UI:
                    advancedSearchUI(event as AdvancedSearchUIEvent); 
                    break;
            }
        }       

        /**
         * Advanced Search UI
         * 
         * @param advanced search UI event
         */
        public function advancedSearchUI(event:AdvancedSearchUIEvent):void
        {
            var advSearchView:AdvancedSearchView = AdvancedSearchView(PopUpManager.createPopUp(event.parent, AdvancedSearchView, false));
            var advSearchPresenter:AdvancedSearchPresenter = new AdvancedSearchPresenter(advSearchView, event.onComplete); 
        }
        
    }
}
package org.integratedsemantics.flexspaces.control.command.ui
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.presmodel.properties.tagscategories.TagsCategoriesPresModel;
    import org.integratedsemantics.flexspaces.view.properties.tagscategories.TagsCategoriesView;
    import org.integratedsemantics.flexspaces.control.event.ui.TagsCategoriesUIEvent;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    

    /**
     * Display the UI for tagging and categorizing a document/folder node
     * 
     */
    public class TagsCategoriesUICommand extends Command
    {
        protected var model : AppModelLocator = AppModelLocator.getInstance();

        /**
         * Constructor
         */
        public function TagsCategoriesUICommand()
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
                case TagsCategoriesUIEvent.TAGS_CATEGORIES_UI:
                    tagsUI(event as TagsCategoriesUIEvent); 
                    break;
            }
        }       

        /**
         * Tags UI
         * 
         * @param event tags UI event
         */
        public function tagsUI(event:TagsCategoriesUIEvent):void
        {
            var selectedItem:Object = event.selectedItem;
            if (selectedItem != null)
            {
                var tagsCategoriesView:TagsCategoriesView = TagsCategoriesView(PopUpManager.createPopUp(event.parent, TagsCategoriesView, false));
                var tagsCategoriesPresModel:TagsCategoriesPresModel = new TagsCategoriesPresModel(selectedItem as IRepoNode);
                tagsCategoriesView.tagCategoriesPresModel = tagsCategoriesPresModel;
                tagsCategoriesView.onComplete = event.onComplete;                                       
            }            
        }
        
    }
}
package org.integratedsemantics.flexspaces.control.command
{	
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.CategoriesDelegate;
    import org.integratedsemantics.flexspaces.control.event.CategoriesEvent;
	
	
	/**
	 * Categories command provides operation to get one level of sub-category children for a given category
	 */
	public class CategoriesCommand extends Command
	{
        /**
         * Constructor
         */
        public function CategoriesCommand()
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
                case CategoriesEvent.GET_CATEGORIES:
                    getCategories(event as CategoriesEvent);  
                    break;
                case CategoriesEvent.GET_CATEGORY_PROPERTIES:
                    getCategoryProperties(event as CategoriesEvent);  
                    break;
                case CategoriesEvent.ADD_CATEGORY:
                    addCategory(event as CategoriesEvent);  
                    break;
                case CategoriesEvent.REMOVE_CATEGORY:
                    removeCategory(event as CategoriesEvent);  
                    break;
            }
        }       
        
		/**
		 * Gets sub-category data for category (one level of children) 
		 * 
		 * @param event categories event
		 * 
		 */
		public function getCategories(event:CategoriesEvent):void
		{
            var handlers:Callbacks = new Callbacks(onGetCategoriesSuccess, onFault);
            var delegate:CategoriesDelegate = new CategoriesDelegate(handlers);
            delegate.getCategories(event.repoNode);                  
		}
		
        /**
         * Gets categories assigned to a node
         * 
         * @param event categories event
         * 
         */
        public function getCategoryProperties(event:CategoriesEvent):void
        {
            var handlers:Callbacks = new Callbacks(onGetCategoriesSuccess, onFault);
            var delegate:CategoriesDelegate = new CategoriesDelegate(handlers);
            delegate.getCategoryProperties(event.repoNode);                  
        }        
        
        /**
         * Add a category to a node
         * 
         * @param event categories event
         * 
         */
        public function addCategory(event:CategoriesEvent):void
        {
            var handlers:Callbacks = new Callbacks(onGetCategoriesSuccess, onFault);
            var delegate:CategoriesDelegate = new CategoriesDelegate(handlers);
            delegate.addCategory(event.repoNode, event.categoryNode);                  
        }        

        /**
         * Remove a category from a node
         * 
         * @param event categories event
         * 
         */
        public function removeCategory(event:CategoriesEvent):void
        {
            var handlers:Callbacks = new Callbacks(onGetCategoriesSuccess, onFault);
            var delegate:CategoriesDelegate = new CategoriesDelegate(handlers);
            delegate.removeCategory(event.repoNode, event.categoryNode);                  
        }        

		/**
		 * onGetCategoriesSuccess event handler
		 * 
		 * @param event success event
		 */
		protected function onGetCategoriesSuccess(event:*):void
		{
            this.result(event.result);
		}
	}
	
}
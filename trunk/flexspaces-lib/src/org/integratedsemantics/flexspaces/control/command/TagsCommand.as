package org.integratedsemantics.flexspaces.control.command
{	
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.TagsDelegate;
    import org.integratedsemantics.flexspaces.control.event.TagsEvent;
	
		
	/**
	 * Tags Command provides listing the tags for a node
	 */
	public class TagsCommand extends Command
	{
        /**
         * Constructor
         */
        public function TagsCommand()
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
                case TagsEvent.GET_TAGS:
                    getTags(event as TagsEvent);  
                    break;
                case TagsEvent.ADD_TAG:
                    addTag(event as TagsEvent);  
                    break;
                case TagsEvent.REMOVE_TAG:
                    removeTag(event as TagsEvent);  
                    break;
            }
        }       

		/**
		 * Gets tags data for document / folder or all tags
		 * 
		 * @param event tags event 
		 */
		public function getTags(event:TagsEvent):void
		{
            var handlers:Callbacks = new Callbacks(onTagsDataSuccess, onFault);
            var delegate:TagsDelegate = new TagsDelegate(handlers);
            delegate.getTags(event.repoNode);                  
		}
		
        /**
         * Add tag to document / folder
         * 
         * @param event tags event 
         */
        public function addTag(event:TagsEvent):void
        {
            var handlers:Callbacks = new Callbacks(onTagsDataSuccess, onFault);
            var delegate:TagsDelegate = new TagsDelegate(handlers);
            delegate.addTag(event.tagName, event.repoNode);                  
        }

        /**
         * Remove tag from document / folder
         * 
         * @param event tags event 
         */
        public function removeTag(event:TagsEvent):void
        {
            var handlers:Callbacks = new Callbacks(onTagsDataSuccess, onFault);
            var delegate:TagsDelegate = new TagsDelegate(handlers);
            delegate.removeTag(event.tagName, event.repoNode);                  
        }

		/**
		 * onTagsDataSuccess event handler
		 * 
		 * @param event success event
		 */
		protected function onTagsDataSuccess(event:*):void
		{
            this.result(event.result);
		}

	}
	
}
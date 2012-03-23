package org.integratedsemantics.flexspaces.control.command
{	
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.SemanticTagsDelegate;
    import org.integratedsemantics.flexspaces.control.event.SemanticTagsEvent;
    import org.integratedsemantics.flexspaces.model.tree.SemanticTagTreeNode;
	
		
	/**
	 * Semantic Tags Command provides listing  ofthe semantic tags for a node, and add/remove semantic tag from a node
	 */
	public class SemanticTagsCommand extends Command
	{
        /**
         * Constructor
         */
        public function SemanticTagsCommand()
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
                case SemanticTagsEvent.GET_SEMANTIC_TAGS:
                    getSemanticTags(event as SemanticTagsEvent);  
                    break;
                case SemanticTagsEvent.ADD_SEMANTIC_TAG:
                    addSemanticTag(event as SemanticTagsEvent);  
                    break;
                case SemanticTagsEvent.REMOVE_SEMANTIC_TAG:
                    removeSemanticTag(event as SemanticTagsEvent);  
                    break;
                case SemanticTagsEvent.AUTO_SEMANTIC_TAG:
                    autoSemanticTag(event as SemanticTagsEvent);  
                    break;
                case SemanticTagsEvent.GET_SEMANTIC_TAG_TREE:
                    getSemanticTagTree(event as SemanticTagsEvent);  
                    break;
                case SemanticTagsEvent.GET_NODE_SEMANTIC_TAGS:
                    getNodeSemanticTags(event as SemanticTagsEvent);
                    break;  
                case SemanticTagsEvent.SUGGEST_SEMANTIC_TAGS:
                    suggestSemanticTags(event as SemanticTagsEvent);  
                    break;
                case SemanticTagsEvent.ADD_NEW_SEMANTIC_TAG:
                    addNewSemanticTag(event as SemanticTagsEvent);  
                    break;
            }
        }       

		/**
		 * Gets semantic tags data (for semantic tag clouds)
		 * (and tags are a particular semantic category or all semantic categories)
		 * 
		 * @param event semantic tags event 
		 */
		public function getSemanticTags(event:SemanticTagsEvent):void
		{
            var handlers:Callbacks = new Callbacks(onTagsDataSuccess, onFault);
            var delegate:SemanticTagsDelegate = new SemanticTagsDelegate(handlers);
            delegate.getSemanticTags(event.semanticCategory);               
		}
		

		/**
		 * Gets semantic tags assigned to a given node
		 * 
		 * @param event semantic tags event 
		 */
		public function getNodeSemanticTags(event:SemanticTagsEvent):void
		{
            var handlers:Callbacks = new Callbacks(onTagsDataSuccess, onFault);
            var delegate:SemanticTagsDelegate = new SemanticTagsDelegate(handlers);
            delegate.getNodeSemanticTags(event.repoNode);               
		}

		/**
		 * Auto semantic tag document
		 * 
		 * @param event semantic tags event 
		 */
		public function autoSemanticTag(event:SemanticTagsEvent):void
		{
            var handlers:Callbacks = new Callbacks(onTagsDataSuccess, onFault);
            var delegate:SemanticTagsDelegate = new SemanticTagsDelegate(handlers);
            delegate.autoTag(event.repoNode);               
		}

		/**
		 * Suggest semantic tags for a document
		 * 
		 * @param event semantic tags event 
		 */
		public function suggestSemanticTags(event:SemanticTagsEvent):void
		{
            var handlers:Callbacks = new Callbacks(onTagsDataSuccess, onFault);
            var delegate:SemanticTagsDelegate = new SemanticTagsDelegate(handlers);
            delegate.suggestTags(event.repoNode);               
		}

        /**
         * Add semantic new semantic tag
         * 
         * @param event semantic tags event 
         */
        public function addNewSemanticTag(event:SemanticTagsEvent):void
        {
            var handlers:Callbacks = new Callbacks(onTagsDataSuccess, onFault);
            var delegate:SemanticTagsDelegate = new SemanticTagsDelegate(handlers);
            var t:SemanticTagTreeNode = event.semanticTagTreeNode;
            delegate.addNewSemanticTag(t.name, event.semanticCategory, event.repoNode, t.normalizedName,
							           t.latitude, t.longitude, t.uri, t.website, t.ticker);                  
        }

        /**
         * Add semantic tag to document / folder
         * 
         * @param event semantic tags event 
         */
        public function addSemanticTag(event:SemanticTagsEvent):void
        {
            var handlers:Callbacks = new Callbacks(onTagsDataSuccess, onFault);
            var delegate:SemanticTagsDelegate = new SemanticTagsDelegate(handlers);
            delegate.addSemanticTag(event.repoNode, event.tagNode);                  
        }

        /**
         * Remove semantic tag from document / folder
         * 
         * @param event semantic tags event 
         */
        public function removeSemanticTag(event:SemanticTagsEvent):void
        {
            var handlers:Callbacks = new Callbacks(onTagsDataSuccess, onFault);
            var delegate:SemanticTagsDelegate = new SemanticTagsDelegate(handlers);
            delegate.removeSemanticTag(event.repoNode, event.tagNode);                  
        }

		/**
		 * Gets semantic tag category/tag tree data, one level of children
		 * a time from a given semantic tag cateogry tree node) 
		 * 
		 * @param event semantic tags event 
		 */
		public function getSemanticTagTree(event:SemanticTagsEvent):void
		{
            var handlers:Callbacks = new Callbacks(onTagsDataSuccess, onFault);
            var delegate:SemanticTagsDelegate = new SemanticTagsDelegate(handlers);
            delegate.getSemanticTagTree(event.repoNode);               
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
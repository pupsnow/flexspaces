package org.integratedsemantics.flexspaces.model.tasks
{
    import org.integratedsemantics.flexspaces.model.folder.NodeCollection;    
    
    
    /**
     * Collection of node documents attached to a task 
     * This is used as the model for the task attachments sub view
     * 
     */
    [Bindable] 
    public class AttachmentsCollection extends NodeCollection
    {       
        /**
         * Constructor 
         * 
         */
        public function AttachmentsCollection()
        {
            super();
        }
        
        /**
         * Inits with task attachment data
         * 
         * @param data  task attachments data
         */
        public function initData(data:Object):void
        {
            var result:AttachmentsCollection = data as AttachmentsCollection;

			this.nodeCollection = result.nodeCollection;                
            result.nodeCollection = null;
            
            this.source = nodeCollection.source;
            this.refresh();
        }
                       
    }
}

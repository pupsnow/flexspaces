package org.integratedsemantics.flexspaces.model.checkedout
{
    import org.integratedsemantics.flexspaces.model.folder.NodeCollection;    
    
    
    /**
     * Collection of nodes in checked out list for current user 
     * Used as the model for checked out list view / pres model
     * 
     */
    [Bindable] 
    public class CheckedOutCollection extends NodeCollection
    {       
        /**
         * Constructor
         * 
         */
        public function CheckedOutCollection()
        {
            super();
        }
        
        /**
         * Inits with search results data
         * 
         * @data   search results data
         */
        public function initData(data:Object):void
        {
            var result:CheckedOutCollection = data as CheckedOutCollection;
            
			this.nodeCollection = result.nodeCollection;                
            result.nodeCollection = null;

            this.source = nodeCollection.source;
            this.refresh();
        }
                       
    }
}

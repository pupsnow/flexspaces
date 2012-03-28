package org.integratedsemantics.flexspaces.model.versionlist
{
    import org.integratedsemantics.flexspaces.model.folder.NodeCollection;    
    
    
    /**
     * Collection of nodes in version history list 
     * Used as the model for the version list view
     * 
     */
    [Bindable] 
    public class VersionHistoryCollection extends NodeCollection
    {       
        /**
         * Constructor
         * 
         */
        public function VersionHistoryCollection()
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
            var result:VersionHistoryCollection = data as VersionHistoryCollection;
            
			this.nodeCollection = result.nodeCollection;                
            result.nodeCollection = null;

            this.source = nodeCollection.source;
            this.refresh();
        }
                       
    }
}

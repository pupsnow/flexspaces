package org.integratedsemantics.flexspaces.model.favorites
{
    import org.integratedsemantics.flexspaces.model.folder.NodeCollection;    
    
    
    /**
     * Collection of nodes in users shortcut favorites list 
     * Used as the model for the favorites view
     * 
     */
    [Bindable] 
    public class FavoritesCollection extends NodeCollection
    {      	    
        /**
         * Constructor
         * 
         */
        public function FavoritesCollection()
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
            var result:FavoritesCollection = data as FavoritesCollection;

 			this.nodeCollection = result.nodeCollection;                
            result.nodeCollection = null;   
                     
            this.source = nodeCollection.source;
            this.refresh();
        }
                       
    }
}

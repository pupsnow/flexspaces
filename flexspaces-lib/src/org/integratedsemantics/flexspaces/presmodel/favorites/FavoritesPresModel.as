 
package org.integratedsemantics.flexspaces.presmodel.favorites
{
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.control.event.FavoritesEvent;
    import org.integratedsemantics.flexspaces.model.favorites.FavoritesCollection;
    import org.integratedsemantics.flexspaces.model.folder.Node;
    import org.integratedsemantics.flexspaces.presmodel.folderview.NodeListViewPresModel;


	/**
	 * Presentation model of user's favorites/shortcuts
	 * 
	 */	 	
	[Bindable] 
	public class FavoritesPresModel extends NodeListViewPresModel
	{	    		    
	    /**
	     * Constructor 
	     * 
	     */
	    public function FavoritesPresModel()
	    {
	        super();
        }
     	
        /**
         * Initialize model 
         * 
         */
        override public function initModel():void
        {
            this.nodeCollection = new FavoritesCollection();              
        }

        /**
         * Get latest favorites list data from server to redraw with 
         * 
         */
        public function redraw():void
        {
            var responder:Responder = new Responder(onResultGetFavoritesList, onFaultFavoritesList);
            var favoritesEvent:FavoritesEvent = new FavoritesEvent(FavoritesEvent.LIST_FAVORITES, responder);
            favoritesEvent.dispatch();                                
        }

        /**
         * Handle return of favorites list data
         * 
         * @param data favorites list data
         * 
         */
        protected function onResultGetFavoritesList(data:Object):void
        {
		    var resultsCollection:FavoritesCollection = this.nodeCollection as FavoritesCollection; 
		    resultsCollection.initData(data);
		    
            // set showThumbnail flags on nodes
            for each (var node:Node in nodeCollection)
            {
                node.showThumbnail = showThumbnails;
            }                                
        }
        
        /**
         * Handler for error on return of favorites list data 
         * 
         * @param info fault information
         * 
         */
        protected function onFaultFavoritesList(info:Object):void
        {
            trace("onFaultFavoritesList" + info);            
        }
		
     }
}
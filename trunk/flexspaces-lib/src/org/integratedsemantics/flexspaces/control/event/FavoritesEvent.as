package org.integratedsemantics.flexspaces.control.event
{
    import com.universalmind.cairngorm.events.UMEvent;
    
    import mx.rpc.IResponder;
    
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;


    /**
     * Event to request favorites/shortcuts operations 
     * 
     */
    public class FavoritesEvent extends UMEvent
    {
        /** Event name */
        public static const LIST_FAVORITES:String = "listFavorites";
        public static const NEW_FAVORITE:String = "newFavorite";
        public static const DELETE_FAVORITE:String = "deleteFavorite";

        public var repoNode:IRepoNode;

        /**
         * Constructor
         *  
         * @param eventType event name
         * @param handlers handlers responder with result and fault handlers
         * @param repoNode node to add/remove favorite for
         * 
         */
        public function FavoritesEvent(eventType:String, handlers:IResponder, repoNode:IRepoNode=null)
        {
            super(eventType, handlers);
            
            this.repoNode = repoNode;
        }       
        
    }
}
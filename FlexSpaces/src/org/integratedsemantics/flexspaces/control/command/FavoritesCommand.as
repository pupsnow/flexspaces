package org.integratedsemantics.flexspaces.control.command
{
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.universalmind.cairngorm.commands.Command;
    import com.universalmind.cairngorm.events.Callbacks;
    
    import org.integratedsemantics.flexspaces.control.delegate.webscript.FavoritesDelegate;
    import org.integratedsemantics.flexspaces.control.event.FavoritesEvent;


    /**
     * Favorites Command provides operations on favorites/shortcuts 
     */
    public class FavoritesCommand extends Command
    {
        /**
         * Constructor
         */
        public function FavoritesCommand()
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
                case FavoritesEvent.LIST_FAVORITES:
                    getFavoritesList(event as FavoritesEvent);  
                    break;
                case FavoritesEvent.NEW_FAVORITE:
                    newFavorite(event as FavoritesEvent);  
                    break;
                case FavoritesEvent.DELETE_FAVORITE:
                    deleteFavorite(event as FavoritesEvent);  
                    break;
            }
        }       

        /**
         * Get list of favorites / shortcuts for current user
         * 
         * @param event favorites event
         */
        public function getFavoritesList(event:FavoritesEvent):void
        {
            var handlers:Callbacks = new Callbacks(onFavoritesActionSuccess, onFault);
            var delegate:FavoritesDelegate = new FavoritesDelegate(handlers);
            delegate.getFavoritesList();                  
        }

        /**
         * Add new favorite / shortcut
         * 
         * @param event favorites event
         */
        public function newFavorite(event:FavoritesEvent):void
        {
            var handlers:Callbacks = new Callbacks(onFavoritesActionSuccess, onFault);
            var delegate:FavoritesDelegate = new FavoritesDelegate(handlers);
            delegate.newFavorite(event.repoNode);                  
        }

        /**
         * Delete favorite / shortcut
         * 
         * @param event favorites event
         */
        public function deleteFavorite(event:FavoritesEvent):void
        {
            var handlers:Callbacks = new Callbacks(onFavoritesActionSuccess, onFault);
            var delegate:FavoritesDelegate = new FavoritesDelegate(handlers);
            delegate.deleteFavorite(event.repoNode);                  
        }
        
        /**
         * onFavoritesActionSuccess event handler
         * 
         * @param event success event
         */
        protected function onFavoritesActionSuccess(event:*):void
        {
            this.result(event.result);
        }
        
    }
}
package org.integratedsemantics.flexspaces.view.wcm.folderview
{
    import flash.events.Event;
    
    import mx.rpc.Responder;
    
    import org.integratedsemantics.flexspaces.presmodel.wcm.folderview.WcmFolderViewPresModel;
    import org.integratedsemantics.flexspaces.view.folderview.FolderViewBase;
    import org.integratedsemantics.flexspaces.view.menu.contextmenu.ConfigurableContextMenu;


    /**
     * Folder view base class 
     * 
     */
    public class WcmFolderViewBase extends FolderViewBase
    {       
        /**
         * Constructor 
         * 
         */
        public function WcmFolderViewBase()
        {
            super();
        }        

        /**
         * Getter for the wcm folder view pres model
         *  
         * @return the pres model
         * 
         */
        [Bindable] 
        public function get wcmFolderViewPresModel():WcmFolderViewPresModel
        {
            return this.folderViewPresModel as WcmFolderViewPresModel;            
        }       

        public function set wcmFolderViewPresModel(wcmFolderViewPresModel:WcmFolderViewPresModel):void
        {
            this.folderViewPresModel = wcmFolderViewPresModel;            
        }       

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:Event):void
        {
           super.onCreationComplete(event);           
        }
        
        /**
         * Initialize context menus 
         * 
         */
        override protected function initContextMenu():void
        {
        	var srcPath:String = wcmFolderViewPresModel.model.appConfig.srcPath;
        	var locale:String = wcmFolderViewPresModel.model.appConfig.locale;

            fileContextMenu = new ConfigurableContextMenu(wcmFolderViewPresModel, this, srcPath + "config/" + locale + "/contextmenu/wcmfolderview/fileContextMenu.xml");
            folderContextMenu = new ConfigurableContextMenu(wcmFolderViewPresModel, this, srcPath + "config/" + locale + "/contextmenu/wcmfolderview/folderContextMenu.xml");
            
            folderIconView.folderTileList.contextMenu = fileContextMenu.contextMenu;         
            folderGridView.folderGrid.contextMenu = fileContextMenu.contextMenu;                    
        }        

        override public function initPaging():void
        {
            // wcm currently uses clientside paging so paging init related to server side paging not needed
        }
        
        override protected function onPageSizeChange(event:Event):void
        {
            folderViewPresModel.model.flexSpacesPresModel.wcmPageSize = event.target.value;            
            pageBar.curPageIndex = 0;            
        }
        
    }
}
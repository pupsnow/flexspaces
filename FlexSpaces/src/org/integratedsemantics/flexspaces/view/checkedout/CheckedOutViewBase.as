package org.integratedsemantics.flexspaces.view.checkedout
{   
    import flash.events.Event;
    
    import org.integratedsemantics.flexspaces.presmodel.checkedout.CheckedOutPresModel;
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.view.folderview.NodeListViewBase;
    import org.integratedsemantics.flexspaces.view.folderview.event.ClickNodeEvent;
    import org.integratedsemantics.flexspaces.view.folderview.event.DoubleClickDocEvent;
    import org.integratedsemantics.flexspaces.view.menu.contextmenu.ConfigurableContextMenu;

        
    /**
     * Checked out list base view class 
     * 
     */
    public class CheckedOutViewBase extends  NodeListViewBase
    {
        /**
         * Constructor 
         * 
         */
        public function CheckedOutViewBase()
        {
            super();
        }

        [Bindable] 
        public function get checkedOutPresModel():CheckedOutPresModel
        {
            return this.nodeListViewPresModel as CheckedOutPresModel;            
        }       

        public function set checkedOutPresModel(checkedOutPresModel:CheckedOutPresModel):void
        {
            this.nodeListViewPresModel = checkedOutPresModel;            
        } 
                               
        
        /**
         * Handle creation complete 
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
        	var srcPath:String = checkedOutPresModel.model.appConfig.srcPath;
        	var locale:String = checkedOutPresModel.model.appConfig.locale;
            
            fileContextMenu = new ConfigurableContextMenu(checkedOutPresModel, this, srcPath + "config/" + locale + "/contextmenu/folderview/fileContextMenu.xml");
            
            folderIconView.folderTileList.contextMenu = fileContextMenu.contextMenu;         
            folderGridView.folderGrid.contextMenu = fileContextMenu.contextMenu;                    
        }        

        public function redraw():void
        {
        	checkedOutPresModel.initCheckedOutList();	
        }    
        
        protected function onPageSizeChange(event:Event):void
        {
            checkedOutPresModel.model.flexSpacesPresModel.checkedOutPageSize = event.target.value;            
            pageBar.curPageIndex = 0;
        }
        
    }
}
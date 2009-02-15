package org.integratedsemantics.flexspaces.view.folderview.iconview
{
    import mx.containers.VBox;
    import mx.controls.NumericStepper;
    import mx.controls.TileList;
    
    import org.integratedsemantics.flexspaces.presmodel.folderview.NodeListViewPresModel;
    import org.integratedsemantics.flexspaces.view.folderview.paging.Pager;
    import org.integratedsemantics.flexspaces.view.folderview.paging.PagerBar;

    /**
     * Folder grid base view class 
     * 
     */
    public class FolderIconViewBase extends VBox
    {
        [Bindable] public var nodeListViewPresModel:NodeListViewPresModel;
        
        public var folderTileList:TileList;
                
        public var showThumbnails:Boolean = false;
       
        [Bindable]
        public var dataProvider:Object;    

                
        /**
         * Constructor 
         * 
         */
        public function FolderIconViewBase()
        {
            super();
        }

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
        }        
                
        protected function onChange(event:Event):void
        {
			nodeListViewPresModel.changeSelection(folderTileList.selectedItem, folderTileList.selectedItems);      
        }
        
    }
}
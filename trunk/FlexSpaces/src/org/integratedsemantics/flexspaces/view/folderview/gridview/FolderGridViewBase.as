package org.integratedsemantics.flexspaces.view.folderview.gridview
{
    import mx.containers.VBox;
    import mx.controls.DataGrid;
    
    import org.integratedsemantics.flexspaces.presmodel.folderview.NodeListViewPresModel;
    import org.integratedsemantics.flexspaces.view.folderview.paging.Pager;
    import org.integratedsemantics.flexspaces.view.folderview.paging.PagerBar;

        
    /**
     * Folder grid base view class 
     * 
     */
    public class FolderGridViewBase extends  VBox
    {
        [Bindable] public var nodeListViewPresModel:NodeListViewPresModel;

        [Bindable] public var pageSize:uint = 10;
                
        public var folderGrid:DataGrid;
        
        [Bindable] public var pager:Pager;
        
        public var pageBar:PagerBar;
        
        
        /**
         * Constructor 
         * 
         */
        public function FolderGridViewBase()
        {
            super();
        }

        protected function onChange(event:Event):void
        {
			nodeListViewPresModel.changeSelection(folderGrid.selectedItem, folderGrid.selectedItems);      
        }
        
    }
}
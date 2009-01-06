package org.integratedsemantics.flexspaces.view.folderview.coverflow
{
    import com.dougmccune.containers.CoverFlowContainer;
    
    import mx.containers.VBox;
    import mx.controls.DataGrid;
    import mx.core.Repeater;
    
    import org.integratedsemantics.flexspaces.presmodel.folderview.NodeListViewPresModel;
    import org.integratedsemantics.flexspaces.view.folderview.paging.Pager;
    import org.integratedsemantics.flexspaces.view.folderview.paging.PagerBar;

        
    /**
     * Folder grid base view class 
     * 
     */
    public class CoverFlowViewBase extends  VBox
    {
        [Bindable] public var nodeListViewPresModel:NodeListViewPresModel;
        
        public var coverFlowContainer:CoverFlowContainer;  
        [Bindable] public var coverFlowRepeater:Repeater;      
        public var coverFlowDataGrid:DataGrid;      
                  
        [Bindable] public var pageSize:uint = 10;
                        
        [Bindable] public var pager:Pager;
        
        public var pageBar:PagerBar;

        
        /**
         * Constructor 
         * 
         */
        public function CoverFlowViewBase()
        {
            super();
        }
        
        protected function onChange(event:Event):void
        {
			nodeListViewPresModel.changeSelection(coverFlowDataGrid.selectedItem, coverFlowDataGrid.selectedItems);      
        }
        
    }
}
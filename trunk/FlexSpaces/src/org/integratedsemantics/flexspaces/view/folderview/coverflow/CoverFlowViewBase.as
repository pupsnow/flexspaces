package org.integratedsemantics.flexspaces.view.folderview.coverflow
{
    import com.dougmccune.containers.CoverFlowContainer;
    
    import flash.events.Event;
    
    import mx.containers.VBox;
    import mx.controls.DataGrid;
    import mx.controls.NumericStepper;
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
                  
        [Bindable]
        public var dataProvider:Object;    
        
                
        /**
         * Constructor 
         * 
         */
        public function CoverFlowViewBase()
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
			nodeListViewPresModel.changeSelection(coverFlowDataGrid.selectedItem, coverFlowDataGrid.selectedItems);      
        }
        
    }
}
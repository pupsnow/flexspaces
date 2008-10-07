package org.integratedsemantics.flexspaces.component.folderview.coverflow
{
    import com.dougmccune.containers.CoverFlowContainer;
    
    import mx.containers.VBox;
    import mx.controls.DataGrid;
    import mx.core.Repeater;
    
    import org.integratedsemantics.flexspaces.component.folderview.paging.Pager;
    import org.integratedsemantics.flexspaces.component.folderview.paging.PagerBar;
    import org.integratedsemantics.flexspaces.model.folder.NodeCollection;

        
    /**
     * Folder grid base view class 
     * 
     */
    public class CoverFlowViewBase extends  VBox
    {
        [Bindable] public var repoFolderCollection:NodeCollection;
        
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
        
    }
}
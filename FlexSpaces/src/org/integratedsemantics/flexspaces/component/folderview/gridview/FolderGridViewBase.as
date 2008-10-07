package org.integratedsemantics.flexspaces.component.folderview.gridview
{
    import mx.containers.VBox;
    import mx.controls.DataGrid;
    
    import org.integratedsemantics.flexspaces.component.folderview.paging.Pager;
    import org.integratedsemantics.flexspaces.component.folderview.paging.PagerBar;
    import org.integratedsemantics.flexspaces.model.folder.NodeCollection;

        
    /**
     * Folder grid base view class 
     * 
     */
    public class FolderGridViewBase extends  VBox
    {
        [Bindable] public var repoFolderCollection:NodeCollection;

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
        
    }
}
package org.integratedsemantics.flexspaces.component.folderview.iconview
{
    import mx.containers.VBox;
    import mx.controls.TileList;
    
    import org.integratedsemantics.flexspaces.component.folderview.paging.Pager;
    import org.integratedsemantics.flexspaces.component.folderview.paging.PagerBar;
    import org.integratedsemantics.flexspaces.model.folder.NodeCollection;

    /**
     * Folder grid base view class 
     * 
     */
    public class FolderIconViewBase extends VBox
    {
        [Bindable] public var repoFolderCollection:NodeCollection;
        
        public var folderTileList:TileList;
                
        public var showThumbnails:Boolean = false;

        [Bindable] public var pageSize:uint = 10;
                        
        [Bindable] public var pager:Pager;
        
        public var pageBar:PagerBar;

                
        /**
         * Constructor 
         * 
         */
        public function FolderIconViewBase()
        {
            super();
        }
        
    }
}
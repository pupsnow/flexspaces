package org.integratedsemantics.flexspaces.component.versions.versionlist
{
    import mx.containers.VBox;
    import mx.controls.DataGrid;
    
    import org.integratedsemantics.flexspaces.model.folder.NodeCollection;

        
    /**
     * Folder grid base view class 
     * 
     */
    public class VersionListViewBase extends  VBox
    {
        [Bindable] public var repoFolderCollection:NodeCollection;
                
        public var versionListGrid:DataGrid;
                
        
        /**
         * Constructor 
         * 
         */
        public function VersionListViewBase()
        {
            super();
        }
        
    }
}
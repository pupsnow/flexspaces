package org.integratedsemantics.flexspaces.component.folderview
{
    import com.decoursey.components.BreadcrumbDisplay;
    
    import mx.containers.Canvas;
    import mx.containers.HBox;
    import mx.containers.ViewStack;
    
    import org.integratedsemantics.flexspaces.component.folderview.coverflow.CoverFlowViewBase;
    import org.integratedsemantics.flexspaces.component.folderview.gridview.FolderGridViewBase;
    import org.integratedsemantics.flexspaces.component.folderview.iconview.FolderIconViewBase;
    import org.integratedsemantics.flexspaces.component.folderview.viewmodebar.ViewModeBarViewBase;

    /**
     * Folder view base class 
     * 
     */
    public class FolderViewBase extends Canvas
    {       
        public var breadCrumbAreaBox:HBox;
        public var breadCrumb:BreadcrumbDisplay;
        
        public var viewModeBar:ViewModeBarViewBase;
        
        public var folderViewStack:ViewStack;
        
        public var folderIconView:FolderIconViewBase;
        
        public var folderGridView:FolderGridViewBase;
        
        public var coverFlowView:CoverFlowViewBase;

        public var showThumbnails:Boolean = false;

        
        /**
         * Constructor 
         * 
         */
        public function FolderViewBase()
        {
            super();
        }
        
    }
}
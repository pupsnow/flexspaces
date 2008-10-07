package org.integratedsemantics.flexspacesair.component.localfiles
{
    import com.decoursey.components.BreadcrumbDisplay;
    
    import mx.containers.HDividedBox;
    import mx.containers.VBox;
    import mx.controls.Button;
    import mx.controls.FileSystemDataGrid;
    import mx.controls.FileSystemHistoryButton;
    import mx.controls.FileSystemTree;
    

    /**
     * Base class for local files browser views  
     * 
     */
    public class LocalFilesBrowserViewBase extends HDividedBox
    {
        public var localfilestree:FileSystemTree;
        
        public var localfilesfolderlist:VBox;       
        
        public var backBtn:FileSystemHistoryButton;        
        public var forwardBtn:FileSystemHistoryButton;
        public var upBtn:Button;
        
        public var localFileBreadCrumb:BreadcrumbDisplay;
        
        [Bindable] public var localFileGrid:FileSystemDataGrid; 


        /**
         * Constructor 
         */
        public function LocalFilesBrowserViewBase()
        {
            super();
        }        
    }
}
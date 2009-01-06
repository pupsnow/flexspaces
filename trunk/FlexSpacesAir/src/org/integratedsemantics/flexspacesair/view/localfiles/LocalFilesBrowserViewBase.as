package org.integratedsemantics.flexspacesair.view.localfiles
{
    import com.decoursey.components.BreadcrumbDisplay;
    import com.decoursey.components.event.BreadcrumbDisplayEvent;
    
    import flash.events.Event;
    import flash.filesystem.File;
    
    import mx.containers.HDividedBox;
    import mx.containers.VBox;
    import mx.controls.Button;
    import mx.controls.FileSystemDataGrid;
    import mx.controls.FileSystemHistoryButton;
    import mx.controls.FileSystemTree;
    import mx.events.FileEvent;
    
    import org.integratedsemantics.flexspacesair.presmodel.localfiles.LocalFilesBrowserPresModel;
    

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
        
        [Bindable]
        public var presModel:LocalFilesBrowserPresModel;


        /**
         * Constructor 
         */
        public function LocalFilesBrowserViewBase()
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
            this.localFileBreadCrumb.addEventListener(BreadcrumbDisplayEvent.BREADCRUMB_ACTION, onBreadCrumbClick);
            this.localFileGrid.addEventListener(FileEvent.DIRECTORY_CHANGE, onLocalFileGridChange);
            
            // setup initial path display in breadcrumb
            var fullPath:String = this.localFileGrid.directory.nativePath;
            this.localFileBreadCrumb.path = fullPath;            
        }                

        /**
         * Handle breadcrumb navigation by navigating file grid
         *  
         * @param event breadcrumb event
         * 
         */
        protected function onBreadCrumbClick(event:BreadcrumbDisplayEvent):void
        {
            var newPath:String = event.path;
            this.localFileGrid.navigateTo(new File(newPath));
        }
        
        /**
         * Handle navigation in local files grid by updating bread crumb and tree
         * 
         * @param event file control event
         * 
         */
        protected function onLocalFileGridChange(event:FileEvent):void
        {
            var fullPath:String = this.localFileGrid.directory.nativePath;
            this.localFileBreadCrumb.path = fullPath;
            this.localfilestree.openSubdirectory(this.localFileGrid.directory.nativePath);
            this.localfilestree.selectedPath = this.localFileGrid.directory.nativePath;
        }
        
        /**
         * Toggle the visibility of the local files tree 
         * 
         */
        public function showHideLocalFilesTree():void
        {
            if (this.localfilestree.visible == true)
            {
                this.localfilestree.visible = false;
                this.localfilestree.includeInLayout = false;
            }    
            else
            {
                this.localfilestree.visible = true;
                this.localfilestree.includeInLayout = true;
            }
            this.invalidateDisplayList();
        }
        
        /**
         * Toggle the visibility of the local files grid / nav controls
         * 
         */
        public function showHideLocalFilesFolder():void
        {
            if (this.localfilesfolderlist.visible == true)
            {
                this.localfilesfolderlist.visible = false;
                this.localfilesfolderlist.includeInLayout = false;
            }    
            else
            {
                this.localfilesfolderlist.visible = true;
                this.localfilesfolderlist.includeInLayout = true;
            }
            this.invalidateDisplayList();
        } 
         
    }
}
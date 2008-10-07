package org.integratedsemantics.flexspacesair.component.localfiles
{
    import com.decoursey.components.event.BreadcrumbDisplayEvent;
    
    import flash.events.Event;
    import flash.filesystem.File;
    
    import mx.events.FileEvent;
    
    import org.integratedsemantics.flexspaces.framework.presenter.Presenter;
    

    /**
     * Presenter for local files browser with tree and file grid
     * Uses air specific flex controls and file apis
     * 
     * Presenter/Controller of LocalFilesBrowserViewBase views
     */
    public class LocalFilesBrowserPresenter extends Presenter
    {
        /**
         * Constructor
         *  
         * @param localFilesView view to control
         * 
         */
        public function LocalFilesBrowserPresenter(localFilesView:LocalFilesBrowserViewBase)
        {
            super(localFilesView);
            
            if (localFilesView.initialized == true)
            {
                onCreationComplete(new Event(""));
            }
            else
            {
                observeCreation(localFilesView, onCreationComplete);            
            }
        }
        
        /**
         * Getter for the view
         *  
         * @return the view
         * 
         */
        protected function get localFilesView():LocalFilesBrowserViewBase
        {
            return this.view as LocalFilesBrowserViewBase;            
        }       

        /**
         * Handle view creation complete 
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:Event):void
        {
            localFilesView.localFileBreadCrumb.addEventListener(BreadcrumbDisplayEvent.BREADCRUMB_ACTION, onBreadCrumbClick);
            localFilesView.localFileGrid.addEventListener(FileEvent.DIRECTORY_CHANGE, onLocalFileGridChange);
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
            localFilesView.localFileGrid.navigateTo(new File(newPath));
        }
        
        /**
         * Handle navigation in local files grid by updating bread crumb and tree
         * 
         * @param event file control event
         * 
         */
        protected function onLocalFileGridChange(event:FileEvent):void
        {
            var fullPath:String = localFilesView.localFileGrid.directory.nativePath;
            localFilesView.localFileBreadCrumb.path = fullPath;
            localFilesView.localfilestree.openSubdirectory(localFilesView.localFileGrid.directory.nativePath);
            localFilesView.localfilestree.selectedPath = localFilesView.localFileGrid.directory.nativePath;
        }
        
        /**
         * Toggle the visibility of the local files tree 
         * 
         */
        public function showHideLocalFilesTree():void
        {
            if (localFilesView.localfilestree.visible == true)
            {
                localFilesView.localfilestree.visible = false;
                localFilesView.localfilestree.includeInLayout = false;
            }    
            else
            {
                localFilesView.localfilestree.visible = true;
                localFilesView.localfilestree.includeInLayout = true;
            }
            localFilesView.invalidateDisplayList();
        }
        
        /**
         * Toggle the visibility of the local files grid / nav controls
         * 
         */
        public function showHideLocalFilesFolder():void
        {
            if (localFilesView.localfilesfolderlist.visible == true)
            {
                localFilesView.localfilesfolderlist.visible = false;
                localFilesView.localfilesfolderlist.includeInLayout = false;
            }    
            else
            {
                localFilesView.localfilesfolderlist.visible = true;
                localFilesView.localfilesfolderlist.includeInLayout = true;
            }
            localFilesView.invalidateDisplayList();
        } 
        
    }
}
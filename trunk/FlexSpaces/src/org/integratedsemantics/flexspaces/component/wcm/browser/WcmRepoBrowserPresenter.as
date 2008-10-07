package org.integratedsemantics.flexspaces.component.wcm.browser
{
    import org.integratedsemantics.flexspaces.component.browser.RepoBrowserPresenter;
    import org.integratedsemantics.flexspaces.component.browser.RepoBrowserViewBase;
    
    import org.integratedsemantics.flexspaces.component.wcm.folderview.WcmFolderViewPresenter;
    import org.integratedsemantics.flexspaces.component.wcm.tree.WcmTreePresenter;


    /**
     * Presenter for wcm repository tree/dual folder browser views
     *    
     * Presenter/Controller for WcmRepoBrowserViewBase views
     * 
     */
    public class WcmRepoBrowserPresenter extends RepoBrowserPresenter
    {
        /**
         * Constructor
         *  
         * @param browserView view to control
         * 
         */
        public function WcmRepoBrowserPresenter(browserView:RepoBrowserViewBase)
        {
            super(browserView);
        }
        
        /**
         * Override setup presenters to use different wcm presenter classes 
         * 
         */
        override protected function setupPresenters():void
        {
            this.treePresenter = new WcmTreePresenter(treeView);           
            this.folderViewPresenter1 = new WcmFolderViewPresenter(this.fileView1);     
            this.folderViewPresenter2 = new WcmFolderViewPresenter(this.fileView2);                         
        }        
        
    }
}
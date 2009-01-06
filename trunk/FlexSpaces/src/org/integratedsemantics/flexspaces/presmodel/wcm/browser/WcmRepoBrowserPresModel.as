package org.integratedsemantics.flexspaces.presmodel.wcm.browser
{
    import org.integratedsemantics.flexspaces.presmodel.browser.RepoBrowserPresModel;
    import org.integratedsemantics.flexspaces.presmodel.versions.versionlist.VersionListPresModel;
    import org.integratedsemantics.flexspaces.presmodel.wcm.folderview.WcmFolderViewPresModel;
    import org.integratedsemantics.flexspaces.presmodel.wcm.tree.WcmTreePresModel;


    /**
     * Presentation model for wcm repository tree/dual folder browser views
     *    
     */
    [Bindable] 
    public class WcmRepoBrowserPresModel extends RepoBrowserPresModel
    {
        /**
         * Constructor
         *  
         */
        public function WcmRepoBrowserPresModel()
        {
            super();
        }
        
        /**
         * Override setup presentation model to use different wcm presentation model classes 
         * 
         */
        override protected function setupSubViewModels():void
        {
            this.treePresModel = new WcmTreePresModel();           
            this.folderViewPresModel1 = new WcmFolderViewPresModel();     
            this.folderViewPresModel2 = new WcmFolderViewPresModel(); 
            // todo need special wcm version list presentation model?
            versionListPresModel = new VersionListPresModel();    
        }    
        
        // get / setter for wcm folder view 1 pres model
        
        public function get wcmFolderViewPresModel1():WcmFolderViewPresModel
        {
            return this.folderViewPresModel1 as WcmFolderViewPresModel;            
        }       

        public function set wcmFolderViewPresModel1(wcmFolderViewPresModel1:WcmFolderViewPresModel):void
        {
            this.folderViewPresModel1 = wcmFolderViewPresModel1;  
        }       
        
        // get / setter for wcm folder view 2 pres model

        public function get wcmFolderViewPresModel2():WcmFolderViewPresModel
        {
            return this.folderViewPresModel2 as WcmFolderViewPresModel;            
        }       

        public function set wcmFolderViewPresModel2(wcmFolderViewPresModel2:WcmFolderViewPresModel):void
        {
            this.folderViewPresModel2 = wcmFolderViewPresModel1;  
        }       
                
        // get / setter for wcm tree pres model

        public function get wcmTreePresModel():WcmTreePresModel
        {
            return this.treePresModel as WcmTreePresModel;            
        }       

        public function set wcmTreePresModel(wcmTreePresModel:WcmTreePresModel):void
        {
            this.treePresModel = wcmTreePresModel;  
        }       
                    
    }
}
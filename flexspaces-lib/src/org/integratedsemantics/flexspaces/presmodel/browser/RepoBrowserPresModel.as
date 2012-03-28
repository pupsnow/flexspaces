package org.integratedsemantics.flexspaces.presmodel.browser
{
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.presmodel.folderview.FolderViewPresModel;
    import org.integratedsemantics.flexspaces.presmodel.tree.TreePresModel;
    import org.integratedsemantics.flexspaces.presmodel.versions.versionlist.VersionListPresModel;

    
    /**
     * Presentation Model for repository tree/dual folder browser views
     *    
     */
    [Bindable] 
    public class RepoBrowserPresModel extends PresModel
    {
        public var activeView:Boolean = false;

        public var treePresModel:TreePresModel;
        public var folderViewPresModel1:FolderViewPresModel;
        public var folderViewPresModel2:FolderViewPresModel;
        public var versionListPresModel:VersionListPresModel;

		public var showTree:Boolean = true;
		public var showDualFolders:Boolean = false;
		public var showVersionHistory:Boolean = false;
		
        public var model:AppModelLocator = AppModelLocator.getInstance();


        /**
         * Constructor
         *  
         */
        public function RepoBrowserPresModel()
        {
        	setupSubViewModels();
        }
        
        /**
         * Setup pres models for tree and each folder view 
         * 
         */
        protected function setupSubViewModels():void
        {
            treePresModel = new TreePresModel();           
            folderViewPresModel1 = new FolderViewPresModel();     
            folderViewPresModel2 = new FolderViewPresModel();   
            versionListPresModel = new VersionListPresModel();                      
        }   
                
        /**
         * Handle toggling the showing the tree pane 
         * 
         */
        public function showHideRepoTree():void
        {
            showTree = ! showTree;
        }
                     

    }
}
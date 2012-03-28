package org.integratedsemantics.flexspaces.presmodel.navpanel
{
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.presmodel.categories.tree.CategoryTreePresModel;
    import org.integratedsemantics.flexspaces.presmodel.favorites.FavoritesPresModel;
    import org.integratedsemantics.flexspaces.presmodel.search.results.SearchResultsPresModel;
    import org.integratedsemantics.flexspaces.presmodel.semantictags.map.SemanticTagMapPresModel;
    import org.integratedsemantics.flexspaces.presmodel.semantictags.semantictagcloud.SemanticTagCloudPresModel;
    import org.integratedsemantics.flexspaces.presmodel.tags.tagcloud.TagCloudPresModel;
    import org.integratedsemantics.flexspaces.presmodel.tree.TreePresModel;


    /**
     * Presentation model for panel company/user home trees, category tree, tag cloud, semantic tag clouds/map, and favorites
     * 
     */
    [Bindable] 
    public class NavPanelPresModel extends PresModel
    {       
        public var companyHomeTreePresModel:TreePresModel;
        public var userHomeTreePresModel:TreePresModel;        
        
        public var tagCloudPresModel:TagCloudPresModel;

        public var categoryTreePresModel:CategoryTreePresModel;
        
        public var semanticTagCloudPresModel:SemanticTagCloudPresModel;
        public var companySemanticTagCloudPresModel:SemanticTagCloudPresModel;
        public var personSemanticTagCloudPresModel:SemanticTagCloudPresModel;

        public var mapPresModel:SemanticTagMapPresModel;
        
        public var model:AppModelLocator = AppModelLocator.getInstance();

        public var favoritesPresModel:FavoritesPresModel;                         

                
        public function NavPanelPresModel()
        {
            super();           
        }
        
        /**
         * Setup sub view presentation models
         * 
         */
        public function setupSubViews():void
        {
            // setup company/user home trees
            companyHomeTreePresModel = new TreePresModel();               
            userHomeTreePresModel = new TreePresModel();               
            
            // setup category tree
            categoryTreePresModel = new CategoryTreePresModel();
            categoryTreePresModel.doSearchOnClick = true;    
            
            var version:Number = model.ecmServerConfig.serverVersionNum();
            
            // only setup tag cloud if 2.9 or greater since tagging content model added in 2.9
            if (version >= 2.9)
            {
                tagCloudPresModel = new TagCloudPresModel();            
                tagCloudPresModel.doSearchOnClick = true;
            }
            
            if (model.calaisConfig.enableCalais == true)
            {    
                semanticTagCloudPresModel = new SemanticTagCloudPresModel(null);            
                semanticTagCloudPresModel.doSearchOnClick = true;                                    
                
                companySemanticTagCloudPresModel = new SemanticTagCloudPresModel("Company");            
                companySemanticTagCloudPresModel.doSearchOnClick = true;                                    

                personSemanticTagCloudPresModel = new SemanticTagCloudPresModel("Person");            
                personSemanticTagCloudPresModel.doSearchOnClick = true;      
                
                if (model.googleMapConfig.enableGoogleMap == true)
                {
	                mapPresModel = new SemanticTagMapPresModel();                              
	                mapPresModel.doSearchOnClick = true;
                } 
            } 
            
            favoritesPresModel = new FavoritesPresModel();
        }                
                                                        
    }
}
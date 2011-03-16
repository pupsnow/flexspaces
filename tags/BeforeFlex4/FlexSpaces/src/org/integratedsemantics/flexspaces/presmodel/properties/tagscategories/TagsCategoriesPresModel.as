package org.integratedsemantics.flexspaces.presmodel.properties.tagscategories
{
    import org.integratedsemantics.flexspaces.framework.presmodel.PresModel;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;
    import org.integratedsemantics.flexspaces.presmodel.categories.properties.CategoryPropertiesPresModel;
    import org.integratedsemantics.flexspaces.presmodel.semantictags.properties.SemanticTagPropertiesPresModel;
    import org.integratedsemantics.flexspaces.presmodel.tags.properties.TagPropertiesPresModel;

    
    /**
     *  Presentation model for Tags/Categories properties dialog
     *  for viewing/editing tags and categories on a doc/folder
     *  
     */
    [Bindable] 
    public class TagsCategoriesPresModel extends PresModel
    {
        public var repoNode:IRepoNode;        
        public var tagPropertiesPresModel:TagPropertiesPresModel;
        public var categoryPropertiesPresModel:CategoryPropertiesPresModel;
        public var semanticTagPropertiesPresModel:SemanticTagPropertiesPresModel;
        
               
        /**
         * Constructor 
         * 
         * @param repoNode  node to view/edit tag and category properties on
         * 
         */
        public function TagsCategoriesPresModel(repoNode:IRepoNode)
        {
            super();
            
            this.repoNode = repoNode;   
            
            setupSubViews();         
        }
        
        /**
         * Setup presentation models for sub views
         * 
         */
        protected function setupSubViews():void
        {
            // setup categories tab
            categoryPropertiesPresModel = new CategoryPropertiesPresModel(repoNode);   
            
            var model:AppModelLocator = AppModelLocator.getInstance();
            var version:Number = model.ecmServerConfig.serverVersionNum();
            
            // only setup tags tab if 2.9 or greater since its tagging content model added in 2.9
            if (version >= 2.9)
            {
                tagPropertiesPresModel = new TagPropertiesPresModel(repoNode);                   
            }   
            
            // only setup semantic tags if Calias tagging features enabling has been configured
            if (model.calaisConfig.enableCalias == true)
            {
                semanticTagPropertiesPresModel = new SemanticTagPropertiesPresModel(repoNode);                   		    	        	
            }                       
        }
                
    }
}
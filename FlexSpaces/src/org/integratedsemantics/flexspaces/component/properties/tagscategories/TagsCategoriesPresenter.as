package org.integratedsemantics.flexspaces.component.properties.tagscategories
{
    import flash.events.MouseEvent;
    
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.component.categories.properties.CategoryPropertiesPresenter;
    import org.integratedsemantics.flexspaces.component.tags.properties.TagPropertiesPresenter;
    import org.integratedsemantics.flexspaces.framework.dialog.DialogPresenter;
    import org.integratedsemantics.flexspaces.model.AppModelLocator;
    import org.integratedsemantics.flexspaces.model.repo.IRepoNode;

    
    /**
     *  Presenter for Tags/Categories properties dialog
     *  for viewing/editing tags and categories on a doc/folder
     *  
     *  Presenter/Controller of TagsCategoriesViewBase views  
     * 
     */
    public class TagsCategoriesPresenter extends DialogPresenter
    {
        protected var repoNode:IRepoNode;        
        protected var onComplete:Function;
        protected var tagPropertiesPresenter:TagPropertiesPresenter;
        protected var categoryPropertiesPresenter:CategoryPropertiesPresenter;
        
               
        /**
         * Constructor 
         * 
         * @param tagsCategoriesView  view for to control
         * @param repoNode  node to view/edit tag and category properties on
         * @param onComplete  handler to call after renaming
         * 
         */
        public function TagsCategoriesPresenter(tagsCategoriesView:TagsCategoriesViewBase, repoNode:IRepoNode, 
                                                onComplete:Function=null)
        {
            super(tagsCategoriesView);
            
            this.repoNode = repoNode;
            
            this.onComplete = onComplete;            
        }
        
        /**
         * Getter for the view
         *  
         * @return this view
         * 
         */
        protected function get tagsCategoriesView():TagsCategoriesViewBase
        {
            return this.view as TagsCategoriesViewBase;            
        }       

        /**
         * Handle view creation complete by requesting name property data from server 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);
            
            // setup categories tab
            tagsCategoriesView.nameLabel.text = repoNode.getName();                                   
            categoryPropertiesPresenter = new CategoryPropertiesPresenter(tagsCategoriesView.categoryPropertiesView, repoNode);   
            
            var model:AppModelLocator = AppModelLocator.getInstance();
            var version:Number = model.serverVersionNum();
            
            // only setup tags tab if 2.9 or greater since its tagging content model added in 2.9
            if (version >= 2.9)
            {
                tagPropertiesPresenter = new TagPropertiesPresenter(tagsCategoriesView.tagPropertiesView, repoNode);                   
            }              
        }
        
        /**
         * Handle close buttion click
         * (not for X close in title area)
         * 
         * @param click event
         * 
         */
        override protected function onCloseBtn(event:MouseEvent):void 
        {            
            PopUpManager.removePopUp(tagsCategoriesView);
            if (onComplete != null)
            {
                onComplete();
            }                        
        }
        
    }
}
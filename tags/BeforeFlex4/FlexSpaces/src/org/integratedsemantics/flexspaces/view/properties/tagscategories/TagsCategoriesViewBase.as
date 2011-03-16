package org.integratedsemantics.flexspaces.view.properties.tagscategories
{
    import flash.events.MouseEvent;
    
    import mx.controls.Label;

    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
        
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspaces.presmodel.properties.tagscategories.TagsCategoriesPresModel;
    import org.integratedsemantics.flexspaces.view.categories.properties.CategoryPropertiesViewBase;
    import org.integratedsemantics.flexspaces.view.semantictags.properties.SemanticTagPropertiesViewBase;
    import org.integratedsemantics.flexspaces.view.tags.properties.TagPropertiesViewBase;


    /**
     * Base class for tags view/edit views  
     * 
     */
    public class TagsCategoriesViewBase extends DialogViewBase
    {
        public var onComplete:Function;

        public var nameLabel:Label;
       
        public var tagPropertiesView:TagPropertiesViewBase;
        
        public var categoryPropertiesView:CategoryPropertiesViewBase;
        
        public var semanticTagPropertiesView:SemanticTagPropertiesViewBase;

        [Bindable]
        public var tagCategoriesPresModel:TagsCategoriesPresModel;
                
                      
        /**
         * Constructor 
         * 
         * @param onComplete  handler to call after renaming
         * 
         */
        public function TagsCategoriesViewBase(onComplete:Function=null)
        {
            super();
            
            this.onComplete = onComplete;            
        }      

        /**
         * Handle view creation complete
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);
            
            nameLabel.text = tagCategoriesPresModel.repoNode.getName();                                               
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
            PopUpManager.removePopUp(this);
            if (onComplete != null)
            {
                onComplete();
            }                        
        }        
          
    }
}
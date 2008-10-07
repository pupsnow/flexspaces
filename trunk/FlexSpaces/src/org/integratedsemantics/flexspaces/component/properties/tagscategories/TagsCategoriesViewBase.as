package org.integratedsemantics.flexspaces.component.properties.tagscategories
{
    import mx.controls.Label;
    
    import org.integratedsemantics.flexspaces.component.categories.properties.CategoryPropertiesViewBase;
    import org.integratedsemantics.flexspaces.component.tags.properties.TagPropertiesViewBase;
    import org.integratedsemantics.flexspaces.framework.dialog.DialogViewBase;


    /**
     * Base class for tags view/edit views  
     * 
     */
    public class TagsCategoriesViewBase extends DialogViewBase
    {
        public var nameLabel:Label;
        
        public var tagPropertiesView:TagPropertiesViewBase;
        
        public var categoryPropertiesView:CategoryPropertiesViewBase;
        
                      
        /**
         * Constructor 
         */
        public function TagsCategoriesViewBase()
        {
            super();
        }        
    }
}
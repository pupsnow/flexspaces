package org.integratedsemantics.flexspaces.component.tags.properties
{
    import mx.collections.XMLListCollection;
    import mx.containers.Form;
    import mx.controls.Button;
    import mx.controls.List;
    import mx.controls.TextInput;


    /**
     * Base class for tags view/edit views  
     * 
     */
    public class TagPropertiesViewBase extends Form
    {
        [Bindable] public var tags:XMLListCollection;   
        [Bindable] public var allTags:XMLListCollection;   

        public var tagList:List;
        public var removeTagBtn:Button;        
        
        public var tagName:TextInput;
        public var addNewTagBtn:Button;

        public var allTagsList:List;
        public var addExistingTagBtn:Button;

              
        /**
         * Constructor 
         */
        public function TagPropertiesViewBase()
        {
            super();
        }        
    }
}
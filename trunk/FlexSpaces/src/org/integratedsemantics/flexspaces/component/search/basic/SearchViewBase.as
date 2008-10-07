package org.integratedsemantics.flexspaces.component.search.basic
{
    import mx.containers.Box;
    import mx.controls.Button;
    import mx.controls.LinkButton;
    import mx.controls.TextInput;
    
        
    /**
     * Base class for one box basic search views  
     * 
     */
    public class SearchViewBase extends Box
    {
        public var searchTextInput:TextInput;
        public var searchBtn:Button;
        public var advancedLink:LinkButton
        
        /**
         * Constructor 
         */
        public function SearchViewBase()
        {
            super();
        }        
    }
}
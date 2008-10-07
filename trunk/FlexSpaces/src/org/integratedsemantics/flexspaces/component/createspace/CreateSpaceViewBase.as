package org.integratedsemantics.flexspaces.component.createspace
{
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;
    import mx.controls.ComboBox;
    import mx.controls.TextInput;
    import mx.controls.TileList;
    
    import org.integratedsemantics.flexspaces.framework.dialog.DialogViewBase;


    /**
     * Base class for create space views  
     * 
     */
    public class CreateSpaceViewBase extends DialogViewBase
    {        
        [Bindable] public var templates:XMLListCollection;  
        [Bindable] public var icons:ArrayCollection;
        
        public var foldername:TextInput;
        public var nodetitle:TextInput;
        public var description:TextInput;
        public var templatecombo:ComboBox;
        public var iconlist:TileList;
        
        
        /**
         * Constructor 
         */
        public function CreateSpaceViewBase()
        {
            super();
        }        
    }
}
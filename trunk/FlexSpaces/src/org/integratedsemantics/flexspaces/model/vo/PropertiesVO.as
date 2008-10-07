package org.integratedsemantics.flexspaces.model.vo
{
    /**
     * Properties value object returned by get properties delegate 
     * 
     */
    [Bindable]
    public class PropertiesVO
    {
        public var name:String;
        public var title:String;
        public var description:String;
        public var author:String;
        public var size:String;
        public var creator:String;
        public var created:String;
        public var modifier:String;
        public var modified:String;
        public var emailid:String;
        public var mimetype:String;
        public var isFolder:Boolean;
        
        
        /**
         * Constructor 
         * 
         */
        public function PropertiesVO()
        {
        }

    }
}
package org.integratedsemantics.flexspaces.model.repo
{
    public class RepoQName extends Object
    {
        public var namespaceURI:String; 
        public var localName:String;
        public var prefix:String;
                
        protected static const NAMESPACE_PREFIX:String = ':';
        protected static const NAMESPACE_BEGIN:String = '{';
        protected static const NAMESPACE_END:String = '}';


        public function RepoQName(namespaceURI:String, localName:String, prefix:String=null)
        {
            super();
            
            this.namespaceURI = namespaceURI;
            this.localName = localName;
            this.prefix = prefix;
        }
        
        /**
         * Render string representation of RepoQName using format:
         * 
         * <code>{namespace}name</code>
         * 
         * @return the string representation
         */
        public function toString():String
        {
            var strQName:String = NAMESPACE_BEGIN + this.namespaceURI + NAMESPACE_END + this.localName;
            
            return strQName;
        }                
        
    }
}
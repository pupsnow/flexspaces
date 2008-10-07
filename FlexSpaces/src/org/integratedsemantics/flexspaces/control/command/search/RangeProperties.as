package org.integratedsemantics.flexspaces.control.command.search
{
    import org.integratedsemantics.flexspaces.model.repo.RepoQName;

            
    public class RangeProperties
    {
        public var qname:RepoQName;
        public var lower:String;
        public var upper:String;
        public var inclusive:Boolean;


        public function RangeProperties(qname:RepoQName, lower:String, upper:String, inclusive:Boolean)
        {
            this.qname = qname;
            this.lower = lower;
            this.upper = upper;
            this.inclusive = inclusive;            
        }

    }
}
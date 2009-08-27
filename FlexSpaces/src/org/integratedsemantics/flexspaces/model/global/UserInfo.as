package org.integratedsemantics.flexspaces.model.global
{
	import org.integratedsemantics.flexspaces.model.repo.RepoNode;

	[Bindable]	
	public class UserInfo
	{
        // login
		public var loginTicket:String = null;
		public var loginUserName:String = "";
		public var loginPassword:String = "";
		public var autoLogin:Boolean = false;
		
        // from get info
        public var userName:String;
        public var firstName:String;
        public var lastName:String;
        public var companyHome:RepoNode;
        public var userHome:RepoNode;
		        
		public function UserInfo()
		{
		}

	}
}
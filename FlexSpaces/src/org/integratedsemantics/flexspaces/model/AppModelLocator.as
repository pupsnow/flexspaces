package org.integratedsemantics.flexspaces.model
{
	import com.adobe.cairngorm.model.ModelLocator;
	
	import org.integratedsemantics.flexspaces.model.folder.NodeCollection;
	import org.integratedsemantics.flexspaces.model.repo.RepoNode;


	/**
	 *  FlexSpaces Cairngorm Model Locator
	 * 
	 */
    [Bindable]
	public class AppModelLocator implements ModelLocator
	{
		// this instance stores a static reference to itself
		private static var model : AppModelLocator;

        public var srcPath:String = "";
        
        // login
		public var loginTicket:String = null;
		public var loginUserName:String = null;
		public var loginPassword:String = null;
		
		// what type of server (alfresco or livecycle content services es)
		public var isLiveCycleContentServices:Boolean = false;				 
		
		// from config service
		public var urlPrefix:String = null;
		
        public var serverEdition:String;
        public var serverVersion:String = "";

        // from get info
        public var userName:String;
        public var firstName:String;
        public var lastName:String;
        public var companyHome:RepoNode;
        public var userHome:RepoNode;
		
		// clipboard
		// todo move field to a clipboard model
        public var cut:Array;
        public var copy:Array;
        public var wcmCutCopy:Boolean = false;
        
        // clipboard format flag for doc/folder nodes within flexspaces (air only)
        public static const FLEXSPACES_FORMAT:String = "FLEXSPACES";
        
        // handle avm files in wcm browser special vs adm files
        public var wcmMode:Boolean = false;

        // selected item, items in current folder view
        public var selectedItem:Object = null;      
        public var selectedItems:Array = null;
        
        // model of current folder view
        public var currentNodeList:NodeCollection;
        
        // whether to have various views
        public var showDocLib:Boolean = true;
        public var showSearch:Boolean = true;
        public var showTasks:Boolean = true;
        public var showWCM:Boolean = true;
        public var showShare:Boolean = true;

        // thumbnail name
        public var thumbnailName:String = "doclib";
        

        public function clearSelection():void
        {
            selectedItem = null;
            selectedItems = null;    
        }
        
        public function serverVersionNum():Number
        {
            var number:Number = new Number( Number(serverVersion.substr(0,3)) );
            return number;
        }

		// singleton: constructor only allows one model locator
		public function AppLocator():void
		{
			if (AppModelLocator.model != null)
			{
				throw new Error( "Only one ModelLocator instance should be instantiated" );
			}
		}

		// singleton: always returns the one existing static instance to itself
		public static function getInstance():AppModelLocator
		{
			if (model == null)
			{
				model = new AppModelLocator();
			}
			return model;
		}		
	}
}


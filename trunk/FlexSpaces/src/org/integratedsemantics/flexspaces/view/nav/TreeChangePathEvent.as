package org.integratedsemantics.flexspaces.view.nav
{
	import flash.events.Event;


	/**
	 * Event to let containers know that a  folder has been selected by the user in a nav panel 
	 * tree (either in the company home tree or the user home tree)
	 */
	public class TreeChangePathEvent extends Event
	{
		/** Event name */
		public static const COMPANY_HOME_TREE_CHANGE_PATH:String = "companyHomeTreeChangePath";
        public static const USER_HOME_TREE_CHANGE_PATH:String = "userHomeTreeChangePath";
        public static const TREE_CHANGE_PATH:String = "treeChangePath";

		/** data storing new path */
		private var newPath:String;
		
		/**
		 * Constructor
		 * 
		 * @param type     event name
		 * @param newPath  new path changed to
		 */
		public function TreeChangePathEvent(type:String, newPath:String)
		{
			super(type);
			
			this.newPath = newPath;
		}
		
		/**
		 * Getter for the new path
		 */
		public function get path():String
		{
			return this.newPath;
		}
		
	}
}
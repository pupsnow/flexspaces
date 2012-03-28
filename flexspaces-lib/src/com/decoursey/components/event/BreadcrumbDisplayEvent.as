package com.decoursey.components.event {
	import flash.events.Event;

	public class BreadcrumbDisplayEvent extends Event {
		
		public static const BREADCRUMB_ACTION:String = "breadcrumbAction";
		
		public function BreadcrumbDisplayEvent(path:String, type:String=BREADCRUMB_ACTION, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this._path = path;
		}
		
		public function get path():String {
			return this._path;
		}
		
		private var _path:String;
	}
}
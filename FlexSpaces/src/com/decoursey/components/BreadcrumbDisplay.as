package com.decoursey.components {
	import mx.core.UITextField;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextLineMetrics;
	import mx.core.Container;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	import com.decoursey.components.event.BreadcrumbDisplayEvent;
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import flash.display.DisplayObject;
	
	
	[Style(name="crumbBackgroundColor",type="Number",format="Color",inherit="no")]
	[Style(name="hoverBackgroundColor",type="Number",format="Color",inherit="no")]
	[Style(name="crumbBackgroundAlpha",type="Number",inherit="no")]
	[Style(name="hoverBackgroundAlpha",type="Number",inherit="no")]
	[Style(name="padding",type="Number",format="int",inherit="no")]
	[Style(name="cornerRadius",type="Number",format="int",inherit="no")]
	[Event(name="breadcrumbAction", type="com.decoursey.components.event.BreadcrumbDisplayEvent")]
	
	public class BreadcrumbDisplay extends Container {
		
		
		public function BreadcrumbDisplay() {
			this.addEventListener(MouseEvent.ROLL_OVER, this.mouseOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, this.mouseOutHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			this.addEventListener(MouseEvent.CLICK, this.mouseClickHandler);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			this.display = new UIComponent();
			this.addChild(this.display);
		}
		
		public function set path(path:String):void {
			this._path = path;
			this.invalidateProperties();
		}
		
		public function get path():String {
			return this._path;
		}
		
		public function set title(title:String):void {
			this._title = title;
			this.invalidateProperties();
		}
		
		public function get title():String {
			return this._title;
		}
		
		public function set delimeter(delimeter:String):void {
			this._delimeter = delimeter;
			this.invalidateProperties();
		}
		
		public function get delimeter():String {
			return this._delimeter;
		}
		
		public function set displayDivider(displayDivider:String):void {
			this._displayDivider = displayDivider;
			this.invalidateProperties();
		}
		
		public function get displayDivider():String {
			return this._displayDivider;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);
			this.display.graphics.clear();
			var padding:int = this.getStyle("padding");
			var backgroundColor:uint = this.getStyle("crumbBackgroundColor");
			var hoverBackgroundColor:uint = this.getStyle("hoverBackgroundColor");
			var cornerRadius:int = this.getStyle("cornerRadius");
			var backgroundAlpha:Number = this.getStyle("crumbBackgroundAlpha");
			var hoverBackgroundAlpha:Number = this.getStyle("hoverBackgroundAlpha");
			
    		var rect:Rectangle = this._pathPartsRects[this._pathPartsRects.length-1] as Rectangle;
    		if(rect==null) {
    			rect = nullRect();
    		}
    		this.display.graphics.lineStyle(0, 0x000000, 0);
    		this.display.graphics.beginFill(backgroundColor, backgroundAlpha);
    		this.display.graphics.drawRoundRect(padding, padding, rect.right-padding, this._maxHeight, cornerRadius, cornerRadius);
    		this.display.graphics.endFill();
    		
			if(this._hoveredItemLimit>0) {
				this.display.graphics.lineStyle(0, 0x000000, 0);
				this.display.graphics.beginFill(hoverBackgroundColor, hoverBackgroundAlpha);
				this.display.graphics.drawRoundRect(padding, padding, this._hoveredItemLimit, this._maxHeight, cornerRadius, cornerRadius);
				this.display.graphics.endFill();
			}
			
	  		if(this._titleRect!=null) {
				this.display.graphics.lineStyle(0, 0x000000, 0);
    			this.display.graphics.beginFill(backgroundColor, backgroundAlpha);
    			this.display.graphics.drawRoundRect(this._titleRect.x, this._titleRect.y, this._titleRect.width, this._titleRect.height, cornerRadius, cornerRadius);
    			this.display.graphics.endFill();
			}
		}
		
		override protected function measure():void {
			super.measure();
			var padding:int = this.getStyle("padding");
			
			this.measuredWidth = this.measuredMinWidth = 0;
			
			if(this._pathPartsRects!=null) {
				var totalWidth:Number = 0;
				for(var index:int=0;index<this._pathPartsRects.length;index++) {
		    		var rect:Rectangle = this._pathPartsRects[index] as Rectangle;
		    		totalWidth += rect.width;
		  		}
				this.measuredWidth = this.measuredMinWidth = totalWidth + (padding * 2);
			}
			if(this.title!=null && this.title!="") {
				this.measuredWidth = this.measuredMinWidth = this.measuredWidth + this._titleRect.width + padding;
			}
			this.measuredHeight = this.measuredMinHeight = this._maxHeight + (padding * 2);
		}
		
		public function removeAllDisplayChildren():void {
			while(this.display.numChildren>0) {
				this.display.removeChildAt(0);
			}
		}
		
		override protected function commitProperties():void {
		    super.commitProperties();
 		    this.removeAllDisplayChildren();
	    	this._pathParts = new Array();
	    	this._pathPartsRects = new Array();
		    	this._pathPrefixed = false;
		    if(path!="" && path!=null) {
			    if(this.path.match("^" + this._delimeter)) {
			    	_pathPrefixed = true;
				    this._pathParts = this._path.split(this._delimeter);
				    if((this._pathParts[0] as String)=="") {
				    	this._pathParts.splice(0, 1);
				    }
			    } else {
			    	_pathPrefixed = false;
			    	this._pathParts = this._path.split(this._delimeter);
			    }
			    for(var index:int=0;index<this._pathParts.length;index++) {
			    	this.createRect(this._pathParts[index] as String);
			    }
		    }
		    var padding:int = this.getStyle("padding");
			if(this.title!=null && this.title!="") {
				var lineMetrics:TextLineMetrics = this.measureText(this.title);
				this._titleRect = new Rectangle();
				var rect:Rectangle = this._pathPartsRects[this._pathPartsRects.length-1] as Rectangle;
				if(rect==null) {
					rect = nullRect();
				}
				this._titleRect.x = rect.right + padding;
				this._titleRect.y = padding;
				this._titleRect.width = lineMetrics.width + (padding * 2);
				this._titleRect.height = this._maxHeight;
				var textField:UITextField = new UITextField();
				textField.x = this._titleRect.x+padding;
				textField.y = this._titleRect.y+padding;
				textField.text = this.title;
				textField.width = lineMetrics.width + (padding * 4);
				textField.mouseEnabled = false;
				this.display.addChild(textField);
			} else {
				this._titleRect = null;
			}
			
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		
		private function whereMouse(x:int, y:int):void {
			this._hoveredItemIndex = -1;
			this._hoveredItemLimit = 0;
			for(var index:int=0;index<this._pathPartsRects.length;index++) {
	    		var rect:Rectangle = this._pathPartsRects[index] as Rectangle;
	    		if(rect.contains(x, y)) {
	    			this._hoveredItemIndex = index;
	    			this._hoveredItemLimit = rect.right - this.getStyle("padding");
	    		}
	  		}
		}
		
		private function mouseOverHandler(event:MouseEvent):void {
			this.whereMouse(event.localX, event.localY);
			this.invalidateDisplayList();
		}
		
		private function mouseOutHandler(event:MouseEvent):void {
			this._hoveredItemLimit = -1;
			this.invalidateDisplayList();
		}
		
		private function mouseMoveHandler(event:MouseEvent):void {
			this.whereMouse(event.localX, event.localY);
			this.invalidateDisplayList();
		}
		
		private function mouseClickHandler(event:MouseEvent):void {
			if(this._hoveredItemIndex<0) return;
			var targetPath:String = this._pathPrefixed?this._delimeter:"";
			for(var index:int=0;index<this._hoveredItemIndex+1;index++) {
		    	targetPath += this._pathParts[index] as String;
		    	if(index!=this._hoveredItemIndex) {
		    		targetPath += this._delimeter;
		    	}
		    }
		    this.dispatchEvent(new BreadcrumbDisplayEvent(targetPath));
		}
		
		private function nullRect():Rectangle {
			var padding:int = this.getStyle("padding");
			var rect:Rectangle = new Rectangle();
			rect.x = padding;
			rect.y = padding;
			rect.height = 0;
			rect.width = 0;
			return rect;
		}
		
		private function createRect(text:String):void {
			var rect:Rectangle = new Rectangle();
			var previous_rect:Rectangle;
			var padding:int = this.getStyle("padding");
			
			var displayText:String = this._displayDivider + " " + text;
			if(this._pathPartsRects.length==0) {
				previous_rect = nullRect();
			} else {
				previous_rect = this._pathPartsRects[this._pathPartsRects.length-1];
			}
			var lineMetrics:TextLineMetrics = this.measureText(displayText);
			rect.x = previous_rect.x + previous_rect.width;
			rect.y = previous_rect.y;
			rect.height = lineMetrics.height + (padding * 3);
			rect.width = lineMetrics.width + (padding * 4);
			if(rect.height>this._maxHeight) {
				this._maxHeight = rect.height;
			}
			var textField:UITextField = new UITextField();
			textField.x = rect.x+padding;
			textField.y = rect.y+padding;
			textField.text = displayText;
			textField.mouseEnabled = false;
			textField.width = lineMetrics.width + (padding * 4);
			this.display.addChild(textField);
			this._pathPartsRects.push(rect);
		}
		
		private var _path:String;
		private var _pathParts:Array;
		private var _pathPartsRects:Array;
		private var _title:String;
		private var _titleRect:Rectangle;
		private var _delimeter:String = "/";
		private var _pathPrefixed:Boolean = false;
		private var _displayDivider:String = ">>";
		private var _maxHeight:Number = 0;
		
		private var _hoveredItemIndex:int = -1;
		private var _hoveredItemLimit:int = 0;
		
		private var display:UIComponent;
		
		private static var classConstructed:Boolean = classConstruct();
    
        // Define a static method.
        private static function classConstruct():Boolean {
            if (!StyleManager.getStyleDeclaration("BreadcrumbDisplay")) {
                // If there is no CSS definition for BreadcrumbDisplay, 
                // then create one and set the default value.
                var newStyleDeclaration:CSSStyleDeclaration = new CSSStyleDeclaration();
                
                // sreiner quick fix to have diffrent style
                newStyleDeclaration.setStyle("crumbBackgroundColor", 0x333333);
                newStyleDeclaration.setStyle("hoverBackgroundColor", 0x666666);
                newStyleDeclaration.setStyle("crumbBackgroundAlpha", 1.0);
                newStyleDeclaration.setStyle("hoverBackgroundAlpha", 1.0);
                newStyleDeclaration.setStyle("padding", 1);
                newStyleDeclaration.setStyle("cornerRadius", 14);
                newStyleDeclaration.setStyle("textDecoration", "underline");
                newStyleDeclaration.setStyle("fontSize", 11);
                newStyleDeclaration.setStyle("color", 0xFFFFFF);
                
                //newStyleDeclaration.setStyle("crumbBackgroundColor", 0xEEEEEE);
                //newStyleDeclaration.setStyle("hoverBackgroundColor", 0xFF0000);
                //newStyleDeclaration.setStyle("crumbBackgroundAlpha", 0.6);
                //newStyleDeclaration.setStyle("hoverBackgroundAlpha", 0.6);
                //newStyleDeclaration.setStyle("padding", 4);
                //newStyleDeclaration.setStyle("cornerRadius", 14);
                //newStyleDeclaration.setStyle("fontWeight", "bold");
                //newStyleDeclaration.setStyle("fontSize", 13);
                
                
	         	StyleManager.setStyleDeclaration("BreadcrumbDisplay", newStyleDeclaration, true);
            }
            return true;
        }
		
	}
}
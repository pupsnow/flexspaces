package org.integratedsemantics.flexspacesair.view.browser
{
    import flash.display.NativeWindow;
    import flash.display.NativeWindowInitOptions;
    import flash.display.StageScaleMode;
    import flash.geom.Rectangle;
    import flash.html.HTMLHost;
    import flash.html.HTMLLoader;
    import flash.html.HTMLWindowCreateOptions;


    public class CustomHtmlHost extends HTMLHost
    {
        public function CustomHtmlHost(defaultBehaviors:Boolean=true)
        {
            super(defaultBehaviors);
        }
        
        override public function windowClose():void
        {
            trace("CustomHtmlHost windowClose");
        }
        
        override public function createWindow(windowCreateOptions:HTMLWindowCreateOptions):HTMLLoader
        {
            var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
            var window:NativeWindow = new NativeWindow(initOptions);
            window.visible = true;
            var htmlLoader2:HTMLLoader = new HTMLLoader();
            htmlLoader2.width = window.width;
            htmlLoader2.height = window.height;
            window.stage.scaleMode = StageScaleMode.NO_SCALE;
            window.stage.addChild(htmlLoader2);
            return htmlLoader2;
        }
        
        override public function updateLocation(locationURL:String):void
        {
            trace("CustomHtmlHost updateLocation: " + locationURL);
        }  
              
        override public function set windowRect(value:Rectangle):void
        {
        }
        
        override public function updateStatus(status:String):void
        {
            //trace("CustomHtmlHost updateStatus: " + status);
        } 
               
        override public function updateTitle(title:String):void
        {
            trace("CustomHtmlHost updtateTitle: " + title);
        }
        
        override public function windowBlur():void
        {
            htmlLoader.alpha = 0.5;
        }
        
        override public function windowFocus():void
        {
            htmlLoader.alpha = 1;
        }                
    }
}
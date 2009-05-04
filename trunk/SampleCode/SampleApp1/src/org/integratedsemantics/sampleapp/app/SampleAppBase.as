package org.integratedsemantics.sampleapp.app
{
    import flash.events.Event;
    
    import org.integratedsemantics.flexspaces.app.AppBase;
    import org.integratedsemantics.sampleapp.presmodel.main.SampleAppPresModel;
    import org.springextensions.actionscript.context.support.FlexXMLApplicationContext;


    public class SampleAppBase extends AppBase
    {
        public function SampleAppBase()
        {
            super();            
        }
  
        [Bindable]
        public function get sampleAppPresModel():SampleAppPresModel
        {
            return this.flexSpacesPresModel as SampleAppPresModel;
        }

        public function set sampleAppPresModel(sampleAppPresModel:SampleAppPresModel):void
        {
            this.flexSpacesPresModel = sampleAppPresModel;            
        }               

        override protected function loadConfig():void
        {
            // spring actionscript config
            applicationContext = new FlexXMLApplicationContext("SampleAppConfig.xml");
            applicationContext.addEventListener(Event.COMPLETE, onApplicationContextComplete);
            applicationContext.load();                                          
        }

        override protected function onApplicationContextComplete(event:Event):void
        {
            super.onApplicationContextComplete(event);  
        }     
      
    }
}
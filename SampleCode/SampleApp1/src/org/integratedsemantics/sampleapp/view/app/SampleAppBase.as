package org.integratedsemantics.sampleapp.view.app
{
   import org.integratedsemantics.sampleapp.presmodel.main.SampleAppPresModel;
   
   import flash.events.Event;
   
   import org.integratedsemantics.flexspaces.view.app.AppBase;

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

      /**
      * Handle alfresco-config.xml config read done
      *  
      * @param event config complete event
      * 
      */
      override protected function onConfigComplete(event:Event):void
      {
         sampleAppPresModel = new SampleAppPresModel();
         model.flexSpacesPresModel = sampleAppPresModel;            
      }     
      
   }
}
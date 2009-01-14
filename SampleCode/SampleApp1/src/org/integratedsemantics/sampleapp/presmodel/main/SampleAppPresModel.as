package org.integratedsemantics.sampleapp.presmodel.main
{
   
   import org.integratedsemantics.flexspaces.presmodel.main.FlexSpacesPresModel;

   [Bindable]
   public class SampleAppPresModel extends FlexSpacesPresModel
   {
      // additional sub presentation models would go here
      
      public function SampleAppPresModel()
      {
         super();
               
         this.showTasks = false;
         this.showWCM = false;         
      }
      
   }
}
package org.integratedsemantics.flexspaces.view.semantictags.suggest
{
    import flash.events.MouseEvent;
    
    import mx.controls.Button;
    import mx.controls.List;
    import mx.events.FlexEvent;
    import mx.managers.PopUpManager;
    
    import org.integratedsemantics.flexspaces.framework.presmodel.DialogViewBase;
    import org.integratedsemantics.flexspaces.model.vo.CategoryVO;
    import org.integratedsemantics.flexspaces.presmodel.semantictags.suggest.SemanticTagSuggestPresModel;
    import org.integratedsemantics.flexspaces.view.semantictags.suggesttree.SemanticTagSuggestionTreeViewBase;


    /**
     * Base class for semantic tag suggestions views  
     * 
     */
    public class SemanticTagSuggestViewBase extends DialogViewBase
    {
        public var onComplete:Function;

        public var categoryList:List;
        public var removeCategoryBtn:Button;        
        
        public var semanticTagTreeView:SemanticTagSuggestionTreeViewBase;
        public var addExistingCategoryBtn:Button;
                
        [Bindable]
        public var semanticTagSuggestPresModel:SemanticTagSuggestPresModel;


        /**
         * Constructor 
         * 
         * @param onComplete  handler to call after renaming
         * 
         */
        public function SemanticTagSuggestViewBase(onComplete:Function=null)
        {
            super();

            this.onComplete = onComplete;                        
        }        
        
        /**
         * Handle view creation complete by requesting name property data from server 
         * 
         * @param creation complete event
         * 
         */
        override protected function onCreationComplete(event:FlexEvent):void
        {
            super.onCreationComplete(event);
    
            // only setup semantic tags if Calias tagging features enabling has been configured
            if (semanticTagSuggestPresModel.model.calaisConfig.enableCalias == true)
			{
	            observeButtonClick(addExistingCategoryBtn, onAddSuggestedTagBtn);
	            observeButtonClick(removeCategoryBtn, onRemoveTagBtn);
	
	            // get updated list of semantic tags on node
	            semanticTagSuggestPresModel.getNodeSemanticTags();                                          	            
        	}                                                             
        }
               
        /**
         * Handle close buttion click
         * (not for X close in title area)
         * 
         * @param click event
         * 
         */
        override protected function onCloseBtn(event:MouseEvent):void 
        {            
            PopUpManager.removePopUp(this);
            if (onComplete != null)
            {
                onComplete();
            }                        
        }
        
        /**
         * Handle add existing tag buttion click
         * 
         * @param click event
         * 
         */
        protected function onAddSuggestedTagBtn(event:MouseEvent):void 
        {            
	        semanticTagSuggestPresModel.addSuggestedTagFromTree();
        }
     
        /**
         * Handle remove tag buttion click
         * 
         * @param click event
         * 
         */
        protected function onRemoveTagBtn(event:MouseEvent):void 
        {      
	        semanticTagSuggestPresModel.removeSemanticTag();
        }
 
        protected function onChangeSemanticTagList(event:Event):void
        {
			semanticTagSuggestPresModel.selectedNodeSemanticTag = categoryList.selectedItem as CategoryVO;      		
        }
       
    }
}
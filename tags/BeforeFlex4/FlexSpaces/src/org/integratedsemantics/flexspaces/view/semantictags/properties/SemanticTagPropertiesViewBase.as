package org.integratedsemantics.flexspaces.view.semantictags.properties
{
    import flash.events.MouseEvent;
    
    import mx.containers.Form;
    import mx.controls.Button;
    import mx.controls.List;
    import mx.events.FlexEvent;
    
    import org.integratedsemantics.flexspaces.model.vo.CategoryVO;
    import org.integratedsemantics.flexspaces.presmodel.semantictags.properties.SemanticTagPropertiesPresModel;
    import org.integratedsemantics.flexspaces.util.ObserveUtil;
    import org.integratedsemantics.flexspaces.view.semantictags.tree.SemanticTagTreeViewBase;


    /**
     * Base class for semantic tags view/edit views  
     * 
     */
    public class SemanticTagPropertiesViewBase extends Form
    {
        public var categoryList:List;
        public var removeCategoryBtn:Button;        
        
        public var semanticTagTreeView:SemanticTagTreeViewBase;
        public var addExistingCategoryBtn:Button;

        [Bindable]
        public var semanticTagPropertiesPresModel:SemanticTagPropertiesPresModel;
        
              
        /**
         * Constructor 
         */
        public function SemanticTagPropertiesViewBase()
        {
            super();
        }
        
        /**
         * Handle view creation complete
         * 
         * @param creation complete event
         * 
         */
        protected function onCreationComplete(event:FlexEvent):void
        {
        	if (semanticTagPropertiesPresModel != null)
        	{
	            ObserveUtil.observeButtonClick(addExistingCategoryBtn, onAddExistingTagBtn);
	            ObserveUtil.observeButtonClick(removeCategoryBtn, onRemoveTagBtn);
	
	            // get updated list of semantic tags on node
	            semanticTagPropertiesPresModel.getNodeSemanticTags();                                            	            
         	}                                                               
        }
        
        /**
         * Handle add existing tag buttion click
         * 
         * @param click event
         * 
         */
        protected function onAddExistingTagBtn(event:MouseEvent):void 
        {            
	        semanticTagPropertiesPresModel.addSemanticTagFromTree();                        
        }

        /**
         * Handle remove tag buttion click
         * 
         * @param click event
         * 
         */
        protected function onRemoveTagBtn(event:MouseEvent):void 
        {      
	        semanticTagPropertiesPresModel.removeSemanticTag();
        }

        protected function onChangeSemanticTagList(event:Event):void
        {
			semanticTagPropertiesPresModel.selectedNodeSemanticTag = categoryList.selectedItem as CategoryVO;
        }
                
    }
}
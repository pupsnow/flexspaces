package org.integratedsemantics.flexspaces.skin
{
    import mx.controls.MenuBar;
    import mx.controls.menuClasses.MenuBarItem;
    
    public class MenuBarItem2 extends MenuBarItem
    {
        override public function set menuBarItemState(value:String):void
        {
            super.menuBarItemState = value;
            
            if (!label)
            {
                return;
            }
            
            if (value == "itemOverSkin")
            {
                label.textColor = MenuBar(owner).getStyle("textRollOverColor");
            }
            else if (value == "itemDownSkin")
            {
                label.textColor = MenuBar(owner).getStyle("textSelectedColor");
            }
            else
            {
                label.textColor = MenuBar(owner).getStyle("color");
            }
        }    
        
    };
    
}
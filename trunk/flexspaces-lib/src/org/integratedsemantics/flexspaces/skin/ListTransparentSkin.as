package org.integratedsemantics.flexspaces.skin
{
    import mx.skins.ProgrammaticSkin;

    public class ListTransparentSkin extends ProgrammaticSkin
    {
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            graphics.clear();
            graphics.beginFill(0, 0);
            graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
            graphics.endFill();
        }
        
    }
}
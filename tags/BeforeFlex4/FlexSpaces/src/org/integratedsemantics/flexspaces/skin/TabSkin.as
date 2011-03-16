

package org.integratedsemantics.flexspaces.skin
{
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	import mx.skins.ProgrammaticSkin;


	[Style(name="tabBackgroundColors", type="Array", arrayType="uint", format="Color", inherit="yes")]	
	[Style(name="tabBackgroundAlphas", type="Array", arrayType="Number", inherit="yes")]
	

	public class TabSkin extends ProgrammaticSkin
	{
        private var transformMatrix:Matrix = null;   
        private var tabBackgroundColors:Array;
        private var tabBackgroundAlphas:Array;
        private var colorDistRatios:Array = [0, 255];
        private var gradientRotation:Number = Math.PI/2;


		public function TabSkin()
		{
			super();
		}
				
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
	 		 
			graphics.clear();
			
			switch (name)
			{
				case "overSkin":
				case "selectedOverSkin":
				case "selectedUpSkin":
				{
					if (transformMatrix == null) 
					{
						transformMatrix = new Matrix();																	
						transformMatrix.createGradientBox(unscaledWidth, unscaledHeight, gradientRotation, 0, 0);
						tabBackgroundColors = getStyle("tabBackgroundColors");
						tabBackgroundAlphas = getStyle("tabBackgroundAlphas");
					}						
					
					graphics.beginGradientFill(GradientType.LINEAR, tabBackgroundColors, tabBackgroundAlphas, colorDistRatios, transformMatrix, 
					                           SpreadMethod.PAD, InterpolationMethod.LINEAR_RGB); 

					graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);

					break;						
				}
			}
		}
	}
}

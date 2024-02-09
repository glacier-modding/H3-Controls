package basic
{
	import common.BaseControl;
	
	public class BoundsExtender extends BaseControl
	{
		
		public function BoundsExtender()
		{
			super();
			this.graphics.beginFill(0, 0);
			this.graphics.lineStyle(0, 0, 0);
			this.graphics.drawRect(-9999999 / 2, -9999999 / 2, 9999999 * 2, 9999999 * 2);
			this.mouseEnabled = false;
		}
	}
}

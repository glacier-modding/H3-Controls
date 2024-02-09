package menu3
{
	import flash.geom.Rectangle;
	
	public dynamic class MenuElementNode extends MenuElementBase
	{
		
		public function MenuElementNode(param1:Object)
		{
			super(param1);
		}
		
		override public function getVisualBounds(param1:MenuElementBase):Rectangle
		{
			return new Rectangle();
		}
	}
}

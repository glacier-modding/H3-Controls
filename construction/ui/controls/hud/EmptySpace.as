package hud
{
	import menu3.MenuElementBase;
	
	public dynamic class EmptySpace extends MenuElementBase
	{
		
		public function EmptySpace(param1:Object)
		{
			var _loc2_:Object = new Object();
			super(_loc2_);
			var _loc3_:InventorySlotSpace = new InventorySlotSpace();
			_loc3_.width = param1.width;
			_loc3_.height = param1.height;
			_loc3_.y = param1.height * 0.5;
			addChild(_loc3_);
		}
	}
}

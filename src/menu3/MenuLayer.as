package menu3
{
	import common.MouseUtil;
	import common.menu.MenuConstants;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public dynamic class MenuLayer extends MenuElementBase
	{
		
		private var m_background:Sprite;
		
		private var m_addedToStage:Boolean = false;
		
		private var m_element:Sprite = null;
		
		private var m_anchorBound:Object = null;
		
		private var m_positionSide:String;
		
		private var m_spaceX:int = 0;
		
		public function MenuLayer(param1:Object)
		{
			this.m_background = new Sprite();
			super(param1);
			m_mouseMode = MouseUtil.MODE_DISABLE;
			addChildAt(this.m_background, 0);
			this.m_background.graphics.clear();
			this.m_background.graphics.beginFill(16711680, 0);
			this.m_background.graphics.drawRect(-100, -100, MenuConstants.BaseWidth + 200, MenuConstants.BaseHeight + 200);
			this.m_background.graphics.endFill();
			this.m_anchorBound = param1.anchorbound;
			this.m_spaceX = param1.spaceX != undefined ? int(param1.spaceX) : 0;
			this.m_positionSide = param1.positionSide != undefined ? String(param1.positionSide) : "right";
			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true, 0, true);
		}
		
		override public function addChild2(param1:Sprite, param2:int = -1):void
		{
			super.addChild2(param1, param2);
			this.m_element = param1;
			if (this.m_addedToStage)
			{
				this.placeChild();
			}
		}
		
		override public function onUnregister():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true);
			super.onUnregister();
		}
		
		protected function onAddedToStage(param1:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true);
			this.m_addedToStage = true;
			if (this.m_element != null)
			{
				this.placeChild();
			}
		}
		
		private function placeChild():void
		{
			var _loc3_:Rectangle = null;
			if (this.m_anchorBound == null)
			{
				return;
			}
			var _loc1_:Point = this.m_element.parent.globalToLocal(new Point(this.m_anchorBound.x, this.m_anchorBound.y));
			var _loc2_:Point = this.m_element.parent.globalToLocal(new Point(this.m_anchorBound.x + this.m_anchorBound.width, this.m_anchorBound.y + this.m_anchorBound.height));
			this.m_element.y = _loc1_.y;
			if (this.m_positionSide == "left")
			{
				_loc3_ = this.m_element.getBounds(this.m_element.parent);
				this.m_element.x = _loc1_.x - this.m_spaceX - _loc3_.width;
			}
			else
			{
				this.m_element.x = _loc2_.x + this.m_spaceX;
			}
		}
	}
}

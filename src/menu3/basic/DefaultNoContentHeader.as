package menu3.basic
{
	import common.menu.MenuConstants;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import menu3.MenuFrame;
	
	public dynamic class DefaultNoContentHeader extends HeadlineElement
	{
		
		private var m_absoluteX:Number;
		
		private var m_absoluteY:Number;
		
		private var m_screenSize:Point;
		
		private var m_needsUpdate:Boolean = false;
		
		public function DefaultNoContentHeader(param1:Object)
		{
			super(param1);
			addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler, false, 0, true);
		}
		
		override public function onSetData(param1:Object):void
		{
			if (!param1.typeicon)
			{
				param1.typeicon = "info";
			}
			super.onSetData(param1);
			if (param1.absolute_x)
			{
				this.m_absoluteX = param1.absolute_x;
			}
			else
			{
				this.m_absoluteX = MenuConstants.HeadlineElementXPos;
			}
			if (param1.absolute_y)
			{
				this.m_absoluteY = param1.absolute_y;
			}
			else
			{
				this.m_absoluteY = MenuConstants.HeadlineElementYPos;
			}
			if (!isNaN(param1.sizeX) && !isNaN(param1.sizeY))
			{
				this.m_screenSize = new Point(param1.sizeX, param1.sizeY);
			}
			this.m_needsUpdate = true;
			this.updatePosition();
		}
		
		override public function onUnregister():void
		{
			super.onUnregister();
			if (hasEventListener(Event.ADDED_TO_STAGE))
			{
				removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler, false);
			}
		}
		
		private function addedToStageHandler():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler, false);
			this.updatePosition();
		}
		
		public function updatePosition():void
		{
			var _loc3_:MenuFrame = null;
			var _loc4_:Rectangle = null;
			var _loc5_:Rectangle = null;
			var _loc6_:HeadlineElementView = null;
			if (!this.m_needsUpdate)
			{
				return;
			}
			var _loc1_:DisplayObject = this;
			var _loc2_:DisplayObject = null;
			while (_loc1_ != null && _loc2_ == null)
			{
				_loc3_ = _loc1_.parent as MenuFrame;
				if (_loc3_ != null)
				{
					_loc2_ = _loc1_;
				}
				else
				{
					_loc1_ = _loc1_.parent;
				}
			}
			if (_loc2_ != null)
			{
				_loc4_ = this.getBounds(this);
				_loc5_ = this.getBounds(_loc2_);
				(_loc6_ = getRootView()).x = this.m_absoluteX - (_loc5_.x - _loc4_.x);
				_loc6_.y = this.m_absoluteY - (_loc5_.y - _loc4_.y);
				this.m_needsUpdate = false;
			}
		}
	}
}

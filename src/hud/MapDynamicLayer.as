package hud
{
	import common.BaseControl;
	import flash.display.Sprite;
	
	public class MapDynamicLayer extends BaseControl
	{
		
		private var m_sprite:Sprite;
		
		private var m_spriteSuspiciousBodies:Sprite;
		
		public function MapDynamicLayer()
		{
			trace("ActionScript Map - trace");
			super();
			this.m_sprite = new Sprite();
			addChild(this.m_sprite);
			this.m_spriteSuspiciousBodies = new Sprite();
			addChild(this.m_spriteSuspiciousBodies);
		}
		
		public function setRectangles(param1:Array):void
		{
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			var _loc6_:Number = NaN;
			var _loc7_:Number = NaN;
			trace("MapDynamicLayer::setRectangles");
			this.m_sprite.graphics.clear();
			var _loc2_:int = 0;
			while (_loc2_ < param1.length)
			{
				_loc3_ = param1[_loc2_] * 0.5 + 0.3;
				this.m_sprite.graphics.beginFill(16711680, _loc3_);
				_loc4_ = Number(param1[_loc2_ + 1]);
				_loc5_ = Number(param1[_loc2_ + 2]);
				_loc6_ = Number(param1[_loc2_ + 3]);
				_loc7_ = Number(param1[_loc2_ + 4]);
				trace("MapDynamicLayer::setRectangles " + _loc4_ + " " + _loc5_ + " " + _loc6_ + " " + _loc7_);
				this.m_sprite.graphics.drawRect(_loc4_, _loc5_, _loc6_, _loc7_);
				_loc2_ += 5;
			}
		}
		
		public function setSuspiciousBodies(param1:Array):void
		{
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			trace("MapDynamicLayer::setSuspiciousBodies");
			this.m_spriteSuspiciousBodies.graphics.clear();
			if (param1.length == 0)
			{
				return;
			}
			this.m_spriteSuspiciousBodies.graphics.beginFill(10027008, 0.8);
			var _loc2_:Number = param1[0] * 0.5 + 0.3;
			var _loc3_:int = 1;
			while (_loc3_ < param1.length)
			{
				_loc4_ = param1[_loc3_] + _loc2_ * 0.5;
				_loc5_ = param1[_loc3_ + 1] + _loc2_ * 0.5;
				trace("MapDynamicLayer::setSuspiciousBodies " + _loc4_ + " " + _loc5_ + " " + _loc2_);
				this.m_spriteSuspiciousBodies.graphics.drawCircle(_loc4_, _loc5_, _loc2_);
				_loc3_ += 2;
			}
			this.m_spriteSuspiciousBodies.graphics.endFill();
		}
	}
}

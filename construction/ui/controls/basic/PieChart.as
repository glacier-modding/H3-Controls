package basic
{
	import flash.display.Sprite;
	
	public class PieChart extends Sprite
	{
		
		private const PI:Number = 3.141592653589793;
		
		public function PieChart()
		{
			super();
		}
		
		protected function drawSlice(param1:Sprite, param2:Number, param3:Number, param4:uint = 16711680, param5:Number = 0):void
		{
			var _loc6_:Number = NaN;
			var _loc7_:Number = NaN;
			var _loc8_:Number = NaN;
			var _loc9_:Number = NaN;
			var _loc10_:Number = NaN;
			var _loc11_:Number = NaN;
			var _loc12_:Number = NaN;
			var _loc13_:Number = NaN;
			var _loc14_:Number = NaN;
			var _loc15_:Number = NaN;
			param1.graphics.clear();
			param1.graphics.beginFill(param4, 1);
			param1.graphics.moveTo(0, 0);
			if (Math.abs(param3) > 360)
			{
				param3 = 360;
			}
			_loc9_ = Math.ceil(Math.abs(param3) / 45);
			_loc6_ = (_loc6_ = param3 / _loc9_) / 180 * this.PI;
			_loc7_ = param5 / 180 * this.PI;
			_loc10_ = Math.cos(_loc7_) * param2;
			_loc11_ = Math.sin(-_loc7_) * param2;
			param1.graphics.lineTo(_loc10_, _loc11_);
			var _loc16_:int = 0;
			while (_loc16_ < _loc9_)
			{
				_loc8_ = (_loc7_ += _loc6_) - _loc6_ / 2;
				_loc12_ = Math.cos(_loc7_) * param2;
				_loc13_ = Math.sin(_loc7_) * param2;
				_loc14_ = Math.cos(_loc8_) * (param2 / Math.cos(_loc6_ / 2));
				_loc15_ = Math.sin(_loc8_) * (param2 / Math.cos(_loc6_ / 2));
				param1.graphics.curveTo(_loc14_, _loc15_, _loc12_, _loc13_);
				_loc16_++;
			}
			param1.graphics.lineTo(0, 0);
			param1.graphics.endFill();
		}
	}
}

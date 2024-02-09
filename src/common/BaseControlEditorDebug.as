package common
{
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BaseControlEditorDebug
	{
		
		private static var s_selectionWidget:Sprite;
		
		private static var s_selectionWidgetStage:Stage;
		
		private static var s_selectionArrowWidget:Sprite;
		
		private static var s_selectionArrowWidgetStage:Stage;
		
		private static var s_containerWidget:Sprite;
		
		private static var s_containerWidgetStage:Stage;
		
		public function BaseControlEditorDebug()
		{
			super();
		}
		
		public static function setSelectionWidget(param1:BaseControl, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number):Sprite
		{
			if (s_selectionWidget != null)
			{
				unsetSelectionWidget(s_selectionWidget);
			}
			if (param1 == null || param1.stage == null)
			{
				return null;
			}
			s_selectionWidget = new Sprite();
			s_selectionWidget.name = "EditorSelectionWidgetNode";
			drawSelectionWidget(s_selectionWidget, param1, param2, param3, param4, param5, param6, param7);
			s_selectionWidgetStage = param1.stage;
			s_selectionWidgetStage.addChild(s_selectionWidget);
			return s_selectionWidget;
		}
		
		public static function unsetSelectionWidget(param1:Sprite):void
		{
			if (param1 == null || s_selectionWidget != param1)
			{
				return;
			}
			s_selectionWidgetStage.removeChild(s_selectionWidget);
			s_selectionWidget = null;
			s_selectionWidgetStage = null;
		}
		
		public static function setSelectionArrowWidget(param1:BaseControl, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number):Sprite
		{
			if (s_selectionArrowWidget != null)
			{
				unsetSelectionArrowWidget(s_selectionArrowWidget);
			}
			if (param1 == null || param1.stage == null)
			{
				return null;
			}
			var _loc8_:Number = 0;
			var _loc9_:Rectangle = new Rectangle(_loc8_, _loc8_, param1.stage.stageWidth - _loc8_, param1.stage.stageHeight - _loc8_);
			if (isObjectInBounds(_loc9_, param1, param2, param3, param4, param5, param6, param7))
			{
				return null;
			}
			s_selectionArrowWidget = new Sprite();
			s_selectionArrowWidget.name = "EditorSelectionArrowWidgetNode";
			drawSelectionArrowWidget(s_selectionArrowWidget, _loc9_, param1, param2, param3, param4, param5, param6, param7);
			s_selectionArrowWidgetStage = param1.stage;
			s_selectionArrowWidgetStage.addChild(s_selectionArrowWidget);
			return s_selectionArrowWidget;
		}
		
		public static function unsetSelectionArrowWidget(param1:Sprite):void
		{
			if (param1 == null || s_selectionArrowWidget != param1)
			{
				return;
			}
			s_selectionArrowWidgetStage.removeChild(s_selectionArrowWidget);
			s_selectionArrowWidget = null;
			s_selectionArrowWidgetStage = null;
		}
		
		public static function setContainerWidget(param1:BaseControl, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number):Sprite
		{
			if (s_containerWidget != null)
			{
				unsetContainerWidget(s_containerWidget);
			}
			if (param1 == null || param1.stage == null)
			{
				return null;
			}
			s_containerWidget = new Sprite();
			s_containerWidget.name = "EditorContainerWidgetNode";
			drawContainerWidget(s_containerWidget, param1, param2, param3, param4, param5, param6, param7);
			s_containerWidgetStage = param1.stage;
			s_containerWidgetStage.addChild(s_containerWidget);
			return s_containerWidget;
		}
		
		public static function unsetContainerWidget(param1:Sprite):void
		{
			if (param1 == null || s_containerWidget != param1)
			{
				return;
			}
			s_containerWidgetStage.removeChild(s_containerWidget);
			s_containerWidget = null;
			s_containerWidgetStage = null;
		}
		
		private static function returnARGB(param1:uint, param2:uint):uint
		{
			var _loc3_:uint = 0;
			_loc3_ += param2 << 24;
			return _loc3_ + param1;
		}
		
		private static function isObjectInBounds(param1:Rectangle, param2:BaseControl, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number):Boolean
		{
			var _loc9_:Point = new Point(param2.x + param7, param2.y + param8);
			var _loc10_:Point = param2.parent.localToGlobal(_loc9_);
			var _loc11_:Point = param2.parent.globalToLocal(new Point(0, 0));
			var _loc12_:Sprite = new Sprite();
			param2.parent.addChild(_loc12_);
			_loc12_.x = _loc11_.x;
			_loc12_.y = _loc11_.y;
			var _loc13_:Point = _loc12_.localToGlobal(new Point(param3, param4));
			param2.parent.removeChild(_loc12_);
			var _loc14_:Rectangle = new Rectangle(_loc10_.x, _loc10_.y, Math.max(1, Math.abs(_loc13_.x)), Math.max(1, Math.abs(_loc13_.y)));
			if (_loc13_.x < 0)
			{
				_loc14_.x -= _loc14_.width;
			}
			if (_loc13_.y < 0)
			{
				_loc14_.y -= _loc14_.height;
			}
			return param1.intersects(_loc14_);
		}
		
		private static function drawSelectionWidget(param1:Sprite, param2:BaseControl, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number):void
		{
			var _loc9_:int = 65280;
			var _loc10_:int = 0;
			var _loc11_:int = 53247;
			var _loc12_:Number = 2;
			var _loc13_:Number = 4;
			var _loc14_:Number = 30;
			var _loc15_:Point = new Point(param2.x + param7, param2.y + param8);
			var _loc16_:Point = param2.parent.localToGlobal(_loc15_);
			var _loc17_:Point = param2.parent.globalToLocal(new Point(0, 0));
			var _loc18_:Sprite = new Sprite();
			param2.parent.addChild(_loc18_);
			_loc18_.x = _loc17_.x;
			_loc18_.y = _loc17_.y;
			var _loc19_:Point = _loc18_.localToGlobal(new Point(param3, param4));
			param2.parent.removeChild(_loc18_);
			var _loc20_:Number = Math.floor(_loc12_ / 2);
			param1.graphics.lineStyle(_loc12_, _loc10_, 1, true, LineScaleMode.NONE, null, JointStyle.MITER);
			param1.graphics.drawRect(_loc20_ * 2, _loc20_ * 2, _loc19_.x - _loc12_ * 2, _loc19_.y - _loc12_ * 2);
			param1.graphics.lineStyle(_loc12_, _loc9_, 1, true, LineScaleMode.NONE, null, JointStyle.MITER);
			param1.graphics.drawRect(_loc20_, _loc20_, _loc19_.x - _loc12_, _loc19_.y - _loc12_);
			param1.graphics.endFill();
			var _loc21_:Point = new Point(_loc19_.x * param5, _loc19_.y * param6);
			param1.graphics.lineStyle(_loc13_ + 2, _loc10_, 0.8, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);
			param1.graphics.moveTo(_loc21_.x - _loc14_, _loc21_.y);
			param1.graphics.lineTo(_loc21_.x + _loc14_, _loc21_.y);
			param1.graphics.moveTo(_loc21_.x, _loc21_.y - _loc14_);
			param1.graphics.lineTo(_loc21_.x, _loc21_.y + _loc14_);
			param1.graphics.lineStyle(_loc13_, _loc11_, 1, false, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER);
			param1.graphics.moveTo(_loc21_.x - _loc14_, _loc21_.y);
			param1.graphics.lineTo(_loc21_.x + _loc14_, _loc21_.y);
			param1.graphics.moveTo(_loc21_.x, _loc21_.y - _loc14_);
			param1.graphics.lineTo(_loc21_.x, _loc21_.y + _loc14_);
			param1.x = _loc16_.x;
			param1.y = _loc16_.y;
		}
		
		private static function drawSelectionArrowWidget(param1:Sprite, param2:Rectangle, param3:BaseControl, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number):void
		{
			var _loc12_:Number = NaN;
			var _loc10_:int = 53247;
			var _loc11_:int = 0;
			var _loc13_:Number = (_loc12_ = 4) + 2;
			var _loc14_:Number = 50;
			var _loc15_:Number = 15;
			var _loc16_:Number = 20;
			var _loc17_:Point = new Point(param3.x + param8, param3.y + param9);
			var _loc18_:Point = param3.parent.localToGlobal(_loc17_);
			var _loc19_:Point = param3.parent.globalToLocal(new Point(0, 0));
			var _loc20_:Sprite = new Sprite();
			param3.parent.addChild(_loc20_);
			_loc20_.x = _loc19_.x;
			_loc20_.y = _loc19_.y;
			var _loc21_:Point = _loc20_.localToGlobal(new Point(param4, param5));
			param3.parent.removeChild(_loc20_);
			var _loc22_:Point = new Point(_loc18_.x + _loc21_.x * param6, _loc18_.y + _loc21_.y * param7);
			var _loc23_:Point = new Point(Math.max(param2.x + _loc16_, Math.min(_loc22_.x, param2.width - _loc16_)), Math.max(param2.y + _loc16_, Math.min(_loc22_.y, param2.height - _loc16_)));
			var _loc24_:Point;
			(_loc24_ = new Point(_loc22_.x - _loc23_.x, _loc22_.y - _loc23_.y)).normalize(1);
			var _loc25_:Number = Math.atan2(_loc24_.y, _loc24_.x);
			param1.graphics.lineStyle(_loc13_, _loc11_, 0.8, false, LineScaleMode.NONE, null, JointStyle.MITER);
			param1.graphics.moveTo(_loc23_.x, _loc23_.y);
			param1.graphics.lineTo(_loc23_.x + _loc24_.x * -_loc14_, _loc23_.y + _loc24_.y * -_loc14_);
			param1.graphics.moveTo(_loc23_.x, _loc23_.y);
			param1.graphics.lineTo(_loc23_.x - _loc15_ * Math.cos(_loc25_) + _loc15_ * Math.sin(_loc25_), _loc23_.y - _loc15_ * Math.cos(_loc25_) - _loc15_ * Math.sin(_loc25_));
			param1.graphics.moveTo(_loc23_.x, _loc23_.y);
			param1.graphics.lineTo(_loc23_.x - _loc15_ * Math.cos(_loc25_) - _loc15_ * Math.sin(_loc25_), _loc23_.y + _loc15_ * Math.cos(_loc25_) - _loc15_ * Math.sin(_loc25_));
			param1.graphics.lineStyle(_loc12_, _loc10_, 1, true, LineScaleMode.NONE, null, JointStyle.MITER);
			param1.graphics.moveTo(_loc23_.x, _loc23_.y);
			param1.graphics.lineTo(_loc23_.x + _loc24_.x * -_loc14_, _loc23_.y + _loc24_.y * -_loc14_);
			param1.graphics.moveTo(_loc23_.x, _loc23_.y);
			param1.graphics.lineTo(_loc23_.x - _loc15_ * Math.cos(_loc25_) + _loc15_ * Math.sin(_loc25_), _loc23_.y - _loc15_ * Math.cos(_loc25_) - _loc15_ * Math.sin(_loc25_));
			param1.graphics.moveTo(_loc23_.x, _loc23_.y);
			param1.graphics.lineTo(_loc23_.x - _loc15_ * Math.cos(_loc25_) - _loc15_ * Math.sin(_loc25_), _loc23_.y + _loc15_ * Math.cos(_loc25_) - _loc15_ * Math.sin(_loc25_));
			param1.x = 0;
			param1.y = 0;
		}
		
		private static function drawContainerWidget(param1:Sprite, param2:BaseControl, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number):void
		{
			var _loc9_:int = 13421772;
			var _loc10_:int = 0;
			var _loc11_:int = 16777215;
			var _loc12_:int = 4;
			var _loc13_:int = 4;
			var _loc14_:Number = 2;
			var _loc15_:Number = 4;
			var _loc16_:Number = 30;
			var _loc17_:Point = new Point(param2.x + param7, param2.y + param8);
			var _loc18_:Point = param2.parent.localToGlobal(_loc17_);
			var _loc19_:Point = param2.parent.globalToLocal(new Point(0, 0));
			var _loc20_:Sprite = new Sprite();
			param2.parent.addChild(_loc20_);
			_loc20_.x = _loc19_.x;
			_loc20_.y = _loc19_.y;
			var _loc21_:Point = _loc20_.localToGlobal(new Point(param3, param4));
			param2.parent.removeChild(_loc20_);
			var _loc22_:BitmapData = new BitmapData(_loc12_ + _loc13_, _loc12_ + _loc13_);
			var _loc23_:Rectangle = new Rectangle(0, 0, _loc12_, _loc12_);
			var _loc24_:Rectangle = new Rectangle(0, 0, _loc12_ + _loc13_, _loc12_ + _loc13_);
			var _loc25_:Rectangle = new Rectangle(_loc13_, _loc13_, _loc12_, _loc12_);
			var _loc26_:uint = returnARGB(_loc9_, 255);
			_loc22_.fillRect(_loc24_, 0);
			_loc22_.fillRect(_loc23_, _loc26_);
			_loc22_.fillRect(_loc25_, _loc26_);
			param1.graphics.lineStyle(0);
			param1.graphics.beginBitmapFill(_loc22_);
			param1.graphics.drawRect(0, 0, _loc21_.x, _loc14_);
			param1.graphics.drawRect(0, 0, _loc14_, _loc21_.y);
			param1.graphics.drawRect(_loc21_.x - _loc14_, 0, _loc14_, _loc21_.y);
			param1.graphics.drawRect(0, _loc21_.y - _loc14_, _loc21_.x, _loc14_);
			param1.graphics.endFill();
			var _loc27_:Point = new Point(_loc21_.x * param5, _loc21_.y * param6);
			param1.graphics.lineStyle(_loc15_ + 2, _loc10_, 0.8, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);
			param1.graphics.moveTo(_loc27_.x - _loc16_, _loc27_.y - _loc16_);
			param1.graphics.lineTo(_loc27_.x + _loc16_, _loc27_.y + _loc16_);
			param1.graphics.moveTo(_loc27_.x + _loc16_, _loc27_.y - _loc16_);
			param1.graphics.lineTo(_loc27_.x - _loc16_, _loc27_.y + _loc16_);
			param1.graphics.moveTo(_loc27_.x - _loc16_, _loc27_.y);
			param1.graphics.lineTo(_loc27_.x + _loc16_, _loc27_.y);
			param1.graphics.moveTo(_loc27_.x, _loc27_.y - _loc16_);
			param1.graphics.lineTo(_loc27_.x, _loc27_.y + _loc16_);
			param1.graphics.lineStyle(_loc15_, _loc11_, 1, false, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER);
			param1.graphics.moveTo(_loc27_.x - _loc16_, _loc27_.y - _loc16_);
			param1.graphics.lineTo(_loc27_.x + _loc16_, _loc27_.y + _loc16_);
			param1.graphics.moveTo(_loc27_.x + _loc16_, _loc27_.y - _loc16_);
			param1.graphics.lineTo(_loc27_.x - _loc16_, _loc27_.y + _loc16_);
			param1.graphics.moveTo(_loc27_.x - _loc16_, _loc27_.y);
			param1.graphics.lineTo(_loc27_.x + _loc16_, _loc27_.y);
			param1.graphics.moveTo(_loc27_.x, _loc27_.y - _loc16_);
			param1.graphics.lineTo(_loc27_.x, _loc27_.y + _loc16_);
			param1.x = _loc18_.x;
			param1.y = _loc18_.y;
		}
	}
}

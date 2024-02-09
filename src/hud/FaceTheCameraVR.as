package hud
{
	import common.Animate;
	import common.BaseControl;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class FaceTheCameraVR extends BaseControl
	{
		
		private static const P2W:Number = 1 / 1000;
		
		private static const W2P:Number = 1000 / 1;
		
		private var m_widgetContainer:Sprite;
		
		private var m_cameraWidget:Sprite;
		
		private var m_textWidget:Sprite;
		
		private var m_arrowStripWidget:Vector.<Shape>;
		
		private var m_worldZPositionOfRearPlane:Number = 0;
		
		private var m_fadeIn_Delay:Number;
		
		private var m_fadeIn_Duration:Number;
		
		private var m_fadeOut_Delay:Number;
		
		private var m_fadeOut_Duration:Number;
		
		private var m_rearPlane_MoveAnimDuration:Number;
		
		private var m_textWidget_Width:Number;
		
		private var m_arrowStripWidget_WidthSpacing:Number;
		
		private var m_arrowStripWidget_AngularSpan:Number;
		
		private var m_arrowStripWidget_ArrowLength:Number;
		
		private var m_arrowStripWidget_ArrowHeight:Number;
		
		private var m_arrowStripWidget_NumArrows:int;
		
		public function FaceTheCameraVR()
		{
			super();
			this.m_widgetContainer = new Sprite();
			addChild(this.m_widgetContainer);
			this.m_widgetContainer.alpha = 0;
			this.m_widgetContainer.scaleX = P2W;
			this.m_widgetContainer.scaleY = P2W;
			this.m_widgetContainer.scaleZ = P2W;
		}
		
		private static function drawArrow(param1:Graphics, param2:Number, param3:Number):void
		{
			param1.beginFill(16777215);
			param1.moveTo(0, 0 + param3 / 2);
			param1.lineTo(0 + param2, 0 + param3 / 2);
			param1.lineTo(0 + param2 + param3 / 2, 0);
			param1.lineTo(0 + param2, 0 - param3 / 2);
			param1.lineTo(0, 0 - param3 / 2);
			param1.lineTo(0 + param3 / 2, 0);
			param1.endFill();
		}
		
		private static function createXYZAxes(param1:Number):Sprite
		{
			var _loc2_:Sprite = new Sprite();
			var _loc3_:Number = param1 / 200;
			var _loc4_:uint = 16711680;
			var _loc5_:uint = 65280;
			var _loc6_:uint = 255;
			_loc2_.graphics.lineStyle(_loc3_, _loc4_);
			_loc2_.graphics.moveTo(0, 0);
			_loc2_.graphics.lineTo(param1, 0);
			_loc2_.graphics.lineStyle(_loc3_, _loc5_);
			_loc2_.graphics.moveTo(0, 0);
			_loc2_.graphics.lineTo(0, param1);
			var _loc7_:Shape;
			(_loc7_ = new Shape()).rotationY = -90;
			_loc2_.addChild(_loc7_);
			_loc7_.graphics.lineStyle(_loc3_, _loc6_);
			_loc7_.graphics.moveTo(0, 0);
			_loc7_.graphics.lineTo(param1, 0);
			return _loc2_;
		}
		
		public function set fadeIn_Delay(param1:Number):void
		{
			this.m_fadeIn_Delay = param1;
		}
		
		public function set fadeIn_Duration(param1:Number):void
		{
			this.m_fadeIn_Duration = param1;
		}
		
		public function set fadeOut_Delay(param1:Number):void
		{
			this.m_fadeOut_Delay = param1;
		}
		
		public function set fadeOut_Duration(param1:Number):void
		{
			this.m_fadeOut_Duration = param1;
		}
		
		public function set rearPlane_MoveAnimDuration(param1:Number):void
		{
			this.m_rearPlane_MoveAnimDuration = param1;
		}
		
		public function set textWidget_Width(param1:Number):void
		{
			this.m_textWidget_Width = param1;
			this.updateTextWidget();
		}
		
		public function set arrowStripWidget_WidthSpacing(param1:Number):void
		{
			this.m_arrowStripWidget_WidthSpacing = param1;
			this.updateArrowStripWidget();
		}
		
		public function set arrowStripWidget_AngularSpan(param1:Number):void
		{
			this.m_arrowStripWidget_AngularSpan = param1;
			this.updateArrowStripWidget();
		}
		
		public function set arrowStripWidget_ArrowLength(param1:Number):void
		{
			this.m_arrowStripWidget_ArrowLength = param1;
			this.updateArrowStripWidget();
		}
		
		public function set arrowStripWidget_ArrowHeight(param1:Number):void
		{
			this.m_arrowStripWidget_ArrowHeight = param1;
			this.updateArrowStripWidget();
		}
		
		public function set arrowStripWidget_NumArrows(param1:int):void
		{
			this.m_arrowStripWidget_NumArrows = param1;
			this.updateArrowStripWidget();
		}
		
		public function set cameraWidget(param1:Boolean):void
		{
			if (param1 && !this.m_cameraWidget)
			{
				this.m_cameraWidget = new Sprite();
				this.m_widgetContainer.addChild(this.m_cameraWidget);
			}
			else if (!param1 && Boolean(this.m_cameraWidget))
			{
				this.m_widgetContainer.removeChild(this.m_cameraWidget);
				this.m_cameraWidget = null;
			}
			this.updateCameraWidget();
		}
		
		public function set textWidget(param1:Boolean):void
		{
			var _loc2_:TextField = null;
			if (param1 && !this.m_textWidget)
			{
				this.m_textWidget = new Sprite();
				this.addChild(this.m_textWidget);
				_loc2_ = new TextField();
				_loc2_.autoSize = TextFieldAutoSize.LEFT;
				_loc2_.multiline = false;
				MenuUtils.setupTextUpper(_loc2_, Localization.get("UI_VR_HUD_FACE_THE_CAMERA"), 16, MenuConstants.FONT_TYPE_MEDIUM, "#ffffff");
				_loc2_.x = -_loc2_.width / 2;
				_loc2_.y = -_loc2_.height / 2;
				this.m_textWidget.rotation = 180;
				this.m_textWidget.z = this.m_worldZPositionOfRearPlane;
				this.m_textWidget.addChild(_loc2_);
			}
			else if (!param1 && Boolean(this.m_textWidget))
			{
				Animate.kill(this.m_textWidget);
				this.removeChild(this.m_textWidget);
				this.m_textWidget = null;
			}
			this.updateTextWidget();
		}
		
		public function set arrowStripWidget(param1:Boolean):void
		{
			var _loc2_:int = 0;
			if (param1 && !this.m_arrowStripWidget)
			{
				this.m_arrowStripWidget = new Vector.<Shape>();
			}
			else if (!param1 && Boolean(this.m_arrowStripWidget))
			{
				_loc2_ = 0;
				while (_loc2_ < this.m_arrowStripWidget.length)
				{
					Animate.kill(this.m_arrowStripWidget[_loc2_]);
					this.m_widgetContainer.removeChild(this.m_arrowStripWidget[_loc2_]);
					_loc2_++;
				}
				this.m_arrowStripWidget = null;
			}
			this.updateArrowStripWidget();
		}
		
		public function set showMeatSpaceAxes(param1:Boolean):void
		{
			var _loc2_:Sprite = Sprite(getChildByName("meatSpaceAxes"));
			if (param1 && !_loc2_)
			{
				_loc2_ = createXYZAxes(1);
				_loc2_.name = "meatSpaceAxes";
				addChild(_loc2_);
			}
			else if (!param1 && Boolean(_loc2_))
			{
				removeChild(_loc2_);
			}
		}
		
		public function moveRearPlaneToZPosition(param1:Number):void
		{
			var _loc2_:int = 0;
			var _loc3_:* = false;
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			var _loc6_:Number = NaN;
			var _loc7_:Number = NaN;
			var _loc8_:Number = NaN;
			var _loc9_:Number = NaN;
			this.m_worldZPositionOfRearPlane = param1;
			if (this.m_textWidget)
			{
				Animate.to(this.m_textWidget, this.m_rearPlane_MoveAnimDuration, 0, {"z": param1}, Animate.SineOut);
			}
			if (this.m_arrowStripWidget)
			{
				_loc2_ = 0;
				while (_loc2_ < this.m_arrowStripWidget.length)
				{
					_loc3_ = _loc2_ >= this.m_arrowStripWidget_NumArrows;
					_loc6_ = (_loc5_ = (_loc4_ = Number(_loc2_ % this.m_arrowStripWidget_NumArrows) / this.m_arrowStripWidget_NumArrows) * this.m_arrowStripWidget_AngularSpan) / 180 * Math.PI;
					_loc7_ = W2P * this.m_arrowStripWidget_WidthSpacing;
					_loc8_ = W2P * this.m_worldZPositionOfRearPlane / 2;
					_loc9_ = _loc7_ + _loc8_ * Math.sin(_loc6_);
					param1 = _loc8_ * (1 + Math.cos(_loc6_));
					if (_loc3_)
					{
						_loc9_ *= -1;
					}
					Animate.to(this.m_arrowStripWidget[_loc2_], this.m_rearPlane_MoveAnimDuration, 0, {"x": _loc9_, "z": param1}, Animate.SineOut);
					_loc2_++;
				}
			}
		}
		
		public function fadeIn():void
		{
			Animate.kill(this.m_widgetContainer);
			Animate.to(this.m_widgetContainer, this.m_fadeIn_Duration, this.m_fadeIn_Delay, {"alpha": 1}, Animate.Linear);
		}
		
		public function fadeOut():void
		{
			Animate.kill(this.m_widgetContainer);
			Animate.to(this.m_widgetContainer, this.m_fadeOut_Duration, this.m_fadeOut_Delay, {"alpha": 0}, Animate.Linear);
		}
		
		private function updateCameraWidget():void
		{
			if (!this.m_cameraWidget)
			{
				return;
			}
			var _loc1_:Number = W2P * 0.2;
			var _loc2_:Number = W2P * 0.04;
			var _loc3_:Number = W2P * 0.01;
			var _loc4_:Number = W2P * 0.005;
			var _loc5_:Number = 0.75;
			var _loc6_:uint = 0;
			var _loc7_:uint = 16777215;
			var _loc8_:Graphics;
			(_loc8_ = this.m_cameraWidget.graphics).clear();
			_loc8_.lineStyle(_loc4_, _loc7_);
			_loc8_.beginFill(_loc6_, _loc5_);
			_loc8_.drawRect(-_loc1_ / 2, -_loc2_ / 2, _loc1_, _loc2_);
			_loc8_.endFill();
			_loc8_.drawCircle(-3 * _loc1_ / 12, 0, _loc3_);
			_loc8_.drawCircle(3 * _loc1_ / 12, 0, _loc3_);
		}
		
		private function updateArrowStripWidget():void
		{
			var _loc1_:Shape = null;
			var _loc3_:* = false;
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			var _loc6_:Number = NaN;
			var _loc7_:Number = NaN;
			var _loc8_:Number = NaN;
			var _loc9_:Number = NaN;
			var _loc10_:Number = NaN;
			var _loc11_:Number = NaN;
			if (!this.m_arrowStripWidget)
			{
				return;
			}
			if (this.m_arrowStripWidget_NumArrows < 0)
			{
				this.m_arrowStripWidget_NumArrows = 0;
			}
			while (this.m_arrowStripWidget.length < 2 * this.m_arrowStripWidget_NumArrows)
			{
				_loc1_ = new Shape();
				this.m_arrowStripWidget.push(_loc1_);
				this.m_widgetContainer.addChild(_loc1_);
			}
			while (this.m_arrowStripWidget.length > 2 * this.m_arrowStripWidget_NumArrows)
			{
				_loc1_ = this.m_arrowStripWidget.pop();
				Animate.kill(_loc1_);
				this.m_widgetContainer.removeChild(_loc1_);
			}
			var _loc2_:int = 0;
			while (_loc2_ < this.m_arrowStripWidget.length)
			{
				_loc1_ = this.m_arrowStripWidget[_loc2_];
				_loc3_ = _loc2_ >= this.m_arrowStripWidget_NumArrows;
				_loc6_ = (_loc5_ = (_loc4_ = Number(_loc2_ % this.m_arrowStripWidget_NumArrows) / this.m_arrowStripWidget_NumArrows) * this.m_arrowStripWidget_AngularSpan) / 180 * Math.PI;
				_loc7_ = W2P * this.m_arrowStripWidget_WidthSpacing;
				_loc8_ = W2P * this.m_arrowStripWidget_ArrowLength;
				_loc9_ = W2P * this.m_arrowStripWidget_ArrowHeight;
				_loc1_.graphics.clear();
				drawArrow(_loc1_.graphics, _loc8_, _loc9_);
				_loc10_ = 0.5;
				_loc1_.alpha = _loc10_ * (1 - _loc4_);
				_loc11_ = W2P * this.m_worldZPositionOfRearPlane / 2;
				_loc1_.x = _loc7_ + _loc11_ * Math.sin(_loc6_);
				_loc1_.z = _loc11_ * (1 + Math.cos(_loc6_));
				_loc1_.rotationY = _loc5_ + 0.5 * this.m_arrowStripWidget_AngularSpan / this.m_arrowStripWidget_NumArrows;
				if (_loc3_)
				{
					_loc1_.x *= -1;
					_loc1_.rotationY = 180 - _loc1_.rotationY;
				}
				_loc2_++;
			}
		}
		
		private function updateTextWidget():void
		{
			if (!this.m_textWidget)
			{
				return;
			}
			this.m_textWidget.width = this.m_textWidget_Width;
			this.m_textWidget.scaleY = this.m_textWidget.scaleX;
		}
	}
}

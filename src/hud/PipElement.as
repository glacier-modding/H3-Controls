package hud
{
	import common.Animate;
	import common.BaseControl;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	public class PipElement extends BaseControl
	{
		
		private var m_view:PIPElementView;
		
		private var m_pipSize:Point;
		
		private var m_bgMcScaleY:Number;
		
		private var m_pipShown:Boolean;
		
		private var m_labelTxtTextFormat:TextFormat;
		
		public function PipElement()
		{
			super();
			this.m_view = new PIPElementView();
			this.m_view.visible = false;
			addChild(this.m_view);
			this.m_labelTxtTextFormat = new TextFormat();
			this.m_labelTxtTextFormat.leading = -3.5;
			this.m_view.messageMc.labelTxt.autoSize = "left";
			this.m_view.messageMc.labelTxt.multiline = true;
			this.m_view.messageMc.labelTxt.wordWrap = true;
			this.m_view.messageMc.labelTxt.width = 406;
			this.m_view.messageMc.labelTxt.text = "";
			this.m_view.messageMc.labelTxt.setTextFormat(this.m_labelTxtTextFormat);
			this.m_view.messageMc.bgMc.height = 23;
			this.m_bgMcScaleY = 1;
			this.m_view.borderMc.alpha = 0.6;
			this.m_view.gradientMc.alpha = 0.6;
			this.m_pipSize = new Point(this.m_view.gradientMc.width, this.m_view.gradientMc.height);
		}
		
		public function setPipMessage(param1:String, param2:Number):void
		{
			if (param1 != "")
			{
				MenuUtils.setColor(this.m_view.messageMc.iconMc, param2 == 1 ? uint(MenuConstants.COLOR_GREY_ULTRA_DARK) : uint(MenuConstants.COLOR_WHITE));
				this.m_view.messageMc.iconMc.gotoAndStop(param2 > 0 ? param2 : 1);
				if (param2 == 1)
				{
					this.m_view.messageMc.bgGradient.gotoAndStop(3);
					this.m_view.messageMc.bgMc.gotoAndStop(2);
				}
				else
				{
					this.m_view.messageMc.bgGradient.gotoAndStop(1);
					this.m_view.messageMc.bgMc.gotoAndStop(1);
				}
				MenuUtils.setupTextUpper(this.m_view.messageMc.labelTxt, param1, 18, MenuConstants.FONT_TYPE_MEDIUM, param2 == 1 ? MenuConstants.FontColorGreyUltraDark : MenuConstants.FontColorGreyUltraLight);
				this.m_view.messageMc.labelTxt.setTextFormat(this.m_labelTxtTextFormat);
				this.m_view.messageMc.bgMc.height = 23 + (this.m_view.messageMc.labelTxt.numLines - 1) * 19;
				this.m_bgMcScaleY = this.m_view.messageMc.bgMc.scaleY;
				this.showPipMessage();
			}
			else if (this.m_pipShown)
			{
				this.hidePipMessage();
			}
		}
		
		private function showPipMessage():void
		{
			this.m_pipShown = true;
			this.playSound("play_gui_pip_shown");
			this.clearPipMessageAnimations();
			this.m_view.messageMc.visible = true;
			this.m_view.messageMc.alpha = 0;
			this.m_view.messageMc.bgGradient.alpha = 0;
			this.m_view.messageMc.iconMc.alpha = 0;
			this.m_view.messageMc.labelTxt.alpha = 0;
			this.m_view.messageMc.bgMc.alpha = 0;
			this.m_view.visible = true;
			Animate.fromTo(this.m_view.messageMc, 0.2, 0, {"alpha": 0}, {"alpha": 1}, Animate.ExpoOut);
			Animate.fromTo(this.m_view.messageMc.bgGradient, 0.5, 0, {"alpha": 0}, {"alpha": 0.4}, Animate.ExpoOut);
			Animate.fromTo(this.m_view.messageMc.iconMc, 0.3, 0.1, {"alpha": 0, "scaleX": 0, "scaleY": 0}, {"alpha": 1, "scaleX": 1, "scaleY": 1}, Animate.BackOut);
			Animate.fromTo(this.m_view.messageMc.labelTxt, 0.4, 0, {"alpha": 0, "y": 229}, {"alpha": 1, "y": 239}, Animate.ExpoOut);
			Animate.fromTo(this.m_view.messageMc.bgMc, 0.4, 0, {"alpha": 0, "scaleY": 0}, {"alpha": 1, "scaleY": this.m_bgMcScaleY}, Animate.ExpoOut);
		}
		
		private function hidePipMessage():void
		{
			this.m_pipShown = false;
			this.playSound("play_gui_pip_hide");
			this.clearPipMessageAnimations();
			this.m_view.messageMc.labelTxt.text = "";
			this.m_view.messageMc.visible = false;
			this.m_view.visible = false;
		}
		
		private function clearPipMessageAnimations():void
		{
			Animate.kill(this.m_view.messageMc);
			Animate.kill(this.m_view.messageMc.iconMc);
			Animate.kill(this.m_view.messageMc.bgGradient);
			Animate.kill(this.m_view.messageMc.labelTxt);
			Animate.kill(this.m_view.messageMc.bgMc);
		}
		
		public function showTestPipElement():void
		{
			var _loc1_:String = "This is a test string displaying Picture in Picture Info";
			this.setPipMessage(_loc1_, 0);
		}
		
		public function hideTestPipElement():void
		{
			this.hidePipMessage();
		}
		
		private function updateNotifySize():void
		{
			var _loc1_:Point = new Point(this.m_view.gradientMc.x, this.m_view.gradientMc.y);
			var _loc2_:Point = new Point(this.m_pipSize.x * this.scaleX, this.m_pipSize.y * this.scaleY);
			var _loc3_:Point = this.localToGlobal(_loc1_);
			ExternalInterface.call("RenderSetPiPViewport", _loc3_.x, _loc3_.y, _loc2_.x, _loc2_.y);
		}
		
		public function playSound(param1:String):void
		{
			ExternalInterface.call("PlaySound", param1);
		}
		
		override public function onSetSize(param1:Number, param2:Number):void
		{
			this.scaleX = this.scaleY = MenuUtils.getFillAspectScale(MenuConstants.BaseWidth, MenuConstants.BaseHeight, param1, param2);
			this.updateNotifySize();
		}
	}
}

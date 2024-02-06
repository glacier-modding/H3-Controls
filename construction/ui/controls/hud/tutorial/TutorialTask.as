package hud.tutorial
{
	import common.Animate;
	import common.BaseControl;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	
	public class TutorialTask extends BaseControl
	{
		
		private var m_view:TutorialTaskView;
		
		private var m_header:String;
		
		private var m_label:String;
		
		private var m_isCentered:Boolean = false;
		
		public function TutorialTask()
		{
			super();
			this.m_view = new TutorialTaskView();
			addChild(this.m_view);
			this.m_view.alpha = 0;
			var _loc1_:Number = ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL ? 1.2 : 1;
			this.m_view.scaleX = _loc1_;
			this.m_view.scaleY = _loc1_;
		}
		
		public function onSetData(param1:Object):void
		{
			var _loc2_:Number = ControlsMain.getDisplaySize() == ControlsMain.DISPLAY_SIZE_SMALL ? 1.2 : 1;
			if (this.m_view.scaleX != _loc2_)
			{
				this.m_view.scaleX = _loc2_;
				this.m_view.scaleY = _loc2_;
			}
			this.m_view.header_txt.visible = false;
			MenuUtils.setupTextUpper(this.m_view.header_txt, String(param1.header) || "", 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGrey);
			MenuUtils.setupTextUpper(this.m_view.label_txt, String(param1.title) || "", 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.recenter();
		}
		
		public function setCentered(param1:Boolean):void
		{
			if (this.m_isCentered != param1)
			{
				this.m_isCentered = param1;
				this.recenter();
			}
		}
		
		private function recenter():void
		{
			if (!this.m_isCentered)
			{
				this.m_view.x = 0;
			}
			else
			{
				this.m_view.x = -this.m_view.scaleX * (this.m_view.label_txt.x + this.m_view.label_txt.textWidth) / 2;
			}
		}
		
		public function ShowNotification():void
		{
			Animate.kill(this.m_view);
			Animate.kill(this.m_view.icon_mc);
			this.m_view.visible = true;
			this.m_view.icon_mc.alpha = 0.3;
			Animate.fromTo(this.m_view.icon_mc, 0.05, 0.7, {"scaleX": 1.2, "scaleY": 1.2, "alpha": 0.7}, {"scaleX": 1, "scaleY": 1, "alpha": 1}, Animate.ExpoIn);
			Animate.fromTo(this.m_view, 0.6, 0.1, {"y": 62, "alpha": 0}, {"y": 0, "alpha": 1}, Animate.ExpoIn);
		}
		
		public function HideNotification():void
		{
			Animate.kill(this.m_view);
			Animate.kill(this.m_view.icon_mc);
			Animate.fromTo(this.m_view, 0.6, 0, {"y": this.m_view.y, "alpha": this.m_view.alpha}, {"y": -62, "alpha": 0}, Animate.ExpoIn, function():void
			{
				m_view.visible = false;
			});
		}
		
		public function set showHeader(param1:Boolean):void
		{
			this.m_view.header_txt.visible = param1;
		}
	}
}

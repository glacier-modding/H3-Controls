package hud.tutorial
{
	import common.Animate;
	import common.BaseControl;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	
	public class TutorialBar extends BaseControl
	{
		
		private var m_view:TutorialBarView;
		
		public function TutorialBar()
		{
			super();
			this.m_view = new TutorialBarView();
			addChild(this.m_view);
			this.m_view.visible = false;
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
			MenuUtils.setupText(this.m_view.label_txt, String(param1.title) || "", 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		}
		
		public function ShowNotification():void
		{
			this.m_view.visible = true;
			this.m_view.box_mc.height = this.m_view.label_txt.textHeight + 34;
			if (this.m_view.box_mc.height < 64)
			{
				this.m_view.box_mc.height = 64;
			}
			this.m_view.icon_mc.scaleX = this.m_view.icon_mc.scaleY = 1.3;
			this.m_view.icon_mc.alpha = 0.5;
			Animate.legacyTo(this.m_view.icon_mc, 0.7, {"scaleX": 1, "scaleY": 1, "alpha": 1}, Animate.ExpoIn);
			this.m_view.alpha = 0;
			var _loc1_:Number = 0;
			if (this.m_view.box_mc.height > 60)
			{
				_loc1_ = 60 - this.m_view.box_mc.height;
			}
			this.m_view.y = _loc1_ + 20;
			Animate.legacyTo(this.m_view, 0.5, {"alpha": 1, "y": _loc1_}, Animate.ExpoIn);
		}
		
		public function HideNotification():void
		{
			Animate.legacyTo(this.m_view, 0.5, {"alpha": 0}, Animate.ExpoIn, function():void
			{
				m_view.visible = false;
			});
		}
	}
}

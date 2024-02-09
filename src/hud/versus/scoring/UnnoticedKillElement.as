package hud.versus.scoring
{
	import common.Animate;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.MovieClip;
	import flash.text.TextFieldAutoSize;
	
	public class UnnoticedKillElement extends MovieClip
	{
		
		private var m_view:UnnoticedKillElementView;
		
		private var m_isAnimating:Boolean = false;
		
		public function UnnoticedKillElement()
		{
			super();
			this.m_view = new UnnoticedKillElementView();
			this.m_view.alpha = 0;
			this.m_view.bgMc.visible = false;
			addChild(this.m_view);
		}
		
		public function onSetData(param1:Object):void
		{
			this.updateHeader(param1.header);
			this.show();
		}
		
		public function show():void
		{
			this.m_view.barMc.scaleX = 1;
			Animate.to(this.m_view, 0.5, 0, {"alpha": 1}, Animate.ExpoOut);
		}
		
		public function hide():void
		{
			this.killAnimations();
			Animate.to(this.m_view, 0.5, 0, {"alpha": 0}, Animate.ExpoOut);
		}
		
		public function update(param1:Number):void
		{
			if (!this.m_isAnimating)
			{
				this.m_isAnimating = true;
				this.updateBar(param1);
				this.pulsateHeaderIn();
			}
		}
		
		private function updateHeader(param1:String):void
		{
			MenuUtils.setupTextUpper(this.m_view.headerMc.txtLabel, param1, 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.m_view.headerMc.txtLabel.autoSize = TextFieldAutoSize.CENTER;
			this.m_view.bgMc.width = this.m_view.headerMc.txtLabel.textWidth + 20;
		}
		
		private function updateBar(param1:Number):void
		{
			var duration:Number = param1;
			Animate.to(this.m_view.barMc, duration, 0, {"scaleX": 0}, Animate.Linear, function():void
			{
				m_isAnimating = false;
			});
		}
		
		private function pulsateHeaderOut():void
		{
			this.m_view.bgMc.visible = true;
			MenuUtils.setColor(this.m_view.headerMc, MenuConstants.COLOR_GREY_ULTRA_DARK);
			Animate.delay(this, 0.5, this.pulsateHeaderIn);
		}
		
		private function pulsateHeaderIn():void
		{
			this.m_view.bgMc.visible = false;
			MenuUtils.removeColor(this.m_view.headerMc);
			Animate.delay(this, 0.5, this.pulsateHeaderOut);
		}
		
		private function killAnimations():void
		{
			Animate.kill(this);
			Animate.kill(this.m_view.barMc);
			Animate.kill(this.m_view);
			this.m_isAnimating = false;
		}
	}
}

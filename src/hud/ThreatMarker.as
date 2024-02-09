package hud
{
	import common.Animate;
	import common.BaseControl;
	import flash.display.Sprite;
	
	public class ThreatMarker extends BaseControl
	{
		
		private var m_view:Sprite;
		
		private var m_outline:ThreatMarkersView;
		
		private var m_fill:ThreatMarkersView;
		
		private var m_back:ThreatMarkersView;
		
		private var m_alert:ThreatMarkersView;
		
		private var lastState:String;
		
		private var ratio:Number;
		
		public function ThreatMarker()
		{
			super();
			this.m_view = new Sprite();
			this.m_fill = new ThreatMarkersView();
			this.m_view.addChild(this.m_fill);
			this.lastState = "";
			addChild(this.m_view);
			this.m_view.visible = false;
		}
		
		public function onSetData(param1:Number, param2:Number, param3:Number, param4:Number, param5:Boolean):void
		{
			this.m_view.visible = true;
			this.ratio = param3;
			if (param1 <= 2 && param2 < 2)
			{
				this.m_fill.gotoAndStop(1);
				this.m_fill.alpha = 1;
				this.m_fill.scaleX = this.m_fill.scaleY = 1;
				this.lastState = "A";
			}
			else if (param1 == 2 && param2 == 2)
			{
				if (this.lastState != "C")
				{
					this.m_fill.gotoAndPlay("alert");
					this.m_fill.alpha = 1;
					this.m_fill.scaleX = this.m_fill.scaleY = 1;
				}
				this.lastState = "C";
			}
			else if (param1 >= 3)
			{
				if (this.lastState != "D")
				{
					Animate.legacyTo(this.m_fill, 1, {"scaleX": 2, "scaleY": 2, "alpha": 0}, Animate.ExpoOut);
				}
				this.lastState = "D";
			}
		}
		
		private function animateRing():void
		{
			this.m_fill.anim_mc.rotation = 0;
			Animate.legacyTo(this.m_fill.anim_mc, 2 - this.ratio * 1.5, {"rotation": 360}, Animate.Linear, this.animateRing, null);
		}
	}
}

package hud
{
	import common.BaseControl;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class MissionTimerVR extends BaseControl
	{
		
		private var m_offsAlign:Sprite;
		
		private var m_clock_txt:TextField;
		
		public function MissionTimerVR()
		{
			super();
			this.m_offsAlign = new Sprite();
			this.m_offsAlign.name = "offsAlign";
			addChild(this.m_offsAlign);
			this.m_clock_txt = new TextField();
			this.m_clock_txt.name = "clock_txt";
			this.m_clock_txt.z = 1;
			this.m_offsAlign.addChild(this.m_clock_txt);
			MenuUtils.setupText(this.m_clock_txt, "00:00:00", 20, "$global", "#ffffff");
			this.m_clock_txt.autoSize = TextFieldAutoSize.LEFT;
			var _loc1_:Number = 3;
			this.m_clock_txt.x = _loc1_;
			this.m_offsAlign.graphics.beginFill(0, 0.125);
			this.m_offsAlign.graphics.drawRect(0, 0, this.m_clock_txt.width + 2 * _loc1_, this.m_clock_txt.y + this.m_clock_txt.height);
			this.m_offsAlign.graphics.endFill();
		}
		
		public function set zOffset(param1:Number):void
		{
			this.m_clock_txt.z = param1;
		}
		
		public function SetText(param1:String):void
		{
			this.m_clock_txt.text = param1;
		}
		
		public function setRightAligned(param1:Boolean):void
		{
			this.m_offsAlign.x = param1 ? -this.m_offsAlign.width : 0;
		}
	}
}

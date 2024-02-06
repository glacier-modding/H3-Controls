package hud
{
	import common.BaseControl;
	import common.CommonUtils;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	
	public class CountdownTimer extends BaseControl
	{
		
		private var m_view:timeDisplayView;
		
		private var startDial:Number;
		
		private var m_textLocaleYOffset:int;
		
		private var m_timeTextFontSize:int;
		
		public function CountdownTimer()
		{
			super();
			this.m_view = new timeDisplayView();
			addChild(this.m_view);
			this.m_view.y = -31;
			this.m_view.visible = false;
			this.m_textLocaleYOffset = 6;
			this.m_timeTextFontSize = 60;
			if (CommonUtils.getActiveTextLocaleIndex() == 10 || CommonUtils.getActiveTextLocaleIndex() == 11 || CommonUtils.getActiveTextLocaleIndex() == 12)
			{
				this.m_textLocaleYOffset = 13;
				this.m_timeTextFontSize = 52;
			}
			MenuUtils.setupText(this.m_view.header_txt, Localization.get("UI_BRIEFING_DIAL_TIME"), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		}
		
		public function onSetData(param1:Object):void
		{
			var _loc2_:String = param1.time as String;
			var _loc3_:String = param1.string as String;
			var _loc4_:Number = param1.dial as Number;
			this.showCountDown(_loc2_, _loc3_, _loc4_);
		}
		
		public function showCountDown(param1:String, param2:String, param3:Number):void
		{
			this.m_view.time_txt.y = this.m_textLocaleYOffset;
			MenuUtils.setupText(this.m_view.time_txt, param1, this.m_timeTextFontSize, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			if (param2)
			{
				MenuUtils.setupText(this.m_view.header_txt, param2, 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			}
			else
			{
				MenuUtils.setupText(this.m_view.header_txt, Localization.get("UI_BRIEFING_DIAL_TIME"), 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
			}
			this.m_view.visible = true;
		}
		
		public function updateCountDown(param1:String, param2:String, param3:Number, param4:Number):void
		{
			this.m_view.time_txt.y = this.m_textLocaleYOffset;
			MenuUtils.setupText(this.m_view.time_txt, param1, this.m_timeTextFontSize, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraLight);
		}
		
		public function hideCountDown():void
		{
		}
		
		public function SetText(param1:String):void
		{
			this.m_view.visible = true;
			var _loc2_:Array = new Array();
			_loc2_ = param1.split(":");
			var _loc3_:Number = _loc2_.length;
			var _loc4_:Number = Number(_loc2_[_loc3_ - 2]);
			var _loc5_:Number = Number(_loc2_[_loc3_ - 3]);
			var _loc6_:String = _loc2_.slice(-_loc3_, _loc3_ - 1).join(":");
			this.updateCountDown(_loc6_, this.startDial + "-" + param1, _loc4_ / 60, 0);
		}
		
		public function ShowTest():void
		{
			this.onSetData({"time": "10:10"});
		}
	}
}

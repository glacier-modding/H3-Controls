package hud.sniper
{
	import common.Animate;
	import common.BaseControl;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.external.ExternalInterface;
	
	public class AIInformationElement extends BaseControl
	{
		
		private var m_view:AIInformationElementView;
		
		public function AIInformationElement()
		{
			super();
			this.m_view = new AIInformationElementView();
			addChild(this.m_view);
			this.m_view.visible = false;
		}
		
		public function onSetData(param1:Object):void
		{
			this.showAIinformation(param1.info, String(param1.infoHash));
		}
		
		public function SetText(param1:String):void
		{
			this.onSetData(param1);
		}
		
		public function showText(param1:String, param2:String):void
		{
			var _loc3_:* = "";
			if (param1.length > 0)
			{
				_loc3_ += param1;
				if (param2.length > 0)
				{
					_loc3_ += " : ";
				}
			}
			_loc3_ += param2;
			this.onSetData(_loc3_);
		}
		
		public function showAIinformation(param1:String, param2:String):void
		{
			Animate.kill(this.m_view.overlay);
			this.m_view.overlay.alpha = 1;
			this.m_view.overlay.x = this.m_view.overlay.y = 0;
			var _loc3_:String = MenuConstants.FontColorWhite;
			switch (param2)
			{
			case "1693438042": 
				MenuUtils.setColor(this.m_view.bg, MenuConstants.COLOR_RED);
				_loc3_ = MenuConstants.FontColorWhite;
				this.m_view.icons.gotoAndStop(2);
				break;
			case "771211205": 
				MenuUtils.setColor(this.m_view.bg, MenuConstants.COLOR_YELLOW);
				_loc3_ = MenuConstants.FontColorWhite;
				this.m_view.icons.gotoAndStop(3);
				break;
			case "884078140": 
				MenuUtils.setColor(this.m_view.bg, MenuConstants.COLOR_YELLOW);
				_loc3_ = MenuConstants.FontColorWhite;
				this.m_view.icons.gotoAndStop(3);
				break;
			case "1237512292": 
				MenuUtils.setColor(this.m_view.bg, MenuConstants.COLOR_YELLOW);
				_loc3_ = MenuConstants.FontColorWhite;
				this.m_view.icons.gotoAndStop(3);
				break;
			case "-699114243": 
				MenuUtils.setColor(this.m_view.bg, MenuConstants.COLOR_YELLOW);
				_loc3_ = MenuConstants.FontColorWhite;
				this.m_view.icons.gotoAndStop(3);
				break;
			case "-1549117600": 
				MenuUtils.setColor(this.m_view.bg, MenuConstants.COLOR_YELLOW);
				_loc3_ = MenuConstants.FontColorWhite;
				this.m_view.icons.gotoAndStop(1);
				break;
			case "-788287662": 
				MenuUtils.setColor(this.m_view.bg, MenuConstants.COLOR_GREEN);
				_loc3_ = MenuConstants.FontColorWhite;
				this.m_view.icons.gotoAndStop(4);
			}
			MenuUtils.setupText(this.m_view.info_txt, param1, 18, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			this.m_view.bg.width = 45 + this.m_view.info_txt.textWidth + 12;
			this.m_view.overlay.width = this.m_view.bg.width;
			this.m_view.overlay.height = this.m_view.bg.height;
			this.m_view.overlay.width += 120;
			var _loc4_:Number = -120 / 2;
			var _loc5_:Number = this.m_view.overlay.scaleX;
			this.m_view.overlay.width = this.m_view.bg.width;
			this.m_view.x = this.m_view.bg.width / -2;
			this.m_view.visible = true;
			this.playSound("AI_Info_Displayed");
			Animate.to(this.m_view.overlay, 0.8, 0, {"scaleX": _loc5_, "x": _loc4_, "alpha": 0}, Animate.ExpoOut);
		}
		
		public function showTestString():void
		{
			this.showAIinformation("This is a test", "0");
		}
		
		public function hideObjectivesBar():void
		{
			Animate.kill(this.m_view.overlay);
			this.m_view.visible = false;
		}
		
		public function hideText():void
		{
			this.hideObjectivesBar();
		}
		
		public function playSound(param1:String):void
		{
			ExternalInterface.call("PlaySound", param1);
		}
	}
}

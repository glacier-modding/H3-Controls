package menu3.basic
{
	import common.Animate;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import menu3.MenuElementBase;
	
	public dynamic class MasteryElement extends MenuElementBase
	{
		
		private var m_view:MasteryElementView;
		
		private var m_masteryXpTitleText:String;
		
		private var m_unit:String;
		
		public function MasteryElement(param1:Object)
		{
			super(param1);
			this.m_view = new MasteryElementView();
			this.m_view.masteryxp.indicator.scaleX = 0;
			this.m_view.masteryxp.visible = false;
			MenuUtils.setupTextUpper(this.m_view.masterytitle, "", 12, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_view.masteryxptitle, "", 12, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			this.refreshLoca();
			addChild(this.m_view);
		}
		
		protected function getRootView():MasteryElementView
		{
			return this.m_view;
		}
		
		public function refreshLoca():void
		{
			this.m_unit = Localization.get("UI_PERFORMANCE_MASTERY_XP");
		}
		
		public function getVisiblityFromData(param1:Object):Boolean
		{
			if (param1.masterycompletion == undefined || param1.masteryxpleft == undefined)
			{
				return false;
			}
			if (param1.masterycompletion >= 0 && param1.masteryxpleft != "")
			{
				return true;
			}
			return false;
		}
		
		override public function onSetData(param1:Object):void
		{
			if (getData().masteryheader == param1.masteryheader && getData().masterytitle == param1.masterytitle && getData().masterycompletion == param1.masterycompletion && getData().masteryxpleft == param1.masteryxpleft && getData().showUnit == param1.showUnit)
			{
				return;
			}
			super.onSetData(param1);
			if (param1.masterycompletion == undefined || param1.masteryxpleft == undefined)
			{
				this.m_view.visible = false;
				return;
			}
			var _loc2_:Boolean = true;
			if (param1.showUnit != null)
			{
				_loc2_ = Boolean(param1.showUnit);
			}
			this.showMastery(param1.masteryheader, param1.masterytitle, param1.masterycompletion, param1.masteryxpleft, _loc2_);
		}
		
		private function showMastery(param1:String, param2:String, param3:Number, param4:String, param5:Boolean):void
		{
			var _loc6_:Number = NaN;
			var _loc7_:String = null;
			var _loc8_:* = false;
			var _loc9_:String = null;
			if (param3 >= 0 && param4 != "")
			{
				_loc6_ = Number(param4);
				if (!isNaN(_loc6_) && _loc6_ != 0)
				{
					param4 = MenuUtils.formatNumber(_loc6_);
				}
				this.m_view.visible = true;
				_loc7_ = String((param1 != null ? param1 : "") + (param2 != null ? " " + param2 : ""));
				this.m_view.masterytitle.htmlText = _loc7_.toUpperCase();
				this.m_view.masteryxp.visible = true;
				param3 = Math.min(Math.max(param3, 0), 1);
				Animate.to(this.m_view.masteryxp.indicator, 0.2, 0, {"scaleX": param3}, Animate.ExpoOut);
				_loc8_ = param4 != "0";
				this.m_view.masteryxptitle.visible = _loc8_;
				this.m_view.arrow.visible = _loc8_;
				_loc9_ = param4;
				if (param5)
				{
					_loc9_ = _loc9_ + " " + this.m_unit;
				}
				this.m_masteryXpTitleText = _loc9_.toUpperCase();
				this.m_view.masteryxptitle.htmlText = this.m_masteryXpTitleText;
			}
			else
			{
				this.m_view.visible = false;
			}
		}
		
		public function setupDifficulty(param1:Boolean):void
		{
		}
		
		private function completeAnimations():void
		{
			Animate.complete(this.m_view.masteryxp.indicator);
		}
		
		override public function onUnregister():void
		{
			if (this.m_view)
			{
				this.completeAnimations();
				removeChild(this.m_view);
				this.m_view = null;
			}
			super.onUnregister();
		}
	}
}

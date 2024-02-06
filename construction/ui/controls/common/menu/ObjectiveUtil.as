package common.menu
{
	import common.CommonUtils;
	import common.Localization;
	
	public class ObjectiveUtil
	{
		
		private static const ICON_WEAPON:String = "difficulty";
		
		private static const ICON_DISGUISE:String = "disguise";
		
		public function ObjectiveUtil()
		{
			super();
		}
		
		public static function setupConditionIndicator(param1:Object, param2:Object, param3:Array, param4:String = "#FFFFFF"):void
		{
			var _loc5_:String = param2.type != "kill" || Boolean(param2.hardcondition) ? String(param2.header) : Localization.get("UI_DIALOG_OPTIONAL") + " " + param2.header;
			MenuUtils.setupText(param1.header, _loc5_, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.truncateTextfield(param1.header, 1, MenuConstants.FontColorWhite);
			var _loc6_:Array = splitTitle(param2.title);
			MenuUtils.setupText(param1.title, _loc6_[0], 24, MenuConstants.FONT_TYPE_MEDIUM, param4);
			var _loc7_:String = String(param1.title.htmlText);
			MenuUtils.truncateTextfield(param1.title, 1, param4);
			if (param1.method != undefined && param1.method != null)
			{
				MenuUtils.setupText(param1.method, _loc6_[1], 18, MenuConstants.FONT_TYPE_MEDIUM, param4);
				MenuUtils.truncateTextfield(param1.method, 1, param4);
			}
			var _loc8_:textTicker = new textTicker();
			param3.unshift({"indicatortextfield": param1.title, "title": _loc7_, "textticker": _loc8_});
			_loc8_.startTextTickerHtml(param1.title, _loc7_, CommonUtils.changeFontToGlobalIfNeeded);
		}
		
		private static function splitTitle(param1:String):Array
		{
			var _loc4_:String = null;
			var _loc5_:int = 0;
			var _loc6_:String = null;
			var _loc2_:RegExp = /^\s+|\s+$/g;
			var _loc3_:int = param1.indexOf(":");
			if (_loc3_ >= 0)
			{
				_loc4_ = param1.substr(0, _loc3_);
				_loc5_ = _loc3_ + 1;
				_loc6_ = param1.substr(_loc5_, param1.length - _loc5_);
				_loc4_ = _loc4_.replace(_loc2_, "");
				_loc2_.lastIndex = 0;
				return [_loc6_ = _loc6_.replace(_loc2_, ""), _loc4_];
			}
			param1 = param1.replace(_loc2_, "");
			return [param1];
		}
		
		private static function createCondition(param1:String):Object
		{
			if (param1 != ICON_DISGUISE && param1 != ICON_WEAPON)
			{
				return null;
			}
			var _loc2_:Object = new Object();
			if (param1 == ICON_DISGUISE)
			{
				_loc2_["header"] = Localization.get("UI_BRIEFING_CONDITION_DISGUISE");
				_loc2_["title"] = Localization.get("UI_BRIEFING_CONDITION_ANY_DISGUISE");
				_loc2_["icon"] = ICON_DISGUISE;
			}
			else
			{
				_loc2_["header"] = Localization.get("UI_BRIEFING_CONDITION_ELIMINATE_WITH");
				_loc2_["title"] = Localization.get("UI_BRIEFING_CONDITION_ANY_METHOD");
				_loc2_["icon"] = ICON_WEAPON;
			}
			_loc2_["type"] = "defaultkill";
			_loc2_["hardcondition"] = true;
			return _loc2_;
		}
		
		public static function prepareConditions(param1:Array, param2:Boolean = true, param3:Boolean = true, param4:Boolean = true):Array
		{
			var _loc5_:Object = null;
			if (param1.length == 0 && param2)
			{
				param1.unshift(createCondition(ICON_DISGUISE));
				param1.unshift(createCondition(ICON_WEAPON));
			}
			else if (param1.length == 1 && param1[0].type == "kill")
			{
				if (param1[0].icon == ICON_WEAPON && param4)
				{
					param1.unshift(createCondition(ICON_DISGUISE));
				}
				else if (param1[0].icon == ICON_DISGUISE && param3)
				{
					param1.push(createCondition(ICON_WEAPON));
				}
			}
			if (param1.length == 2 && param1[0].icon == ICON_DISGUISE)
			{
				_loc5_ = param1[0];
				param1[0] = param1[1];
				param1[1] = _loc5_;
			}
			return param1;
		}
	}
}

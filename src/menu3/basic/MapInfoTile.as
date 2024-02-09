package menu3.basic
{
	import common.Animate;
	import common.CommonUtils;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import common.menu.ObjectiveUtil;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.*;
	import menu3.MenuElementBase;
	import menu3.MenuImageLoader;
	
	public dynamic class MapInfoTile extends MenuElementBase
	{
		
		private const IMAGE_WIDTH:Number = 350;
		
		private const IMAGE_HEIGHT:Number = 261;
		
		private const CONDITION_TYPE_KILL:String = "kill";
		
		private const CONDITION_TYPE_CUSTOMKILL:String = "customkill";
		
		private const CONDITION_TYPE_DEFAULTKILL:String = "defaultkill";
		
		private const CONDITION_TYPE_SETPIECE:String = "setpiece";
		
		private const CONDITION_TYPE_CUSTOM:String = "custom";
		
		private const CONDITION_TYPE_GAMECHANGER:String = "gamechanger";
		
		private const CONDITION_TYPE_STASHPOINT_ITEM:String = "stashpointitem";
		
		private const CONTRACT_TYPE_MISSION:String = "mission";
		
		private const CONTRACT_TYPE_FLASHBACK:String = "flashback";
		
		private const CONTRACT_TYPE_ELUSIVE:String = "elusive";
		
		private const CONTRACT_TYPE_ESCALATION:String = "escalation";
		
		private const CONTRACT_TYPE_USER_CREATED:String = "usercreated";
		
		private const CONTRACT_TYPE_TUTORIAL:String = "tutorial";
		
		private const CONTRACT_TYPE_CREATION:String = "creation";
		
		private const CONTRACT_TYPE_ORBIS:String = "orbis";
		
		private const CONTRACT_TYPE_FEATURED:String = "featured";
		
		private const CONTRACT_TYPE_INVALID:String = "";
		
		private var m_contractType:String;
		
		private var m_view:MapInfoTileView;
		
		private var m_loader:MenuImageLoader;
		
		private var m_toggleField:MovieClip;
		
		private var m_toggleFieldOrigX:Number = 0;
		
		private var m_toggleFieldHiddenX:Number = 0;
		
		private var m_indicatorTextObjArray:Array;
		
		private var m_conditionsYOffset:int = 0;
		
		private var m_initialTileBgHeight:Number;
		
		private var m_initialIndicatorBgHeight:Number;
		
		private var m_sendEventWithValue:Function = null;
		
		public function MapInfoTile(param1:Object)
		{
			this.m_indicatorTextObjArray = [];
			super(param1);
			this.m_view = new MapInfoTileView();
			this.m_view.alpha = 0;
			this.m_view.visible = false;
			this.m_view.tileBg.alpha = 0;
			this.m_toggleField = this.m_view.togglefield;
			this.m_toggleField.alpha = 0;
			this.m_initialTileBgHeight = this.m_view.tileBg.height;
			this.m_initialIndicatorBgHeight = this.m_view.indicatorbg.height;
			MenuUtils.setColor(this.m_view.indicatorbg, MenuConstants.COLOR_MENU_SOLID_BACKGROUND);
			this.m_toggleField.toggleIconLeft.addEventListener(MouseEvent.MOUSE_UP, this.handleToggleIconLeftMouseUp);
			this.m_toggleField.toggleIconRight.addEventListener(MouseEvent.MOUSE_UP, this.handleToggleIconRightMouseUp);
			MenuUtils.setColor(this.m_view.tileDarkBg, MenuConstants.COLOR_MENU_SOLID_BACKGROUND);
			addChild(this.m_view);
			if (ControlsMain.isVrModeActive())
			{
				this.z = -MenuConstants.VRNotebookMapZOffset;
			}
		}
		
		override public function onSetData(param1:Object):void
		{
			super.onSetData(param1);
			this.showInfo(param1);
		}
		
		public function showInfo(param1:Object):void
		{
			this.m_conditionsYOffset = 0;
			Animate.complete(this.m_view);
			this.m_view.indicator.removeChildren();
			this.m_view.visible = true;
			Animate.to(this.m_view, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
			var _loc2_:int = MenuConstants.COLOR_WHITE;
			var _loc3_:int = MenuConstants.COLOR_RED;
			switch (param1.icon)
			{
			case "target": 
				_loc2_ = MenuConstants.COLOR_WHITE;
				_loc3_ = MenuConstants.COLOR_RED;
				break;
			case "objective": 
				_loc2_ = MenuConstants.COLOR_WHITE;
				_loc3_ = MenuConstants.COLOR_BLUE;
				break;
			case "stashpointfull": 
				_loc2_ = MenuConstants.COLOR_GREY_ULTRA_DARK;
				_loc3_ = MenuConstants.COLOR_TURQUOISE;
			}
			MenuUtils.setupIcon(this.m_view.tileIcon, param1.icon, _loc2_, false, true, _loc3_);
			MenuUtils.setupTextUpper(this.m_view.header, param1.header, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.truncateTextfield(this.m_view.header, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.header));
			MenuUtils.setupTextUpper(this.m_view.title, param1.title, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.truncateTextfield(this.m_view.title, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title));
			if (param1.contracttype != undefined)
			{
				this.m_contractType = param1.contracttype;
			}
			if (param1.location)
			{
				this.setLocation(param1.location, !!param1.conditions ? true : false);
			}
			if (param1.displayaskill)
			{
				this.setConditions(ObjectiveUtil.prepareConditions([]));
			}
			else if (param1.conditions)
			{
				this.setConditions(ObjectiveUtil.prepareConditions(param1.conditions));
			}
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			while (_loc5_ < m_children.length)
			{
				m_children[_loc5_].y = this.getView().height + _loc4_;
				_loc4_ += m_children[_loc5_].getView().height;
				_loc5_++;
			}
			this.setIndex(param1);
			if (param1.image)
			{
				this.loadImage(param1.image);
			}
		}
		
		public function hideInfo():void
		{
			this.m_toggleField.alpha = 0;
			Animate.complete(this.m_view);
			Animate.to(this.m_view, 0.3, 0, {"alpha": 0}, Animate.ExpoOut, function():void
			{
				m_view.visible = false;
			});
		}
		
		public function setIndex(param1:Object):void
		{
			if (param1.elementcount >= 2)
			{
				this.setupToggleField(param1.elementindex, param1.elementcount);
				this.m_toggleField.alpha = 1;
			}
		}
		
		private function setLocation(param1:Object, param2:Boolean):void
		{
			var _loc3_:ConditionIndicatorSmallView = new ConditionIndicatorSmallView();
			_loc3_.y = this.m_conditionsYOffset;
			MenuUtils.setupIcon(_loc3_.valueIcon, param1.icon, MenuConstants.COLOR_WHITE, true, false);
			MenuUtils.setupTextUpper(_loc3_.header, Localization.get("UI_MENU_PAGE_MASTERY_UNLOCKABLE_NAME_LOCATION"), 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.truncateTextfield(_loc3_.header, 1, null, CommonUtils.changeFontToGlobalIfNeeded(_loc3_.header));
			MenuUtils.setupTextUpper(_loc3_.title, param1.level, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			MenuUtils.truncateTextfield(_loc3_.title, 1, null, CommonUtils.changeFontToGlobalIfNeeded(_loc3_.title));
			this.m_view.indicator.addChild(_loc3_);
			this.m_conditionsYOffset += MenuConstants.ValueIndicatorHeight;
		}
		
		private function setConditions(param1:Array):void
		{
			var _loc6_:ConditionIndicatorSmallView = null;
			var _loc2_:Number = 11;
			var _loc3_:int = this.m_conditionsYOffset + (_loc2_ - 2);
			var _loc4_:int = int(param1.length);
			this.m_indicatorTextObjArray = [];
			var _loc5_:int = 0;
			while (_loc5_ < _loc4_)
			{
				(_loc6_ = new ConditionIndicatorSmallView()).y = _loc3_;
				MenuUtils.setupIcon(_loc6_.valueIcon, param1[_loc5_].icon, MenuConstants.COLOR_WHITE, true, false);
				if (param1[_loc5_].type == this.CONDITION_TYPE_STASHPOINT_ITEM)
				{
					MenuUtils.setupTextUpper(_loc6_.header, Localization.get("UI_MENU_PAGE_LOADOUT_CONTENT"), 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
					MenuUtils.truncateTextfield(_loc6_.header, 1, null, CommonUtils.changeFontToGlobalIfNeeded(_loc6_.header));
					MenuUtils.setupTextUpper(_loc6_.title, param1[_loc5_].title, 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					MenuUtils.truncateTextfield(_loc6_.title, 1, null, CommonUtils.changeFontToGlobalIfNeeded(_loc6_.title));
				}
				else if (param1[_loc5_].type == this.CONDITION_TYPE_DEFAULTKILL || param1[_loc5_].type == this.CONDITION_TYPE_KILL)
				{
					ObjectiveUtil.setupConditionIndicator(_loc6_, param1[_loc5_], this.m_indicatorTextObjArray, MenuConstants.FontColorWhite);
				}
				else if (param1[_loc5_].type == this.CONDITION_TYPE_CUSTOMKILL || param1[_loc5_].type == this.CONDITION_TYPE_SETPIECE || param1[_loc5_].type == this.CONDITION_TYPE_GAMECHANGER)
				{
					_loc6_.description.autoSize = TextFieldAutoSize.LEFT;
					_loc6_.description.width = 276;
					_loc6_.description.multiline = true;
					_loc6_.description.wordWrap = true;
					MenuUtils.setupText(_loc6_.description, param1[_loc5_].summary, 18, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
					MenuUtils.truncateTextfield(_loc6_.description, 7, null, CommonUtils.changeFontToGlobalIfNeeded(_loc6_.description));
				}
				this.m_view.indicator.addChild(_loc6_);
				if (param1[_loc5_].type == this.CONDITION_TYPE_CUSTOMKILL || param1[_loc5_].type == this.CONDITION_TYPE_SETPIECE || param1[_loc5_].type == this.CONDITION_TYPE_GAMECHANGER)
				{
					if (_loc6_.description.numLines > 2)
					{
						_loc3_ += _loc6_.description.height - MenuConstants.ValueIndicatorHeight + 12;
					}
				}
				this.m_view.indicatorbg.height = this.m_initialIndicatorBgHeight + (_loc3_ - (_loc2_ + 4));
				this.m_view.tileBg.height = this.m_initialTileBgHeight + (_loc3_ - _loc2_);
				this.m_view.tileBg.y = (this.m_initialTileBgHeight >> 1) + (_loc3_ - (_loc2_ + 4) >> 1);
				if (param1[_loc5_].type == this.CONDITION_TYPE_KILL || param1[_loc5_].type == this.CONDITION_TYPE_DEFAULTKILL)
				{
					_loc3_ += MenuConstants.ValueIndicatorHeight + (20 - _loc2_ - 2);
				}
				_loc5_++;
			}
		}
		
		private function loadImage(param1:String):void
		{
			var imagePath:String = param1;
			if (this.m_loader != null)
			{
				this.m_loader.cancelIfLoading();
				this.m_view.image.removeChild(this.m_loader);
				this.m_loader = null;
			}
			this.m_loader = new MenuImageLoader();
			this.m_view.image.addChild(this.m_loader);
			this.m_loader.center = true;
			this.m_loader.loadImage(imagePath, function():void
			{
				m_loader.getImage().smoothing = true;
				Animate.to(m_view.tileDarkBg, 0.3, 0, {"alpha": 0}, Animate.Linear);
				MenuUtils.scaleProportionalByWidth(m_view.image, IMAGE_WIDTH);
			});
		}
		
		public function toggleLeft(param1:Object):void
		{
			Animate.complete(this.m_toggleField.toggleIconLeft);
			this.setToggleTitle((param1.elementindex + 1).toString(), param1.elementcount);
			this.m_toggleField.toggleIconLeft.alpha = 0.6;
			Animate.to(this.m_toggleField.toggleIconLeft, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
		}
		
		public function toggleRight(param1:Object):void
		{
			Animate.complete(this.m_toggleField.toggleIconRight);
			this.setToggleTitle((param1.elementindex + 1).toString(), param1.elementcount);
			this.m_toggleField.toggleIconRight.alpha = 0.6;
			Animate.to(this.m_toggleField.toggleIconRight, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
		}
		
		private function setupToggleField(param1:int, param2:int):void
		{
			this.m_toggleField.toggletitle.alpha = 0;
			this.m_toggleField.toggletitle.autoSize = TextFieldAutoSize.RIGHT;
			this.setToggleTitle((param1 + 1).toString(), param2.toString());
			this.m_toggleField.toggleIconLeft.x = this.m_toggleField.toggleIconRight.x - this.m_toggleField.toggleIconRight.width - this.m_toggleField.toggletitle.width;
			this.m_toggleField.toggleIconLeft.alpha = 1;
			this.m_toggleField.toggleIconRight.alpha = 1;
			this.m_toggleField.toggletitle.alpha = 1;
			this.m_toggleFieldOrigX = this.m_toggleField.x;
			this.m_toggleFieldHiddenX = this.m_toggleField.x - this.m_toggleField.width;
		}
		
		private function setToggleTitle(param1:String, param2:String):void
		{
			MenuUtils.setupText(this.m_toggleField.toggletitle, param1 + "  /  " + param2, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		}
		
		override public function setEngineCallbacks(param1:Function, param2:Function):void
		{
			this.m_sendEventWithValue = param2;
		}
		
		override public function getView():Sprite
		{
			return this.m_view.tileBg;
		}
		
		override public function onUnregister():void
		{
			var _loc1_:int = 0;
			if (this.m_view)
			{
				Animate.complete(this.m_view);
				if (this.m_indicatorTextObjArray.length > 0)
				{
					_loc1_ = 0;
					while (_loc1_ < this.m_indicatorTextObjArray.length)
					{
						this.m_indicatorTextObjArray[_loc1_].textticker.stopTextTicker(this.m_indicatorTextObjArray[_loc1_].indicatortextfield, this.m_indicatorTextObjArray[_loc1_].title);
						this.m_indicatorTextObjArray[_loc1_].textticker = null;
						_loc1_++;
					}
					this.m_indicatorTextObjArray = [];
				}
				if (this.m_toggleField)
				{
					Animate.complete(this.m_toggleField.toggleIconLeft);
					Animate.complete(this.m_toggleField.toggleIconRight);
				}
				if (this.m_loader)
				{
					this.m_loader.cancelIfLoading();
					this.m_view.image.removeChild(this.m_loader);
					this.m_loader = null;
				}
				removeChild(this.m_view);
				this.m_view = null;
			}
		}
		
		override public function handleMouseUp(param1:Function, param2:MouseEvent):void
		{
			var _loc3_:int = 0;
			param2.stopImmediatePropagation();
			if (stage.focus == this)
			{
				return;
			}
			if (this["_nodedata"])
			{
				_loc3_ = this["_nodedata"]["id"] as int;
				param1("onElementSelect", _loc3_);
			}
		}
		
		override public function handleMouseDown(param1:Function, param2:MouseEvent):void
		{
			param2.stopImmediatePropagation();
		}
		
		private function handleToggleIconLeftMouseUp(param1:MouseEvent):void
		{
			var _loc2_:int = 0;
			if (Boolean(this["_nodedata"]) && this.m_sendEventWithValue != null)
			{
				_loc2_ = this["_nodedata"]["id"] as int;
				this.m_sendEventWithValue("onElementPrev", _loc2_);
			}
		}
		
		private function handleToggleIconRightMouseUp(param1:MouseEvent):void
		{
			var _loc2_:int = 0;
			if (Boolean(this["_nodedata"]) && this.m_sendEventWithValue != null)
			{
				_loc2_ = this["_nodedata"]["id"] as int;
				this.m_sendEventWithValue("onElementNext", _loc2_);
			}
		}
	}
}

package menu3.basic
{
	import common.Animate;
	import common.CommonUtils;
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import common.menu.ObjectiveUtil;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import menu3.IScreenVisibilityReceiver;
	import menu3.MenuElementAvailabilityBase;
	import menu3.MenuImageLoader;
	
	public dynamic class ObjectiveTile extends MenuElementAvailabilityBase implements IScreenVisibilityReceiver
	{
		
		public static const TILETYPE_NEW:String = "new";
		
		public static const TILETYPE_CURRENT:String = "current";
		
		private const CONTRACT_STATE_COMPLETED:String = "completed";
		
		private const CONTRACT_STATE_FAILED:String = "failed";
		
		private const CONTRACT_STATE_INPROGRESS:String = "inprogress";
		
		private const CONTRACT_STATE_UNKNOWN:String = "unknown";
		
		private const CONTRACT_STATE_AVAILABLE:String = "available";
		
		private const CONTRACT_STATE_LOCKED:String = "locked";
		
		private const CONTRACT_STATE_DOWNLOADING:String = "downloading";
		
		private var m_contractState:String;
		
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
		
		private const CONDITION_TYPE_KILL:String = "kill";
		
		private const CONDITION_TYPE_CUSTOMKILL:String = "customkill";
		
		private const CONDITION_TYPE_DEFAULTKILL:String = "defaultkill";
		
		private const CONDITION_TYPE_SETPIECE:String = "setpiece";
		
		private const CONDITION_TYPE_CUSTOM:String = "custom";
		
		private const CONDITION_TYPE_GAMECHANGER:String = "gamechanger";
		
		private var m_view:ObjectiveTileView;
		
		private var m_descriptionInitalY:Number;
		
		private var m_descriptionInitalHeight:Number;
		
		private var m_loader:MenuImageLoader;
		
		private var m_newObjectiveIndicator:NewObjectiveIndicatorView;
		
		private var m_perkElements:Array;
		
		private var m_textObj:Object;
		
		private var m_indicatorTextObjArray:Array;
		
		private var m_pressable:Boolean = true;
		
		private var m_markedForRemoval:Boolean = false;
		
		private var m_isLocked:Boolean = false;
		
		private var m_isAvailable:Boolean = true;
		
		private var m_loadOnVisibleOnScreen:Boolean = false;
		
		private var m_isVisibleOnScreen:Boolean = false;
		
		private var m_animateConditions:Boolean = true;
		
		private var m_conditionsContainer:Array;
		
		private var m_newConditionsContainer:Array;
		
		private var m_conditionCompletionIndicators:Array;
		
		private var m_conditionCompletionIndicatorCount:int = 0;
		
		private var m_conditionCompletionIndicatorDelay:Number = 0;
		
		private var m_useZoomedImage:Boolean = false;
		
		private var m_iconLabel:String;
		
		public function ObjectiveTile(param1:Object)
		{
			this.m_perkElements = [];
			this.m_textObj = {};
			this.m_indicatorTextObjArray = [];
			this.m_conditionsContainer = [];
			this.m_newConditionsContainer = [];
			this.m_conditionCompletionIndicators = [];
			super(param1);
			this.m_view = new ObjectiveTileView();
			this.m_view.tileBg.alpha = 0;
			this.m_view.tileDarkBg.alpha = 0.3;
			this.m_view.dropShadow.alpha = 0;
			this.m_descriptionInitalY = this.m_view.description.y;
			this.m_descriptionInitalHeight = this.m_view.description.height;
			var _loc2_:Shape = new Shape();
			_loc2_.width = this.m_view.tileBg.width;
			_loc2_.height = this.m_view.tileBg.height;
			addChild(_loc2_);
			addChild(this.m_view);
		}
		
		override public function onSetData(param1:Object):void
		{
			var _loc5_:String = null;
			var _loc6_:Sprite = null;
			var _loc7_:Rectangle = null;
			var _loc8_:Number = NaN;
			var _loc9_:Number = NaN;
			super.onSetData(param1);
			this.m_iconLabel = param1.icon;
			this.m_useZoomedImage = param1.useZoomedImage === true;
			this.m_loadOnVisibleOnScreen = param1.loadonvisibleonscreen == true;
			this.m_view.visible = !this.m_loadOnVisibleOnScreen || this.m_isVisibleOnScreen;
			var _loc2_:String = param1.state != null ? String(param1.state).toLowerCase() : this.CONTRACT_STATE_UNKNOWN;
			var _loc3_:Boolean = _loc2_ == this.CONTRACT_STATE_COMPLETED || _loc2_ == this.CONTRACT_STATE_FAILED || _loc2_ == this.CONTRACT_STATE_INPROGRESS;
			if (_loc3_)
			{
				this.m_useZoomedImage = false;
			}
			if (this.m_useZoomedImage)
			{
				MenuUtils.setColorFilter(this.m_view.image);
			}
			else
			{
				MenuUtils.setColorFilter(this.m_view.imagesmall);
			}
			if (this.m_useZoomedImage == true)
			{
				this.m_view.conditionsBg.visible = false;
			}
			this.m_markedForRemoval = param1.markedforremoval == true;
			this.m_isLocked = param1.islocked == true;
			this.m_isAvailable = param1.availability == null || param1.availability.available == true;
			MenuUtils.setColor(this.m_view.conditionsBg, MenuConstants.COLOR_MENU_SOLID_BACKGROUND);
			MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
			this.m_pressable = getNodeProp(this, "pressable");
			MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, this.m_pressable ? uint(MenuConstants.COLOR_WHITE) : uint(MenuConstants.COLOR_GREY), true, false);
			if (param1.contracttype != undefined)
			{
				this.m_contractType = param1.contracttype;
			}
			if (this.m_view.indicator.numChildren > 0)
			{
				this.m_animateConditions = false;
			}
			else
			{
				this.m_animateConditions = true;
			}
			this.m_view.indicator.removeChildren();
			this.setupTextFields(param1.header, param1.title);
			this.changeTextColor(this.m_pressable ? uint(MenuConstants.COLOR_WHITE) : uint(MenuConstants.COLOR_GREY), this.m_pressable ? uint(MenuConstants.COLOR_WHITE) : uint(MenuConstants.COLOR_GREY));
			if (this.m_markedForRemoval)
			{
				this.changeTextColor(MenuConstants.COLOR_GREY, MenuConstants.COLOR_GREY);
			}
			if (!this.m_isAvailable)
			{
				setAvailablity(this.m_view, param1, "tall");
			}
			else if (_loc3_)
			{
				this.setContractState(_loc2_);
				m_valueIndicator = new ValueIndicatorSmallView();
				m_valueIndicator.y = this.m_view.tileBg.height / 2 - MenuConstants.ValueIndicatorYOffset + MenuConstants.ValueIndicatorHeight + 1;
				_loc5_ = this.m_contractState;
				if (_loc2_ == this.CONTRACT_STATE_INPROGRESS)
				{
					_loc5_ = "arrowright";
				}
				if (_loc2_ == this.CONTRACT_STATE_FAILED)
				{
					MenuUtils.setupText(m_valueIndicator.title, Localization.get("UI_MENU_PAGE_PLANNING_ELEMENT_FAILED"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					MenuUtils.setupIcon(m_valueIndicator.valueIcon, _loc5_, MenuConstants.COLOR_WHITE, true, true, MenuConstants.COLOR_RED, MenuConstants.MenuElementBackgroundAlpha);
				}
				else if (_loc2_ == this.CONTRACT_STATE_INPROGRESS)
				{
					MenuUtils.setupText(m_valueIndicator.title, Localization.get("UI_MENU_PAGE_PLANNING_ELEMENT_INPROGRESS"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					MenuUtils.setupIcon(m_valueIndicator.valueIcon, _loc5_, MenuConstants.COLOR_WHITE, true, true, MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
				}
				else
				{
					MenuUtils.setupIcon(m_valueIndicator.valueIcon, _loc5_, MenuConstants.COLOR_WHITE, true, true, 2728241, MenuConstants.MenuElementBackgroundAlpha);
					if (this.m_iconLabel == "target")
					{
						MenuUtils.setupText(m_valueIndicator.title, Localization.get("UI_CONTRACT_ELUSIVE_STATE_COMPLETED"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					}
					else
					{
						MenuUtils.setupText(m_valueIndicator.title, Localization.get("UI_MENU_PAGE_PLANNING_ELEMENT_COMPLETED"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
					}
				}
				MenuUtils.truncateTextfield(m_valueIndicator.title, 1);
				this.m_view.indicator.addChild(m_valueIndicator);
			}
			else
			{
				this.setContractState(this.CONTRACT_STATE_AVAILABLE);
				if (this.m_markedForRemoval)
				{
					m_valueIndicator = new ValueIndicatorSmallView();
					m_valueIndicator.y = this.m_view.tileBg.height / 2 - MenuConstants.ValueIndicatorYOffset + MenuConstants.ValueIndicatorHeight + 1;
					MenuUtils.setupIcon(m_valueIndicator.valueIcon, this.CONTRACT_STATE_FAILED, MenuConstants.COLOR_GREY, true, true, MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
					MenuUtils.setupText(m_valueIndicator.title, Localization.get("UI_CONTRACT_STATE_REMOVED"), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGrey);
					MenuUtils.truncateTextfield(m_valueIndicator.title, 1);
					this.m_view.indicator.addChild(m_valueIndicator);
				}
			}
			var _loc4_:* = !this.m_useZoomedImage;
			if (param1.displayaskill)
			{
				this.setConditions(ObjectiveUtil.prepareConditions([], _loc4_));
			}
			else if (param1.conditions)
			{
				this.setConditions(ObjectiveUtil.prepareConditions(param1.conditions, _loc4_));
			}
			if (param1.perks != undefined)
			{
				if (param1.perks[0] != "NONE")
				{
					this.setupPerks(param1.perks);
				}
			}
			this.setOverlayColor();
			if (param1.image)
			{
				this.loadImage(param1.image);
			}
			this.m_view.description.text = "";
			this.m_view.description.y = this.m_descriptionInitalY;
			this.m_view.description.height = this.m_descriptionInitalHeight;
			if (this.m_conditionsContainer.length <= 1 && param1.description != null)
			{
				if (this.m_conditionsContainer.length == 1)
				{
					_loc8_ = (_loc7_ = (_loc6_ = this.m_conditionsContainer[0]).getBounds(this)).height;
					this.m_view.description.height -= _loc8_;
					if (m_valueIndicator != null)
					{
						this.m_view.description.height -= m_valueIndicator.height;
					}
				}
				MenuUtils.setupText(this.m_view.description, param1.description, 18, MenuConstants.FONT_TYPE_NORMAL, this.m_isLocked || !this.m_isAvailable ? MenuConstants.FontColorGreyMedium : MenuConstants.FontColorWhite);
				MenuUtils.truncateHTMLField(this.m_view.description, this.m_view.description.htmlText);
				if (param1.descriptionAlignment == "top")
				{
					this.m_view.description.y = this.m_descriptionInitalY + _loc8_;
				}
				else
				{
					_loc9_ = this.m_view.description.textHeight;
					this.m_view.description.y = this.m_descriptionInitalY + (this.m_descriptionInitalHeight - _loc9_);
				}
			}
		}
		
		override public function setContractState(param1:String):void
		{
			this.m_contractState = param1;
			switch (param1)
			{
			case this.CONTRACT_STATE_AVAILABLE: 
				MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, this.m_markedForRemoval ? uint(MenuConstants.COLOR_GREY) : uint(MenuConstants.COLOR_WHITE), true, false);
				break;
			case this.CONTRACT_STATE_LOCKED: 
				this.m_view.tileIcon.icons.gotoAndStop(param1);
				break;
			case this.CONTRACT_STATE_DOWNLOADING: 
				this.m_view.tileIcon.icons.gotoAndStop(param1);
				break;
			case this.CONTRACT_STATE_COMPLETED: 
			case this.CONTRACT_STATE_FAILED: 
			}
			this.setOverlayColor();
		}
		
		override public function setOverlayColor(param1:Boolean = false):void
		{
			if (!this.m_isAvailable)
			{
				if (this.m_useZoomedImage)
				{
					MenuUtils.setColorFilter(this.m_view.image, "available");
				}
				else
				{
					MenuUtils.setColorFilter(this.m_view.imagesmall, "selected");
				}
			}
			else if (param1)
			{
				if (this.m_useZoomedImage)
				{
					MenuUtils.setColorFilter(this.m_view.image, "selected");
				}
				else
				{
					MenuUtils.setColorFilter(this.m_view.imagesmall, "selected");
				}
			}
			else if (!m_isSelected)
			{
				if (this.m_useZoomedImage)
				{
					MenuUtils.setColorFilter(this.m_view.image, this.m_contractState);
				}
				else
				{
					MenuUtils.setColorFilter(this.m_view.imagesmall, this.m_contractState);
				}
			}
		}
		
		private function setConditions(param1:Array):void
		{
			var _loc5_:ConditionIndicatorSmallView = null;
			this.m_indicatorTextObjArray = [];
			this.m_newConditionsContainer = [];
			this.m_conditionsContainer = [];
			this.m_conditionCompletionIndicators = [];
			this.m_conditionCompletionIndicatorCount = 0;
			var _loc2_:Boolean = Boolean(getData().isnew);
			var _loc3_:int = MenuConstants.ValueIndicatorHeight * 2;
			var _loc4_:int = 0;
			while (_loc4_ < param1.length)
			{
				(_loc5_ = new ConditionIndicatorSmallView()).y = this.m_view.tileBg.height - MenuConstants.ValueIndicatorYOffset - _loc3_;
				if (param1[_loc4_].type == this.CONDITION_TYPE_DEFAULTKILL || param1[_loc4_].type == this.CONDITION_TYPE_KILL)
				{
					ObjectiveUtil.setupConditionIndicator(_loc5_, param1[_loc4_], this.m_indicatorTextObjArray, MenuConstants.FontColorWhite);
				}
				else if (param1[_loc4_].type == this.CONDITION_TYPE_SETPIECE || param1[_loc4_].type == this.CONDITION_TYPE_GAMECHANGER || param1[_loc4_].type == this.CONDITION_TYPE_CUSTOMKILL)
				{
					_loc5_.description.autoSize = "left";
					_loc5_.description.width = 276;
					_loc5_.description.multiline = true;
					_loc5_.description.wordWrap = true;
					MenuUtils.setupText(_loc5_.description, param1[_loc4_].summary, 18, MenuConstants.FONT_TYPE_NORMAL, this.m_isLocked || !this.m_isAvailable ? MenuConstants.FontColorGreyMedium : MenuConstants.FontColorWhite);
					MenuUtils.truncateTextfield(_loc5_.description, 7, this.m_isLocked || !this.m_isAvailable ? MenuConstants.FontColorGreyMedium : MenuConstants.FontColorWhite);
				}
				if (this.m_useZoomedImage)
				{
					MenuUtils.setupIcon(_loc5_.valueIcon, param1[_loc4_].icon, this.m_isLocked || !this.m_isAvailable ? uint(MenuConstants.COLOR_GREY_MEDIUM) : uint(MenuConstants.COLOR_WHITE), true, true, MenuConstants.COLOR_MENU_TABS_BACKGROUND, MenuConstants.MenuElementBackgroundAlpha);
				}
				else
				{
					MenuUtils.setupIcon(_loc5_.valueIcon, param1[_loc4_].icon, this.m_isLocked || !this.m_isAvailable ? uint(MenuConstants.COLOR_GREY_MEDIUM) : uint(MenuConstants.COLOR_WHITE), true, false);
				}
				if (this.m_contractState == this.CONTRACT_STATE_COMPLETED)
				{
					if (param1[_loc4_].hardcondition === false)
					{
						this.setupConditionCompletion(_loc5_, param1[_loc4_].satisfied);
					}
				}
				if (param1[_loc4_].type == null && param1.length == 1)
				{
					if (param1[_loc4_].header)
					{
						MenuUtils.setupText(_loc5_.header, param1[_loc4_].header, 18, MenuConstants.FONT_TYPE_NORMAL, this.m_isLocked || !this.m_isAvailable ? MenuConstants.FontColorGreyMedium : MenuConstants.FontColorWhite);
					}
					if (param1[_loc4_].title)
					{
						MenuUtils.setupText(_loc5_.title, param1[_loc4_].title, 24, MenuConstants.FONT_TYPE_MEDIUM, this.m_isLocked || !this.m_isAvailable ? MenuConstants.FontColorGreyMedium : MenuConstants.FontColorWhite);
						_loc5_.title.autoSize = "left";
						_loc5_.title.width = 276;
						_loc5_.title.multiline = true;
						_loc5_.title.wordWrap = true;
						MenuUtils.truncateTextfield(_loc5_.title, 3, this.m_isLocked || !this.m_isAvailable ? MenuConstants.FontColorGreyMedium : MenuConstants.FontColorWhite);
					}
				}
				_loc5_.alpha = 0;
				if (_loc2_)
				{
					this.m_newConditionsContainer.push(_loc5_);
				}
				else
				{
					this.m_conditionsContainer.push(_loc5_);
				}
				if (this.m_useZoomedImage)
				{
					MenuUtils.addDropShadowFilter(_loc5_);
				}
				this.m_view.indicator.addChild(_loc5_);
				if (param1[_loc4_].type == this.CONDITION_TYPE_KILL || param1[_loc4_].type == this.CONDITION_TYPE_DEFAULTKILL)
				{
					_loc3_ -= MenuConstants.ValueIndicatorHeight + 14;
				}
				_loc4_++;
			}
			if (!_loc2_)
			{
				this.showConditions(TILETYPE_CURRENT, 0.2);
			}
		}
		
		private function showNewIndicator():void
		{
			this.m_newObjectiveIndicator = new NewObjectiveIndicatorView();
			this.m_newObjectiveIndicator.x = 22;
			this.m_newObjectiveIndicator.alpha = 0;
			this.m_newObjectiveIndicator.icon.scaleX = this.m_newObjectiveIndicator.icon.scaleY = 0;
			this.m_newObjectiveIndicator.icon.rotation = -90;
			this.m_view.indicator.addChild(this.m_newObjectiveIndicator);
			Animate.legacyTo(this.m_newObjectiveIndicator, 0.2, {"alpha": 1}, Animate.ExpoOut);
			Animate.legacyFrom(this.m_newObjectiveIndicator.bg, 0.3, {"scaleY": 0.25}, Animate.ExpoOut);
			Animate.delay(this.m_newObjectiveIndicator.icon, 0.1, function():void
			{
				Animate.legacyTo(m_newObjectiveIndicator.icon, 0.2, {"rotation": 0, "scaleX": 1, "scaleY": 1}, Animate.ExpoOut);
			});
		}
		
		public function showConditions(param1:String, param2:Number = 0):void
		{
			var len:int;
			var i:int;
			var arr:Array = null;
			var iconCount:int = 0;
			var headerCount:int = 0;
			var titleCount:int = 0;
			var descriptionCount:int = 0;
			var xOffset:Number = NaN;
			var index:int = 0;
			var tileType:String = param1;
			var delay:Number = param2;
			if (tileType == TILETYPE_NEW)
			{
				arr = this.m_newConditionsContainer;
				this.showNewIndicator();
			}
			else
			{
				arr = this.m_conditionsContainer;
			}
			this.m_conditionCompletionIndicatorCount = 0;
			iconCount = 0;
			headerCount = 0;
			titleCount = 0;
			descriptionCount = 0;
			xOffset = 15;
			len = int(arr.length);
			i = 0;
			while (i < len)
			{
				arr[i].alpha = 1;
				if (this.m_animateConditions)
				{
					arr[i].valueIcon.scaleX = arr[i].valueIcon.scaleY = arr[i].valueIcon.alpha = 0;
					Animate.delay(arr[i].valueIcon, delay, function():void
					{
						Animate.legacyTo(arr[iconCount].valueIcon, 0.25, {"scaleX": 1, "scaleY": 1, "alpha": 1}, Animate.ExpoOut);
						if (m_conditionCompletionIndicators.length > 0)
						{
							showConditionCompletion();
						}
						iconCount += 1;
					});
					if (arr[i].description.length > 1)
					{
						arr[i].description.x -= xOffset;
						arr[i].description.alpha = 0;
						Animate.delay(arr[i].description, delay + 0.05, function():void
						{
							Animate.legacyTo(arr[descriptionCount].description, 0.2, {"x": arr[descriptionCount].description.x + xOffset, "alpha": 1}, Animate.ExpoOut);
							descriptionCount += 1;
						});
					}
					else
					{
						arr[i].header.x -= xOffset;
						arr[i].header.alpha = 0;
						arr[i].title.x -= xOffset;
						arr[i].title.alpha = 0;
						arr[i].method.x -= xOffset;
						arr[i].method.alpha = 0;
						Animate.delay(arr[i].header, delay + 0.05, function():void
						{
							Animate.legacyTo(arr[headerCount].header, 0.2, {"x": arr[headerCount].header.x + xOffset, "alpha": 1}, Animate.ExpoOut);
							headerCount += 1;
						});
						Animate.delay(arr[i].title, delay + 0.1, function():void
						{
							Animate.legacyTo(arr[titleCount].title, 0.2, {"x": arr[titleCount].title.x + xOffset, "alpha": 1}, Animate.ExpoOut);
							Animate.legacyTo(arr[titleCount].method, 0.2, {"x": arr[titleCount].method.x + xOffset, "alpha": 1}, Animate.ExpoOut);
							titleCount += 1;
						});
					}
				}
				delay += 0.1;
				i++;
			}
			if (!this.m_animateConditions)
			{
				index = 0;
				while (index < this.m_conditionCompletionIndicators.length)
				{
					this.m_conditionCompletionIndicators[index].scaleX = 1;
					this.m_conditionCompletionIndicators[index].scaleY = 1;
					this.m_conditionCompletionIndicators[index].alpha = 1;
					index++;
				}
			}
		}
		
		private function setupConditionCompletion(param1:ConditionIndicatorSmallView, param2:Boolean):void
		{
			var _loc3_:MovieClip = null;
			if (param2)
			{
				_loc3_ = new KillConditionCompleteIndicatorView();
			}
			else
			{
				_loc3_ = new KillConditionFailIndicatorView();
			}
			_loc3_.x = param1.valueIcon.x + param1.valueIcon.width / 2 - 5;
			_loc3_.y = param1.valueIcon.y + param1.valueIcon.height / 2 - _loc3_.height / 2;
			_loc3_.scaleX = 0;
			_loc3_.scaleY = 0;
			_loc3_.alpha = 0;
			param1.addChild(_loc3_);
			this.m_conditionCompletionIndicators.push(_loc3_);
		}
		
		private function showConditionCompletion():void
		{
			Animate.delay(this.m_conditionCompletionIndicators[this.m_conditionCompletionIndicatorCount], this.m_conditionCompletionIndicatorDelay, function():void
			{
				Animate.legacyTo(m_conditionCompletionIndicators[m_conditionCompletionIndicatorCount], 0.25, {"scaleX": 1, "scaleY": 1, "alpha": 1}, Animate.ExpoOut);
				m_conditionCompletionIndicatorCount += 1;
			});
			this.m_conditionCompletionIndicatorDelay += 0.1;
		}
		
		override public function getView():Sprite
		{
			return this.m_view.tileBg;
		}
		
		private function setupPerks(param1:Array):void
		{
			var _loc6_:MovieClip = null;
			var _loc2_:int = int(param1.length);
			var _loc3_:Number = 5;
			var _loc4_:Number = this.m_view.tileIcon.x;
			var _loc5_:Number = this.m_view.tileIcon.y - (this.m_view.tileIcon.height >> 1) - _loc3_ * 2 - 215;
			this.m_perkElements = [];
			var _loc7_:int = 0;
			while (_loc7_ < _loc2_)
			{
				_loc6_ = new iconsAll76x76View();
				MenuUtils.setupIcon(_loc6_, param1[_loc7_], MenuConstants.COLOR_GREY_ULTRA_DARK, false, true, MenuConstants.COLOR_WHITE, 1);
				_loc6_.width = _loc6_.height = 32;
				_loc6_.x = _loc4_;
				_loc6_.y = _loc5_ - (_loc6_.height >> 1);
				_loc5_ -= MenuConstants.perksIconYOffset;
				this.m_perkElements[_loc7_] = _loc6_;
				this.m_view.addChild(_loc6_);
				_loc7_++;
			}
		}
		
		private function setupTextFields(param1:String, param2:String):void
		{
			MenuUtils.setupTextUpper(this.m_view.header, param1, 14, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.setupTextUpper(this.m_view.title, param2, 26, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.m_textObj.header = this.m_view.header.htmlText;
			this.m_textObj.title = this.m_view.title.htmlText;
			MenuUtils.truncateTextfield(this.m_view.header, 1, MenuConstants.FontColorWhite, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.header));
			MenuUtils.truncateTextfield(this.m_view.title, 1, MenuConstants.FontColorWhite, CommonUtils.changeFontToGlobalIfNeeded(this.m_view.title));
		}
		
		private function changeTextColor(param1:uint, param2:uint):void
		{
			this.m_view.header.textColor = param1;
			this.m_view.title.textColor = param2;
		}
		
		private function showText(param1:Boolean):void
		{
			this.m_view.header.visible = param1;
			this.m_view.title.visible = param1;
		}
		
		private function callTextTicker(param1:Boolean):void
		{
			var _loc2_:int = 0;
			if (this.m_indicatorTextObjArray.length > 0)
			{
				_loc2_ = 0;
				while (_loc2_ < this.m_indicatorTextObjArray.length)
				{
					if (param1)
					{
						this.m_indicatorTextObjArray[_loc2_].textticker.startTextTickerHtml(this.m_indicatorTextObjArray[_loc2_].indicatortextfield, this.m_indicatorTextObjArray[_loc2_].title);
					}
					else
					{
						this.m_indicatorTextObjArray[_loc2_].textticker.stopTextTicker(this.m_indicatorTextObjArray[_loc2_].indicatortextfield, this.m_indicatorTextObjArray[_loc2_].title);
						MenuUtils.truncateTextfield(this.m_indicatorTextObjArray[_loc2_].indicatortextfield, 1, MenuConstants.FontColorWhite);
					}
					_loc2_++;
				}
			}
		}
		
		private function loadImage(param1:String):void
		{
			var imagePath:String = param1;
			if (this.m_loader != null)
			{
				this.m_loader.cancelIfLoading();
				if (this.m_useZoomedImage)
				{
					this.m_view.image.removeChild(this.m_loader);
				}
				else
				{
					this.m_view.imagesmall.removeChild(this.m_loader);
				}
				this.m_loader = null;
			}
			this.m_loader = new MenuImageLoader(ControlsMain.isVrModeActive(), this.m_loadOnVisibleOnScreen);
			if (this.m_useZoomedImage)
			{
				this.m_view.image.addChild(this.m_loader);
			}
			else
			{
				this.m_view.imagesmall.addChild(this.m_loader);
			}
			this.m_loader.center = true;
			this.m_loader.loadImage(imagePath, function():void
			{
				Animate.legacyTo(m_view.tileDarkBg, 0.3, {"alpha": 0}, Animate.Linear);
				if (m_useZoomedImage)
				{
					MenuUtils.trySetCacheAsBitmap(m_view.image, true);
					m_view.image.height = MenuConstants.MenuTileLargeHeight;
					m_view.image.scaleX = m_view.image.scaleY;
					if (m_view.image.width < MenuConstants.MenuTileTallWidth)
					{
						m_view.image.width = MenuConstants.MenuTileTallWidth;
						m_view.image.scaleY = m_view.image.scaleX;
					}
				}
				else
				{
					MenuUtils.trySetCacheAsBitmap(m_view.imagesmall, true);
					m_view.imagesmall.height = MenuConstants.MenuTileSmallHeight;
					m_view.imagesmall.scaleX = m_view.imagesmall.scaleY;
					if (m_view.imagesmall.width < MenuConstants.MenuTileSmallWidth)
					{
						m_view.imagesmall.width = MenuConstants.MenuTileSmallWidth;
						m_view.imagesmall.scaleY = m_view.imagesmall.scaleX;
					}
				}
			});
			this.m_loader.setVisibleOnScreen(this.m_isVisibleOnScreen);
			if (this.m_isLocked)
			{
				MenuUtils.setColorFilter(this.m_loader, "unknown");
			}
			else if (this.m_markedForRemoval)
			{
				MenuUtils.setColorFilter(this.m_loader, "markedforremoval");
			}
			else if (!this.m_isAvailable)
			{
				MenuUtils.setColorFilter(this.m_loader, "shop");
			}
		}
		
		override protected function handleSelectionChange():void
		{
			var delayTime:Number = NaN;
			Animate.complete(this.m_view);
			if (m_loading)
			{
				return;
			}
			if (m_isSelected)
			{
				if (!this.m_loadOnVisibleOnScreen)
				{
					setPopOutScale(this.m_view, true);
					Animate.to(this.m_view.dropShadow, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
				}
				else
				{
					delayTime = ControlsMain.isVrModeActive() ? 0.2 : 0.05;
					Animate.delay(this.m_view.dropShadow, delayTime, function():void
					{
						setPopOutScale(m_view, true);
						Animate.to(m_view.dropShadow, 0.3, 0, {"alpha": 1}, Animate.ExpoOut);
					});
				}
				this.setOverlayColor(true);
				if (this.m_pressable)
				{
					MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
					MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, MenuConstants.COLOR_RED, false, true, MenuConstants.COLOR_WHITE, 1, 0, true);
					this.callTextTicker(true);
				}
			}
			else
			{
				setPopOutScale(this.m_view, false);
				Animate.kill(this.m_view.dropShadow);
				this.m_view.dropShadow.alpha = 0;
				this.setOverlayColor(false);
				if (this.m_pressable)
				{
					MenuUtils.setColor(this.m_view.tileSelect, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
					MenuUtils.setupIcon(this.m_view.tileIcon, this.m_iconLabel, this.m_markedForRemoval ? uint(MenuConstants.COLOR_GREY) : uint(MenuConstants.COLOR_WHITE), true, false);
					this.callTextTicker(false);
				}
			}
		}
		
		override public function onUnregister():void
		{
			var _loc1_:int = 0;
			if (this.m_view)
			{
				Animate.complete(this.m_view.tileDarkBg);
				Animate.complete(this.m_view.tileSelect);
				Animate.kill(this.m_view.dropShadow);
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
				if (this.m_conditionsContainer.length > 0)
				{
					_loc1_ = 0;
					while (_loc1_ < this.m_conditionsContainer.length)
					{
						Animate.kill(this.m_conditionsContainer[_loc1_].valueIcon);
						Animate.kill(this.m_conditionsContainer[_loc1_].header);
						Animate.kill(this.m_conditionsContainer[_loc1_].title);
						Animate.kill(this.m_conditionsContainer[_loc1_].description);
						_loc1_++;
					}
					this.m_conditionsContainer = [];
				}
				if (this.m_newConditionsContainer.length > 0)
				{
					_loc1_ = 0;
					while (_loc1_ < this.m_newConditionsContainer.length)
					{
						Animate.kill(this.m_newConditionsContainer[_loc1_].valueIcon);
						Animate.kill(this.m_newConditionsContainer[_loc1_].header);
						Animate.kill(this.m_newConditionsContainer[_loc1_].title);
						Animate.kill(this.m_newConditionsContainer[_loc1_].description);
						_loc1_++;
					}
					this.m_newConditionsContainer = [];
				}
				if (this.m_conditionCompletionIndicators.length > 0)
				{
					_loc1_ = 0;
					while (_loc1_ < this.m_conditionCompletionIndicators.length)
					{
						Animate.kill(this.m_conditionCompletionIndicators[_loc1_]);
						_loc1_++;
					}
					this.m_conditionCompletionIndicators = [];
				}
				while (this.m_view.indicator.numChildren > 0)
				{
					this.m_view.indicator.removeChild(this.m_view.indicator.getChildAt(0));
				}
				if (this.m_loader)
				{
					this.m_loader.cancelIfLoading();
					if (this.m_useZoomedImage)
					{
						this.m_view.image.removeChild(this.m_loader);
					}
					else
					{
						this.m_view.imagesmall.removeChild(this.m_loader);
					}
					this.m_loader = null;
				}
				if (this.m_perkElements.length > 0)
				{
					_loc1_ = 0;
					while (_loc1_ < this.m_perkElements.length)
					{
						removeChild(this.m_perkElements[_loc1_]);
						this.m_perkElements[_loc1_] = null;
						_loc1_++;
					}
					this.m_perkElements = [];
				}
				removeChild(this.m_view);
				this.m_view = null;
			}
			super.onUnregister();
		}
		
		public function setVisibleOnScreen(param1:Boolean):void
		{
			this.m_isVisibleOnScreen = param1;
			if (!this.m_loadOnVisibleOnScreen)
			{
				return;
			}
			if (this.m_loader != null)
			{
				this.m_loader.setVisibleOnScreen(param1);
			}
			if (this.m_view != null)
			{
				this.m_view.visible = param1;
			}
		}
	}
}

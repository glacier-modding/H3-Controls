package hud
{
	import basic.ButtonPromptImage;
	import basic.ButtonPromtUtil;
	import basic.IButtonPromptOwner;
	import common.BaseControl;
	import common.Log;
	import common.TaskletSequencer;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Dictionary;
	
	public dynamic class MapLayerIndicator extends BaseControl implements IButtonPromptOwner
	{
		
		private var m_view:MapLayerIndicatorView;
		
		private var m_labelContainer:Sprite;
		
		private var m_promptUp:ButtonPromptImage;
		
		private var m_promptDown:ButtonPromptImage;
		
		private var m_selectedMapLayerLevel:int = -1;
		
		private var m_layerIndicatorLevelDict:Dictionary;
		
		private var m_numOfElements:int = 0;
		
		public function MapLayerIndicator()
		{
			this.m_layerIndicatorLevelDict = new Dictionary(true);
			super();
			this.m_view = new MapLayerIndicatorView();
			this.m_promptUp = new ButtonPromptImage();
			this.m_promptDown = new ButtonPromptImage();
			addMouseUpEventListener(this.m_promptUp, this.handlePromptMouseEvent, "lt");
			addMouseUpEventListener(this.m_promptDown, this.handlePromptMouseEvent, "rt");
			this.setPrompts();
			this.m_view.promptsMc.prompt1.addChild(this.m_promptUp);
			this.m_view.promptsMc.prompt2.addChild(this.m_promptDown);
			addChild(this.m_view);
			addEventListener(Event.ADDED_TO_STAGE, this.addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, this.removedHandler);
			this.m_layerIndicatorLevelDict = new Dictionary(true);
			this.m_labelContainer = new Sprite();
			this.m_view.addChild(this.m_labelContainer);
		}
		
		private static function addMouseUpEventListener(param1:ButtonPromptImage, param2:Function, param3:String):void
		{
			var prompt:ButtonPromptImage = param1;
			var mouseCallback:Function = param2;
			var actiontype:String = param3;
			if (prompt == null || mouseCallback == null)
			{
				return;
			}
			prompt.addEventListener(MouseEvent.MOUSE_UP, function(param1:MouseEvent):void
			{
				param1.stopPropagation();
				mouseCallback(actiontype);
			}, false, 0, false);
		}
		
		private function getLabel(param1:int):MapLayIndicatorLabelView
		{
			var _loc2_:MapLayIndicatorLabelView = null;
			while (param1 >= this.m_labelContainer.numChildren)
			{
				_loc2_ = new MapLayIndicatorLabelView();
				_loc2_.x = 0;
				MenuUtils.setColor(_loc2_.icon, MenuConstants.COLOR_WHITE);
				MenuUtils.setupTextUpper(_loc2_.label_txt, "", 20, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
				MenuUtils.setColor(_loc2_.bg, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
				_loc2_.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
				this.m_layerIndicatorLevelDict[_loc2_] = param1;
				this.m_labelContainer.addChild(_loc2_);
			}
			return this.m_labelContainer.getChildAt(param1) as MapLayIndicatorLabelView;
		}
		
		public function onSetData(param1:Array):void
		{
			var data:Array = param1;
			if (data == null)
			{
				this.m_labelContainer.visible = false;
				return;
			}
			TaskletSequencer.getGlobalInstance().addChunk(function():void
			{
				var _loc1_:int = 0;
				var _loc2_:int = 0;
				var _loc3_:Object = null;
				var _loc4_:MapLayIndicatorLabelView = null;
				var _loc5_:MapLayIndicatorLabelView = null;
				var _loc6_:MapLayIndicatorLabelView = null;
				m_labelContainer.visible = true;
				m_numOfElements = data.length;
				if (m_numOfElements > 0)
				{
					_loc1_ = 1;
					_loc2_ = 0;
					while (_loc2_ < m_numOfElements)
					{
						_loc3_ = data[_loc2_];
						(_loc4_ = getLabel(_loc2_)).visible = true;
						_loc4_.y = -(m_view.promptsMc.height + _loc1_ * _loc4_.height);
						_loc4_.label_txt.htmlText = _loc3_.label;
						if (Boolean(_loc3_.selected) && m_selectedMapLayerLevel != _loc2_)
						{
							MenuUtils.setColor(_loc4_.bg, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
							if (m_selectedMapLayerLevel != -1)
							{
								_loc5_ = m_labelContainer.getChildAt(m_selectedMapLayerLevel) as MapLayIndicatorLabelView;
								MenuUtils.setColor(_loc5_.bg, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
							}
							m_selectedMapLayerLevel = _loc2_;
						}
						_loc4_.icon.visible = _loc3_.agentOnLevel;
						_loc1_++;
						_loc2_++;
					}
					while (m_labelContainer.numChildren > m_numOfElements)
					{
						(_loc6_ = m_labelContainer.getChildAt(m_labelContainer.numChildren - 1) as MapLayIndicatorLabelView).removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
						m_labelContainer.removeChild(_loc6_);
					}
				}
				m_view.promptsMc.prompt1.alpha = m_selectedMapLayerLevel == m_numOfElements - 1 ? 0.2 : 1;
				m_view.promptsMc.prompt2.alpha = m_selectedMapLayerLevel == 0 ? 0.2 : 1;
			});
		}
		
		public function showPrompts(param1:Boolean):void
		{
			this.m_view.visible = param1;
		}
		
		private function setPrompts():void
		{
			this.m_promptUp.platform = this.m_promptDown.platform = ControlsMain.getControllerType();
			this.m_promptUp.action = "lt";
			this.m_promptDown.action = "rt";
		}
		
		public function updateButtonPrompts():void
		{
			this.setPrompts();
		}
		
		private function addedHandler(param1:Event):void
		{
			ButtonPromtUtil.registerButtonPromptOwner(this);
		}
		
		private function removedHandler(param1:Event):void
		{
			ButtonPromtUtil.unregisterButtonPromptOwner(this);
		}
		
		public function handleMouseUp(param1:MouseEvent):void
		{
			var _loc2_:int = int(this.m_layerIndicatorLevelDict[param1.currentTarget]);
			var _loc3_:int = _loc2_ - this.m_selectedMapLayerLevel;
			if (_loc3_ != 0)
			{
				sendEventWithValue("onChangeMapLayer", _loc3_);
			}
		}
		
		private function handlePromptMouseEvent(param1:String):void
		{
			Log.info("mouse", this, "Prompt action click: " + param1);
			var _loc2_:* = param1 == "lt";
			if (_loc2_ && this.m_selectedMapLayerLevel >= this.m_numOfElements)
			{
				return;
			}
			if (!_loc2_ && this.m_selectedMapLayerLevel <= 0)
			{
				return;
			}
			var _loc3_:int = _loc2_ ? 1 : -1;
			sendEventWithValue("onChangeMapLayer", _loc3_);
		}
	}
}

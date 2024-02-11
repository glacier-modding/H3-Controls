// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.MapLayerIndicator

package hud {
import common.BaseControl;

import basic.IButtonPromptOwner;

import flash.display.Sprite;

import basic.ButtonPromptImage;

import flash.utils.Dictionary;
import flash.events.Event;
import flash.events.MouseEvent;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.TaskletSequencer;

import basic.ButtonPromtUtil;

import common.Log;

import flash.events.*;

public dynamic class MapLayerIndicator extends BaseControl implements IButtonPromptOwner {

	private var m_view:MapLayerIndicatorView;
	private var m_labelContainer:Sprite;
	private var m_promptUp:ButtonPromptImage;
	private var m_promptDown:ButtonPromptImage;
	private var m_selectedMapLayerLevel:int = -1;
	private var m_layerIndicatorLevelDict:Dictionary = new Dictionary(true);
	private var m_numOfElements:int = 0;

	public function MapLayerIndicator() {
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

	private static function addMouseUpEventListener(prompt:ButtonPromptImage, mouseCallback:Function, actiontype:String):void {
		if (((prompt == null) || (mouseCallback == null))) {
			return;
		}
		;
		prompt.addEventListener(MouseEvent.MOUSE_UP, function (_arg_1:MouseEvent):void {
			_arg_1.stopPropagation();
			mouseCallback(actiontype);
		}, false, 0, false);
	}


	private function getLabel(_arg_1:int):MapLayIndicatorLabelView {
		var _local_2:MapLayIndicatorLabelView;
		while (_arg_1 >= this.m_labelContainer.numChildren) {
			_local_2 = new MapLayIndicatorLabelView();
			_local_2.x = 0;
			MenuUtils.setColor(_local_2.icon, MenuConstants.COLOR_WHITE);
			MenuUtils.setupTextUpper(_local_2.label_txt, "", 20, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			MenuUtils.setColor(_local_2.bg, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
			_local_2.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
			this.m_layerIndicatorLevelDict[_local_2] = _arg_1;
			this.m_labelContainer.addChild(_local_2);
		}
		;
		return (this.m_labelContainer.getChildAt(_arg_1) as MapLayIndicatorLabelView);
	}

	public function onSetData(data:Array):void {
		if (data == null) {
			this.m_labelContainer.visible = false;
			return;
		}
		;
		TaskletSequencer.getGlobalInstance().addChunk(function ():void {
			var _local_1:int;
			var _local_2:int;
			var _local_3:Object;
			var _local_4:MapLayIndicatorLabelView;
			var _local_5:MapLayIndicatorLabelView;
			var _local_6:MapLayIndicatorLabelView;
			m_labelContainer.visible = true;
			m_numOfElements = data.length;
			if (m_numOfElements > 0) {
				_local_1 = 1;
				_local_2 = 0;
				while (_local_2 < m_numOfElements) {
					_local_3 = data[_local_2];
					_local_4 = getLabel(_local_2);
					_local_4.visible = true;
					_local_4.y = -(m_view.promptsMc.height + (_local_1 * _local_4.height));
					_local_4.label_txt.htmlText = _local_3.label;
					if (((_local_3.selected) && (!(m_selectedMapLayerLevel == _local_2)))) {
						MenuUtils.setColor(_local_4.bg, MenuConstants.COLOR_RED, true, MenuConstants.MenuElementSelectedAlpha);
						if (m_selectedMapLayerLevel != -1) {
							_local_5 = (m_labelContainer.getChildAt(m_selectedMapLayerLevel) as MapLayIndicatorLabelView);
							MenuUtils.setColor(_local_5.bg, MenuConstants.COLOR_MENU_TABS_BACKGROUND, true, MenuConstants.MenuElementBackgroundAlpha);
						}
						;
						m_selectedMapLayerLevel = _local_2;
					}
					;
					_local_4.icon.visible = _local_3.agentOnLevel;
					_local_1++;
					_local_2++;
				}
				;
				while (m_labelContainer.numChildren > m_numOfElements) {
					_local_6 = (m_labelContainer.getChildAt((m_labelContainer.numChildren - 1)) as MapLayIndicatorLabelView);
					_local_6.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
					m_labelContainer.removeChild(_local_6);
				}
				;
			}
			;
			m_view.promptsMc.prompt1.alpha = ((m_selectedMapLayerLevel == (m_numOfElements - 1)) ? 0.2 : 1);
			m_view.promptsMc.prompt2.alpha = ((m_selectedMapLayerLevel == 0) ? 0.2 : 1);
		});
	}

	public function showPrompts(_arg_1:Boolean):void {
		this.m_view.visible = _arg_1;
	}

	private function setPrompts():void {
		this.m_promptUp.platform = (this.m_promptDown.platform = ControlsMain.getControllerType());
		this.m_promptUp.action = "lt";
		this.m_promptDown.action = "rt";
	}

	public function updateButtonPrompts():void {
		this.setPrompts();
	}

	private function addedHandler(_arg_1:Event):void {
		ButtonPromtUtil.registerButtonPromptOwner(this);
	}

	private function removedHandler(_arg_1:Event):void {
		ButtonPromtUtil.unregisterButtonPromptOwner(this);
	}

	public function handleMouseUp(_arg_1:MouseEvent):void {
		var _local_2:int = this.m_layerIndicatorLevelDict[_arg_1.currentTarget];
		var _local_3:int = (_local_2 - this.m_selectedMapLayerLevel);
		if (_local_3 != 0) {
			sendEventWithValue("onChangeMapLayer", _local_3);
		}
		;
	}

	private function handlePromptMouseEvent(_arg_1:String):void {
		Log.info("mouse", this, ("Prompt action click: " + _arg_1));
		var _local_2:* = (_arg_1 == "lt");
		if (((_local_2) && (this.m_selectedMapLayerLevel >= this.m_numOfElements))) {
			return;
		}
		;
		if (((!(_local_2)) && (this.m_selectedMapLayerLevel <= 0))) {
			return;
		}
		;
		var _local_3:int = ((_local_2) ? 1 : -1);
		sendEventWithValue("onChangeMapLayer", _local_3);
	}


}
}//package hud


// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.photomode.PhotoModeWidget

package hud.photomode {
import common.BaseControl;


import basic.ButtonPromptImage;

import common.menu.MenuUtils;


public class PhotoModeWidget extends BaseControl {

	public static const VIEWFINDERSTYLE_NONE:int = 0;
	public static const VIEWFINDERSTYLE_CAMERAITEM:int = 1;
	public static const VIEWFINDERSTYLE_PHOTOOPP:int = 2;
	public static const VIEWFINDERSTYLE_SPYCAM:int = 3;
	private static const DY_HEIGHT_ENTRY:int = 21;
	private static const DY_GAP_BETWEEN_ENTRIES:int = 1;
	private static const DY_HEIGHT_BGMARGIN:int = 68;
	private static const DY_HEIGHT_BG_COLLAPSED:int = 37;
	private static const DX_GAP_BETWEEN_PROMPTIMAGE:int = 6;
	private static const DX_GAP_BETWEEN_PROMPTS:int = 24;

	private var m_view:PhotoModeWidgetView;
	private var m_entriesVisible:Vector.<PhotoModeEntry> = new Vector.<PhotoModeEntry>();
	private var m_promptsVisible:Vector.<PromptData> = new Vector.<PromptData>();
	private var m_entriesAvailable:Vector.<PhotoModeEntry> = new Vector.<PhotoModeEntry>();
	private var m_promptsAvailable:Vector.<PromptData> = new Vector.<PromptData>();
	private var m_buttonPromptImagesAvailable:Vector.<ButtonPromptImage> = new Vector.<ButtonPromptImage>();

	public function PhotoModeWidget() {
		var _local_6:ButtonPromptImage;
		super();
		this.m_view = new PhotoModeWidgetView();
		addChild(this.m_view);
		this.m_view.visible = false;
		this.m_view.bg_mc.alpha = 0.4;
		var _local_1:Array = [];
		var _local_2:int = 4;
		while (_local_1.length < _local_2) {
			_local_1.push(this.acquirePhotoModeEntry());
		}

		while (_local_1.length > 0) {
			this.releasePhotoModeEntry(_local_1.pop());
		}

		var _local_3:int = 34;
		while (_local_1.length < _local_3) {
			_local_1.push(this.acquirePrompt());
		}

		while (_local_1.length > 0) {
			this.releasePrompt(_local_1.pop());
		}

		var _local_4:int = 4;
		var _local_5:String = ControlsMain.getControllerType();
		while (_local_1.length < _local_4) {
			_local_6 = this.acquireButtonPromptImage();
			_local_6.platform = _local_5;
			_local_1.push(_local_6);
		}

		while (_local_1.length > 0) {
			this.releaseButtonPromptImage(_local_1.pop());
		}

	}

	public function onSetData(_arg_1:Object):void {
		if (_arg_1 == null) {
			return;
		}

		if (!_arg_1.bIsVisible) {
			this.m_view.visible = false;
			return;
		}

		this.m_view.visible = true;
		this.adjustNumVisibleEntries(_arg_1.aMenuEntries.length);
		this.feedDataToEntries(_arg_1.aMenuEntries);
		this.adjustNumVisiblePrompts(_arg_1.aPrompts.length);
		this.feedDataToPrompts(_arg_1.sInputPlatform, _arg_1.aPrompts);
	}

	private function adjustNumVisibleEntries(_arg_1:uint):void {
		var _local_2:PhotoModeEntry;
		while (_arg_1 > this.m_entriesVisible.length) {
			_local_2 = this.acquirePhotoModeEntry();
			_local_2.y = (-(DY_HEIGHT_ENTRY + DY_GAP_BETWEEN_ENTRIES) * this.m_entriesVisible.length);
			this.m_entriesVisible.unshift(_local_2);
		}

		while (_arg_1 < this.m_entriesVisible.length) {
			this.releasePhotoModeEntry(this.m_entriesVisible.shift());
		}

		this.m_view.bg_mc.height = ((this.m_entriesVisible.length > 0) ? (DY_HEIGHT_BGMARGIN + ((DY_HEIGHT_ENTRY + DY_GAP_BETWEEN_ENTRIES) * this.m_entriesVisible.length)) : DY_HEIGHT_BG_COLLAPSED);
		this.m_view.bg_mc.y = -(this.m_view.bg_mc.height);
	}

	private function feedDataToEntries(_arg_1:Array):void {
		var _local_2:int;
		while (_local_2 < _arg_1.length) {
			this.m_entriesVisible[_local_2].onSetData(_arg_1[_local_2]);
			_local_2++;
		}

	}

	private function adjustNumVisiblePrompts(_arg_1:uint):void {
		while (_arg_1 > this.m_promptsVisible.length) {
			this.m_promptsVisible.push(this.acquirePrompt());
		}

		while (_arg_1 < this.m_promptsVisible.length) {
			this.releasePrompt(this.m_promptsVisible.pop());
		}

	}

	private function feedDataToPrompts(_arg_1:String, _arg_2:Array):void {
		var _local_5:Number;
		var _local_6:PromptData;
		var _local_7:Array;
		var _local_8:int;
		var _local_9:ButtonPromptImage;
		var _local_3:Number = 10;
		var _local_4:int;
		while (_local_4 < _arg_2.length) {
			_local_5 = ((_arg_2[_local_4].bIsEnabled) ? 1 : 0.3);
			_local_6 = this.m_promptsVisible[_local_4];
			_local_7 = _arg_2[_local_4].aIcons;
			while (_local_6.images.length < _local_7.length) {
				_local_6.images.push(this.acquireButtonPromptImage());
			}

			while (_local_6.images.length > _local_7.length) {
				this.releaseButtonPromptImage(_local_6.images.pop());
			}

			_local_8 = 0;
			while (_local_8 < _local_7.length) {
				_local_9 = _local_6.images[_local_8];
				if (_local_9.platform != _arg_1) {
					_local_9.platform = _arg_1;
				}

				_local_9.alpha = _local_5;
				if ((_local_7[_local_8] is Number)) {
					_local_9.button = _local_7[_local_8];
				} else {
					if ((_local_7[_local_8] is String)) {
						_local_9.customKey = _local_7[_local_8];
					}

				}

				_local_9.x = (_local_3 + (_local_9.width / 2));
				_local_3 = (_local_3 + (_local_9.width + 2));
				_local_8++;
			}

			_local_6.labelTextField.text = _arg_2[_local_4].sLabel;
			_local_6.labelTextField.alpha = _local_5;
			_local_6.labelTextField.x = (_local_3 + DX_GAP_BETWEEN_PROMPTIMAGE);
			_local_3 = (_local_3 + ((DX_GAP_BETWEEN_PROMPTIMAGE + _local_6.labelTextField.width) + DX_GAP_BETWEEN_PROMPTS));
			_local_4++;
		}

		if (_local_3 > 535) {
			this.m_view.bg_mc.width = _local_3;
		} else {
			this.m_view.bg_mc.width = 535;
		}

	}

	public function triggerTestHUD():void {
		this.onSetData({
			"bIsVisible": true,
			"aMenuEntries": [{
				"eType": PhotoModeEntry.TYPE_TOGGLE,
				"sLabel": "Selfie cam",
				"bIsEnabled": MenuUtils.getRandomBoolean(),
				"bIsHighlighted": MenuUtils.getRandomBoolean(),
				"bIsToggledOn": MenuUtils.getRandomBoolean(),
				"sCurrentValue": "maybe"
			}, {
				"eType": PhotoModeEntry.TYPE_SLIDER,
				"sLabel": "DOF",
				"bIsEnabled": MenuUtils.getRandomBoolean(),
				"bIsHighlighted": MenuUtils.getRandomBoolean(),
				"fSliderPerc": MenuUtils.getRandomInRange(0, 100, true),
				"sCurrentValue": "xx%"
			}, {
				"eType": PhotoModeEntry.TYPE_LIST,
				"sLabel": "Filter",
				"bIsEnabled": MenuUtils.getRandomBoolean(),
				"bIsHighlighted": MenuUtils.getRandomBoolean(),
				"sCurrentValue": "Sepia"
			}],
			"sInputPlatform": ["xboxone", "ps4", "key", "pc"][MenuUtils.getRandomInRange(0, 3, true)],
			"aPrompts": MenuUtils.shuffleArray([{
				"bIsEnabled": true,
				"aIcons": [5, 7, 6, 8],
				"sLabel": "Navigate"
			}, {
				"bIsEnabled": true,
				"aIcons": [10],
				"sLabel": "Take Photo"
			}, {
				"bIsEnabled": true,
				"aIcons": [1],
				"sLabel": "Accept"
			}, {
				"bIsEnabled": true,
				"aIcons": [4],
				"sLabel": "Cancel"
			}, {
				"bIsEnabled": true,
				"aIcons": [],
				"sLabel": "Nothin'"
			}]).slice(MenuUtils.getRandomInRange(0, 5, true))
		});
	}

	private function acquirePhotoModeEntry():PhotoModeEntry {
		var _local_1:PhotoModeEntry;
		if (this.m_entriesAvailable.length > 0) {
			_local_1 = this.m_entriesAvailable.pop();
			_local_1.visible = true;
		} else {
			_local_1 = new PhotoModeEntry();
			this.m_view.entryholder_mc.addChild(_local_1);
		}

		return (_local_1);
	}

	private function releasePhotoModeEntry(_arg_1:PhotoModeEntry):void {
		_arg_1.visible = false;
		this.m_entriesAvailable.push(_arg_1);
	}

	private function acquirePrompt():PromptData {
		var _local_1:PromptData;
		if (this.m_promptsAvailable.length > 0) {
			_local_1 = this.m_promptsAvailable.pop();
			_local_1.labelTextField.visible = true;
		} else {
			_local_1 = new PromptData();
			this.m_view.addChild(_local_1.labelTextField);
		}

		return (_local_1);
	}

	private function releasePrompt(_arg_1:PromptData):void {
		while (_arg_1.images.length > 0) {
			this.releaseButtonPromptImage(_arg_1.images.pop());
		}

		_arg_1.labelTextField.visible = false;
		this.m_promptsAvailable.push(_arg_1);
	}

	private function acquireButtonPromptImage():ButtonPromptImage {
		var _local_1:ButtonPromptImage;
		if (this.m_buttonPromptImagesAvailable.length > 0) {
			_local_1 = this.m_buttonPromptImagesAvailable.pop();
			_local_1.visible = true;
		} else {
			_local_1 = new ButtonPromptImage();
			_local_1.y = -19;
			_local_1.scaleX = (_local_1.scaleY = 0.6);
			this.m_view.addChild(_local_1);
		}

		return (_local_1);
	}

	private function releaseButtonPromptImage(_arg_1:ButtonPromptImage):void {
		_arg_1.visible = false;
		this.m_buttonPromptImagesAvailable.push(_arg_1);
	}


}
}//package hud.photomode

import basic.ButtonPromptImage;

import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.menu.MenuConstants;


class PromptData {

	public var images:Vector.<ButtonPromptImage> = new Vector.<ButtonPromptImage>();
	public var labelTextField:TextField = new TextField();

	public function PromptData() {
		this.labelTextField.autoSize = TextFieldAutoSize.LEFT;
		this.labelTextField.y = -30;
		MenuUtils.setupText(this.labelTextField, "", 16, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
	}

}



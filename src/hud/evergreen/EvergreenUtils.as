// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.evergreen.EvergreenUtils

package hud.evergreen {


import flash.display.DisplayObject;
import flash.text.TextField;
import flash.display.DisplayObjectContainer;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;
import flash.display.Shape;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.Localization;

import flash.display.Sprite;

public class EvergreenUtils {

	public static const LABELPURPOSE_NONE:int = 0;
	public static const LABELPURPOSE_ACTION_KILL_TYPE:int = 1;
	public static const LABELPURPOSE_POISON_LETHAL:int = 2;
	public static const LABELPURPOSE_POISON_EMETIC:int = 3;
	public static const LABELPURPOSE_POISON_SEDATIVE:int = 4;
	public static const LABELPURPOSE_ITEMRARITY_COMMON:int = 5;
	public static const LABELPURPOSE_ITEMRARITY_RARE:int = 6;
	public static const LABELPURPOSE_ITEMRARITY_EPIC:int = 7;
	public static const LABELPURPOSE_ITEMRARITY_LEGENDARY:int = 8;
	public static const LABELPURPOSE_LOSE_ON_WOUNDED:int = 9;
	public static const ITEMRARITY_SAFEHOUSEONLY:int = -1;
	public static const ITEMRARITY_NONE:int = 0;
	public static const ITEMRARITY_COMMON:int = 1;
	public static const ITEMRARITY_RARE:int = 2;
	public static const ITEMRARITY_EPIC:int = 3;
	public static const ITEMRARITY_LEGENDARY:int = 4;
	public static const LABELBGCOLOR:Vector.<uint> = new <uint>[0xFFFFFF, 4210754, 0xFF003C, 8036144, 10428060, 3237406, 1122670, 7280494, 15629830];
	public static const CRIMESECTOR_ARMSTRAFFICKING:int = 0;
	public static const CRIMESECTOR_ASSASSINATION:int = 1;
	public static const CRIMESECTOR_ORGANTRAFFICKING:int = 2;
	public static const CRIMESECTOR_BIGPHARMA:int = 3;
	public static const CRIMESECTOR_ECOCRIME:int = 4;
	public static const CRIMESECTOR_PSYOPS:int = 5;
	public static const CRIMESECTOR_ESPIONAGE:int = 6;
	public static const CRIMESECTOR_SICKGAMES:int = 7;


	public static function disableMaskingInTextFields(_arg_1:DisplayObjectContainer):void {
		var _local_4:DisplayObject;
		var _local_5:TextField;
		var _local_6:DisplayObjectContainer;
		var _local_7:TextFormat;
		var _local_2:int = _arg_1.numChildren;
		var _local_3:int;
		while (_local_3 < _local_2) {
			_local_4 = _arg_1.getChildAt(_local_3);
			_local_5 = (_local_4 as TextField);
			if (_local_5 != null) {
				_local_7 = _local_5.defaultTextFormat;
				switch (_local_7.align) {
					case TextFormatAlign.CENTER:
						_local_5.autoSize = TextFieldAutoSize.CENTER;
						break;
					case TextFormatAlign.RIGHT:
					case TextFormatAlign.END:
						_local_5.autoSize = TextFieldAutoSize.RIGHT;
						break;
					case TextFormatAlign.LEFT:
					case TextFormatAlign.START:
					case TextFormatAlign.JUSTIFY:
						_local_5.autoSize = TextFieldAutoSize.LEFT;
						break;
				}

			}

			_local_6 = (_local_4 as DisplayObjectContainer);
			if (_local_6 != null) {
				disableMaskingInTextFields(_local_6);
			}

			_local_3++;
		}

	}

	public static function isValidRarityLabel(_arg_1:int):Boolean {
		switch (_arg_1) {
			case ITEMRARITY_COMMON:
			case ITEMRARITY_RARE:
			case ITEMRARITY_EPIC:
			case ITEMRARITY_LEGENDARY:
				return (true);
			default:
				return (false);
		}

	}

	public static function createRarityLabel(_arg_1:int, _arg_2:Boolean = true):DisplayObject {
		var _local_3:Shape = new Shape();
		var _local_4:TextField = new TextField();
		_local_3.name = "background";
		_local_4.name = "txt";
		MenuUtils.setupText(_local_4, "", 30, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		_local_4.autoSize = TextFieldAutoSize.LEFT;
		switch (_arg_1) {
			case ITEMRARITY_COMMON:
				_local_4.text = Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY_COMMON").toUpperCase();
				break;
			case ITEMRARITY_RARE:
				_local_4.text = Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY_RARE").toUpperCase();
				break;
			case ITEMRARITY_EPIC:
				_local_4.text = Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY_EPIC").toUpperCase();
				break;
			case ITEMRARITY_LEGENDARY:
				_local_4.text = Localization.get("UI_INVENTORY_EVERGREEN_ITEMRARITY_LEGENDARY").toUpperCase();
				break;
			default:
				_local_4.text = "???";
		}

		_local_4.x = (-(_local_4.width) / 2);
		_local_4.y = ((-(_local_4.height) / 2) + 1);
		var _local_5:uint;
		switch (_arg_1) {
			case ITEMRARITY_COMMON:
				_local_5 = LABELBGCOLOR[LABELPURPOSE_ITEMRARITY_COMMON];
				break;
			case ITEMRARITY_RARE:
				_local_5 = LABELBGCOLOR[LABELPURPOSE_ITEMRARITY_RARE];
				break;
			case ITEMRARITY_EPIC:
				_local_5 = LABELBGCOLOR[LABELPURPOSE_ITEMRARITY_EPIC];
				break;
			case ITEMRARITY_LEGENDARY:
				_local_5 = LABELBGCOLOR[LABELPURPOSE_ITEMRARITY_LEGENDARY];
				break;
		}

		var _local_6:Number = 25;
		_local_3.graphics.beginFill(_local_5);
		_local_3.graphics.drawRoundRect((-(_local_4.width + _local_6) / 2), (-52 / 2), (_local_4.width + _local_6), 52, ((_arg_2) ? 10 : 0));
		_local_3.graphics.endFill();
		var _local_7:Sprite = new Sprite();
		_local_7.addChild(_local_3);
		_local_7.addChild(_local_4);
		return (_local_7);
	}


}
}//package hud.evergreen


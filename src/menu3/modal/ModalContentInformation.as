// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalContentInformation

package menu3.modal {
import menu3.MenuImageLoader;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.AntiAliasType;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;

public class ModalContentInformation {


	public static function createContent(_arg_1:ModalScrollingContainer, _arg_2:Array):void {
		var _local_7:ModalDialogContentImageView;
		var _local_8:MenuImageLoader;
		var _local_9:TextField;
		var _local_10:Number;
		var _local_11:TextFormat;
		var _local_12:Number;
		var _local_13:Number;
		var _local_14:ModalDialogContractElement;
		var _local_15:ModalDialogDlcMissingElement;
		var _local_16:ModalDialogImageTextElement;
		var _local_3:Number = _arg_1.getContentWidth();
		var _local_4:Number = _arg_1.getScrollDist();
		var _local_5:Number = 0;
		var _local_6:int;
		while (_local_6 < _arg_2.length) {
			if (_arg_2[_local_6].image) {
				if (_local_5 > 0) {
					_arg_1.addGap(_local_5);
					_local_5 = 0;
				}

				_local_7 = new ModalDialogContentImageView();
				_local_8 = new MenuImageLoader();
				_local_8.center = false;
				_local_7.image.addChild(_local_8);
				_local_8.loadImage(_arg_2[_local_6].image);
				_arg_1.appendEntry(_local_7, false, _arg_2[_local_6].imageheight, "image");
				_local_5 = _local_4;
			}

			if (_arg_2[_local_6].description) {
				if (_local_5 > 0) {
					_arg_1.addGap(_local_5);
					_local_5 = 0;
				}

				_local_9 = new TextField();
				_local_9.autoSize = "left";
				_local_9.antiAliasType = AntiAliasType.NORMAL;
				_local_10 = 16;
				_local_9.width = (_local_3 - _local_10);
				_local_9.multiline = true;
				_local_9.wordWrap = true;
				_local_9.selectable = false;
				MenuUtils.setupText(_local_9, _arg_2[_local_6].description, 21, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
				CommonUtils.changeFontToGlobalIfNeeded(_local_9);
				_local_11 = new TextFormat();
				_local_11.leading = 5;
				_local_11.letterSpacing = 0.3;
				_local_9.setTextFormat(_local_11);
				_local_12 = Math.ceil((_local_9.numLines * _arg_1.getScrollDist()));
				if (_local_9.height > _local_12) {
					_local_13 = ((_local_9.height - _local_12) / _local_9.numLines);
					_local_11.leading = (5 - _local_13);
					_local_11.letterSpacing = 0.3;
					_local_9.setTextFormat(_local_11);
				}

				_arg_1.appendEntry(_local_9, false, _local_9.height);
				_local_5 = _local_4;
			}

			if (_arg_2[_local_6].contract) {
				if (_local_5 > 0) {
					_arg_1.addGap(_local_5);
					_local_5 = 0;
				}

				_local_14 = new ModalDialogContractElement();
				_local_14.setData(_arg_2[_local_6].contract);
				_arg_1.appendEntry(_local_14, false, 0, "contract");
				_local_5 = _local_4;
			}

			if (_arg_2[_local_6].dlcmissing) {
				if (_local_5 > 0) {
					_arg_1.addGap(_local_5);
					_local_5 = 0;
				}

				_local_15 = new ModalDialogDlcMissingElement();
				_local_15.setData(_arg_2[_local_6].dlcmissing);
				_arg_1.appendEntry(_local_15, false, 0, "dlcmissing");
				_local_5 = _local_4;
			}

			if (_arg_2[_local_6].imagetext) {
				if (_local_5 > 0) {
					_arg_1.addGap(_local_5);
					_local_5 = 0;
				}

				_local_16 = new ModalDialogImageTextElement();
				_local_16.setData(_arg_2[_local_6].imagetext);
				_arg_1.appendEntry(_local_16, false, 0, "imagetext");
				_local_5 = _local_4;
			}

			_local_6++;
		}

	}


}
}//package menu3.modal


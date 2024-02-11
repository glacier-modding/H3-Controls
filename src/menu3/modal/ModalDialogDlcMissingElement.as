// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogDlcMissingElement

package menu3.modal {
import flash.display.Sprite;

import menu3.MenuImageLoader;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;

public class ModalDialogDlcMissingElement extends Sprite implements ModalDialogContentInfoElementBase {

	private const DLC_MISSING_HEIGHT:int = 361;
	private const DLC_MISSING_INITIAL_Y:int = 510;
	private const DLC_MISSING_INITIAL_Y_WITHOUT_CONTRACT:int = 147;
	private const DLC_MISSING_DESCRIPTION_SPACE:int = 3;

	private var m_dlcMissingView:ModalDialogDlcView;
	private var m_dlcImageLoader:MenuImageLoader;

	public function ModalDialogDlcMissingElement() {
		this.m_dlcMissingView = new ModalDialogDlcView();
		addChild(this.m_dlcMissingView);
		MenuUtils.setColor(this.m_dlcMissingView.line, MenuConstants.COLOR_WHITE, true, 1);
	}

	public function setData(_arg_1:Object):void {
		this.setupDlcTextFields(_arg_1.showcreatedin, ((_arg_1.episode == null) ? "" : _arg_1.episode), ((_arg_1.location == null) ? "" : _arg_1.location), _arg_1.description);
		if (_arg_1.image) {
			this.loadDlcImage(_arg_1.image);
		}
		;
	}

	public function destroy():void {
		this.cleanupDlcImage();
		if (this.m_dlcMissingView != null) {
			removeChild(this.m_dlcMissingView);
			this.m_dlcMissingView = null;
		}
		;
	}

	private function setupDlcTextFields(_arg_1:Boolean, _arg_2:String, _arg_3:String, _arg_4:String):void {
		this.m_dlcMissingView.title.autoSize = "left";
		this.m_dlcMissingView.title.width = 366;
		this.m_dlcMissingView.title.multiline = true;
		this.m_dlcMissingView.title.wordWrap = true;
		MenuUtils.setupText(this.m_dlcMissingView.title, _arg_2, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_dlcMissingView.description.autoSize = "left";
		this.m_dlcMissingView.description.width = 366;
		this.m_dlcMissingView.description.multiline = true;
		this.m_dlcMissingView.description.wordWrap = true;
		var _local_5:String = ((_arg_1) ? ((_arg_3 + "<br><br>") + _arg_4) : _arg_4);
		MenuUtils.setupText(this.m_dlcMissingView.description, _local_5, 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(this.m_dlcMissingView.title, 4, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_dlcMissingView.title));
		var _local_6:int = 1;
		if (this.m_dlcMissingView.title.numLines > 4) {
			_local_6 = 2;
		}
		;
		this.m_dlcMissingView.title.y = (this.m_dlcMissingView.title.y - ((this.m_dlcMissingView.title.numLines - _local_6) * 31));
		var _local_7:int = 12;
		switch ((this.m_dlcMissingView.title.numLines + (1 - _local_6))) {
			case 1:
				_local_7 = 12;
				break;
			case 2:
				_local_7 = 11;
				break;
			case 3:
				_local_7 = 10;
				break;
			case 4:
				_local_7 = 9;
				break;
			default:
				_local_7 = 12;
		}
		;
		MenuUtils.truncateTextfield(this.m_dlcMissingView.description, _local_7, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_dlcMissingView.description));
		var _local_8:int = 1;
		if (this.m_dlcMissingView.description.numLines > _local_7) {
			_local_8 = 2;
		}
		;
		var _local_9:Number = ((this.m_dlcMissingView.description.numLines - _local_8) * 24);
		this.m_dlcMissingView.title.y = (this.m_dlcMissingView.title.y - _local_9);
		this.m_dlcMissingView.line.y = (this.m_dlcMissingView.line.y - _local_9);
		this.m_dlcMissingView.description.y = (this.m_dlcMissingView.description.y - _local_9);
	}

	private function loadDlcImage(imagePath:String):void {
		this.cleanupDlcImage();
		this.m_dlcImageLoader = new MenuImageLoader();
		this.m_dlcMissingView.image.addChild(this.m_dlcImageLoader);
		this.m_dlcImageLoader.center = true;
		this.m_dlcImageLoader.loadImage(imagePath, function ():void {
			MenuUtils.trySetCacheAsBitmap(m_dlcMissingView.image, true);
			var _local_1:Number = (MenuConstants.MenuTileSmallWidth / MenuConstants.MenuTileLargeWidth);
			var _local_2:Number = (MenuConstants.MenuTileLargeWidth * _local_1);
			var _local_3:Number = (MenuConstants.MenuTileLargeWidth * _local_1);
			m_dlcMissingView.image.width = (_local_2 - (MenuConstants.tileImageBorder * 2));
			m_dlcMissingView.image.height = (_local_3 - (MenuConstants.tileImageBorder * 2));
		});
	}

	private function cleanupDlcImage():void {
		if (this.m_dlcImageLoader == null) {
			return;
		}
		;
		this.m_dlcImageLoader.cancelIfLoading();
		this.m_dlcMissingView.image.removeChild(this.m_dlcImageLoader);
		this.m_dlcImageLoader = null;
	}


}
}//package menu3.modal


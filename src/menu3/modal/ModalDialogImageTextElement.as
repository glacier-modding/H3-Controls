// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogImageTextElement

package menu3.modal {
import flash.display.Sprite;

import menu3.MenuImageLoader;

import common.menu.MenuUtils;
import common.menu.MenuConstants;
import common.CommonUtils;

public class ModalDialogImageTextElement extends Sprite implements ModalDialogContentInfoElementBase {

	private const DLC_MISSING_HEIGHT:int = 361;
	private const DLC_MISSING_INITIAL_Y:int = 510;
	private const DLC_MISSING_INITIAL_Y_WITHOUT_CONTRACT:int = 147;
	private const DLC_MISSING_DESCRIPTION_SPACE:int = 3;

	private var m_dialogDlcView:ModalDialogDlcView;
	private var m_imageLoader:MenuImageLoader;

	public function ModalDialogImageTextElement() {
		this.m_dialogDlcView = new ModalDialogDlcView();
		addChild(this.m_dialogDlcView);
	}

	public function setData(_arg_1:Object):void {
		this.setupText(_arg_1.header, _arg_1.description);
		if (_arg_1.image) {
			this.loadImage(_arg_1.image);
		}
		;
	}

	public function destroy():void {
		this.cleanupImage();
		if (this.m_dialogDlcView != null) {
			removeChild(this.m_dialogDlcView);
			this.m_dialogDlcView = null;
		}
		;
	}

	private function setupText(_arg_1:String, _arg_2:String):void {
		if (((!(_arg_1 == null)) && (!(_arg_1 == "")))) {
			this.m_dialogDlcView.title.autoSize = "left";
			this.m_dialogDlcView.title.width = 366;
			this.m_dialogDlcView.title.multiline = true;
			this.m_dialogDlcView.title.wordWrap = true;
			MenuUtils.setupText(this.m_dialogDlcView.title, _arg_1, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
			this.m_dialogDlcView.line.visible = true;
		} else {
			this.m_dialogDlcView.line.visible = false;
		}
		;
		if (((!(_arg_2 == null)) && (!(_arg_2 == "")))) {
			this.m_dialogDlcView.description.autoSize = "left";
			this.m_dialogDlcView.description.width = 366;
			this.m_dialogDlcView.description.multiline = true;
			this.m_dialogDlcView.description.wordWrap = true;
			MenuUtils.setupText(this.m_dialogDlcView.description, _arg_2, 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		}
		;
		MenuUtils.truncateTextfield(this.m_dialogDlcView.title, 4, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_dialogDlcView.title));
		var _local_3:int = 1;
		if (this.m_dialogDlcView.title.numLines > 4) {
			_local_3 = 2;
		}
		;
		this.m_dialogDlcView.title.y = (this.m_dialogDlcView.title.y - ((this.m_dialogDlcView.title.numLines - _local_3) * 31));
		var _local_4:int = 12;
		switch ((this.m_dialogDlcView.title.numLines + (1 - _local_3))) {
			case 1:
				_local_4 = 12;
				break;
			case 2:
				_local_4 = 11;
				break;
			case 3:
				_local_4 = 10;
				break;
			case 4:
				_local_4 = 9;
				break;
			default:
				_local_4 = 12;
		}
		;
		MenuUtils.truncateTextfield(this.m_dialogDlcView.description, _local_4, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_dialogDlcView.description));
		var _local_5:int = 1;
		if (this.m_dialogDlcView.description.numLines > _local_4) {
			_local_5 = 2;
		}
		;
		var _local_6:Number = ((this.m_dialogDlcView.description.numLines - _local_5) * 24);
		this.m_dialogDlcView.title.y = (this.m_dialogDlcView.title.y - _local_6);
		this.m_dialogDlcView.line.y = (this.m_dialogDlcView.line.y - _local_6);
		this.m_dialogDlcView.description.y = (this.m_dialogDlcView.description.y - _local_6);
	}

	private function loadImage(imagePath:String):void {
		this.cleanupImage();
		this.m_imageLoader = new MenuImageLoader();
		this.m_dialogDlcView.image.addChild(this.m_imageLoader);
		this.m_imageLoader.center = true;
		this.m_imageLoader.loadImage(imagePath, function ():void {
			MenuUtils.trySetCacheAsBitmap(m_dialogDlcView.image, true);
			var _local_1:Number = (MenuConstants.MenuTileSmallWidth / MenuConstants.MenuTileLargeWidth);
			var _local_2:Number = (MenuConstants.MenuTileLargeWidth * _local_1);
			var _local_3:Number = (MenuConstants.MenuTileLargeWidth * _local_1);
			m_dialogDlcView.image.width = (_local_2 - (MenuConstants.tileImageBorder * 2));
			m_dialogDlcView.image.height = (_local_3 - (MenuConstants.tileImageBorder * 2));
		});
	}

	private function cleanupImage():void {
		if (this.m_imageLoader == null) {
			return;
		}
		;
		this.m_imageLoader.cancelIfLoading();
		this.m_dialogDlcView.image.removeChild(this.m_imageLoader);
		this.m_imageLoader = null;
	}


}
}//package menu3.modal


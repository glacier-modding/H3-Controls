// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialogContractElement

package menu3.modal {
import flash.display.Sprite;

import menu3.MenuImageLoader;
import menu3.indicator.InPlaylistIndicator;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import menu3.indicator.CompletionStatusIndicatorUtil;

import common.Localization;
import common.Animate;
import common.DateTimeUtils;
import common.CommonUtils;

public dynamic class ModalDialogContractElement extends Sprite implements ModalDialogContentInfoElementBase {

	private static const CONTRACT_FOUND_HEIGHT:int = 273;
	private static const CONTRACT_FOUND_ICON_INITIAL_Y:int = 125;
	private static const CONTRACT_FOUND_TITLE_INITIAL_Y:int = 147;
	private static const CONTRACT_FOUND_LINE_INITIAL_Y:int = 185.5;//185
	private static const CONTRACT_FOUND_CREATOR_INITIAL_Y:int = 190;
	private static const StatusIndicatorAdditionOffsetY:int = 7;

	private var m_modalDialogContractView:ModalDialogContractView;
	private var m_contractImageLoader:MenuImageLoader;
	private var m_isInPlaylist:Boolean = false;
	private var m_inPlaylistIndicator:InPlaylistIndicator;

	public function ModalDialogContractElement() {
		this.m_modalDialogContractView = new ModalDialogContractView();
		addChild(this.m_modalDialogContractView);
		MenuUtils.setColor(this.m_modalDialogContractView.line, MenuConstants.COLOR_WHITE, true, 1);
	}

	public function destroy():void {
		this.cleanupContractImage();
		CompletionStatusIndicatorUtil.removeIndicator(this);
		if (this.m_modalDialogContractView != null) {
			removeChild(this.m_modalDialogContractView);
			this.m_modalDialogContractView = null;
		}
		;
	}

	public function setData(_arg_1:Object):void {
		var _local_3:ModalDialogContractAddedToPlaylistView;
		var _local_2:Boolean = ((!(_arg_1.hasOwnProperty("type"))) || (_arg_1.type == "usercreated"));
		if (_local_2) {
			this.setupUGCTextFields(_arg_1.name, _arg_1.creator, _arg_1.id, _arg_1.creationdate);
		} else {
			this.setupContractTextFields(_arg_1.name, _arg_1.description);
		}
		;
		MenuUtils.setupIcon(this.m_modalDialogContractView.icon, _arg_1.icon, MenuConstants.COLOR_WHITE, true, false);
		this.m_modalDialogContractView.tileIcon.visible = false;
		if (_arg_1.image) {
			this.loadContractImage(_arg_1.image);
		}
		;
		if (_arg_1.locked) {
			this.m_modalDialogContractView.tileIcon.visible = true;
			MenuUtils.setupIcon(this.m_modalDialogContractView.tileIcon, "locked", MenuConstants.COLOR_WHITE, true, false);
		}
		;
		CompletionStatusIndicatorUtil.removeIndicator(this);
		if (((_arg_1.completionstate) && (_arg_1.completionstate.length > 0))) {
			CompletionStatusIndicatorUtil.addIndicator(this, _arg_1.completionstate, CompletionStatusIndicatorUtil.StatusIndicatorOffset, (CompletionStatusIndicatorUtil.StatusIndicatorOffset + StatusIndicatorAdditionOffsetY));
		}
		;
		if (((!(_arg_1.addedSuccessfullyToPlaylist == undefined)) && (_arg_1.addedSuccessfullyToPlaylist == true))) {
			_local_3 = new ModalDialogContractAddedToPlaylistView();
			_local_3.x = 351;
			_local_3.y = 0;
			_local_3.label.y = _local_3.icon.y;
			_local_3.label.text = Localization.get("UI_DIALOG_CONTRACT_SEARCH_ADDED_TO_PLAYLIST");
			Animate.addFromTo(_local_3, MenuConstants.TabsHoverScrollTime, 2, {"alpha": 1}, {"alpha": 0}, Animate.ExpoOut);
			_local_3.icon.visible = false;
			this.m_modalDialogContractView.addChild(_local_3);
		}
		;
		this.m_isInPlaylist = (_arg_1.isInPlaylist === true);
	}

	private function setupUGCTextFields(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String):void {
		this.m_modalDialogContractView.title.autoSize = "left";
		this.m_modalDialogContractView.title.width = 366;
		this.m_modalDialogContractView.title.multiline = true;
		this.m_modalDialogContractView.title.wordWrap = true;
		MenuUtils.setupText(this.m_modalDialogContractView.title, _arg_1, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		var _local_5:String = Localization.get("UI_AUTHOR_BY");
		var _local_6:String = _local_5.substr(0, 1).toUpperCase();
		_local_5 = (_local_6 + _local_5.substr(1));
		MenuUtils.setupText(this.m_modalDialogContractView.creator, ((_local_5 + " ") + _arg_2), 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_modalDialogContractView.id, _arg_3, 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		var _local_7:Date = DateTimeUtils.parseSqlUTCTimeStamp(_arg_4);
		var _local_8:String = ((Localization.get("UI_DIALOG_CONTRACT_SEARCH_CONTRACT_CREATION_DATE") + " ") + DateTimeUtils.formatLocalDateLocalized(_local_7));
		MenuUtils.setupText(this.m_modalDialogContractView.creationdate, _local_8, 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(this.m_modalDialogContractView.title, 4, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_modalDialogContractView.title));
		MenuUtils.truncateTextfield(this.m_modalDialogContractView.creator, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_modalDialogContractView.creator));
		MenuUtils.truncateTextfield(this.m_modalDialogContractView.id, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_modalDialogContractView.id));
		MenuUtils.truncateTextfield(this.m_modalDialogContractView.creationdate, 1, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_modalDialogContractView.creationdate));
		var _local_9:int = 1;
		if (this.m_modalDialogContractView.title.numLines > 4) {
			_local_9 = 2;
		}
		;
		this.m_modalDialogContractView.title.y = (CONTRACT_FOUND_TITLE_INITIAL_Y - ((this.m_modalDialogContractView.title.numLines - _local_9) * 31));
		this.m_modalDialogContractView.icon.y = (CONTRACT_FOUND_ICON_INITIAL_Y - ((this.m_modalDialogContractView.title.numLines - _local_9) * 31));
	}

	private function setupContractTextFields(_arg_1:String, _arg_2:String):void {
		MenuUtils.setupText(this.m_modalDialogContractView.id, "", 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.setupText(this.m_modalDialogContractView.creationdate, "", 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		this.m_modalDialogContractView.icon.y = (CONTRACT_FOUND_ICON_INITIAL_Y + 50);
		this.m_modalDialogContractView.title.y = (CONTRACT_FOUND_TITLE_INITIAL_Y + 50);
		this.m_modalDialogContractView.creator.y = (CONTRACT_FOUND_CREATOR_INITIAL_Y + 50);
		this.m_modalDialogContractView.line.y = (CONTRACT_FOUND_LINE_INITIAL_Y + 50);
		this.m_modalDialogContractView.title.autoSize = "left";
		this.m_modalDialogContractView.title.width = 366;
		this.m_modalDialogContractView.title.multiline = true;
		this.m_modalDialogContractView.title.wordWrap = true;
		MenuUtils.setupText(this.m_modalDialogContractView.title, _arg_1, 28, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		this.m_modalDialogContractView.creator.autoSize = "left";
		this.m_modalDialogContractView.creator.width = 366;
		this.m_modalDialogContractView.creator.multiline = true;
		this.m_modalDialogContractView.creator.wordWrap = true;
		MenuUtils.setupText(this.m_modalDialogContractView.creator, MenuUtils.removeHtmlLineBreaks(_arg_2), 20, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
		MenuUtils.truncateTextfield(this.m_modalDialogContractView.title, 4, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_modalDialogContractView.title));
		var _local_3:int = 1;
		if (this.m_modalDialogContractView.title.numLines > 4) {
			_local_3 = 2;
		}
		;
		this.m_modalDialogContractView.title.y = (this.m_modalDialogContractView.title.y - ((this.m_modalDialogContractView.title.numLines - _local_3) * 31));
		this.m_modalDialogContractView.icon.y = (this.m_modalDialogContractView.icon.y - ((this.m_modalDialogContractView.title.numLines - _local_3) * 31));
		var _local_4:int = 7;
		switch (this.m_modalDialogContractView.title.numLines) {
			case 1:
				_local_4 = 7;
				break;
			case 2:
				_local_4 = 5;
				break;
			case 3:
				_local_4 = 4;
				break;
			case 4:
				_local_4 = 3;
				break;
			default:
				_local_4 = 7;
		}
		;
		MenuUtils.truncateTextfield(this.m_modalDialogContractView.creator, _local_4, null, CommonUtils.changeFontToGlobalIfNeeded(this.m_modalDialogContractView.creator));
		var _local_5:int = 1;
		if (this.m_modalDialogContractView.creator.numLines > _local_4) {
			_local_5 = 2;
		}
		;
		var _local_6:Number = ((this.m_modalDialogContractView.creator.numLines - _local_5) * 24);
		this.m_modalDialogContractView.title.y = (this.m_modalDialogContractView.title.y - _local_6);
		this.m_modalDialogContractView.icon.y = (this.m_modalDialogContractView.icon.y - _local_6);
		this.m_modalDialogContractView.line.y = (this.m_modalDialogContractView.line.y - _local_6);
		this.m_modalDialogContractView.creator.y = (this.m_modalDialogContractView.creator.y - _local_6);
	}

	private function loadContractImage(imagePath:String):void {
		this.cleanupContractImage();
		this.m_contractImageLoader = new MenuImageLoader();
		this.m_modalDialogContractView.image.addChild(this.m_contractImageLoader);
		this.m_contractImageLoader.center = true;
		this.m_contractImageLoader.loadImage(imagePath, function ():void {
			var _local_4:Number;
			MenuUtils.trySetCacheAsBitmap(m_modalDialogContractView.image, true);
			var _local_1:Number = (MenuConstants.MenuTileSmallWidth / MenuConstants.MenuTileLargeWidth);
			var _local_2:Number = (MenuConstants.MenuTileLargeWidth * _local_1);
			var _local_3:Number = (MenuConstants.MenuTileLargeHeight * _local_1);
			m_modalDialogContractView.image.width = (_local_2 - (MenuConstants.tileImageBorder * 2));
			m_modalDialogContractView.image.height = (_local_3 - (MenuConstants.tileImageBorder * 2));
			if (m_isInPlaylist) {
				_local_4 = (11 + m_modalDialogContractView.image.height);
				m_inPlaylistIndicator = new InPlaylistIndicator(m_modalDialogContractView.image.width, _local_4);
				m_inPlaylistIndicator.onSetData(m_modalDialogContractView, new Object());
			}
			;
		});
	}

	private function cleanupContractImage():void {
		if (this.m_contractImageLoader == null) {
			return;
		}
		;
		if (this.m_inPlaylistIndicator != null) {
			this.m_inPlaylistIndicator.onUnregister();
			this.m_inPlaylistIndicator = null;
		}
		;
		this.m_contractImageLoader.cancelIfLoading();
		this.m_modalDialogContractView.image.removeChild(this.m_contractImageLoader);
		this.m_contractImageLoader = null;
	}


}
}//package menu3.modal


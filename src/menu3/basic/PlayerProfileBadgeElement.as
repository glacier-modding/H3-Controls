// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.PlayerProfileBadgeElement

package menu3.basic {
import menu3.MenuElementBase;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.Localization;
import common.menu.MenuConstants;

import basic.Box;

import common.CommonUtils;

public dynamic class PlayerProfileBadgeElement extends MenuElementBase {

	private var m_view:Sprite;
	private var m_badgeClip:Badge;
	private var m_levelClip:Sprite;
	private var m_titleClip:Sprite;
	private var m_isPressable:Boolean;
	private var m_isSelectable:Boolean;
	private var m_badgeSize:Number = 200;
	private var m_useBadgeAnimation:Boolean = false;
	private var m_level:int = 1;
	private var m_title:String = "";

	public function PlayerProfileBadgeElement(_arg_1:Object) {
		super(_arg_1);
		this.m_view = new Sprite();
		addChild(this.m_view);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_isPressable = getNodeProp(this, "pressable");
		this.m_isSelectable = getNodeProp(this, "selectable");
		this.m_title = _arg_1.title;
		this.m_level = _arg_1.level;
		this.m_badgeSize = _arg_1.badgesize;
		this.m_useBadgeAnimation = _arg_1.animate;
		this.createBadge();
		this.m_badgeClip.setLevel(this.m_level, true, this.m_useBadgeAnimation);
	}

	private function createBadge():void {
		this.m_badgeClip = new Badge();
		this.m_badgeClip.x = (this.m_badgeSize / 2);
		this.m_badgeClip.y = (this.m_badgeSize / 2);
		this.m_badgeClip.setMaxSize(this.m_badgeSize);
		this.m_view.addChild(this.m_badgeClip);
	}

	private function createLevelDisplay():void {
		this.m_levelClip = new Sprite();
		this.m_levelClip.x = (this.m_badgeSize / 2);
		this.m_levelClip.y = (this.m_badgeSize + 30);
		this.m_levelClip.alpha = 0;
		var _local_1:TextField = new TextField();
		_local_1.autoSize = TextFieldAutoSize.CENTER;
		_local_1.selectable = false;
		MenuUtils.setupTextUpper(_local_1, ((Localization.get("UI_DIALOG_ESCALATION_LEVEL") + " ") + this.m_level), 24, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorGreyUltraDark);
		_local_1.x = -(_local_1.textWidth / 2);
		_local_1.y = -(_local_1.textHeight / 2);
		this.m_levelClip.addChild(_local_1);
		var _local_2:Sprite = new Box((_local_1.textWidth + 20), (_local_1.textHeight + 16), MenuConstants.COLOR_WHITE, Box.ALIGN_CENTERED, Box.TYPE_SOLID);
		this.m_levelClip.addChildAt(_local_2, 0);
		this.m_view.addChild(this.m_levelClip);
	}

	private function createTitleDisplay():void {
		this.m_titleClip = new Sprite();
		this.m_titleClip.x = this.m_levelClip.x;
		this.m_titleClip.y = (this.m_levelClip.y + 70);
		this.m_titleClip.alpha = 0;
		var _local_1:TextField = new TextField();
		_local_1.autoSize = TextFieldAutoSize.CENTER;
		_local_1.selectable = false;
		MenuUtils.setupText(_local_1, this.m_title, 50, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		CommonUtils.changeFontToGlobalIfNeeded(_local_1);
		MenuUtils.truncateTextfieldWithCharLimit(_local_1, 1, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT);
		MenuUtils.shrinkTextToFit(_local_1, _local_1.width, -1);
		_local_1.x = -(_local_1.textWidth / 2);
		_local_1.y = -(_local_1.textHeight / 2);
		this.m_titleClip.addChild(_local_1);
		this.m_view.addChild(this.m_titleClip);
	}

	override public function getView():Sprite {
		return (this.m_view);
	}

	override public function onUnregister():void {
		super.onUnregister();
		if (this.m_view) {
			removeChild(this.m_view);
			this.m_view = null;
		}
		;
	}


}
}//package menu3.basic


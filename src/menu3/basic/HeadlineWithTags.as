// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.HeadlineWithTags

package menu3.basic {
import common.menu.MenuConstants;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;

public dynamic class HeadlineWithTags extends HeadlineElement {

	private const HEADLINE_OFFSET:Number = -22;
	private const TAG_OFFSET_X:Number = 10;
	private const TAG_OFFSET_Y:Number = 2;
	private const TAG_MIN_WIDTH:Number = 60;
	private const TAG_TEXT_SPACE_X:Number = 20;
	private const TAG_LINETHROUGH_SPACE_X:Number = 14;
	private const TAGLINE_MAX_WIDTH:Number = ((MenuConstants.BaseWidth - MenuConstants.menuXOffset) - 300);

	private var m_tagContainer:Sprite = new Sprite();
	private var m_maxTagLinePosX:Number;

	public function HeadlineWithTags(_arg_1:Object) {
		super(_arg_1);
		var _local_2:HeadlineElementView = getRootView();
		var _local_3:TextField = _local_2.contractby;
		this.m_tagContainer.y = ((_local_3.y + _local_3.height) + this.TAG_OFFSET_Y);
		this.m_tagContainer.x = _local_2.title.x;
		_local_2.addChild(this.m_tagContainer);
		_local_2.y = (_local_2.y + this.HEADLINE_OFFSET);
	}

	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		if (_arg_1.tags != null) {
			this.setupTags(_arg_1.tags);
		}
		;
	}

	private function setupTags(_arg_1:Array):void {
		var _local_5:HeadlineTagView;
		var _local_6:TextField;
		var _local_7:Boolean;
		var _local_8:Number;
		var _local_9:Number;
		var _local_10:Number;
		this.m_tagContainer.removeChildren();
		if (((_arg_1 == null) || (_arg_1.length <= 0))) {
			return;
		}
		;
		var _local_2:Number = 0;
		var _local_3:Boolean;
		var _local_4:int;
		while (((_local_4 < _arg_1.length) && (!(_local_3)))) {
			_local_5 = new HeadlineTagView();
			_local_6 = _local_5.title;
			_local_6.autoSize = TextFieldAutoSize.LEFT;
			_local_7 = _arg_1[_local_4].active;
			MenuUtils.setupText(_local_6, _arg_1[_local_4].title, 18, MenuConstants.FONT_TYPE_MEDIUM, ((_local_7) ? MenuConstants.FontColorGreyUltraLight : MenuConstants.FontColorGreyMedium));
			MenuUtils.setTintColor(_local_5.bg, ((_local_7) ? MenuUtils.TINT_COLOR_MEDIUM_GREY : MenuUtils.TINT_COLOR_GREY));
			MenuUtils.setTintColor(_local_5.linethrough, MenuUtils.TINT_COLOR_NEARLY_WHITE);
			_local_8 = _local_6.width;
			_local_9 = (_local_8 + this.TAG_TEXT_SPACE_X);
			if ((_local_9 + _local_2) > this.TAGLINE_MAX_WIDTH) {
				_local_9 = Math.max((this.TAGLINE_MAX_WIDTH - _local_2), this.TAG_MIN_WIDTH);
				_local_6.width = (_local_9 - this.TAG_TEXT_SPACE_X);
				MenuUtils.truncateTextfield(_local_6, 1, null);
				_local_3 = true;
			}
			;
			_local_5.bg.width = _local_9;
			_local_5.bg.x = (_local_9 / 2);
			_local_5.linethrough.visible = (!(_local_7));
			if (!_local_7) {
				_local_10 = (_local_9 - this.TAG_LINETHROUGH_SPACE_X);
				_local_5.linethrough.width = _local_10;
				_local_5.linethrough.x = ((_local_10 / 2) + (this.TAG_LINETHROUGH_SPACE_X / 2));
			}
			;
			this.m_tagContainer.addChild(_local_5);
			_local_5.x = _local_2;
			_local_2 = (_local_2 + (_local_9 + this.TAG_OFFSET_X));
			_local_4++;
		}
		;
	}

	override public function onUnregister():void {
		this.m_tagContainer.removeChildren();
		getRootView().removeChild(this.m_tagContainer);
		this.m_tagContainer = null;
		super.onUnregister();
	}


}
}//package menu3.basic


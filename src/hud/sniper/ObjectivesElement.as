// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hud.sniper.ObjectivesElement

package hud.sniper {
import common.BaseControl;

import flash.display.Sprite;

import common.Animate;
import common.menu.MenuConstants;
import common.menu.MenuUtils;

import flash.text.TextFormat;

public class ObjectivesElement extends BaseControl {

	public static const BAR_ELEMENT_FADE_ANIM_TIME:Number = 0.3;
	public static const OBJ_MARGIN_HEIGHT:Number = 10;
	public static const OBJ_HINT_MARGIN_HEIGHT:Number = 3;
	public static const LABEL_TEXT_LEADING:Number = 16;
	public static const HINT_INDENTATON:Number = 60;

	private var m_view:Sprite;
	private var m_objectivesHolder:Sprite;
	private var m_startX:Number = 0;
	private var m_startY:Number = 0;
	private var m_objectivesPosY:Number;

	public function ObjectivesElement() {
		this.m_view = new Sprite();
		addChild(this.m_view);
		this.m_objectivesHolder = new Sprite();
		this.m_view.addChild(this.m_objectivesHolder);
		this.m_objectivesPosY = this.m_startY;
	}

	public function onSetData(_arg_1:Object):void {
		this.updateAndShowObjectives(_arg_1);
	}

	public function updateAndShowObjectives(_arg_1:Object):void {
		Animate.kill(this.m_objectivesHolder);
		this.m_objectivesHolder.visible = true;
		this.m_objectivesHolder.alpha = 1;
		while (this.m_objectivesHolder.numChildren > 0) {
			this.m_objectivesHolder.removeChildAt(0);
		}

		this.addObjectives(_arg_1);
		this.updateHeights();
	}

	private function addObjectives(_arg_1:Object):void {
		this.m_objectivesPosY = this.m_startY;
		if (_arg_1.primary.length > 0) {
			this.addObjLines(_arg_1.primary);
		}

		if (_arg_1.secondary.length > 0) {
			this.addObjLines(_arg_1.secondary);
		}

	}

	private function addObjLines(_arg_1:Array):void {
		var _local_2:Number = 0;
		while (_local_2 < _arg_1.length) {
			if (_arg_1[_local_2].isHint == true) {
				this.addHint(_arg_1[_local_2], this.m_startX);
			} else {
				this.addObjective(_arg_1[_local_2].objTitle, this.m_startX, this.m_objectivesPosY, _arg_1[_local_2].objType, _arg_1[_local_2].objSuccess, _arg_1[_local_2].objFail, _arg_1[_local_2].objChanged, _arg_1[_local_2].timerData, _arg_1[_local_2].counterData);
			}

			_local_2++;
		}

	}

	private function addObjective(_arg_1:String, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Boolean, _arg_6:Boolean, _arg_7:Boolean, _arg_8:Object, _arg_9:Object):void {
		var _local_10:ObjectivesElementView = new ObjectivesElementView();
		var _local_11:String = MenuConstants.FontColorWhite;
		_local_10.objective_txt.autoSize = "left";
		_local_10.objective_txt.multiline = true;
		_local_10.objective_txt.wordWrap = true;
		_local_10.objective_txt.width = 670;
		if (((!(_arg_5)) && (!(_arg_6)))) {
			_local_10.icons.gotoAndStop(1);
			_local_10.icons.typeicons.gotoAndStop((_arg_4 + 1));
		}

		if (((_arg_5) && (!(_arg_6)))) {
			_local_11 = MenuConstants.FontColorGreyMedium;
			_local_10.icons.gotoAndStop(3);
		}

		if (((!(_arg_5)) && (_arg_6))) {
			_local_11 = MenuConstants.FontColorGreyMedium;
			_local_10.icons.gotoAndStop(2);
		}

		if (((_arg_5) && (_arg_6))) {
			_local_11 = MenuConstants.FontColorGreyMedium;
			_local_10.icons.gotoAndStop(4);
		}

		if (_arg_7) {
			_local_10.x = (_arg_2 + 150);
			Animate.legacyTo(_local_10, 1, {"x": _arg_2}, Animate.ExpoOut);
		} else {
			_local_10.x = _arg_2;
		}

		_local_10.y = _arg_3;
		MenuUtils.setupText(_local_10.objective_txt, _arg_1, 18, MenuConstants.FONT_TYPE_MEDIUM, _local_11);
		this.m_objectivesPosY = (this.m_objectivesPosY + ((_local_10.objective_txt.numLines * LABEL_TEXT_LEADING) + OBJ_MARGIN_HEIGHT));
		this.m_objectivesHolder.addChild(_local_10);
	}

	private function addHint(_arg_1:Object, _arg_2:Number):void {
		_arg_2 = (_arg_2 + HINT_INDENTATON);
		var _local_3:ObjectivesElementView = new ObjectivesElementView();
		_local_3.icons.gotoAndStop(1);
		_local_3.icons.typeicons.gotoAndStop((_arg_1.objType + 1));
		_local_3.x = (_local_3.x + 11);
		_local_3.icons.scaleX = 0.8;
		_local_3.icons.scaleY = 0.8;
		_local_3.objective_txt.autoSize = "left";
		_local_3.objective_txt.multiline = true;
		_local_3.objective_txt.wordWrap = true;
		_local_3.objective_txt.width = (670 - HINT_INDENTATON);
		if (_arg_1.objChanged) {
			_local_3.x = (_arg_2 + 300);
			Animate.legacyTo(_local_3, 1, {"x": _arg_2}, Animate.ExpoOut);
		} else {
			_local_3.x = _arg_2;
		}

		_local_3.y = this.m_objectivesPosY;
		MenuUtils.setupText(_local_3.objective_txt, _arg_1.objTitle, 18, MenuConstants.FONT_TYPE_MEDIUM, MenuConstants.FontColorWhite);
		var _local_4:TextFormat = _local_3.objective_txt.getTextFormat();
		_local_4.size = (int(_local_4.size) - 5);
		_local_3.objective_txt.setTextFormat(_local_4);
		this.m_objectivesPosY = (this.m_objectivesPosY + ((_local_3.objective_txt.numLines * LABEL_TEXT_LEADING) + OBJ_HINT_MARGIN_HEIGHT));
		this.m_objectivesHolder.addChild(_local_3);
	}

	public function hideObjectives():void {
		Animate.kill(this.m_objectivesHolder);
		this.fadeOutObjectives();
	}

	public function fadeOutObjectives():void {
		Animate.legacyTo(this.m_objectivesHolder, BAR_ELEMENT_FADE_ANIM_TIME, {"alpha": 0}, Animate.Linear, function ():void {
			hideObjectivesHolder();
		});
	}

	public function hideObjectivesHolder():void {
		Animate.kill(this.m_objectivesHolder);
		this.m_objectivesHolder.visible = false;
		this.m_objectivesHolder.alpha = 0;
		this.updateHeights();
	}

	public function updateHeights():void {
		if (!this.m_objectivesHolder.visible) {
			this.m_objectivesPosY = this.m_startY;
		}

	}


}
}//package hud.sniper


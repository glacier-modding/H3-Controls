﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.briefing.BriefingSequenceFrame

package menu3.briefing {
import common.BaseControl;

import flash.display.Sprite;

import common.menu.MenuConstants;
import common.menu.MenuUtils;

public class BriefingSequenceFrame extends BaseControl {

	private var m_pageContent:Sprite;
	private var m_background:Sprite;
	private var m_mask:Sprite;
	private var m_testAlignmentGrid:Sprite;
	private var m_showGrid:Boolean;
	private var m_showBackground:Boolean;
	private var m_unitWidth:Number = (MenuConstants.BaseWidth / 10);
	private var m_unitHeight:Number = (MenuConstants.BaseHeight / 6);

	public function BriefingSequenceFrame() {
		trace("ETBriefing | BriefingSequenceFrame CALLED!!!");
		var _local_1:Number = ((MenuConstants.BaseHeight - MenuConstants.ElusiveContractsBriefingHeight) / 2);
		this.m_background = new Sprite();
		this.m_background.visible = false;
		this.m_background.name = "m_background";
		this.m_background.graphics.clear();
		this.m_background.graphics.beginFill(0, 1);
		this.m_background.graphics.drawRect(0, 0, MenuConstants.BaseWidth, MenuConstants.BaseHeight);
		this.m_background.graphics.endFill();
		addChild(this.m_background);
		this.m_pageContent = new Sprite();
		addChild(this.m_pageContent);
		this.m_mask = new Sprite();
		this.m_mask.graphics.clear();
		this.m_mask.graphics.beginFill(0xFF00, 1);
		this.m_mask.graphics.drawRect(0, _local_1, MenuConstants.BaseWidth, MenuConstants.ElusiveContractsBriefingHeight);
		this.m_mask.graphics.endFill();
		this.m_pageContent.addChild(this.m_mask);
		this.m_pageContent.mask = this.m_mask;
		this.m_testAlignmentGrid = new Sprite();
		this.m_testAlignmentGrid.name = "m_testAlignmentGrid";
		this.m_testAlignmentGrid.x = 0;
		this.m_testAlignmentGrid.y = 0;
	}

	private function showBackground():void {
		this.m_background.visible = true;
	}

	private function showAlignmentGrid():void {
		this.m_testAlignmentGrid.graphics.clear();
		this.m_testAlignmentGrid.graphics.lineStyle(1, 0xEBEBEB, 0.1);
		this.m_testAlignmentGrid.graphics.moveTo(0, 0);
		this.m_testAlignmentGrid.graphics.lineTo(0, MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((this.m_unitWidth * 1), 0);
		this.m_testAlignmentGrid.graphics.lineTo((this.m_unitWidth * 1), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((this.m_unitWidth * 2), 0);
		this.m_testAlignmentGrid.graphics.lineTo((this.m_unitWidth * 2), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((this.m_unitWidth * 3), 0);
		this.m_testAlignmentGrid.graphics.lineTo((this.m_unitWidth * 3), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((this.m_unitWidth * 4), 0);
		this.m_testAlignmentGrid.graphics.lineTo((this.m_unitWidth * 4), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((this.m_unitWidth * 5), 0);
		this.m_testAlignmentGrid.graphics.lineTo((this.m_unitWidth * 5), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((this.m_unitWidth * 6), 0);
		this.m_testAlignmentGrid.graphics.lineTo((this.m_unitWidth * 6), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((this.m_unitWidth * 7), 0);
		this.m_testAlignmentGrid.graphics.lineTo((this.m_unitWidth * 7), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((this.m_unitWidth * 8), 0);
		this.m_testAlignmentGrid.graphics.lineTo((this.m_unitWidth * 8), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((this.m_unitWidth * 9), 0);
		this.m_testAlignmentGrid.graphics.lineTo((this.m_unitWidth * 9), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo((this.m_unitWidth * 10), 0);
		this.m_testAlignmentGrid.graphics.lineTo((this.m_unitWidth * 10), MenuConstants.BaseHeight);
		this.m_testAlignmentGrid.graphics.moveTo(0, 0);
		this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth, (this.m_unitHeight * 0));
		this.m_testAlignmentGrid.graphics.moveTo(0, (this.m_unitHeight * 1));
		this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth, (this.m_unitHeight * 1));
		this.m_testAlignmentGrid.graphics.moveTo(0, (this.m_unitHeight * 2));
		this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth, (this.m_unitHeight * 2));
		this.m_testAlignmentGrid.graphics.moveTo(0, (this.m_unitHeight * 3));
		this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth, (this.m_unitHeight * 3));
		this.m_testAlignmentGrid.graphics.moveTo(0, (this.m_unitHeight * 4));
		this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth, (this.m_unitHeight * 4));
		this.m_testAlignmentGrid.graphics.moveTo(0, (this.m_unitHeight * 5));
		this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth, (this.m_unitHeight * 5));
		this.m_testAlignmentGrid.graphics.moveTo(0, (this.m_unitHeight * 6));
		this.m_testAlignmentGrid.graphics.lineTo(MenuConstants.BaseWidth, (this.m_unitHeight * 6));
		addChild(this.m_testAlignmentGrid);
	}

	override public function getContainer():Sprite {
		return (this.m_pageContent);
	}

	override public function onAttached():void {
		if (this.m_showGrid) {
			this.showAlignmentGrid();
		}

		if (this.m_showBackground) {
			this.showBackground();
		}

	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		MenuUtils.centerFill(this.m_background, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		MenuUtils.centerContained(this.m_pageContent, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
		MenuUtils.centerContained(this.m_testAlignmentGrid, MenuConstants.BaseWidth, MenuConstants.BaseHeight, _arg_1, _arg_2);
	}

	public function set ShowTestAlignmentGrid(_arg_1:Boolean):void {
		this.m_showGrid = _arg_1;
	}

	public function set ShowBlackBackground(_arg_1:Boolean):void {
		this.m_showBackground = _arg_1;
	}


}
}//package menu3.briefing


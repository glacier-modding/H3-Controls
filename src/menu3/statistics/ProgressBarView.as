// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.statistics.ProgressBarView

package menu3.statistics {
import menu3.MenuElementBase;

import flash.text.TextField;
import flash.display.Sprite;
import flash.display.Shape;
import flash.text.TextFieldAutoSize;

import common.menu.MenuUtils;
import common.menu.MenuConstants;

import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;

import common.Animate;

public dynamic class ProgressBarView extends MenuElementBase {

	private const ALMOST_ZERO_WIDTH:Number = 1;
	private const FRAME_THICKNESS:Number = 2;

	private var m_once:Boolean = true;
	private var m_textFieldTitle:TextField;
	private var m_textFieldProgress:TextField;
	private var m_spriteBar:Sprite;
	private var m_shapeFill:Shape;
	private var m_shapeFrame:Shape;
	private var m_xoffset:Number;
	private var m_yoffset:Number;
	private var m_width:Number;
	private var m_height:Number;
	private var m_fillcolor:int = 0xFFFFFF;
	private var m_min:Number;
	private var m_max:Number;
	private var m_current:Number;
	private var m_title:String;
	private var m_titlefonttype:String;
	private var m_titlefontsize:int;
	private var m_titlefontcolor:String;
	private var m_progresstext:String;
	private var m_progresstextfonttype:String;
	private var m_progresstextfontsize:int;
	private var m_progresstextfontcolor:String;

	public function ProgressBarView(_arg_1:Object) {
		super(_arg_1);
		this.m_textFieldTitle = new TextField();
		this.m_textFieldTitle.name = "title";
		this.m_textFieldTitle.autoSize = TextFieldAutoSize.LEFT;
		this.m_textFieldTitle.wordWrap = false;
		this.m_textFieldTitle.multiline = false;
		MenuUtils.addDropShadowFilter(this.m_textFieldTitle);
		addChild(this.m_textFieldTitle);
		this.m_textFieldProgress = new TextField();
		this.m_textFieldProgress.name = "progress";
		this.m_textFieldProgress.autoSize = TextFieldAutoSize.LEFT;
		this.m_textFieldProgress.wordWrap = false;
		this.m_textFieldProgress.multiline = false;
		MenuUtils.addDropShadowFilter(this.m_textFieldProgress);
		addChild(this.m_textFieldProgress);
		this.m_spriteBar = new Sprite();
		this.m_spriteBar.name = "bar";
		MenuUtils.addDropShadowFilter(this.m_spriteBar);
		addChild(this.m_spriteBar);
		this.m_shapeFill = new Shape();
		this.m_shapeFill.name = "fill";
		createRectFill1x1(this.m_shapeFill, this.m_fillcolor);
		this.m_spriteBar.addChild(this.m_shapeFill);
		this.m_shapeFrame = new Shape();
		this.m_shapeFrame.name = "frame";
		this.m_spriteBar.addChild(this.m_shapeFrame);
	}

	private static function createRectFill1x1(_arg_1:Shape, _arg_2:int):void {
		_arg_1.graphics.clear();
		_arg_1.graphics.beginFill(_arg_2, 1);
		_arg_1.graphics.drawRect(0, 0, 1, 1);
		_arg_1.graphics.endFill();
	}


	override public function onSetData(_arg_1:Object):void {
		super.onSetData(_arg_1);
		this.m_xoffset = ((_arg_1.xoffset != null) ? _arg_1.xoffset : 0);
		this.m_yoffset = ((_arg_1.yoffset != null) ? _arg_1.yoffset : 0);
		this.m_width = ((_arg_1.width != null) ? _arg_1.width : 250);
		this.m_height = ((_arg_1.height != null) ? _arg_1.height : 20);
		this.m_min = ((_arg_1.min != null) ? _arg_1.min : 0);
		this.m_max = ((_arg_1.max != null) ? _arg_1.max : 100);
		this.m_current = ((_arg_1.current != null) ? _arg_1.current : 0);
		this.m_title = ((_arg_1.title != null) ? _arg_1.title : "");
		this.m_titlefonttype = ((_arg_1.titlefonttype != null) ? _arg_1.titlefonttype : MenuConstants.FONT_TYPE_MEDIUM);
		this.m_titlefontsize = ((_arg_1.titlefontsize != null) ? _arg_1.titlefontsize : 26);
		this.m_titlefontcolor = ((_arg_1.titlefontcolorname != null) ? MenuConstants.ColorString(MenuConstants.GetColorByName(_arg_1.titlefontcolorname)) : MenuConstants.FontColorWhite);
		this.m_progresstext = ((_arg_1.progresstext != null) ? _arg_1.progresstext : null);
		this.m_progresstextfonttype = ((_arg_1.progresstextfonttype != null) ? _arg_1.progresstextfonttype : MenuConstants.FONT_TYPE_NORMAL);
		this.m_progresstextfontsize = ((_arg_1.progresstextfontsize != null) ? _arg_1.progresstextfontsize : 20);
		this.m_progresstextfontcolor = ((_arg_1.progresstextfontcolorname != null) ? MenuConstants.ColorString(MenuConstants.GetColorByName(_arg_1.progresstextfontcolorname)) : MenuConstants.FontColorWhite);
		var _local_2:Number = ((this.m_current - this.m_min) / (this.m_max - this.m_min));
		var _local_3:String = ((this.m_progresstext != null) ? this.m_progresstext : (Math.round((_local_2 * 100)) + "%"));
		MenuUtils.setupText(this.m_textFieldTitle, this.m_title, this.m_titlefontsize, this.m_titlefonttype, this.m_titlefontcolor);
		this.m_textFieldTitle.x = this.m_xoffset;
		this.m_textFieldTitle.y = this.m_yoffset;
		MenuUtils.setupText(this.m_textFieldProgress, _local_3, this.m_progresstextfontsize, this.m_progresstextfonttype, this.m_progresstextfontcolor);
		this.m_textFieldProgress.x = ((this.m_xoffset + this.m_width) - this.m_textFieldProgress.width);
		this.m_textFieldProgress.y = this.m_yoffset;
		var _local_4:Number = Math.max(this.m_textFieldTitle.height, this.m_textFieldProgress.height);
		this.m_textFieldTitle.y = (this.m_textFieldTitle.y + (_local_4 - this.m_textFieldTitle.height));
		this.m_textFieldProgress.y = (this.m_textFieldProgress.y + (_local_4 - this.m_textFieldProgress.height));
		this.m_shapeFrame.x = this.m_xoffset;
		this.m_shapeFrame.y = (this.m_yoffset + _local_4);
		if (((!(this.m_shapeFrame.width == this.m_width)) || (!(this.m_shapeFrame.height == this.m_height)))) {
			this.m_shapeFrame.graphics.clear();
			this.m_shapeFrame.graphics.lineStyle(this.FRAME_THICKNESS, 0xFFFFFF, 1, false, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.MITER, 1.4142);
			this.m_shapeFrame.graphics.drawRect((this.FRAME_THICKNESS / 2), (this.FRAME_THICKNESS / 2), (this.m_width - this.FRAME_THICKNESS), (this.m_height - this.FRAME_THICKNESS));
		}
		;
		this.m_shapeFill.x = (this.m_xoffset + (this.FRAME_THICKNESS / 2));
		this.m_shapeFill.y = ((this.m_yoffset + (this.FRAME_THICKNESS / 2)) + _local_4);
		this.m_shapeFill.height = (this.m_height - this.FRAME_THICKNESS);
		var _local_5:Number = (this.m_width - this.FRAME_THICKNESS);
		var _local_6:Number = (_local_5 * _local_2);
		if (_local_6 < this.ALMOST_ZERO_WIDTH) {
			_local_6 = this.ALMOST_ZERO_WIDTH;
		}
		;
		if (_local_6 > _local_5) {
			_local_6 = _local_5;
		}
		;
		if (this.m_once) {
			this.m_shapeFill.width = _local_6;
			this.m_once = false;
		} else {
			Animate.to(this.m_shapeFill, 0.2, 0, {"width": _local_6}, Animate.Linear);
		}
		;
		var _local_7:int = ((_arg_1.fillcolorname == null) ? this.m_fillcolor : MenuConstants.GetColorByName(_arg_1.fillcolorname));
		if (_local_7 != this.m_fillcolor) {
			this.m_fillcolor = _local_7;
			createRectFill1x1(this.m_shapeFill, this.m_fillcolor);
		}
		;
	}

	override public function onUnregister():void {
		removeChild(this.m_textFieldTitle);
		removeChild(this.m_textFieldProgress);
		this.m_textFieldTitle = null;
		this.m_textFieldProgress = null;
		super.onUnregister();
	}


}
}//package menu3.statistics


// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.Line

package basic {
import common.BaseControl;

public class Line extends BaseControl {

	private var m_isDotted:Boolean = false;
	private var m_view:* = null;
	private var m_sizeX:Number = 0;
	private var m_sizeY:Number = 0;
	private var m_isHorizontal:Boolean = true;
	private var m_color:uint = 0;


	public function set IsHorizontal(_arg_1:Boolean):void {
		if (this.m_isHorizontal == _arg_1) {
			return;
		}
		;
		this.m_isHorizontal = _arg_1;
		this.drawLine();
	}

	public function set IsDotted(_arg_1:Boolean):void {
		if (this.m_isDotted == _arg_1) {
			return;
		}
		;
		this.m_isDotted = _arg_1;
		this.drawLine();
	}

	public function set Color(_arg_1:String):void {
		var _local_2:Number = parseInt(_arg_1, 16);
		if (!isNaN(_local_2)) {
			if (this.m_color == _local_2) {
				return;
			}
			;
			this.m_color = _local_2;
			this.drawLine();
		}
		;
	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		this.m_sizeX = _arg_1;
		this.m_sizeY = _arg_2;
		this.drawLine();
	}

	private function drawLine():void {
		if (this.m_view != null) {
			removeChild(this.m_view);
		}
		;
		if (this.m_isDotted) {
			this.m_view = new DottedLine(((this.m_isHorizontal) ? this.m_sizeX : this.m_sizeY), this.m_color, ((this.m_isHorizontal) ? "horizontal" : "vertical"), ((this.m_isHorizontal) ? this.m_sizeY : this.m_sizeX), ((this.m_isHorizontal) ? this.m_sizeY : this.m_sizeX));
		} else {
			this.m_view = new SolidLine(((this.m_isHorizontal) ? this.m_sizeX : this.m_sizeY), this.m_color, ((this.m_isHorizontal) ? this.m_sizeY : this.m_sizeX), ((this.m_isHorizontal) ? "horizontal" : "vertical"));
		}
		;
		addChild(this.m_view);
	}


}
}//package basic


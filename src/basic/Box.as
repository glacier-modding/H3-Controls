// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.Box

package basic {
import flash.display.Sprite;

public class Box extends Sprite {

	public static const TYPE_SOLID:String = "solid";
	public static const TYPE_SOLID_ROUNDED:String = "solidRounded";
	public static const TYPE_OUTLINE:String = "outline";
	public static const ALIGN_CENTERED:String = "centered";
	public static const ALIGN_MIDDLE_LEFT:String = "middleLeft";
	public static const ALIGN_MIDDLE_RIGHT:String = "middleRight";
	public static const ALIGN_MIDDLE_TOP:String = "middleTop";
	public static const ALIGN_MIDDLE_BOTTOM:String = "middleBottom";
	public static const ALIGN_TOP_LEFT:String = "topLeft";
	public static const ALIGN_TOP_RIGHT:String = "topRight";
	public static const ALIGN_BOTTOM_LEFT:String = "bottomLeft";
	public static const ALIGN_BOTTOM_RIGHT:String = "bottomRight";

	private var m_width:Number;
	private var m_height:Number;
	private var m_color:uint;
	private var m_type:String;
	private var m_align:String;
	private var m_outlineThickness:Number;
	private var m_cornerRadius:Number;
	private var m_xOffset:Number = 0;
	private var m_yOffset:Number = 0;

	public function Box(_arg_1:Number = 100, _arg_2:Number = 100, _arg_3:uint = 0xFFFFFF, _arg_4:String = "centered", _arg_5:String = "solid", _arg_6:Number = 0, _arg_7:Number = 0) {
		this.m_width = _arg_1;
		this.m_height = _arg_2;
		this.m_color = _arg_3;
		this.m_align = _arg_4;
		this.m_type = _arg_5;
		this.m_outlineThickness = _arg_6;
		this.m_cornerRadius = _arg_7;
		this.calculateOffset();
		if (_arg_5 == TYPE_SOLID) {
			this.drawSolid();
		} else {
			if (_arg_5 == TYPE_SOLID_ROUNDED) {
				this.drawSolid(true);
			} else {
				if (_arg_5 == TYPE_OUTLINE) {
					this.drawOutline();
				}

			}

		}

	}

	private function drawSolid(_arg_1:Boolean = false):void {
		graphics.clear();
		graphics.beginFill(this.m_color, 1);
		if (_arg_1) {
			graphics.drawRoundRect(this.m_xOffset, this.m_yOffset, this.m_width, this.m_height, this.m_cornerRadius);
		} else {
			graphics.drawRect(this.m_xOffset, this.m_yOffset, this.m_width, this.m_height);
		}

		graphics.endFill();
	}

	private function drawOutline():void {
		graphics.clear();
		graphics.beginFill(this.m_color, 1);
		graphics.drawRect(this.m_xOffset, this.m_yOffset, this.m_width, this.m_height);
		graphics.drawRect((this.m_xOffset + (this.m_outlineThickness * 2)), (this.m_yOffset + (this.m_outlineThickness * 2)), (this.m_width - (this.m_outlineThickness * 4)), (this.m_height - (this.m_outlineThickness * 4)));
		graphics.endFill();
	}

	private function calculateOffset():void {
		if (this.m_align == ALIGN_CENTERED) {
			this.m_xOffset = -(this.m_width >> 1);
			this.m_yOffset = -(this.m_height >> 1);
		} else {
			if (this.m_align == ALIGN_TOP_LEFT) {
				this.m_xOffset = 0;
				this.m_yOffset = 0;
			} else {
				if (this.m_align == ALIGN_TOP_RIGHT) {
					this.m_xOffset = -(this.m_width);
					this.m_yOffset = 0;
				} else {
					if (this.m_align == ALIGN_BOTTOM_LEFT) {
						this.m_xOffset = 0;
						this.m_yOffset = -(this.m_height);
					} else {
						if (this.m_align == ALIGN_BOTTOM_RIGHT) {
							this.m_xOffset = -(this.m_width);
							this.m_yOffset = -(this.m_height);
						} else {
							if (this.m_align == ALIGN_MIDDLE_LEFT) {
								this.m_xOffset = 0;
								this.m_yOffset = -(this.m_height >> 1);
							} else {
								if (this.m_align == ALIGN_MIDDLE_RIGHT) {
									this.m_xOffset = -(this.m_width);
									this.m_yOffset = -(this.m_height >> 1);
								} else {
									if (this.m_align == ALIGN_MIDDLE_TOP) {
										this.m_xOffset = -(this.m_width >> 1);
										this.m_yOffset = 0;
									} else {
										if (this.m_align == ALIGN_MIDDLE_BOTTOM) {
											this.m_xOffset = -(this.m_width >> 1);
											this.m_yOffset = -(this.m_height);
										}

									}

								}

							}

						}

					}

				}

			}

		}

	}


}
}//package basic


﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.OptionsInfoMissionTimerPreview

package menu3.basic {
import basic.TextBox;

import flash.utils.clearInterval;
import flash.utils.setInterval;
import flash.utils.*;

public dynamic class OptionsInfoMissionTimerPreview extends OptionsInfoPreview {

	private static const UIOPTION_OPPORTUNITIES_OFF:Number = 0;
	private static const UIOPTION_OPPORTUNITIES_MINIMAL:Number = 1;
	private static const UIOPTION_OPPORTUNITIES_FULL:Number = 2;

	private var m_textBox:TextBox = new TextBox();
	private var m_seconds:uint = 0;
	private var m_minutes:uint = 0;
	private var m_hours:uint = 0;
	private var m_idIntervalTick:uint = 0;

	public function OptionsInfoMissionTimerPreview(_arg_1:Object) {
		super(_arg_1);
		this.m_textBox.name = "m_textBox";
		this.m_textBox.Text = "00:00:00";
		this.m_textBox.TextAlignment = "center";
		this.m_textBox.Font = "$global";
		this.m_textBox.FontSize = 25;
		this.m_textBox.Color = "ffffff";
		getPreviewContentContainer().addChild(this.m_textBox);
		this.m_textBox.onAttached();
		this.m_textBox.onSetSize(400, 100);
		var _local_2:Number = PX_PREVIEW_BACKGROUND_WIDTH;
		this.m_textBox.x = ((_local_2 / 2) - (this.m_textBox.width / 2));
		this.m_textBox.y = 5;
		this.onSetData(_arg_1);
	}

	override public function onSetData(data:Object):void {
		super.onSetData(data);
		if (!data.previewData.showTimer) {
			this.m_textBox.Text = "";
			clearInterval(this.m_idIntervalTick);
			this.m_idIntervalTick = 0;
		} else {
			this.m_textBox.Text = "00:00:00";
			this.m_seconds = 0;
			this.m_minutes = 0;
			this.m_hours = 0;
			clearInterval(this.m_idIntervalTick);
			this.m_idIntervalTick = setInterval(function ():void {
				m_seconds++;
				if (m_seconds >= 60) {
					m_seconds = (m_seconds % 0);
					m_minutes++;
				}

				if (m_minutes >= 60) {
					m_minutes = (m_minutes % 0);
					m_hours++;
				}

				m_textBox.Text = (((((((((m_hours < 10) ? "0" : "") + m_hours.toString()) + ":") + ((m_minutes < 10) ? "0" : "")) + m_minutes.toString()) + ":") + ((m_seconds < 10) ? "0" : "")) + m_seconds.toString());
			}, 1000);
		}

	}

	override protected function onPreviewRemovedFromStage():void {
		clearInterval(this.m_idIntervalTick);
		this.m_idIntervalTick = 0;
		super.onPreviewRemovedFromStage();
	}


}
}//package menu3.basic


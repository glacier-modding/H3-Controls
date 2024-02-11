// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.basic.TextTickerUtil

package menu3.basic {
import common.menu.textTicker;

import flash.text.TextField;

import common.menu.MenuUtils;

public class TextTickerUtil {

	private var m_textTickerConfigurations:Array = [];


	public function addTextTicker(_arg_1:TextField, _arg_2:String, _arg_3:String = null, _arg_4:int = -1):void {
		var _local_5:textTicker = new textTicker();
		this.m_textTickerConfigurations.push({
			"indicatortextfield": _arg_1,
			"title": _arg_2,
			"textticker": _local_5,
			"fontcolor": _arg_3,
			"textfieldcolor": _arg_4
		});
	}

	public function addTextTickerHtmlWithTitle(_arg_1:TextField, _arg_2:String, _arg_3:Number = 0):void {
		var _local_4:textTicker = new textTicker();
		this.m_textTickerConfigurations.push({
			"indicatortextfield": _arg_1,
			"title": _arg_2,
			"textticker": _local_4,
			"resetdelay": _arg_3,
			"isHtmlTicker": true
		});
	}

	public function addTextTickerHtml(_arg_1:TextField, _arg_2:Number = 0):void {
		var _local_3:textTicker = new textTicker();
		this.m_textTickerConfigurations.push({
			"indicatortextfield": _arg_1,
			"title": _arg_1.htmlText,
			"textticker": _local_3,
			"resetdelay": _arg_2,
			"isHtmlTicker": true
		});
	}

	public function callTextTicker(_arg_1:Boolean, _arg_2:int = -1):void {
		var _local_4:Object;
		var _local_3:int;
		while (_local_3 < this.m_textTickerConfigurations.length) {
			_local_4 = this.m_textTickerConfigurations[_local_3];
			if (_local_4.isHtmlTicker === true) {
				if (_arg_1) {
					_local_4.textticker.startTextTickerHtml(_local_4.indicatortextfield, _local_4.title, null, _local_4.resetdelay);
				} else {
					_local_4.textticker.stopTextTicker(_local_4.indicatortextfield, _local_4.title);
					MenuUtils.truncateTextfield(_local_4.indicatortextfield, 1);
				}

			} else {
				if (_arg_1) {
					_local_4.textticker.startTextTicker(_local_4.indicatortextfield, _local_4.title);
					if (((_local_4.textfieldcolor) && (!(_local_4.textfieldcolor == -1)))) {
						_local_4.indicatortextfield.textColor = _local_4.textfieldcolor;
					}

					if (((_arg_2) && (!(_arg_2 == -1)))) {
						_local_4.indicatortextfield.textColor = _arg_2;
					}

				} else {
					_local_4.textticker.stopTextTicker(_local_4.indicatortextfield, _local_4.title);
					if (((!(_local_4.fontcolor == null)) && (_local_4.fontcolor.length > 0))) {
						if (((_local_4.textfieldcolor) && (!(_local_4.textfieldcolor == -1)))) {
							_local_4.indicatortextfield.textColor = _local_4.textfieldcolor;
						}

						MenuUtils.truncateTextfield(_local_4.indicatortextfield, 1, _local_4.fontcolor);
					} else {
						if (((_arg_2) && (!(_arg_2 == -1)))) {
							_local_4.indicatortextfield.textColor = _arg_2;
							MenuUtils.truncateTextfield(_local_4.indicatortextfield, 1, null);
						} else {
							MenuUtils.truncateTextfield(_local_4.indicatortextfield, 1);
						}

					}

				}

			}

			_local_3++;
		}

	}

	public function clearOnly():void {
		this.m_textTickerConfigurations = [];
	}

	public function resetTextTickers():void {
		if (this.m_textTickerConfigurations.length == 0) {
			return;
		}

		this.stopTextTickers();
		this.m_textTickerConfigurations = [];
	}

	public function onUnregister():void {
		this.resetTextTickers();
	}

	public function stopTextTickers():void {
		var _local_2:Object;
		var _local_1:int;
		while (_local_1 < this.m_textTickerConfigurations.length) {
			_local_2 = this.m_textTickerConfigurations[_local_1];
			_local_2.textticker.stopTextTicker(_local_2.indicatortextfield, _local_2.title);
			_local_1++;
		}

	}


}
}//package menu3.basic


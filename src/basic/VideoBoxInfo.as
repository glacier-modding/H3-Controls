// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//basic.VideoBoxInfo

package basic {
import flash.display.Sprite;
import flash.utils.Dictionary;

import common.Log;
import common.menu.MenuUtils;

public class VideoBoxInfo extends Sprite {

	public static var STATE_NONE:String = "stateNone";
	public static var STATE_LOADING:String = "loading";
	public static var STATE_SKIPPABLE:String = "skippable";

	private var m_progress:Number;
	public var m_platformString:String;
	private var m_skipString:String;
	private var m_loadingString:String;
	private var m_currentState:String;
	private var m_stateDisplayObjects:Dictionary = new Dictionary();
	private var m_loadIndicator:GlobalLoadindicator;
	private var m_promptsContainer:Sprite;
	private var m_skipPromptObjPrevious:Object = null;

	public function VideoBoxInfo(_arg_1:Object) {
		this.m_loadIndicator = new GlobalLoadindicator();
		addChild(this.m_loadIndicator);
		this.m_promptsContainer = new Sprite();
		addChild(this.m_promptsContainer);
		this.m_stateDisplayObjects[VideoBoxInfo.STATE_LOADING] = this.m_loadIndicator;
		this.m_stateDisplayObjects[VideoBoxInfo.STATE_SKIPPABLE] = this.m_promptsContainer;
		this.setData(_arg_1);
		this.setInfoState(STATE_NONE);
	}

	public function startIndicatorAnim():void {
		this.m_loadIndicator.ShowLoadindicator({
			"discrete": false,
			"icon": "load",
			"header": this.m_loadingString,
			"showbarcodes": true
		});
		this.m_loadIndicator.x = -158;
		this.m_loadIndicator.y = -73;
	}

	public function stopIndicatorAnim():void {
		this.m_loadIndicator.HideLoadindicator();
	}

	public function setData(_arg_1:Object):void {
		this.m_skipString = _arg_1.skipString;
		this.m_loadingString = _arg_1.loadingString;
		this.m_platformString = _arg_1.platformString;
		this.configureSkipPrompt();
	}

	private function configureSkipPrompt():void {
		Log.info(Log.ChannelVideo, this, ((("Add Prompt " + this.m_skipString) + " platform:") + this.m_platformString));
		var _local_1:Object = new Object();
		_local_1.buttonprompts = new Array({
			"actiontype": "cancel",
			"actionlabel": this.m_skipString,
			"hideIndicator": true,
			"platform": this.m_platformString
		});
		this.m_skipPromptObjPrevious = MenuUtils.parsePrompts(_local_1, this.m_skipPromptObjPrevious, this.m_promptsContainer);
		this.m_promptsContainer.x = (-(this.m_promptsContainer.width) - 70);
		this.m_promptsContainer.y = -65;
	}

	public function setLoadProgress(_arg_1:Number):void {
		this.m_progress = _arg_1;
		var _local_2:int = (this.m_progress * 100);
		this.m_loadIndicator.setProgress(this.m_progress);
	}

	public function setInfoState(_arg_1:String, _arg_2:Boolean = false):void {
		var _local_3:String;
		Log.info(Log.ChannelVideo, this, ("setInfoState " + _arg_1));
		if (((this.m_currentState == _arg_1) && (!(_arg_2)))) {
			return;
		}
		;
		this.m_currentState = _arg_1;
		this.visible = (!(this.m_currentState == STATE_NONE));
		for (_local_3 in this.m_stateDisplayObjects) {
			this.m_stateDisplayObjects[_local_3].visible = (_local_3 == this.m_currentState);
		}
		;
		this.setLoadProgress(this.m_progress);
	}


}
}//package basic


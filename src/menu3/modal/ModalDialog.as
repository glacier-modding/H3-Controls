// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.modal.ModalDialog

package menu3.modal {
import common.BaseControl;

import flash.display.Sprite;

import common.TaskletSequencer;
import common.Log;

import flash.events.Event;

import common.Animate;

import flash.utils.getDefinitionByName;

import common.menu.MenuUtils;

public class ModalDialog extends BaseControl {

	private var m_child:ModalDialogContainerBase;
	private var m_modalContainer:Sprite;
	private var m_dialogContainer:Sprite;
	private var m_bgTile:blackBgTileView;
	private var m_scaleRatio:Number = 1;
	private var m_taskletSequencer:TaskletSequencer = new TaskletSequencer();
	private var m_isEnterFrameActive:Boolean = false;

	public function ModalDialog() {
		this.m_bgTile = new blackBgTileView();
		this.m_bgTile.visible = false;
		this.m_bgTile.alpha = 0;
		this.m_bgTile.visible = false;
		addChild(this.m_bgTile);
		this.m_modalContainer = new Sprite();
		this.m_modalContainer.visible = false;
		this.m_modalContainer.alpha = 0;
		this.m_modalContainer.visible = false;
		addChild(this.m_modalContainer);
		this.m_dialogContainer = new Sprite();
		this.m_modalContainer.addChild(this.m_dialogContainer);
	}

	public function onSetData(_arg_1:Object):void {
		this.showDialog(_arg_1);
	}

	public function showDialog(_arg_1:Object):Object {
		Log.xinfo(Log.ChannelModal, ("ModalDialog showDialog type:" + _arg_1.type));
		if (((_arg_1.view == undefined) || (_arg_1.view.length <= 0))) {
			if (_arg_1.type == "lineedit") {
				_arg_1.view = "menu3.modal.ModalDialogGenericEditLine";
			} else {
				if (_arg_1.type == "textedit") {
					_arg_1.view = "menu3.modal.ModalDialogGenericEditText";
				} else {
					if (_arg_1.type == "publicid") {
						_arg_1.view = "menu3.modal.ModalDialogEditLinePublicId";
					} else {
						_arg_1.view = "menu3.modal.ModalDialogGeneric";
					}

				}

			}

		}

		return (this.openDialog(_arg_1));
	}

	private function onEnterFrame(_arg_1:Event):void {
		this.m_taskletSequencer.processingTime_ms = ((ControlsMain.isVrModeActive()) ? 2 : 20);
		this.m_taskletSequencer.update();
	}

	private function openDialog(data:Object):Object {
		this.m_taskletSequencer.clear();
		if (!this.m_isEnterFrameActive) {
			this.m_isEnterFrameActive = true;
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}

		Animate.kill(this.m_modalContainer);
		Animate.kill(this.m_bgTile);
		if (this.m_child != null) {
			this.m_dialogContainer.removeChild(this.m_child);
			this.m_child = null;
		}

		this.m_bgTile.alpha = 0;
		this.m_bgTile.visible = true;
		this.m_bgTile.width = parent.width;
		this.m_bgTile.height = parent.height;
		this.m_bgTile.x = (parent.width / -2);
		this.m_bgTile.y = (parent.height / -2);
		var dynamicChildType:Class = (getDefinitionByName(data.view) as Class);
		this.m_child = new (dynamicChildType)(data.data);
		this.m_child.setEngineCallbacks(sendEvent, sendEventWithValue);
		this.m_child.setTaskManagerEnqueue(this.m_taskletSequencer.addChunk);
		var dialogInformation:Object = this.m_child.getDialogInformation();
		var funcOnSetData:Function = function ():void {
			m_child.onSetData(data.data);
		};
		this.m_taskletSequencer.addChunk(funcOnSetData);
		var funcSetButtonData:Function = function ():void {
			m_child.setButtonData(data.buttons);
		};
		this.m_taskletSequencer.addChunk(funcSetButtonData);
		var funcAdd:Function = function ():void {
			m_dialogContainer.addChild(m_child);
		};
		this.m_taskletSequencer.addChunk(funcAdd);
		var funcAnimation:Function = function ():void {
			var _local_1:Number = m_child.getModalWidth();
			var _local_2:Number = m_child.getModalHeight();
			m_dialogContainer.x = (_local_1 / -2);
			m_dialogContainer.y = (_local_2 / -2);
			m_modalContainer.alpha = 0;
			m_modalContainer.visible = true;
			m_modalContainer.scaleX = (m_scaleRatio * 3);
			m_modalContainer.scaleY = (m_scaleRatio * 3);
			Animate.legacyTo(m_modalContainer, 0.2, {
				"scaleX": m_scaleRatio,
				"scaleY": m_scaleRatio,
				"alpha": 1
			}, Animate.ExpoOut, onFadeInFinished);
			Animate.legacyTo(m_bgTile, 0.2, {"alpha": 1}, Animate.ExpoOut);
			if (ControlsMain.isVrModeActive()) {
				m_modalContainer.z = MenuUtils.toPixel(-0.4);
			} else {
				m_modalContainer.z = 0;
				m_modalContainer.transform.matrix3D = null;
			}

		};
		this.m_taskletSequencer.addChunk(funcAnimation);
		return (dialogInformation);
	}

	private function onFadeInFinished():void {
		var func:Function;
		if (this.m_child != null) {
			func = function ():void {
				m_child.onFadeInFinished();
			};
			this.m_taskletSequencer.addChunk(func);
		}

	}

	public function buttonPressed(data:Object):void {
		var func:Function;
		if (this.m_child != null) {
			func = function ():void {
				m_child.onButtonPressed(data.button);
			};
			this.m_taskletSequencer.addChunk(func);
		}

	}

	public function onScroll(delta:Number, animate:Boolean):void {
		var func:Function;
		if (this.m_child != null) {
			func = function ():void {
				m_child.onScroll(delta, animate);
			};
			this.m_taskletSequencer.addChunk(func);
		}

	}

	public function updateButtonPrompts():void {
		var func:Function;
		if (this.m_child != null) {
			func = function ():void {
				m_child.updateButtonPrompts();
			};
			this.m_taskletSequencer.addChunk(func);
		}

	}

	public function hideDialog():void {
		Animate.complete(this.m_modalContainer);
		Animate.legacyTo(this.m_modalContainer, 0.2, {
			"scaleX": (this.m_scaleRatio * 0.4),
			"scaleY": (this.m_scaleRatio * 0.4),
			"alpha": 0
		}, Animate.ExpoIn, function ():void {
			m_modalContainer.visible = false;
		});
		Animate.complete(this.m_bgTile);
		Animate.legacyTo(this.m_bgTile, 0.2, {"alpha": 0}, Animate.ExpoOut, function ():void {
			m_bgTile.visible = false;
		});
		if (this.m_child != null) {
			this.m_child.hide();
			this.m_dialogContainer.removeChild(this.m_child);
			this.m_child = null;
		}

		this.m_taskletSequencer.clear();
		if (this.m_isEnterFrameActive) {
			this.m_isEnterFrameActive = false;
			this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}

	}

	public function onSetItemSelected(index:int, selected:Boolean):void {
		var func:Function;
		if (this.m_child != null) {
			func = function ():void {
				m_child.onSetItemSelected(index, selected);
			};
			this.m_taskletSequencer.addChunk(func);
		}

	}

	override public function onSetSize(_arg_1:Number, _arg_2:Number):void {
		Log.xinfo(Log.ChannelModal, ((("ModalDialog size: " + _arg_1) + "x") + _arg_2));
		Log.xinfo(Log.ChannelModal, ((("ModalDialog parent: " + parent.width) + "x") + parent.height));
		if (this.m_bgTile != null) {
			this.m_bgTile.width = parent.width;
			this.m_bgTile.height = parent.height;
			this.m_bgTile.x = (parent.width / -2);
			this.m_bgTile.y = (parent.height / -2);
		}

	}

	override public function onSetViewport(_arg_1:Number, _arg_2:Number, _arg_3:Number):void {
		this.m_scaleRatio = (Math.min(_arg_1, _arg_2) * _arg_3);
		if (this.m_modalContainer != null) {
			this.m_modalContainer.scaleX = this.m_scaleRatio;
			this.m_modalContainer.scaleY = this.m_scaleRatio;
		}

	}

	public function onTextFieldEdited(value:String):void {
		var func:Function;
		if (this.m_child != null) {
			func = function ():void {
				var _local_1:ModalDialogFrameEdit = (m_child as ModalDialogFrameEdit);
				if (_local_1 != null) {
					_local_1.onTextFieldEdited(value);
				}

			};
			this.m_taskletSequencer.addChunk(func);
		}

	}


}
}//package menu3.modal


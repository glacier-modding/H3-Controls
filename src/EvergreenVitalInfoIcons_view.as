// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//EvergreenVitalInfoIcons_view

package {
import flash.display.MovieClip;
import flash.events.Event;
import flash.display.*;
import flash.geom.*;
import flash.events.*;
import flash.text.*;
import flash.utils.*;
import flash.external.*;
import flash.filters.*;
import flash.net.*;
import flash.system.*;

import adobe.utils.*;

import flash.accessibility.*;
import flash.desktop.*;
import flash.errors.*;
import flash.globalization.*;
import flash.media.*;
import flash.net.drm.*;
import flash.printing.*;
import flash.profiler.*;
import flash.sampler.*;
import flash.sensors.*;
import flash.text.ime.*;
import flash.text.engine.*;
import flash.ui.*;
import flash.xml.*;

public dynamic class EvergreenVitalInfoIcons_view extends MovieClip {

	public const CAMERA:Number = 0;
	public const LAYER_PROPERTIES:Number = 1;
	public const LAYER_OBJECT:Number = 2;

	public var bg:MovieClip;
	public var bg_prop_:MovieClip;
	public var icon_mc:MovieClip;
	public var back_mc:*;

	public function EvergreenVitalInfoIcons_view() {
		addFrameScript(0, this.frame1);
		this.__setProp_bg_EvergreenVitalInfoIcons_view_bg_obj__0();
		this.__setProp_bg_prop__EvergreenVitalInfoIcons_view_bg_prop__0();
	}

	public function ___applyLayerZdepthAndEffects___():* {
		var _local_2:*;
		var _local_1:* = 0;
		while (_local_1 < numChildren) {
			_local_2 = getChildAt(_local_1);
			if (((((!(_local_2 == null)) && (_local_2 is MovieClip)) && (MovieClip(_local_2).hasOwnProperty("containerType"))) && (MovieClip(_local_2).containerType == this.LAYER_PROPERTIES))) {
				_local_2.executeFrame();
			}

			_local_1++;
		}

	}

	public function ___onAdded___(_arg_1:Event):* {
		var _local_4:int;
		var _local_5:*;
		var _local_6:*;
		var _local_2:* = _arg_1.target;
		if (!_local_2) {
			return;
		}

		var _local_3:* = _local_2.parent;
		if (((_local_3) && (_local_3 == this))) {
			if ((_local_2 is MovieClip)) {
				_local_4 = 0;
				while (_local_4 < numChildren) {
					_local_5 = getChildAt(_local_4);
					if (_local_5 != _local_2) {
						if (((_local_5 is MovieClip) && (_local_5.name == _local_2.name))) {
							removeChild(_local_2);
							break;
						}

					}

					_local_4++;
				}

			}

		} else {
			if ((_local_2 is MovieClip)) {
				_local_6 = _arg_1.target.parent;
				if ((((_local_6 is MovieClip) && (_local_6.containertype == this.LAYER_OBJECT)) && (!(_local_6.parent == null)))) {
					_local_6.parent[_arg_1.target.name] = _arg_1.target;
				}

			}

		}

	}

	internal function __setProp_bg_EvergreenVitalInfoIcons_view_bg_obj__0():* {
		try {
			this.bg["componentInspectorSetting"] = true;
		} catch (e:Error) {
		}

		this.bg.containerType = 2;
		try {
			this.bg["componentInspectorSetting"] = false;
		} catch (e:Error) {
		}

	}

	internal function __setProp_bg_prop__EvergreenVitalInfoIcons_view_bg_prop__0():* {
		try {
			this.bg_prop_["componentInspectorSetting"] = true;
		} catch (e:Error) {
		}

		this.bg_prop_.containerType = 1;
		this.bg_prop_.isAttachedToCamera = false;
		this.bg_prop_.isAttachedToMask = false;
		this.bg_prop_.layerDepth = 0;
		this.bg_prop_.layerIndex = 0;
		this.bg_prop_.maskLayerName = "";
		try {
			this.bg_prop_["componentInspectorSetting"] = false;
		} catch (e:Error) {
		}

	}


}
}//package 


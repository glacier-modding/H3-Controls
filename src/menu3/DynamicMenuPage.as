// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//menu3.DynamicMenuPage

package menu3 {
import common.BaseControl;

import flash.display.Sprite;

import common.TaskletSequencer;

import flash.events.Event;

import common.menu.MenuConstants;
import common.Log;

import flash.utils.getDefinitionByName;
import flash.events.MouseEvent;

import common.Localization;

public class DynamicMenuPage extends BaseControl {

	private var m_width:Number;
	private var m_height:Number;
	private var m_safeAreaRatio:Number = 1;
	private var m_container:Sprite;
	private var m_allChildren:Object = {};
	private var m_pageIndicator:PageIndicator;
	private var m_taskletSequencer:TaskletSequencer;

	public function DynamicMenuPage() {
		addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true, 0, true);
		this.m_pageIndicator = new PageIndicator(1018);
		this.m_pageIndicator.x = 43;
		this.m_pageIndicator.y = 154;
		this.m_pageIndicator.visible = false;
		addChild(this.m_pageIndicator);
		this.m_container = new Sprite();
		addChild(this.m_container);
		this.m_taskletSequencer = TaskletSequencer.getGlobalInstance();
	}

	override public function getContainer():Sprite {
		return (this.m_container);
	}

	private function onAddedToStage(_arg_1:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true);
		stage.addEventListener(ScreenResizeEvent.SCREEN_RESIZED, this.screenResizeEventHandler, true, 0, true);
	}

	public function screenResizeEventHandler(_arg_1:ScreenResizeEvent):void {
		var _local_2:Object = _arg_1.screenSize;
		this.m_width = _local_2.sizeX;
		this.m_height = _local_2.sizeY;
		this.m_safeAreaRatio = _local_2.safeAreaRatio;
	}

	public function getBaseWidth():Number {
		return (MenuConstants.BaseWidth);
	}

	public function getBaseHeight():Number {
		return (MenuConstants.BaseHeight);
	}

	public function getGridUnitWidth():Number {
		return (MenuConstants.GridUnitWidth);
	}

	public function getGridUnitHeight():Number {
		return (MenuConstants.GridUnitHeight);
	}

	private function createElement(_arg_1:String, _arg_2:Object):Sprite {
		var _local_3:Object = ((_arg_2.data) || ({}));
		if (_arg_2.ncols) {
			_local_3.width = (_arg_2.ncols * MenuConstants.GridUnitWidth);
		}
		;
		if (_arg_2.nrows) {
			_local_3.height = (_arg_2.nrows * MenuConstants.GridUnitHeight);
		}
		;
		if (_arg_2.width) {
			_local_3.width = _arg_2.width;
		}
		;
		if (_arg_2.height) {
			_local_3.height = _arg_2.height;
		}
		;
		_local_3.sizeX = this.m_width;
		_local_3.sizeY = this.m_height;
		_local_3.safeAreaRatio = this.m_safeAreaRatio;
		if (_arg_1.indexOf("menu2") >= 0) {
			Log.error("DynamicMenuPage", this, (("menu2 is not supported anymore: " + _arg_1) + " !!!!1!1!11!!!!"));
			_arg_1 = _arg_1.replace("menu2", "menu3");
		}
		;
		var _local_4:Class = (getDefinitionByName(_arg_1) as Class);
		var _local_5:Sprite = new _local_4(_local_3);
		this.m_allChildren[_arg_2.id] = _local_5;
		_local_3.id = _arg_2.id;
		_local_5["_nodedata"] = _arg_2;
		return (_local_5);
	}

	private function parseElementStructure(elementSprite:Sprite, node:Object):void {
		var elementBase:MenuElementBase;
		var i:int;
		var changed:Function;
		var childData:Object;
		var childHandling:Function;
		if (node.x) {
			elementSprite.x = node.x;
		} else {
			elementSprite.x = ((node.col * MenuConstants.GridUnitWidth) || (0));
		}
		;
		if (node.y) {
			elementSprite.y = node.y;
		} else {
			elementSprite.y = ((node.row * MenuConstants.GridUnitHeight) || (0));
		}
		;
		elementSprite.rotationX = ((node.rotationX) || (0));
		elementSprite.rotationY = ((node.rotationY) || (0));
		elementSprite.rotationZ = ((node.rotationZ) || (0));
		elementBase = (elementSprite as MenuElementBase);
		if (node.mouse) {
			elementBase.addEventListener(MouseEvent.MOUSE_UP, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseUp(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.addEventListener(MouseEvent.MOUSE_DOWN, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseDown(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.addEventListener(MouseEvent.MOUSE_OVER, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseOver(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.addEventListener(MouseEvent.MOUSE_OUT, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseOut(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.addEventListener(MouseEvent.MOUSE_WHEEL, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseWheel(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.addEventListener(MouseEvent.ROLL_OVER, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseRollOver(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.addEventListener(MouseEvent.ROLL_OUT, function (_arg_1:MouseEvent):void {
				elementBase.handleMouseRollOut(sendEventWithValue, _arg_1);
			}, false, 0, false);
			elementBase.setEngineCallbacks(sendEvent, sendEventWithValue);
		}
		;
		var children:Array = node.children;
		if (((children) && (elementBase))) {
			i = 0;
			while (i < children.length) {
				childData = children[i];
				if (childData != null) {
					childHandling = this.parseElementChildStructure(elementBase, childData);
					this.m_taskletSequencer.addChunk(childHandling);
				}
				;
				i = (i + 1);
			}
			;
			changed = function ():void {
				elementBase.onChildrenChanged();
			};
			this.m_taskletSequencer.addChunk(changed);
		}
		;
		var applyDataFunc:Function = function ():void {
			var _local_1:Object;
			applyData(elementSprite);
			if (((!(elementBase == null)) && (node.ismenusystemnode === true))) {
				if (node.visible != null) {
					_local_1 = new Object();
					_local_1["visible"] = (!(node.visible === false));
					elementBase.setVisible(_local_1);
				}
				;
			}
			;
		};
		this.m_taskletSequencer.addChunk(applyDataFunc);
	}

	private function parseElementChildStructure(elementBase:MenuElementBase, childData:Object):Function {
		var childHandling:Function = function ():void {
			var child:Sprite;
			var childHandlingAdd:Function;
			child = processElement(childData);
			if (child != null) {
				childHandlingAdd = function ():void {
					elementBase.addChild2(child);
				};
				m_taskletSequencer.addChunk(childHandlingAdd);
			}
			;
		};
		return (childHandling);
	}

	private function applyData(_arg_1:Sprite):void {
		if (_arg_1["onSetData"]) {
			var _local_2:* = _arg_1;
			(_local_2["onSetData"](((_arg_1["_nodedata"]["data"]) || ({}))));
		}
		;
	}

	private function processElement(_arg_1:Object):Sprite {
		if (!_arg_1.view) {
			return (null);
		}
		;
		var _local_2:Sprite = this.createElement(_arg_1.view, _arg_1);
		if (!_local_2) {
			return (null);
		}
		;
		this.parseElementStructure(_local_2, _arg_1);
		return (_local_2);
	}

	public function callOnChild(id:int, method:String, ...args):void {
		var func:Function = function ():void {
			var _local_1:Object = m_allChildren[id];
			if (((_local_1) && (_local_1[method]))) {
				_local_1[method].apply(_local_1, args);
			}
			;
		};
		this.m_taskletSequencer.addChunk(func);
	}

	public function getElementBounds(_arg_1:int):Object {
		var _local_2:Object = this.m_allChildren[_arg_1];
		if (_local_2 == null) {
			return (null);
		}
		;
		return (_local_2.getView().getBounds(stage));
	}

	public function getBestElementForSelection(_arg_1:int, _arg_2:int, _arg_3:Number, _arg_4:Number):int {
		var _local_9:int;
		Log.xinfo(Log.ChannelContainer, ((((((("getBestElementForSelection: parentID:" + _arg_1) + " selectedId:") + _arg_2) + " inputX:") + _arg_3) + " inputY:") + _arg_4));
		var _local_5:int = -1;
		var _local_6:MenuElementBase = this.m_allChildren[_arg_1];
		var _local_7:MenuElementBase = this.m_allChildren[_arg_2];
		if (((_local_6 == null) || (_local_7 == null))) {
			return (_local_5);
		}
		;
		var _local_8:MenuElementBase = LeafNavigationUtil.getBestElementForSelection(_local_6, _local_6, _local_7, _arg_3, _arg_4);
		if (_local_8 != null) {
			_local_9 = MenuElementBase.getId(_local_8);
			if (_local_9 >= 0) {
				Log.xinfo(Log.ChannelContainer, ("getBestElementForSelection: bestElement:" + _local_9));
				return (_local_9);
			}
			;
		}
		;
		Log.xinfo(Log.ChannelContainer, "getBestElementForSelection: no best element found.");
		return (_local_5);
	}

	private function unregisterChildren(_arg_1:Object):void {
		var _local_4:int;
		var _local_5:int;
		var _local_6:Object;
		var _local_2:Function = _arg_1["getContainer"];
		if (_local_2 == null) {
			return;
		}
		;
		var _local_3:Object = _local_2();
		if (((_local_3) && (_local_3.numChildren))) {
			_local_4 = (_local_3.numChildren as int);
			_local_5 = 0;
			while (_local_5 < _local_4) {
				_local_6 = _local_3.getChildAt(_local_5);
				this.unregister(_local_6);
				_local_5++;
			}
			;
		}
		;
	}

	private function unregister(obj:Object):void {
		var id:int;
		var funcUnregisterChildren:Function;
		var menuElement:MenuElementBase;
		var funcMenuElementUnregister:Function;
		if (obj["_nodedata"]) {
			id = (obj["_nodedata"]["id"] as int);
			delete this.m_allChildren[id];
			funcUnregisterChildren = function ():void {
				unregisterChildren(obj);
			};
			this.m_taskletSequencer.addChunk(funcUnregisterChildren);
			menuElement = (obj as MenuElementBase);
			if (menuElement) {
				funcMenuElementUnregister = function ():void {
					menuElement.onUnregister();
					menuElement.clearChildren();
				};
				this.m_taskletSequencer.addChunk(funcMenuElementUnregister);
			}
			;
		}
		;
	}

	public function assignViewToStructure(parentId:int, view:BaseControl):void {
		var func:Function = function ():void {
			var _local_1:MenuElementBase = m_allChildren[parentId];
			if (!_local_1) {
				return;
			}
			;
			var _local_2:Sprite = (view as Sprite);
			var _local_3:uint;
			while (_local_3 < getContainer().numChildren) {
				if (getContainer().getChildAt(_local_3) == _local_2) {
					getContainer().removeChildAt(_local_3);
					break;
				}
				;
				_local_3++;
			}
			;
			_local_1.addChild2(view, 0);
			_local_1.onChildrenChanged();
		};
		this.m_taskletSequencer.addChunk(func);
	}

	public function addChildNode(parentId:int, childData:Object, index:int = -1):void {
		var func:Function = function ():void {
			var node:MenuElementBase;
			var child:Sprite;
			node = m_allChildren[parentId];
			if (!node) {
				return;
			}
			;
			child = processElement(childData);
			var funcChildrenChanged:Function = function ():void {
				node.addChild2(child, index);
				node.onChildrenChanged();
			};
			m_taskletSequencer.addChunk(funcChildrenChanged);
		};
		this.m_taskletSequencer.addChunk(func);
	}

	public function removeChildNode(childNodeId:int):void {
		var func:Function = function ():void {
			trace(("removeChildNode: " + childNodeId));
			var _local_1:MenuElementBase = m_allChildren[childNodeId];
			if (!_local_1) {
				return;
			}
			;
			var _local_2:MenuElementBase = _local_1.m_parent;
			if (_local_2 != null) {
				_local_2.removeChild2(_local_1);
				_local_2.onChildrenChanged();
			}
			;
			unregister(_local_1);
		};
		this.m_taskletSequencer.addChunk(func);
	}

	public function reorderChildNodes(parentId:int, childNodeIds:Array):void {
		var func:Function = function ():void {
			var _local_4:int;
			var _local_5:MenuElementBase;
			trace(((("reorderChildNodes: parentId: " + parentId) + " childNodeIds count: ") + childNodeIds.length));
			var _local_1:MenuElementBase = m_allChildren[parentId];
			if (!_local_1) {
				return;
			}
			;
			var _local_2:Array = new Array();
			var _local_3:int;
			while (_local_3 < childNodeIds.length) {
				_local_4 = childNodeIds[_local_3];
				_local_5 = m_allChildren[_local_4];
				if (_local_5 != null) {
					_local_2.push(_local_5);
				}
				;
				_local_3++;
			}
			;
			if (_local_2.length > 0) {
				_local_1.reorderChildren(_local_2);
			}
			;
		};
		this.m_taskletSequencer.addChunk(func);
	}

	public function reorderNode(nodeId:int):void {
		var func:Function = function ():void {
			var _local_1:MenuElementBase = m_allChildren[nodeId];
			if (!_local_1) {
				return;
			}
			;
			var _local_2:Object = _local_1.parent;
			if (!_local_2) {
				return;
			}
			;
			_local_2.setChildIndex(_local_1, (_local_2.numChildren - 1));
		};
		this.m_taskletSequencer.addChunk(func);
	}

	public function reloadData(nodeId:int, nodeData:Object):void {
		var func:Function = function ():void {
			var _local_1:Sprite = m_allChildren[nodeId];
			if (!_local_1) {
				return;
			}
			;
			_local_1["_nodedata"] = nodeData;
			applyData(_local_1);
		};
		this.m_taskletSequencer.addChunk(func);
	}

	public function reloadNode(nodeId:int, nodeData:Object):void {
		var func:Function = function ():void {
			var elementSprite:Sprite;
			var menuElement:MenuElementBase;
			elementSprite = m_allChildren[nodeId];
			if (!elementSprite) {
				return;
			}
			;
			unregisterChildren(elementSprite);
			menuElement = (m_allChildren[nodeId] as MenuElementBase);
			if (!menuElement) {
				return;
			}
			;
			var funcClearMenuElement:Function = function ():void {
				var persistentReloadData:Object;
				var menuElementParent:MenuElementBase;
				var child:Sprite;
				var data:Object;
				var funcReplace:Function;
				persistentReloadData = menuElement.getPersistentReloadData();
				menuElement.clearChildren();
				menuElement.onUnregister();
				menuElementParent = menuElement.m_parent;
				if (!menuElementParent) {
					data = {};
					data["root"] = nodeData;
					onSetData(data);
					return;
				}
				;
				child = processElement(nodeData);
				if (child) {
					funcReplace = function ():void {
						var _local_1:MenuElementBase = (child as MenuElementBase);
						if (_local_1 != null) {
							_local_1.onPersistentReloadData(persistentReloadData);
						}
						;
						menuElementParent.replaceChild2(elementSprite, child);
					};
					m_taskletSequencer.addChunk(funcReplace);
				}
				;
				var funcChildrenChanged:Function = function ():void {
					menuElementParent.onChildrenChanged();
				};
				m_taskletSequencer.addChunk(funcChildrenChanged);
			};
			m_taskletSequencer.addChunk(funcClearMenuElement);
		};
		this.m_taskletSequencer.addChunk(func);
	}

	public function bubbleEvent(targetId:int, eventName:String):void {
		var func:Function = function ():void {
			var _local_1:Object = m_allChildren[targetId];
			if (!_local_1) {
				return;
			}
			;
			var _local_2:Object = _local_1.parent;
			while ((((_local_2) && (!(_local_2 == this))) && ((!(_local_2["handleEvent"])) || (!(_local_2["handleEvent"](eventName, _local_1)))))) {
				_local_2 = _local_2.parent;
			}
			;
		};
		this.m_taskletSequencer.addChunk(func);
	}

	public function onSetData(data:Object):void {
		var func:Function = function ():void {
			if (m_container.numChildren > 0) {
				while (m_container.numChildren > 0) {
					unregisterChildren(m_container.getChildAt(0));
					m_container.removeChildAt(0);
				}
				;
			}
			;
			m_allChildren = {};
			if (!data.root) {
				return;
			}
			;
			var funcProcessElement:Function = function ():void {
				var _local_1:Sprite = processElement(data.root);
				if (_local_1) {
					m_container.addChild(_local_1);
				}
				;
			};
			m_taskletSequencer.addChunk(funcProcessElement);
		};
		this.m_taskletSequencer.addChunk(func);
	}

	public function setPageIndicator(_arg_1:String, _arg_2:int, _arg_3:int):void {
		this.m_pageIndicator.visible = true;
		this.m_pageIndicator.setPageIndicator(_arg_3);
		this.m_pageIndicator.updatePageIndicator(_arg_2, _arg_1, Localization.get("UI_PAGE_INDICATOR"), ((String((_arg_2 + 1)) + " / ") + String(_arg_3)));
	}

	private function debug_printNodes():void {
		var _local_1:String;
		var _local_2:Object;
		for (_local_1 in this.m_allChildren) {
			_local_2 = this.m_allChildren[_local_1];
		}
		;
	}


}
}//package menu3


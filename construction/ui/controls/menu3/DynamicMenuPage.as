package menu3
{
	import common.BaseControl;
	import common.Localization;
	import common.Log;
	import common.TaskletSequencer;
	import common.menu.MenuConstants;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	public class DynamicMenuPage extends BaseControl
	{
		
		private var m_width:Number;
		
		private var m_height:Number;
		
		private var m_safeAreaRatio:Number = 1;
		
		private var m_container:Sprite;
		
		private var m_allChildren:Object;
		
		private var m_pageIndicator:PageIndicator;
		
		private var m_taskletSequencer:TaskletSequencer;
		
		public function DynamicMenuPage()
		{
			this.m_allChildren = {};
			super();
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
		
		override public function getContainer():Sprite
		{
			return this.m_container;
		}
		
		private function onAddedToStage(param1:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, true);
			stage.addEventListener(ScreenResizeEvent.SCREEN_RESIZED, this.screenResizeEventHandler, true, 0, true);
		}
		
		public function screenResizeEventHandler(param1:ScreenResizeEvent):void
		{
			var _loc2_:Object = param1.screenSize;
			this.m_width = _loc2_.sizeX;
			this.m_height = _loc2_.sizeY;
			this.m_safeAreaRatio = _loc2_.safeAreaRatio;
		}
		
		public function getBaseWidth():Number
		{
			return MenuConstants.BaseWidth;
		}
		
		public function getBaseHeight():Number
		{
			return MenuConstants.BaseHeight;
		}
		
		public function getGridUnitWidth():Number
		{
			return MenuConstants.GridUnitWidth;
		}
		
		public function getGridUnitHeight():Number
		{
			return MenuConstants.GridUnitHeight;
		}
		
		private function createElement(param1:String, param2:Object):Sprite
		{
			var _loc3_:Object = param2.data || {};
			if (param2.ncols)
			{
				_loc3_.width = param2.ncols * MenuConstants.GridUnitWidth;
			}
			if (param2.nrows)
			{
				_loc3_.height = param2.nrows * MenuConstants.GridUnitHeight;
			}
			if (param2.width)
			{
				_loc3_.width = param2.width;
			}
			if (param2.height)
			{
				_loc3_.height = param2.height;
			}
			_loc3_.sizeX = this.m_width;
			_loc3_.sizeY = this.m_height;
			_loc3_.safeAreaRatio = this.m_safeAreaRatio;
			if (param1.indexOf("menu2") >= 0)
			{
				Log.error("DynamicMenuPage", this, "menu2 is not supported anymore: " + param1 + " !!!!1!1!11!!!!");
				param1 = param1.replace("menu2", "menu3");
			}
			var _loc4_:Class;
			var _loc5_:Sprite = new (_loc4_ = getDefinitionByName(param1) as Class)(_loc3_);
			this.m_allChildren[param2.id] = _loc5_;
			_loc3_.id = param2.id;
			_loc5_["_nodedata"] = param2;
			return _loc5_;
		}
		
		private function parseElementStructure(param1:Sprite, param2:Object):void
		{
			var children:Array;
			var applyDataFunc:Function;
			var elementBase:MenuElementBase = null;
			var i:int = 0;
			var changed:Function = null;
			var childData:Object = null;
			var childHandling:Function = null;
			var elementSprite:Sprite = param1;
			var node:Object = param2;
			if (node.x)
			{
				elementSprite.x = node.x;
			}
			else
			{
				elementSprite.x = node.col * MenuConstants.GridUnitWidth || 0;
			}
			if (node.y)
			{
				elementSprite.y = node.y;
			}
			else
			{
				elementSprite.y = node.row * MenuConstants.GridUnitHeight || 0;
			}
			elementSprite.rotationX = Number(node.rotationX) || 0;
			elementSprite.rotationY = Number(node.rotationY) || 0;
			elementSprite.rotationZ = Number(node.rotationZ) || 0;
			elementBase = elementSprite as MenuElementBase;
			if (node.mouse)
			{
				elementBase.addEventListener(MouseEvent.MOUSE_UP, function(param1:MouseEvent):void
				{
					elementBase.handleMouseUp(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.addEventListener(MouseEvent.MOUSE_DOWN, function(param1:MouseEvent):void
				{
					elementBase.handleMouseDown(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.addEventListener(MouseEvent.MOUSE_OVER, function(param1:MouseEvent):void
				{
					elementBase.handleMouseOver(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.addEventListener(MouseEvent.MOUSE_OUT, function(param1:MouseEvent):void
				{
					elementBase.handleMouseOut(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.addEventListener(MouseEvent.MOUSE_WHEEL, function(param1:MouseEvent):void
				{
					elementBase.handleMouseWheel(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.addEventListener(MouseEvent.ROLL_OVER, function(param1:MouseEvent):void
				{
					elementBase.handleMouseRollOver(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.addEventListener(MouseEvent.ROLL_OUT, function(param1:MouseEvent):void
				{
					elementBase.handleMouseRollOut(sendEventWithValue, param1);
				}, false, 0, false);
				elementBase.setEngineCallbacks(sendEvent, sendEventWithValue);
			}
			children = node.children;
			if (Boolean(children) && Boolean(elementBase))
			{
				i = 0;
				while (i < children.length)
				{
					childData = children[i];
					if (childData != null)
					{
						childHandling = this.parseElementChildStructure(elementBase, childData);
						this.m_taskletSequencer.addChunk(childHandling);
					}
					i++;
				}
				changed = function():void
				{
					elementBase.onChildrenChanged();
				};
				this.m_taskletSequencer.addChunk(changed);
			}
			applyDataFunc = function():void
			{
				var _loc1_:Object = null;
				applyData(elementSprite);
				if (elementBase != null && node.ismenusystemnode === true)
				{
					if (node.visible != null)
					{
						_loc1_ = new Object();
						_loc1_["visible"] = node.visible !== false;
						elementBase.setVisible(_loc1_);
					}
				}
			};
			this.m_taskletSequencer.addChunk(applyDataFunc);
		}
		
		private function parseElementChildStructure(param1:MenuElementBase, param2:Object):Function
		{
			var elementBase:MenuElementBase = param1;
			var childData:Object = param2;
			var childHandling:Function = function():void
			{
				var child:Sprite = null;
				var childHandlingAdd:Function = null;
				child = processElement(childData);
				if (child != null)
				{
					childHandlingAdd = function():void
					{
						elementBase.addChild2(child);
					};
					m_taskletSequencer.addChunk(childHandlingAdd);
				}
			};
			return childHandling;
		}
		
		private function applyData(param1:Sprite):void
		{
			if (param1["onSetData"])
			{
				param1["onSetData"](param1["_nodedata"]["data"] || {});
			}
		}
		
		private function processElement(param1:Object):Sprite
		{
			if (!param1.view)
			{
				return null;
			}
			var _loc2_:Sprite = this.createElement(param1.view, param1);
			if (!_loc2_)
			{
				return null;
			}
			this.parseElementStructure(_loc2_, param1);
			return _loc2_;
		}
		
		public function callOnChild(param1:int, param2:String, ... rest):void
		{
			var id:int = param1;
			var method:String = param2;
			var args:Array = rest;
			var func:Function = function():void
			{
				var _loc1_:Object = m_allChildren[id];
				if (Boolean(_loc1_) && Boolean(_loc1_[method]))
				{
					_loc1_[method].apply(_loc1_, args);
				}
			};
			this.m_taskletSequencer.addChunk(func);
		}
		
		public function getElementBounds(param1:int):Object
		{
			var _loc2_:Object = this.m_allChildren[param1];
			if (_loc2_ == null)
			{
				return null;
			}
			return _loc2_.getView().getBounds(stage);
		}
		
		public function getBestElementForSelection(param1:int, param2:int, param3:Number, param4:Number):int
		{
			var _loc9_:int = 0;
			Log.xinfo(Log.ChannelContainer, "getBestElementForSelection: parentID:" + param1 + " selectedId:" + param2 + " inputX:" + param3 + " inputY:" + param4);
			var _loc5_:int = -1;
			var _loc6_:MenuElementBase = this.m_allChildren[param1];
			var _loc7_:MenuElementBase = this.m_allChildren[param2];
			if (_loc6_ == null || _loc7_ == null)
			{
				return _loc5_;
			}
			var _loc8_:MenuElementBase;
			if ((_loc8_ = LeafNavigationUtil.getBestElementForSelection(_loc6_, _loc6_, _loc7_, param3, param4)) != null)
			{
				if ((_loc9_ = MenuElementBase.getId(_loc8_)) >= 0)
				{
					Log.xinfo(Log.ChannelContainer, "getBestElementForSelection: bestElement:" + _loc9_);
					return _loc9_;
				}
			}
			Log.xinfo(Log.ChannelContainer, "getBestElementForSelection: no best element found.");
			return _loc5_;
		}
		
		private function unregisterChildren(param1:Object):void
		{
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			var _loc6_:Object = null;
			var _loc2_:Function = param1["getContainer"];
			if (_loc2_ == null)
			{
				return;
			}
			var _loc3_:Object = _loc2_();
			if (Boolean(_loc3_) && Boolean(_loc3_.numChildren))
			{
				_loc4_ = _loc3_.numChildren as int;
				_loc5_ = 0;
				while (_loc5_ < _loc4_)
				{
					_loc6_ = _loc3_.getChildAt(_loc5_);
					this.unregister(_loc6_);
					_loc5_++;
				}
			}
		}
		
		private function unregister(param1:Object):void
		{
			var id:int = 0;
			var funcUnregisterChildren:Function = null;
			var menuElement:MenuElementBase = null;
			var funcMenuElementUnregister:Function = null;
			var obj:Object = param1;
			if (obj["_nodedata"])
			{
				id = obj["_nodedata"]["id"] as int;
				delete this.m_allChildren[id];
				funcUnregisterChildren = function():void
				{
					unregisterChildren(obj);
				};
				this.m_taskletSequencer.addChunk(funcUnregisterChildren);
				menuElement = obj as MenuElementBase;
				if (menuElement)
				{
					funcMenuElementUnregister = function():void
					{
						menuElement.onUnregister();
						menuElement.clearChildren();
					};
					this.m_taskletSequencer.addChunk(funcMenuElementUnregister);
				}
			}
		}
		
		public function assignViewToStructure(param1:int, param2:BaseControl):void
		{
			var parentId:int = param1;
			var view:BaseControl = param2;
			var func:Function = function():void
			{
				var _loc1_:MenuElementBase = m_allChildren[parentId];
				if (!_loc1_)
				{
					return;
				}
				var _loc2_:Sprite = view as Sprite;
				var _loc3_:uint = 0;
				while (_loc3_ < getContainer().numChildren)
				{
					if (getContainer().getChildAt(_loc3_) == _loc2_)
					{
						getContainer().removeChildAt(_loc3_);
						break;
					}
					_loc3_++;
				}
				_loc1_.addChild2(view, 0);
				_loc1_.onChildrenChanged();
			};
			this.m_taskletSequencer.addChunk(func);
		}
		
		public function addChildNode(param1:int, param2:Object, param3:int = -1):void
		{
			var parentId:int = param1;
			var childData:Object = param2;
			var index:int = param3;
			var func:Function = function():void
			{
				var funcChildrenChanged:Function;
				var node:MenuElementBase = null;
				var child:Sprite = null;
				node = m_allChildren[parentId];
				if (!node)
				{
					return;
				}
				child = processElement(childData);
				funcChildrenChanged = function():void
				{
					node.addChild2(child, index);
					node.onChildrenChanged();
				};
				m_taskletSequencer.addChunk(funcChildrenChanged);
			};
			this.m_taskletSequencer.addChunk(func);
		}
		
		public function removeChildNode(param1:int):void
		{
			var childNodeId:int = param1;
			var func:Function = function():void
			{
				trace("removeChildNode: " + childNodeId);
				var _loc1_:MenuElementBase = m_allChildren[childNodeId];
				if (!_loc1_)
				{
					return;
				}
				var _loc2_:MenuElementBase = _loc1_.m_parent;
				if (_loc2_ != null)
				{
					_loc2_.removeChild2(_loc1_);
					_loc2_.onChildrenChanged();
				}
				unregister(_loc1_);
			};
			this.m_taskletSequencer.addChunk(func);
		}
		
		public function reorderChildNodes(param1:int, param2:Array):void
		{
			var parentId:int = param1;
			var childNodeIds:Array = param2;
			var func:Function = function():void
			{
				var _loc4_:int = 0;
				var _loc5_:MenuElementBase = null;
				trace("reorderChildNodes: parentId: " + parentId + " childNodeIds count: " + childNodeIds.length);
				var _loc1_:MenuElementBase = m_allChildren[parentId];
				if (!_loc1_)
				{
					return;
				}
				var _loc2_:Array = new Array();
				var _loc3_:int = 0;
				while (_loc3_ < childNodeIds.length)
				{
					_loc4_ = int(childNodeIds[_loc3_]);
					if ((_loc5_ = m_allChildren[_loc4_]) != null)
					{
						_loc2_.push(_loc5_);
					}
					_loc3_++;
				}
				if (_loc2_.length > 0)
				{
					_loc1_.reorderChildren(_loc2_);
				}
			};
			this.m_taskletSequencer.addChunk(func);
		}
		
		public function reorderNode(param1:int):void
		{
			var nodeId:int = param1;
			var func:Function = function():void
			{
				var _loc1_:MenuElementBase = m_allChildren[nodeId];
				if (!_loc1_)
				{
					return;
				}
				var _loc2_:Object = _loc1_.parent;
				if (!_loc2_)
				{
					return;
				}
				_loc2_.setChildIndex(_loc1_, _loc2_.numChildren - 1);
			};
			this.m_taskletSequencer.addChunk(func);
		}
		
		public function reloadData(param1:int, param2:Object):void
		{
			var nodeId:int = param1;
			var nodeData:Object = param2;
			var func:Function = function():void
			{
				var _loc1_:Sprite = m_allChildren[nodeId];
				if (!_loc1_)
				{
					return;
				}
				_loc1_["_nodedata"] = nodeData;
				applyData(_loc1_);
			};
			this.m_taskletSequencer.addChunk(func);
		}
		
		public function reloadNode(param1:int, param2:Object):void
		{
			var nodeId:int = param1;
			var nodeData:Object = param2;
			var func:Function = function():void
			{
				var funcClearMenuElement:Function;
				var elementSprite:Sprite = null;
				var menuElement:MenuElementBase = null;
				elementSprite = m_allChildren[nodeId];
				if (!elementSprite)
				{
					return;
				}
				unregisterChildren(elementSprite);
				menuElement = m_allChildren[nodeId] as MenuElementBase;
				if (!menuElement)
				{
					return;
				}
				funcClearMenuElement = function():void
				{
					var funcChildrenChanged:Function;
					var persistentReloadData:Object = null;
					var menuElementParent:MenuElementBase = null;
					var child:Sprite = null;
					var data:Object = null;
					var funcReplace:Function = null;
					persistentReloadData = menuElement.getPersistentReloadData();
					menuElement.clearChildren();
					menuElement.onUnregister();
					menuElementParent = menuElement.m_parent;
					if (!menuElementParent)
					{
						data = {};
						data["root"] = nodeData;
						onSetData(data);
						return;
					}
					child = processElement(nodeData);
					if (child)
					{
						funcReplace = function():void
						{
							var _loc1_:MenuElementBase = child as MenuElementBase;
							if (_loc1_ != null)
							{
								_loc1_.onPersistentReloadData(persistentReloadData);
							}
							menuElementParent.replaceChild2(elementSprite, child);
						};
						m_taskletSequencer.addChunk(funcReplace);
					}
					funcChildrenChanged = function():void
					{
						menuElementParent.onChildrenChanged();
					};
					m_taskletSequencer.addChunk(funcChildrenChanged);
				};
				m_taskletSequencer.addChunk(funcClearMenuElement);
			};
			this.m_taskletSequencer.addChunk(func);
		}
		
		public function bubbleEvent(param1:int, param2:String):void
		{
			var targetId:int = param1;
			var eventName:String = param2;
			var func:Function = function():void
			{
				var _loc1_:Object = m_allChildren[targetId];
				if (!_loc1_)
				{
					return;
				}
				var _loc2_:Object = _loc1_.parent;
				while (_loc2_ && _loc2_ != this && (!_loc2_["handleEvent"] || !_loc2_["handleEvent"](eventName, _loc1_)))
				{
					_loc2_ = _loc2_.parent;
				}
			};
			this.m_taskletSequencer.addChunk(func);
		}
		
		public function onSetData(param1:Object):void
		{
			var data:Object = param1;
			var func:Function = function():void
			{
				var funcProcessElement:Function;
				if (m_container.numChildren > 0)
				{
					while (m_container.numChildren > 0)
					{
						unregisterChildren(m_container.getChildAt(0));
						m_container.removeChildAt(0);
					}
				}
				m_allChildren = {};
				if (!data.root)
				{
					return;
				}
				funcProcessElement = function():void
				{
					var _loc1_:Sprite = processElement(data.root);
					if (_loc1_)
					{
						m_container.addChild(_loc1_);
					}
				};
				m_taskletSequencer.addChunk(funcProcessElement);
			};
			this.m_taskletSequencer.addChunk(func);
		}
		
		public function setPageIndicator(param1:String, param2:int, param3:int):void
		{
			this.m_pageIndicator.visible = true;
			this.m_pageIndicator.setPageIndicator(param3);
			this.m_pageIndicator.updatePageIndicator(param2, param1, Localization.get("UI_PAGE_INDICATOR"), String(param2 + 1) + " / " + String(param3));
		}
		
		private function debug_printNodes():void
		{
			var _loc1_:String = null;
			var _loc2_:Object = null;
			for (_loc1_ in this.m_allChildren)
			{
				_loc2_ = this.m_allChildren[_loc1_];
			}
		}
	}
}

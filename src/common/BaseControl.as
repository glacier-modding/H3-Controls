package common
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	
	public class BaseControl extends Sprite
	{
		
		public var m_bounds:Rectangle;
		
		private var m_editorSelectionWidget:Sprite = null;
		
		private var m_editorSelectionArrowWidget:Sprite = null;
		
		private var m_editorContainerWidget:Sprite = null;
		
		public var CallEntity:Function;
		
		public function BaseControl()
		{
			super();
			this.m_bounds = new Rectangle();
			var _loc1_:Boolean = ExternalInterface.call("CommonUtilsGetBoundsChangeDebug");
			if (_loc1_)
			{
				addEventListener(Event.ENTER_FRAME, this.onEnterFrameHandler);
			}
		}
		
		public function onEnterFrameHandler():void
		{
			var _loc1_:Rectangle = getBounds(this);
			if (this.m_bounds.x != _loc1_.x || this.m_bounds.y != _loc1_.y || this.m_bounds.width != _loc1_.width || this.m_bounds.height != _loc1_.height)
			{
				this.m_bounds = _loc1_;
			}
		}
		
		public function onAttached():void
		{
		}
		
		public function onChildrenAttached():void
		{
		}
		
		public function updateBounds():void
		{
			this.m_bounds = getBounds(this);
			this.sendBounds(this.m_bounds);
		}
		
		public function onEditorSelected(param1:Boolean, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number):void
		{
			if (this.m_editorSelectionWidget != null)
			{
				BaseControlEditorDebug.unsetSelectionWidget(this.m_editorSelectionWidget);
				this.m_editorSelectionWidget = null;
			}
			if (this.m_editorSelectionArrowWidget != null)
			{
				BaseControlEditorDebug.unsetSelectionArrowWidget(this.m_editorSelectionArrowWidget);
				this.m_editorSelectionArrowWidget = null;
			}
			if (param1)
			{
				this.m_editorSelectionWidget = BaseControlEditorDebug.setSelectionWidget(this, param2, param3, param4, param5, param6, param7);
				this.m_editorSelectionArrowWidget = BaseControlEditorDebug.setSelectionArrowWidget(this, param2, param3, param4, param5, param6, param7);
			}
		}
		
		public function onEditorContainerSelected(param1:Boolean, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number):void
		{
			if (this.m_editorContainerWidget != null)
			{
				BaseControlEditorDebug.unsetContainerWidget(this.m_editorContainerWidget);
				this.m_editorContainerWidget = null;
			}
			if (param1)
			{
				this.m_editorContainerWidget = BaseControlEditorDebug.setContainerWidget(this, param2, param3, param4, param5, param6, param7);
			}
		}
		
		public function clearMatrix3D():void
		{
			transform.perspectiveProjection = null;
			transform.matrix3D = null;
		}
		
		public function getContainer():Sprite
		{
			return this;
		}
		
		public function onSetConstrained(param1:Boolean):void
		{
		}
		
		public function onSetSize(param1:Number, param2:Number):void
		{
		}
		
		public function onSetViewport(param1:Number, param2:Number, param3:Number):void
		{
		}
		
		public function onSetVisible(param1:Boolean):void
		{
		}
		
		public function onMouseEnabled(param1:Boolean):void
		{
			this.mouseEnabled = param1;
			this.mouseChildren = param1;
		}
		
		protected function print(param1:*):void
		{
			if (this.CallEntity != null)
			{
				this.CallEntity(1, param1 as String);
			}
		}
		
		protected function sendEventWithValue(param1:String, param2:*):void
		{
			if (this.CallEntity != null)
			{
				this.CallEntity(2, param1, param2);
			}
		}
		
		protected function sendEvent(param1:String):void
		{
			if (this.CallEntity != null)
			{
				this.CallEntity(2, param1);
			}
		}
		
		protected function getProperty(param1:String):*
		{
			if (this.CallEntity != null)
			{
				return this.CallEntity(3, param1);
			}
			return null;
		}
		
		protected function sendBounds(param1:Rectangle):void
		{
			if (this.CallEntity != null)
			{
				this.CallEntity(4, param1.x, param1.y, param1.width, param1.height);
			}
		}
	}
}

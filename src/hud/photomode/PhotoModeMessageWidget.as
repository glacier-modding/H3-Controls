package hud.photomode
{
	import common.Animate;
	import common.BaseControl;
	import flash.display.Sprite;
	
	public class PhotoModeMessageWidget extends BaseControl
	{
		
		private static const DY_GAP_BETWEEN_MESSAGES:Number = 16;
		
		private var m_Sticky_view:StickyMessageView;
		
		private var m_Sticky_htmlPrimaryEnqueued:String = null;
		
		private var m_Sticky_htmlSecondaryEnqueued:String = null;
		
		private var m_Sticky_isFadingOut:Boolean = false;
		
		private var m_FAF_container:FAFMessageViewContainer;
		
		private var m_FAF_containerStickyOffset:Sprite;
		
		private var m_FAF_viewsEnqueued:Vector.<FAFMessageView>;
		
		private var m_FAF_viewsActive:Vector.<FAFMessageView>;
		
		private var m_FAF_yOffsetTotal:Number = 0;
		
		public function PhotoModeMessageWidget()
		{
			this.m_Sticky_view = new StickyMessageView();
			this.m_FAF_container = new FAFMessageViewContainer();
			this.m_FAF_containerStickyOffset = new Sprite();
			this.m_FAF_viewsEnqueued = new Vector.<FAFMessageView>();
			this.m_FAF_viewsActive = new Vector.<FAFMessageView>();
			super();
			this.m_FAF_container.name = "faf";
			this.m_FAF_containerStickyOffset.name = "fafStickyOffset";
			this.m_FAF_containerStickyOffset.addChild(this.m_FAF_container);
			this.m_Sticky_view.name = "sticky";
			this.m_Sticky_view.visible = false;
			addChild(this.m_Sticky_view);
			addChild(this.m_FAF_containerStickyOffset);
		}
		
		public function fireAndForget(param1:String, param2:String):void
		{
			var _loc3_:FAFMessageView = this.m_FAF_container.acquireView();
			_loc3_.alpha = 0;
			_loc3_.setupTextFields(param1, param2);
			this.m_FAF_viewsEnqueued.push(_loc3_);
			this.m_FAF_yOffsetTotal += _loc3_.getTotalTextHeight() + DY_GAP_BETWEEN_MESSAGES;
			_loc3_.y = -this.m_FAF_yOffsetTotal;
			Animate.to(this.m_FAF_container, 0.125, 0, {"y": this.m_FAF_yOffsetTotal}, Animate.SineOut, this.onFAFSlideDownCompleted);
		}
		
		private function onFAFSlideDownCompleted():void
		{
			var _loc1_:FAFMessageView = null;
			while (this.m_FAF_viewsEnqueued.length > 0)
			{
				_loc1_ = this.m_FAF_viewsEnqueued.pop();
				this.m_FAF_viewsActive.push(_loc1_);
				_loc1_.startAnimation(this.onFAFAnimationCompleted);
			}
		}
		
		private function onFAFAnimationCompleted(param1:FAFMessageView):void
		{
			this.m_FAF_container.releaseView(param1);
			param1.y = 0;
			var _loc2_:int = 0;
			while (_loc2_ < this.m_FAF_viewsActive.length)
			{
				if (this.m_FAF_viewsActive[_loc2_] == param1)
				{
					this.m_FAF_viewsActive.splice(_loc2_, 1);
					break;
				}
				_loc2_++;
			}
			if (this.m_FAF_viewsActive.length == 0)
			{
				this.m_FAF_yOffsetTotal = 0;
				this.m_FAF_container.y = 0;
			}
		}
		
		public function clearAllFiredAndForgotten():void
		{
			var _loc1_:FAFMessageView = null;
			Animate.kill(this.m_FAF_container);
			this.m_FAF_yOffsetTotal = 0;
			this.m_FAF_container.y = 0;
			while (this.m_FAF_viewsEnqueued.length > 0)
			{
				_loc1_ = this.m_FAF_viewsEnqueued.pop();
				_loc1_.y = 0;
				this.m_FAF_container.releaseView(_loc1_);
			}
			while (this.m_FAF_viewsActive.length > 0)
			{
				_loc1_ = this.m_FAF_viewsActive.pop();
				Animate.kill(_loc1_);
				_loc1_.y = 0;
				this.m_FAF_container.releaseView(_loc1_);
			}
		}
		
		public function setSticky(param1:String, param2:String):void
		{
			if (!this.m_Sticky_view.visible)
			{
				this.m_Sticky_view.visible = true;
				this.m_Sticky_view.fadeInAnimation(param1, param2);
				Animate.to(this.m_FAF_containerStickyOffset, 0.125, 0, {"y": this.m_Sticky_view.getTotalTextHeight() + DY_GAP_BETWEEN_MESSAGES}, Animate.SineOut);
			}
			else
			{
				if (!this.m_Sticky_isFadingOut)
				{
					this.m_Sticky_view.fadeOutAnimation(this.onStickyFadeOutCompleted);
					this.m_Sticky_isFadingOut = true;
				}
				this.m_Sticky_htmlPrimaryEnqueued = param1;
				this.m_Sticky_htmlSecondaryEnqueued = param2;
			}
		}
		
		private function onStickyFadeOutCompleted():void
		{
			this.m_Sticky_isFadingOut = false;
			if (this.m_Sticky_htmlPrimaryEnqueued != null && this.m_Sticky_htmlSecondaryEnqueued != null)
			{
				this.m_Sticky_view.fadeInAnimation(this.m_Sticky_htmlPrimaryEnqueued, this.m_Sticky_htmlSecondaryEnqueued);
				this.m_Sticky_htmlPrimaryEnqueued = null;
				this.m_Sticky_htmlSecondaryEnqueued = null;
				Animate.to(this.m_FAF_containerStickyOffset, 0.125, 0, {"y": this.m_Sticky_view.getTotalTextHeight() + DY_GAP_BETWEEN_MESSAGES}, Animate.SineOut);
			}
			else
			{
				this.m_Sticky_view.visible = false;
			}
		}
		
		public function clearSticky():void
		{
			if (!this.m_Sticky_view.visible)
			{
				return;
			}
			if (!this.m_Sticky_isFadingOut)
			{
				this.m_Sticky_view.fadeOutAnimation(this.onStickyFadeOutCompleted);
				this.m_Sticky_isFadingOut = true;
				Animate.to(this.m_FAF_containerStickyOffset, 0.125, 0, {"y": 0}, Animate.SineOut);
			}
			this.m_Sticky_htmlPrimaryEnqueued = null;
			this.m_Sticky_htmlSecondaryEnqueued = null;
		}
	}
}

import common.menu.MenuConstants;
import common.menu.MenuUtils;
import flash.display.Sprite;
import flash.text.TextField;

class MessageView extends Sprite
{
	
	public var primary_txt:TextField;
	
	public var secondary_txt:TextField;
	
	public function MessageView()
	{
		this.primary_txt = new TextField();
		this.secondary_txt = new TextField();
		super();
		this.primary_txt.name = "primary_txt";
		this.secondary_txt.name = "secondary_txt";
		this.primary_txt.autoSize = "left";
		this.secondary_txt.autoSize = "left";
		MenuUtils.setupText(this.primary_txt, "", 22, MenuConstants.FONT_TYPE_MEDIUM);
		MenuUtils.setupText(this.secondary_txt, "", 18, MenuConstants.FONT_TYPE_MEDIUM);
		MenuUtils.addDropShadowFilter(this.primary_txt);
		MenuUtils.addDropShadowFilter(this.secondary_txt);
		addChild(this.primary_txt);
		addChild(this.secondary_txt);
	}
	
	public function setupTextFields(param1:String, param2:String):void
	{
		this.primary_txt.htmlText = param1.toUpperCase();
		this.primary_txt.x = -this.primary_txt.width / 2;
		if (param2 == "")
		{
			this.secondary_txt.visible = false;
		}
		else
		{
			this.secondary_txt.htmlText = param2;
			this.secondary_txt.x = -this.secondary_txt.width / 2;
			this.secondary_txt.alpha = 1;
			this.secondary_txt.visible = true;
		}
	}
	
	public function getTotalTextHeight():Number
	{
		var _loc1_:Number = Number(this.primary_txt.height);
		if (this.secondary_txt.visible)
		{
			_loc1_ += this.secondary_txt.height;
		}
		return _loc1_;
	}
}

import common.Animate;

class StickyMessageView extends MessageView
{
	
	public function StickyMessageView()
	{
		super();
		alpha = 0;
		scaleX = 1.3;
		scaleY = 1.3;
	}
	
	public function fadeInAnimation(param1:String, param2:String):void
	{
		setupTextFields(param1, param2);
		if (secondary_txt.visible)
		{
			secondary_txt.y = primary_txt.height;
		}
		Animate.to(this, 0.125, 0, {"alpha": 1, "scaleX": 1, "scaleY": 1}, Animate.SineOut);
	}
	
	public function fadeOutAnimation(param1:Function):void
	{
		Animate.to(this, 0.125, 0, {"alpha": 0, "scaleX": 1.3, "scaleY": 1.3}, Animate.SineIn, param1);
	}
}

import common.Animate;
import flash.display.Shape;

class FAFMessageView extends MessageView
{
	
	public var bg:Shape;
	
	public function FAFMessageView()
	{
		this.bg = new Shape();
		super();
		this.bg.name = "bg";
		this.bg.graphics.beginFill(16777215);
		this.bg.graphics.drawRect(-10, 0, 20, 20);
		this.bg.graphics.endFill();
		this.bg.visible = false;
		addChild(this.bg);
	}
	
	public function startAnimation(param1:Function):void
	{
		var _loc2_:Number = 3;
		if (secondary_txt.visible)
		{
			secondary_txt.y = primary_txt.height / 2;
			secondary_txt.alpha = 0;
			Animate.to(secondary_txt, 0.5, 1, {"alpha": 1, "y": primary_txt.height}, Animate.ExpoOut);
			_loc2_ += 1;
		}
		this.bg.width = primary_txt.width;
		this.bg.height = primary_txt.height - 3;
		this.bg.alpha = 1;
		this.bg.visible = true;
		Animate.to(this.bg, 1, 0, {"alpha": 0, "width": primary_txt.width + 200}, Animate.ExpoOut);
		alpha = 1;
		Animate.to(this, 1, _loc2_, {"alpha": 0}, Animate.Linear, param1, this);
	}
}

import flash.display.Sprite;

class FAFMessageViewContainer extends Sprite
{
	
	private var m_viewsAvailable:Vector.<FAFMessageView>;
	
	public function FAFMessageViewContainer()
	{
		var _loc3_:FAFMessageView = null;
		this.m_viewsAvailable = new Vector.<FAFMessageView>();
		super();
		var _loc1_:int = 2;
		var _loc2_:int = 0;
		while (_loc2_ < _loc1_)
		{
			_loc3_ = new FAFMessageView();
			_loc3_.visible = false;
			this.m_viewsAvailable.push(_loc3_);
			addChild(_loc3_);
			_loc2_++;
		}
	}
	
	public function acquireView():FAFMessageView
	{
		var _loc1_:FAFMessageView = null;
		if (this.m_viewsAvailable.length > 0)
		{
			_loc1_ = this.m_viewsAvailable.pop();
			_loc1_.visible = true;
		}
		else
		{
			_loc1_ = new FAFMessageView();
			addChild(_loc1_);
		}
		return _loc1_;
	}
	
	public function releaseView(param1:FAFMessageView):void
	{
		param1.visible = false;
		this.m_viewsAvailable.push(param1);
	}
}

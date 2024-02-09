package hud.evergreen
{
	import common.Animate;
	import common.BaseControl;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	
	public class MenuCursorWidget extends BaseControl
	{
		
		private var m_pxMargin:Number;
		
		private var m_pxThickness:Number;
		
		private var m_pxSerif:Number;
		
		private var m_pxAnimOffset:Number;
		
		private var m_fScaleIcon:Number;
		
		private var m_sprSizeTL:Sprite;
		
		private var m_sprSizeTR:Sprite;
		
		private var m_sprSizeBL:Sprite;
		
		private var m_sprSizeBR:Sprite;
		
		private var m_sprAnimTL:Sprite;
		
		private var m_sprAnimTR:Sprite;
		
		private var m_sprAnimBL:Sprite;
		
		private var m_sprAnimBR:Sprite;
		
		private var m_shpShadowTL:Shape;
		
		private var m_shpShadowTR:Shape;
		
		private var m_shpShadowBL:Shape;
		
		private var m_shpShadowBR:Shape;
		
		private var m_shpWhiteTL:Shape;
		
		private var m_shpWhiteTR:Shape;
		
		private var m_shpWhiteBL:Shape;
		
		private var m_shpWhiteBR:Shape;
		
		private var m_icon:iconsAll76x76View;
		
		public function MenuCursorWidget()
		{
			this.m_sprSizeTL = new Sprite();
			this.m_sprSizeTR = new Sprite();
			this.m_sprSizeBL = new Sprite();
			this.m_sprSizeBR = new Sprite();
			this.m_sprAnimTL = new Sprite();
			this.m_sprAnimTR = new Sprite();
			this.m_sprAnimBL = new Sprite();
			this.m_sprAnimBR = new Sprite();
			this.m_shpShadowTL = new Shape();
			this.m_shpShadowTR = new Shape();
			this.m_shpShadowBL = new Shape();
			this.m_shpShadowBR = new Shape();
			this.m_shpWhiteTL = new Shape();
			this.m_shpWhiteTR = new Shape();
			this.m_shpWhiteBL = new Shape();
			this.m_shpWhiteBR = new Shape();
			this.m_icon = new iconsAll76x76View();
			super();
			this.m_sprSizeTL.name = "m_sprSizeTL";
			this.m_sprAnimTL.name = "m_sprAnimTL";
			this.m_shpShadowTL.name = "m_shpShadowTL";
			this.m_shpWhiteTL.name = "m_shpWhiteTL";
			addChild(this.m_sprSizeTL);
			this.m_sprSizeTL.addChild(this.m_sprAnimTL);
			this.m_sprAnimTL.addChild(this.m_shpShadowTL);
			this.m_sprAnimTL.addChild(this.m_shpWhiteTL);
			this.m_sprSizeTR.name = "m_sprSizeTR";
			this.m_sprAnimTR.name = "m_sprAnimTR";
			this.m_shpShadowTR.name = "m_shpShadowTR";
			this.m_shpWhiteTR.name = "m_shpWhiteTR";
			addChild(this.m_sprSizeTR);
			this.m_sprSizeTR.addChild(this.m_sprAnimTR);
			this.m_sprAnimTR.addChild(this.m_shpShadowTR);
			this.m_sprAnimTR.addChild(this.m_shpWhiteTR);
			this.m_sprSizeBL.name = "m_sprSizeBL";
			this.m_sprAnimBL.name = "m_sprAnimBL";
			this.m_shpShadowBL.name = "m_shpShadowBL";
			this.m_shpWhiteBL.name = "m_shpWhiteBL";
			addChild(this.m_sprSizeBL);
			this.m_sprSizeBL.addChild(this.m_sprAnimBL);
			this.m_sprAnimBL.addChild(this.m_shpShadowBL);
			this.m_sprAnimBL.addChild(this.m_shpWhiteBL);
			this.m_sprSizeBR.name = "m_sprSizeBR";
			this.m_sprAnimBR.name = "m_sprAnimBR";
			this.m_shpShadowBR.name = "m_shpShadowBR";
			this.m_shpWhiteBR.name = "m_shpWhiteBR";
			addChild(this.m_sprSizeBR);
			this.m_sprSizeBR.addChild(this.m_sprAnimBR);
			this.m_sprAnimBR.addChild(this.m_shpShadowBR);
			this.m_sprAnimBR.addChild(this.m_shpWhiteBR);
			this.m_icon.name = "m_icon";
			addChild(this.m_icon);
			this.m_icon.filters = [new DropShadowFilter(4, 90, 0, 1, 16, 16, 1, BitmapFilterQuality.MEDIUM, false, false, false)];
		}
		
		[PROPERTY(CONSTRAINT = "MinValue(0) Step(1)")]
		public function set pxMargin(param1:Number):void
		{
			this.m_pxMargin = param1;
			this.redrawAllCorners();
		}
		
		[PROPERTY(CONSTRAINT = "MinValue(0) Step(1)")]
		public function set pxThickness(param1:Number):void
		{
			this.m_pxThickness = param1;
			this.redrawAllCorners();
		}
		
		[PROPERTY(CONSTRAINT = "MinValue(0) Step(1)")]
		public function set pxSerif(param1:Number):void
		{
			this.m_pxSerif = param1;
			this.redrawAllCorners();
		}
		
		[PROPERTY(CONSTRAINT = "MinValue(0) Step(1)")]
		public function set xShadowOffset(param1:Number):void
		{
			this.m_shpWhiteTL.x = this.m_shpWhiteTR.x = this.m_shpWhiteBL.x = this.m_shpWhiteBR.x = this.m_icon.x = -param1;
		}
		
		[PROPERTY(CONSTRAINT = "MinValue(0) Step(1)")]
		public function set yShadowOffset(param1:Number):void
		{
			this.m_shpWhiteTL.y = this.m_shpWhiteTR.y = this.m_shpWhiteBL.y = this.m_shpWhiteBR.y = this.m_icon.y = -param1;
		}
		
		[PROPERTY(CONSTRAINT = "MinValue(0) Step(1)")]
		public function set zShadowOffset(param1:Number):void
		{
			this.m_shpWhiteTL.z = this.m_shpWhiteTR.z = this.m_shpWhiteBL.z = this.m_shpWhiteBR.z = this.m_icon.z = -param1;
		}
		
		[PROPERTY(CONSTRAINT = "MinValue(0) Step(1)")]
		public function set pxAnimOffset(param1:Number):void
		{
			this.m_pxAnimOffset = param1;
		}
		
		[PROPERTY(CONSTRAINT = "MinValue(0)")]
		public function set fScaleIcon(param1:Number):void
		{
			this.m_fScaleIcon = param1;
			Animate.complete(this.m_icon);
			this.m_icon.scaleX = param1;
			this.m_icon.scaleY = param1;
		}
		
		private function redrawAllCorners():void
		{
			this.redrawCorner(this.m_shpShadowTL.graphics, this.m_shpWhiteTL.graphics, -this.m_pxMargin, -this.m_pxMargin + this.m_pxSerif, -this.m_pxMargin, -this.m_pxMargin, -this.m_pxMargin + this.m_pxSerif, -this.m_pxMargin);
			this.redrawCorner(this.m_shpShadowTR.graphics, this.m_shpWhiteTR.graphics, this.m_pxMargin, -this.m_pxMargin + this.m_pxSerif, this.m_pxMargin, -this.m_pxMargin, this.m_pxMargin - this.m_pxSerif, -this.m_pxMargin);
			this.redrawCorner(this.m_shpShadowBL.graphics, this.m_shpWhiteBL.graphics, -this.m_pxMargin, this.m_pxMargin - this.m_pxSerif, -this.m_pxMargin, this.m_pxMargin, -this.m_pxMargin + this.m_pxSerif, this.m_pxMargin);
			this.redrawCorner(this.m_shpShadowBR.graphics, this.m_shpWhiteBR.graphics, this.m_pxMargin, this.m_pxMargin - this.m_pxSerif, this.m_pxMargin, this.m_pxMargin, this.m_pxMargin - this.m_pxSerif, this.m_pxMargin);
		}
		
		private function redrawCorner(param1:Graphics, param2:Graphics, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number):void
		{
			param1.clear();
			param1.lineStyle(this.m_pxThickness, 0, 0.5, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			param1.moveTo(param3, param4);
			param1.lineTo(param5, param6);
			param1.lineTo(param7, param8);
			param2.clear();
			param2.lineStyle(this.m_pxThickness, 16777215, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			param2.moveTo(param3, param4);
			param2.lineTo(param5, param6);
			param2.lineTo(param7, param8);
		}
		
		public function updateSizeAndDecoration(param1:Number, param2:Number, param3:Object):void
		{
			if (param3 == null || param3.icon == null || param3.icon == "")
			{
				this.m_icon.visible = false;
			}
			else
			{
				this.m_icon.visible = true;
				MenuUtils.setupIcon(this.m_icon, param3.icon, MenuConstants.COLOR_WHITE, param3.isIconFramed, false, 16777215, 0, 0, param3.isIconCutOut);
				param1 = Math.max(param1, 76 * this.m_fScaleIcon);
				param2 = Math.max(param2, 76 * this.m_fScaleIcon);
			}
			this.m_sprSizeTL.x = -param1 / 2;
			this.m_sprSizeTL.y = -param2 / 2;
			this.m_sprSizeTR.x = param1 / 2;
			this.m_sprSizeTR.y = -param2 / 2;
			this.m_sprSizeBL.x = -param1 / 2;
			this.m_sprSizeBL.y = param2 / 2;
			this.m_sprSizeBR.x = param1 / 2;
			this.m_sprSizeBR.y = param2 / 2;
		}
		
		public function animateCursorCorners():void
		{
			this.m_sprAnimTL.alpha = 0;
			this.m_sprAnimTR.alpha = 0;
			this.m_sprAnimBL.alpha = 0;
			this.m_sprAnimBR.alpha = 0;
			this.m_icon.alpha = 0;
			Animate.kill(this);
			this.animatePulse(0, false);
		}
		
		private function animatePulse(param1:Number, param2:Boolean):void
		{
			var _loc5_:Number = NaN;
			var _loc3_:Object = {"x": 0, "y": 0};
			var _loc4_:Object = {"scaleX": this.m_fScaleIcon, "scaleY": this.m_fScaleIcon, "alpha": 1};
			_loc5_ = this.m_pxAnimOffset;
			var _loc6_:Object = {"x": -_loc5_, "y": -_loc5_};
			var _loc7_:Object = {"x": _loc5_, "y": -_loc5_};
			var _loc8_:Object = {"x": -_loc5_, "y": _loc5_};
			var _loc9_:Object = {"x": _loc5_, "y": _loc5_};
			var _loc10_:Object = {"scaleX": this.m_fScaleIcon * 1.25, "scaleY": this.m_fScaleIcon * 1.25, "alpha": 0};
			if (param1 != 1)
			{
				_loc3_.alpha = 1;
				_loc4_.alpha = 1;
				_loc6_.alpha = param1;
				_loc7_.alpha = param1;
				_loc8_.alpha = param1;
				_loc9_.alpha = param1;
			}
			Animate.fromTo(this.m_sprAnimTL, 0.2, 1 / 30, param2 ? _loc3_ : _loc6_, param2 ? _loc6_ : _loc3_, param2 ? Animate.SineIn : Animate.SineOut);
			Animate.fromTo(this.m_sprAnimTR, 0.2, 1 / 30, param2 ? _loc3_ : _loc7_, param2 ? _loc7_ : _loc3_, param2 ? Animate.SineIn : Animate.SineOut);
			Animate.fromTo(this.m_sprAnimBL, 0.2, 1 / 30, param2 ? _loc3_ : _loc8_, param2 ? _loc8_ : _loc3_, param2 ? Animate.SineIn : Animate.SineOut);
			Animate.fromTo(this.m_sprAnimBR, 0.2, 1 / 30, param2 ? _loc3_ : _loc9_, param2 ? _loc9_ : _loc3_, param2 ? Animate.SineIn : Animate.SineOut);
			Animate.fromTo(this.m_icon, 0.2, 1 / 30, param2 ? _loc4_ : _loc10_, param2 ? _loc10_ : _loc4_, param2 ? Animate.SineIn : Animate.SineOut);
			Animate.delay(this, param2 ? 0.2 + 1 / 60 : 1.5 - 2 * 0.2, this.animatePulse, 1, !param2);
		}
	}
}

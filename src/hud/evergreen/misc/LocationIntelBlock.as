package hud.evergreen.misc
{
	import common.Localization;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class LocationIntelBlock extends Sprite
	{
		
		public static const DYGAP:Number = 10;
		
		private var m_header_txt:TextField;
		
		private var m_dottedLine:DottedLineAlt;
		
		private var m_labelTargets_txt:TextField;
		
		private var m_labelSafes_txt:TextField;
		
		private var m_labelMules_txt:TextField;
		
		private var m_labelSuppliers_txt:TextField;
		
		private var m_numTargets_txt:TextField;
		
		private var m_numSafes_txt:TextField;
		
		private var m_numMules_txt:TextField;
		
		private var m_numSuppliers_txt:TextField;
		
		private var m_stackTargets:IconStack;
		
		private var m_stackSafes:IconStack;
		
		private var m_stackMules:IconStack;
		
		private var m_stackSuppliers:IconStack;
		
		private var s_targetLabel_targets:String;
		
		private var s_targetLabel_suspects:String;
		
		private var m_dyContentHeight:Number = 0;
		
		private var m_dxContentWidth:Number = 0;
		
		private var m_pxPadding:Number = 0;
		
		public function LocationIntelBlock(param1:Number, param2:Number)
		{
			this.m_header_txt = new TextField();
			this.m_dottedLine = new DottedLineAlt(1);
			this.m_labelTargets_txt = new TextField();
			this.m_labelSafes_txt = new TextField();
			this.m_labelMules_txt = new TextField();
			this.m_labelSuppliers_txt = new TextField();
			this.m_numTargets_txt = new TextField();
			this.m_numSafes_txt = new TextField();
			this.m_numMules_txt = new TextField();
			this.m_numSuppliers_txt = new TextField();
			this.m_stackTargets = new IconStack("evergreen_target");
			this.m_stackSafes = new IconStack("evergreen_safe");
			this.m_stackMules = new IconStack("evergreen_mules");
			this.m_stackSuppliers = new IconStack("evergreen_suppliers");
			super();
			this.m_dxContentWidth = param1;
			this.m_pxPadding = param2;
			this.m_header_txt.name = "m_header_txt";
			this.m_dottedLine.name = "m_dottedLine";
			this.m_labelTargets_txt.name = "m_labelTargets_txt";
			this.m_labelSafes_txt.name = "m_labelSafes_txt";
			this.m_labelMules_txt.name = "m_labelMules_txt";
			this.m_labelSuppliers_txt.name = "m_labelSuppliers_txt";
			this.m_numTargets_txt.name = "m_numTargets_txt";
			this.m_numSafes_txt.name = "m_numSafes_txt";
			this.m_numMules_txt.name = "m_numMules_txt";
			this.m_numSuppliers_txt.name = "m_numSuppliers_txt";
			this.m_stackTargets.name = "m_stackTargets";
			this.m_stackSafes.name = "m_stackSafes";
			this.m_stackMules.name = "m_stackMules";
			this.m_stackSuppliers.name = "m_stackSuppliers";
			addChild(this.m_header_txt);
			addChild(this.m_dottedLine);
			addChild(this.m_labelTargets_txt);
			addChild(this.m_labelSafes_txt);
			addChild(this.m_labelMules_txt);
			addChild(this.m_labelSuppliers_txt);
			addChild(this.m_numTargets_txt);
			addChild(this.m_numSafes_txt);
			addChild(this.m_numMules_txt);
			addChild(this.m_numSuppliers_txt);
			addChild(this.m_stackTargets);
			addChild(this.m_stackSafes);
			addChild(this.m_stackMules);
			addChild(this.m_stackSuppliers);
			MenuUtils.setupText(this.m_header_txt, "", 18, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_labelTargets_txt, "", 24, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_labelSafes_txt, "", 24, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_labelMules_txt, "", 24, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_labelSuppliers_txt, "", 24, MenuConstants.FONT_TYPE_NORMAL, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_numTargets_txt, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_numSafes_txt, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_numMules_txt, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			MenuUtils.setupText(this.m_numSuppliers_txt, "", 24, MenuConstants.FONT_TYPE_BOLD, MenuConstants.FontColorWhite);
			this.m_header_txt.autoSize = TextFieldAutoSize.LEFT;
			this.m_labelTargets_txt.autoSize = TextFieldAutoSize.LEFT;
			this.m_labelSafes_txt.autoSize = TextFieldAutoSize.LEFT;
			this.m_labelMules_txt.autoSize = TextFieldAutoSize.LEFT;
			this.m_labelSuppliers_txt.autoSize = TextFieldAutoSize.LEFT;
			this.m_numTargets_txt.autoSize = TextFieldAutoSize.LEFT;
			this.m_numSafes_txt.autoSize = TextFieldAutoSize.LEFT;
			this.m_numMules_txt.autoSize = TextFieldAutoSize.LEFT;
			this.m_numSuppliers_txt.autoSize = TextFieldAutoSize.LEFT;
			this.m_header_txt.text = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_LOCATIONINTEL_HEADER").toUpperCase();
			this.m_labelSafes_txt.text = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_LOCATIONINTEL_SAFES").toUpperCase();
			this.m_labelMules_txt.text = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_LOCATIONINTEL_MULES").toUpperCase();
			this.m_labelSuppliers_txt.text = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_LOCATIONINTEL_SUPPLIERS").toUpperCase();
			this.s_targetLabel_targets = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_LOCATIONINTEL_TARGETS").toUpperCase();
			this.s_targetLabel_suspects = Localization.get("UI_EVEREGREEN_SAFEHOUSE_WORLDMAP_LOCATIONINTEL_SUSPECTS").toUpperCase();
			this.m_dottedLine.y = this.m_header_txt.y + this.m_header_txt.textHeight + 10;
			this.m_dottedLine.updateLineLength(this.m_dxContentWidth);
			this.m_stackTargets.scaleX = this.m_stackTargets.scaleY = this.m_stackSafes.scaleX = this.m_stackSafes.scaleY = this.m_stackMules.scaleX = this.m_stackMules.scaleY = this.m_stackSuppliers.scaleX = this.m_stackSuppliers.scaleY = 0.5;
		}
		
		public function get dyContentHeight():Number
		{
			return this.m_dyContentHeight;
		}
		
		public function onSetData(param1:Object):void
		{
			var dyGapLastUsed:Number;
			var dyLastStackHeight:Number;
			var isLastLeftColumn:Boolean;
			var syncCounter:Function;
			var y:Number = NaN;
			var dxMaxLabelWidth:Number = NaN;
			var dxMaxStackWidth:Number = NaN;
			var i:int = 0;
			var stackHeight:Number = NaN;
			var data:Object = param1;
			if (!data.nTargets && !data.nMules && !data.nSafes && !data.nSuppliers)
			{
				this.visible = false;
				this.m_dyContentHeight = 0;
				return;
			}
			if (data.isHotMission)
			{
				this.m_labelTargets_txt.text = this.s_targetLabel_suspects;
			}
			else
			{
				this.m_labelTargets_txt.text = this.s_targetLabel_targets;
			}
			this.visible = true;
			y = this.m_dottedLine.y + this.m_dottedLine.dottedLineThickness + DYGAP;
			dyGapLastUsed = DYGAP;
			this.m_stackTargets.numItemsInStack = Math.min(6, data.nTargets);
			this.m_stackMules.numItemsInStack = Math.min(6, data.nMules);
			this.m_stackSafes.numItemsInStack = Math.min(6, data.nSafes);
			this.m_stackSuppliers.numItemsInStack = Math.min(6, data.nSuppliers);
			dxMaxLabelWidth = Math.max(this.m_labelTargets_txt.textWidth, this.m_labelMules_txt.textWidth, this.m_labelSafes_txt.textWidth, this.m_labelSuppliers_txt.textWidth);
			dxMaxStackWidth = Math.max(this.m_stackTargets.width, this.m_stackMules.width, this.m_stackSafes.width, this.m_stackSuppliers.width);
			i = 0;
			dyLastStackHeight = 0;
			isLastLeftColumn = false;
			stackHeight = this.m_stackTargets.height;
			syncCounter = function(param1:int, param2:TextField, param3:TextField, param4:IconStack):void
			{
				if (param1 == 0)
				{
					param2.alpha = 0.4;
					param3.alpha = 0.4;
					param4.alpha = 0.4;
				}
				else
				{
					param2.alpha = 1;
					param3.alpha = 1;
					param4.alpha = 1;
				}
				param3.htmlText = "<font face=\"$global\">" + param1.toString() + "</font>";
				param4.y = y;
				param2.y = y + param4.height / 2 - param2.height / 2;
				param3.y = y + param4.height / 2 - param3.height / 2;
				var _loc5_:*;
				if (_loc5_ = i % 2 == 0)
				{
					param2.x = 0;
				}
				else
				{
					param2.x = m_dxContentWidth / 2 + m_pxPadding / 2;
					y += stackHeight;
					y += DYGAP;
					dyGapLastUsed = DYGAP;
				}
				param4.x = param2.x + (dxMaxLabelWidth + 50 + ((m_dxContentWidth - m_pxPadding) / 2 - dxMaxStackWidth)) / 2;
				param3.x = param4.x - 20 - param3.textWidth;
				dyLastStackHeight = stackHeight;
				isLastLeftColumn = _loc5_;
				++i;
			};
			syncCounter(data.nTargets, this.m_labelTargets_txt, this.m_numTargets_txt, this.m_stackTargets);
			syncCounter(data.nMules, this.m_labelMules_txt, this.m_numMules_txt, this.m_stackMules);
			syncCounter(data.nSafes, this.m_labelSafes_txt, this.m_numSafes_txt, this.m_stackSafes);
			syncCounter(data.nSuppliers, this.m_labelSuppliers_txt, this.m_numSuppliers_txt, this.m_stackSuppliers);
			if (isLastLeftColumn)
			{
				y += dyLastStackHeight;
				y += DYGAP;
				dyGapLastUsed = DYGAP;
			}
			this.m_dyContentHeight = y - dyGapLastUsed;
		}
	}
}

package menu3.basic
{
	import common.CommonUtils;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.text.TextField;
	
	public dynamic class OptionsInfoInteractionPromptSize extends OptionsInfo
	{
		
		private var m_customTextFieldLabel:TextField;
		
		private var m_customTextFieldDesc:TextField;
		
		public function OptionsInfoInteractionPromptSize(param1:Object)
		{
			super(param1);
		}
		
		override public function onSetData(param1:Object):void
		{
			this.cleanupTextfield();
			super.onSetData(param1);
			var _loc2_:int = MenuConstants.INTERACTIONPROMPTSIZE_DEFAULT;
			if (param1.uioptionname != null && param1.uioptionname.length > 0)
			{
				_loc2_ = CommonUtils.getUIOptionValueNumber(param1.uioptionname);
			}
			var _loc3_:Object = MenuConstants.InteractionIndicatorFontSpecs[_loc2_];
			if (param1.customtext != null && param1.customtext.length > 0)
			{
				this.m_customTextFieldLabel = this.setupTextfield(param1.customtext, _loc3_.fontSizeLabel, _loc3_.yOffsetLabel, _loc3_.fScaleGroup * _loc3_.fScaleIndividual, MenuConstants.FONT_TYPE_BOLD);
				this.m_customTextFieldDesc = this.setupTextfield(param1.customtext, _loc3_.fontSizeDesc, _loc3_.yOffsetDesc, _loc3_.fScaleGroup * _loc3_.fScaleIndividual, MenuConstants.FONT_TYPE_NORMAL);
				this.m_customTextFieldLabel.name = "m_customTextFieldLabel";
				this.m_customTextFieldDesc.name = "m_customTextFieldDesc";
			}
		}
		
		override public function onUnregister():void
		{
			this.cleanupTextfield();
			super.onUnregister();
		}
		
		private function cleanupTextfield():void
		{
			if (this.m_customTextFieldLabel != null)
			{
				m_view.removeChild(this.m_customTextFieldLabel);
				this.m_customTextFieldLabel = null;
			}
			if (this.m_customTextFieldDesc != null)
			{
				m_view.removeChild(this.m_customTextFieldDesc);
				this.m_customTextFieldDesc = null;
			}
		}
		
		private function setupTextfield(param1:String, param2:int, param3:int, param4:Number, param5:String):TextField
		{
			var _loc6_:TextField;
			(_loc6_ = new TextField()).multiline = true;
			_loc6_.wordWrap = true;
			_loc6_.width = m_view.paragraph.width;
			_loc6_.height = m_view.paragraph.height;
			_loc6_.x = 0;
			_loc6_.y = m_view.paragraph.y + m_view.paragraph.textHeight + 70 + param3 * param4;
			_loc6_.scaleX = param4;
			_loc6_.scaleY = param4;
			m_view.addChild(_loc6_);
			MenuUtils.setupTextUpper(_loc6_, param1, param2, param5, MenuConstants.FontColorWhite);
			return _loc6_;
		}
	}
}

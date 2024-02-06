package common
{
	import common.menu.MenuConstants;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	
	public class InputTextFieldSpecialCharacterHandler
	{
		
		private const HIGH_EVENT_PRIORITY:int = 1001;
		
		private var m_inputTextField:TextField = null;
		
		private var m_selectAllCharacterInputTriggered:Boolean = false;
		
		private var m_previousText:String;
		
		private var m_previousSelectionBegin:int = -1;
		
		private var m_previousSelectionEnd:int = -1;
		
		public function InputTextFieldSpecialCharacterHandler(param1:TextField)
		{
			super();
			this.m_inputTextField = param1;
		}
		
		public function onUnregister():void
		{
			this.setActive(false);
			this.m_inputTextField = null;
		}
		
		public function setActive(param1:Boolean):void
		{
			if (param1)
			{
				this.m_inputTextField.addEventListener(Event.CHANGE, this.onTextInputChange, false, this.HIGH_EVENT_PRIORITY, true);
				this.m_inputTextField.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown, false, this.HIGH_EVENT_PRIORITY, true);
			}
			else
			{
				this.m_inputTextField.removeEventListener(Event.CHANGE, this.onTextInputChange, false);
				this.m_inputTextField.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown, false);
			}
		}
		
		private function onKeyDown(param1:KeyboardEvent):void
		{
			this.m_selectAllCharacterInputTriggered = false;
			if (param1.ctrlKey && param1.altKey && param1.keyCode == MenuConstants.KEYCODE_A)
			{
				this.m_selectAllCharacterInputTriggered = true;
				this.m_previousText = this.m_inputTextField.text;
				this.m_previousSelectionBegin = this.m_inputTextField.selectionBeginIndex;
				this.m_previousSelectionEnd = this.m_inputTextField.selectionEndIndex;
			}
		}
		
		private function onTextInputChange(param1:Event):void
		{
			this.handleSelectAllPlusCharacterInputBug();
		}
		
		private function handleSelectAllPlusCharacterInputBug():void
		{
			var _loc4_:String = null;
			var _loc5_:String = null;
			if (!this.m_selectAllCharacterInputTriggered)
			{
				return;
			}
			this.m_selectAllCharacterInputTriggered = false;
			var _loc1_:String = this.m_inputTextField.text;
			var _loc2_:int = this.m_previousSelectionEnd - this.m_previousSelectionBegin;
			var _loc3_:int = this.m_inputTextField.maxChars - (this.m_previousText.length - _loc2_);
			if (_loc3_ > 0)
			{
				_loc4_ = this.m_previousText.substr(0, this.m_previousSelectionBegin);
				_loc5_ = _loc1_.substr(0, _loc3_);
				_loc4_ = (_loc4_ += _loc5_) + this.m_previousText.substr(this.m_previousSelectionEnd);
				this.m_inputTextField.text = _loc4_;
				this.m_inputTextField.setSelection(this.m_previousSelectionBegin + _loc5_.length, this.m_previousSelectionBegin + _loc5_.length);
			}
			else
			{
				this.m_inputTextField.text = this.m_previousText;
				this.m_inputTextField.setSelection(this.m_previousSelectionBegin, this.m_previousSelectionBegin);
			}
		}
	}
}

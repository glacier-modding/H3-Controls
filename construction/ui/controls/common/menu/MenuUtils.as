package common.menu
{
	import basic.ButtonPromptContainer;
	import common.Animate;
	import common.CommonUtils;
	import common.Localization;
	import fl.motion.Color;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import mx.utils.StringUtil;
	
	public class MenuUtils
	{
		
		private static const PI:Number = Math.PI;
		
		private static var s_truncator:String;
		
		private static var s_truncatorLocale:String = "";
		
		private static var s_thousandsSeparator:String;
		
		private static var s_thousandsSeparatorLocale:String = "";
		
		private static var s_decimalSeparator:String = ".";
		
		private static const m_matchHtmlLineBreaks:RegExp = /(?i)\s*<br[^>]*>\s*/g;
		
		public static const TINT_COLOR_BLACK:int = 0;
		
		public static const TINT_COLOR_GREY:int = 1;
		
		public static const TINT_COLOR_LIGHT_GREY:int = 2;
		
		public static const TINT_COLOR_NEARLY_WHITE:int = 3;
		
		public static const TINT_COLOR_WHITE:int = 4;
		
		public static const TINT_COLOR_RED:int = 5;
		
		public static const TINT_COLOR_LIGHT_RED:int = 6;
		
		public static const TINT_COLOR_DARKER_GREY:int = 7;
		
		public static const TINT_COLOR_MEDIUM_GREY:int = 8;
		
		public static const TINT_COLOR_REAL_RED:int = 9;
		
		public static const TINT_COLOR_ULTRA_DARK_GREY:int = 10;
		
		public static const TINT_COLOR_MEDIUM_GREY_3:int = 11;
		
		public static const TINT_COLOR_GREY_DARK_2:int = 12;
		
		public static const TINT_COLOR_GREY_DARK_3:int = 13;
		
		public static const TINT_COLOR_GREEN:int = 14;
		
		public static const TINT_COLOR_GREEN_LIGHT:int = 15;
		
		public static const TINT_COLOR_COLOR_GREY_GOTY:int = 16;
		
		public static const TINT_COLOR_MEDIUM_GREY_GOTY:int = 17;
		
		public static const TINT_COLOR_SUPER_LIGHT_GREY:int = 18;
		
		public static const TINT_COLOR_GREYBG:int = 19;
		
		public static const TINT_COLOR_YELLOW:int = 20;
		
		public static const TINT_COLOR_YELLOW_LIGHT:int = 21;
		
		public static const TINT_COLOR_MAGENTA_DARK:int = 22;
		
		private static const MENU_METER_TO_PIXEL:Number = 1 / 0.00364583;
		
		public function MenuUtils()
		{
			super();
		}
		
		public static function setupText(param1:TextField, param2:String, param3:int = 28, param4:String = "$medium", param5:String = "#ebebeb", param6:Boolean = false):void
		{
			var _loc7_:TextFormat = null;
			if (param2 == null)
			{
				param2 = "";
			}
			if (ControlsMain.isVrModeActive())
			{
				if (param4 == MenuConstants.FONT_TYPE_LIGHT || param4 == MenuConstants.FONT_TYPE_NORMAL)
				{
					param4 = MenuConstants.FONT_TYPE_MEDIUM;
				}
			}
			if (param6)
			{
				param1.htmlText += "<font face=\"" + param4 + "\" color=\"" + param5 + "\" size=\"" + param3 + "\">" + param2 + "</font>";
			}
			else
			{
				param1.htmlText = "<font face=\"" + param4 + "\" color=\"" + param5 + "\" size=\"" + param3 + "\">" + param2 + "</font>";
				(_loc7_ = new TextFormat()).color = MenuConstants.ColorNumber(param5);
				_loc7_.font = param4;
				_loc7_.size = param3;
				param1.defaultTextFormat = _loc7_;
			}
		}
		
		public static function setTextColor(param1:TextField, param2:int):void
		{
			param1.textColor = param2;
			var _loc3_:TextFormat = new TextFormat();
			_loc3_.color = param2;
			param1.defaultTextFormat = _loc3_;
		}
		
		public static function setupTextUpper(param1:TextField, param2:String, param3:int = 28, param4:String = "$medium", param5:String = "#ebebeb", param6:Boolean = false):void
		{
			if (param2 == null)
			{
				param2 = "";
			}
			setupText(param1, param2.toUpperCase(), param3, param4, param5, param6);
		}
		
		public static function setupProfileName(param1:TextField, param2:String, param3:int = 28, param4:String = "$medium", param5:String = "#ebebeb", param6:Boolean = false):void
		{
			if (param2 == null)
			{
				param2 = "";
			}
			setupText(param1, param2, param3, param4, param5, param6);
			CommonUtils.changeFontToGlobalIfNeeded(param1);
			truncateTextfieldWithCharLimit(param1, 1, MenuConstants.PLAYERNAME_MIN_CHAR_COUNT, param5);
			shrinkTextToFit(param1, param1.width, -1);
		}
		
		public static function convertToEscapedHtmlString(param1:String):String
		{
			if (param1 == "" || param1 == null)
			{
				return param1;
			}
			var _loc2_:XML = new XML("<p><![CDATA[" + param1 + "]]></p>");
			return _loc2_.toXMLString();
		}
		
		public static function removeHtmlLineBreaks(param1:String):String
		{
			m_matchHtmlLineBreaks.lastIndex = 0;
			return param1.replace(m_matchHtmlLineBreaks, " ");
		}
		
		public static function truncateTextfield(param1:TextField, param2:int, param3:String = "#ebebeb", param4:Boolean = false):Boolean
		{
			return truncateTextfieldWithCharLimit(param1, param2, 0, param3, param4);
		}
		
		public static function truncateTextfieldWithCharLimit(param1:TextField, param2:int, param3:int = 0, param4:String = "#ebebeb", param5:Boolean = false):Boolean
		{
			var _loc10_:int = 0;
			var _loc11_:int = 0;
			var _loc12_:String = null;
			var _loc13_:int = 0;
			var _loc14_:* = false;
			var _loc15_:String = null;
			var _loc16_:String = null;
			var _loc17_:String = null;
			if (param2 <= 0 || param1.length <= 0)
			{
				return false;
			}
			if (param5)
			{
				CommonUtils.changeFontToGlobalFont(param1);
			}
			var _loc6_:TextFormat = param1.getTextFormat();
			if (Boolean(param4) && param4 != "")
			{
				_loc6_.color = MenuConstants.ColorNumber(param4);
			}
			var _loc7_:Boolean = param1.wordWrap;
			var _loc8_:Boolean;
			if (!(_loc8_ = param1.multiline) || param2 == 1)
			{
				param1.wordWrap = true;
			}
			param1.multiline = true;
			var _loc9_:Boolean = false;
			if (param1.numLines > param2)
			{
				if ((_loc10_ = param1.getLineIndexOfChar(param1.length - 1)) >= param2)
				{
					if ((_loc11_ = param1.getLineOffset(param2) + param1.getLineLength(param2)) < 0)
					{
						_loc11_ = 0;
					}
					_loc13_ = (_loc12_ = param1.text).length;
					if (s_truncator == null || s_truncatorLocale != ControlsMain.getActiveLocale())
					{
						s_truncator = Localization.get("UI_TEXT_TRUNCATOR");
						s_truncatorLocale = ControlsMain.getActiveLocale();
					}
					_loc14_ = false;
					while (!_loc14_ && _loc11_ > 0 && _loc13_ > param3)
					{
						param1.text = "";
						_loc11_--;
						_loc15_ = _loc12_.charAt(_loc11_);
						while (_loc11_ > 0 && (_loc15_ == " " || _loc15_ == "\n" || _loc15_ == "\r"))
						{
							_loc11_--;
							_loc15_ = _loc12_.charAt(_loc11_);
						}
						_loc13_ = (_loc16_ = _loc12_.substring(0, _loc11_ + 1)).length;
						_loc17_ = _loc16_ + s_truncator;
						param1.text = _loc17_;
						param1.setTextFormat(_loc6_);
						_loc14_ = (_loc10_ = param1.getLineIndexOfChar(param1.length - 1)) < param2;
					}
					_loc9_ = true;
				}
			}
			param1.wordWrap = _loc7_;
			param1.multiline = _loc8_;
			return _loc9_;
		}
		
		public static function truncateMultipartTextfield(param1:TextField, param2:String, param3:String, param4:String, param5:uint = 1, param6:String = "#ebebeb", param7:Boolean = false):void
		{
			var _loc12_:int = 0;
			var _loc13_:int = 0;
			var _loc14_:String = null;
			var _loc15_:String = null;
			var _loc16_:String = null;
			var _loc17_:* = false;
			var _loc18_:RegExp = null;
			var _loc19_:String = null;
			var _loc20_:String = null;
			var _loc21_:int = 0;
			var _loc22_:int = 0;
			if (param2.length <= param5 && param3.length <= param5)
			{
				return;
			}
			var _loc8_:int = 1;
			if (param7)
			{
				CommonUtils.changeFontToGlobalFont(param1);
			}
			var _loc9_:TextFormat = param1.getTextFormat();
			if (Boolean(param6) && param6 != "")
			{
				_loc9_.color = MenuConstants.ColorNumber(param6);
			}
			var _loc10_:Boolean = param1.wordWrap;
			var _loc11_:Boolean;
			if (!(_loc11_ = param1.multiline) || _loc8_ == 1)
			{
				param1.wordWrap = true;
			}
			param1.multiline = true;
			if (param1.numLines > _loc8_)
			{
				if ((_loc12_ = param1.getLineIndexOfChar(param1.length - 1)) >= _loc8_)
				{
					if ((_loc13_ = param1.getLineOffset(_loc8_) + param1.getLineLength(_loc8_)) < 0)
					{
						_loc13_ = 0;
					}
					_loc14_ = param1.text;
					param1.text = "";
					param1.htmlText = param2;
					param2 = param1.text;
					param1.htmlText = param3;
					param3 = param1.text;
					_loc15_ = param2;
					_loc16_ = param3;
					if (s_truncator == null || s_truncatorLocale != ControlsMain.getActiveLocale())
					{
						s_truncator = Localization.get("UI_TEXT_TRUNCATOR");
						s_truncatorLocale = ControlsMain.getActiveLocale();
					}
					_loc17_ = false;
					while (!_loc17_)
					{
						_loc18_ = /\S\s*$/;
						if (param2.length > param3.length)
						{
							param2 = param2.substr(0, param2.length - 1);
							if ((_loc21_ = param2.search(_loc18_)) > 0)
							{
								param2 = param2.substring(0, _loc21_ + 1);
							}
							_loc15_ = param2 + s_truncator;
						}
						else
						{
							param3 = param3.substr(0, param3.length - 1);
							if ((_loc22_ = param3.search(_loc18_)) > 0)
							{
								param3 = param3.substring(0, _loc22_ + 1);
							}
							_loc16_ = param3 + s_truncator;
						}
						_loc19_ = _loc15_ + param4 + _loc16_;
						_loc20_ = convertToEscapedHtmlString(_loc19_);
						param1.htmlText = _loc20_;
						param1.setTextFormat(_loc9_);
						_loc17_ = (_loc12_ = param1.getLineIndexOfChar(param1.length - 1)) < _loc8_;
						if (param2.length <= param5 && param3.length <= param5)
						{
							_loc17_ = true;
						}
					}
				}
			}
			param1.wordWrap = _loc10_;
			param1.multiline = _loc11_;
		}
		
		public static function truncateHTMLField(param1:TextField, param2:String, param3:Sprite = null, param4:Boolean = false):void
		{
			if (param4)
			{
				param1.htmlText = "<font face=\"$global\">" + param2 + "</font>";
			}
			else
			{
				param1.htmlText = param2;
			}
			if (s_truncator == null || s_truncatorLocale != ControlsMain.getActiveLocale())
			{
				s_truncator = Localization.get("UI_TEXT_TRUNCATOR");
				s_truncatorLocale = ControlsMain.getActiveLocale();
			}
			var _loc5_:int;
			if ((_loc5_ = getLastVisibleCharacter(param1, param3)) == -1)
			{
				param1.htmlText = "";
				return;
			}
			var _loc6_:String;
			var _loc7_:String = (_loc6_ = param1.text).substr(_loc5_ + 1);
			if ((_loc7_ = StringUtil.trim(_loc7_)).length <= 0)
			{
				return;
			}
			var _loc8_:String = truncateHTMLText(param2, _loc5_, s_truncator, 3);
			if (param4)
			{
				param1.htmlText = "<font face=\"$global\">" + _loc8_ + "</font>";
			}
			else
			{
				param1.htmlText = _loc8_;
			}
		}
		
		public static function truncateHTMLText(param1:String, param2:int, param3:String, param4:int):String
		{
			var strippedString:String = null;
			var currentlyOpenTags:Dictionary = null;
			var contentIndex:int = 0;
			var needsTruncation:Boolean = false;
			var char:String = null;
			var htmlString:String = param1;
			var strLength:int = param2;
			var truncateString:String = param3;
			var truncatePadding:int = param4;
			var finishTag:Function = function(param1:String):void
			{
				isInsideTag = false;
				needsTagFinish = false;
				var _loc2_:* = param1.charAt(1) == "/";
				var _loc3_:Boolean = !_loc2_ && param1.charAt(param1.length - 2) != "/";
				var _loc4_:Boolean = !_loc2_ && !_loc3_;
				var _loc5_:String = "";
				if (_loc3_)
				{
					_loc5_ = param1.substring(1, param1.length - 1);
				}
				else if (_loc2_)
				{
					_loc5_ = param1.substring(2, param1.length - 1);
				}
				var _loc6_:Number = 0;
				if (currentlyOpenTags[_loc5_] != undefined)
				{
					_loc6_ = Number(currentlyOpenTags[_loc5_]);
				}
				if (needsTruncation == false)
				{
					strippedString += param1;
					if (_loc5_ == "br")
					{
						contentIndex += 1;
					}
					if (_loc3_)
					{
						currentlyOpenTags[_loc5_] = _loc6_ + 1;
					}
					else if (_loc2_)
					{
						currentlyOpenTags[_loc5_] = _loc6_ - 1;
						if (currentlyOpenTags[_loc5_] <= 0)
						{
							delete currentlyOpenTags[_loc5_];
						}
					}
				}
				else if (_loc2_ && _loc6_ > 0)
				{
					currentlyOpenTags[_loc5_] = _loc6_ - 1;
					if (currentlyOpenTags[_loc5_] <= 0)
					{
						delete currentlyOpenTags[_loc5_];
					}
					strippedString += param1;
				}
			};
			strLength -= truncatePadding;
			var needsTagFinish:Boolean = false;
			var isInsideTag:Boolean = false;
			strippedString = "";
			var currentTag:String = "";
			currentlyOpenTags = new Dictionary();
			var truncateAdded:Boolean = false;
			contentIndex = 0;
			var i:int = 0;
			while (i < htmlString.length)
			{
				needsTruncation = contentIndex >= strLength;
				if (contentIndex == strLength)
				{
					truncateAdded = true;
					strippedString += truncateString;
					contentIndex += 1;
				}
				if (needsTagFinish)
				{
					finishTag(currentTag);
					currentTag = "";
				}
				char = htmlString.charAt(i);
				if (char == "<")
				{
					isInsideTag = true;
				}
				else if (char == ">")
				{
					needsTagFinish = true;
				}
				if (!isInsideTag && !needsTruncation)
				{
					strippedString += char;
					contentIndex += 1;
				}
				else if (isInsideTag)
				{
					currentTag += char;
				}
				i++;
			}
			if (!truncateAdded)
			{
				strippedString += truncateString;
			}
			if (needsTagFinish)
			{
				finishTag(currentTag);
			}
			return strippedString;
		}
		
		public static function getLastVisibleCharacter(param1:TextField, param2:Sprite = null):int
		{
			var _loc8_:int = 0;
			var _loc9_:int = 0;
			var _loc10_:int = 0;
			var _loc11_:Boolean = false;
			var _loc12_:Rectangle = null;
			var _loc3_:Rectangle = param1.getBounds(param1);
			if (param2 != null)
			{
				param2.graphics.clear();
				param2.graphics.lineStyle(1, 0);
				param2.graphics.drawRect(_loc3_.x, _loc3_.y, _loc3_.width, _loc3_.height);
			}
			var _loc4_:int = -1;
			var _loc5_:int = -1;
			var _loc6_:Rectangle = null;
			var _loc7_:int = 0;
			while (_loc7_ < param1.numLines)
			{
				_loc8_ = param1.getLineOffset(_loc7_);
				_loc9_ = param1.getLineLength(_loc7_);
				_loc10_ = _loc8_;
				while (_loc10_ < _loc8_ + _loc9_)
				{
					_loc11_ = false;
					if ((_loc12_ = param1.getCharBoundaries(_loc10_)) != null)
					{
						_loc12_.x += _loc3_.x;
						_loc12_.y += _loc3_.y;
						_loc12_.height += 5;
						if (_loc3_.containsRect(_loc12_))
						{
							if (_loc6_ == null || _loc7_ > _loc5_)
							{
								_loc11_ = true;
							}
							if (_loc7_ == _loc5_ && _loc12_.x > _loc6_.x)
							{
								_loc11_ = true;
							}
						}
						if (_loc11_)
						{
							_loc5_ = _loc7_;
							_loc4_ = _loc10_;
							_loc6_ = _loc12_;
						}
						if (param2 != null)
						{
							param2.graphics.lineStyle(1, 13421772);
							param2.graphics.drawRect(_loc12_.x, _loc12_.y, _loc12_.width, _loc12_.height);
						}
					}
					_loc10_++;
				}
				_loc7_++;
			}
			if (param2 != null && _loc6_ != null)
			{
				param2.graphics.lineStyle(1, 65280);
				param2.graphics.drawRect(_loc6_.x, _loc6_.y, _loc6_.width, _loc6_.height);
			}
			return _loc4_;
		}
		
		public static function setupTextAndShrinkToFit(param1:TextField, param2:String, param3:int = 28, param4:String = "$medium", param5:Number = 0, param6:Number = 0, param7:Number = 9, param8:String = "#ebebeb", param9:Boolean = false):Boolean
		{
			var _loc14_:TextFormat = null;
			var _loc10_:TextFormat;
			var _loc11_:String = (_loc10_ = param1.getTextFormat()).font;
			var _loc12_:int = int(_loc10_.size);
			var _loc13_:* = param1.text.length > 0;
			setupText(param1, param2, param3, param4, param8, param9);
			_loc10_ = param1.getTextFormat();
			if (_loc13_ && _loc10_.font == _loc11_)
			{
				(_loc14_ = new TextFormat()).size = _loc12_;
				param1.setTextFormat(_loc14_);
			}
			return shrinkTextToFit(param1, param5, param6, param7);
		}
		
		public static function setupTextAndShrinkToFitUpper(param1:TextField, param2:String, param3:int = 28, param4:String = "$medium", param5:Number = 0, param6:Number = 0, param7:Number = 9, param8:String = "#ebebeb", param9:Boolean = false):Boolean
		{
			if (param2 == null)
			{
				param2 = "";
			}
			return setupTextAndShrinkToFit(param1, param2.toUpperCase(), param3, param4, param5, param6, param7, param8, param9);
		}
		
		public static function shrinkTextToFit(param1:TextField, param2:Number, param3:Number, param4:Number = 9, param5:int = -1, param6:Number = 0):Boolean
		{
			var _loc10_:int = 0;
			param4 = Math.max(param4, 1);
			if (param2 > 0)
			{
				param2 = Math.max(1, param2 - 5);
			}
			if (param3 > 0)
			{
				param3 = Math.max(1, param3 - 5);
			}
			var _loc7_:TextFormat = param1.getTextFormat();
			var _loc8_:TextFormat;
			(_loc8_ = new TextFormat()).size = _loc7_.size;
			var _loc9_:Boolean = false;
			while (!_loc9_)
			{
				_loc9_ = true;
				_loc10_ = int(_loc8_.size);
				if (param2 > 0 && param1.textWidth > param2)
				{
					_loc9_ = false;
				}
				else if (param3 > 0 && param1.textHeight > param3)
				{
					_loc9_ = false;
				}
				else if (param5 > 0 && param1.numLines > param5)
				{
					_loc9_ = false;
				}
				if (!_loc9_)
				{
					if (_loc10_ <= param4)
					{
						return false;
					}
					_loc8_.size = _loc10_ - 1;
					if (param6 != 0)
					{
						_loc8_.leading = (_loc10_ - 1) * param6;
					}
					param1.setTextFormat(_loc8_);
				}
			}
			return true;
		}
		
		public static function setBold(param1:Boolean, param2:TextField):void
		{
			var _loc3_:TextFormat = param2.getTextFormat();
			_loc3_.font = param1 ? MenuConstants.FONT_TYPE_BOLD : MenuConstants.FONT_TYPE_NORMAL;
			param2.setTextFormat(_loc3_);
		}
		
		public static function getTimeString(param1:Number):String
		{
			var _loc2_:Number = Math.abs(param1);
			var _loc3_:int = Math.floor(_loc2_ / 60);
			var _loc4_:Number = _loc2_ - _loc3_ * 60;
			var _loc5_:* = "";
			if (_loc3_ < 10)
			{
				_loc5_ += "0";
			}
			_loc5_ += _loc3_.toString();
			var _loc6_:* = "";
			if (_loc4_ < 10)
			{
				_loc6_ += "0";
			}
			_loc6_ += _loc4_.toFixed(3);
			var _loc7_:String = _loc5_ + ":" + _loc6_;
			if (param1 < 0)
			{
				_loc7_ + "-" + _loc7_;
			}
			return _loc7_;
		}
		
		public static function removeWhiteSpaces(param1:String, param2:Boolean = false):String
		{
			var _loc3_:RegExp = param2 ? /^\s*|\s*$/gim : /[\s\r\n]+/gim;
			return param1.replace(_loc3_, "");
		}
		
		public static function useDarkInlineButtonPrompts(param1:TextField):void
		{
			var _loc9_:* = false;
			var _loc10_:int = 0;
			var _loc11_:int = 0;
			var _loc12_:int = 0;
			var _loc13_:String = null;
			var _loc2_:String = "<IMG SRC=\"btn";
			var _loc3_:String = "<IMG SRC=\"dark_btn";
			var _loc4_:String = "key";
			var _loc5_:String;
			if ((_loc5_ = param1.htmlText).length < _loc2_.length)
			{
				return;
			}
			var _loc6_:String = "";
			var _loc7_:int = 0;
			var _loc8_:int = 0;
			while (_loc8_ >= 0)
			{
				_loc9_ = false;
				if ((_loc8_ = _loc5_.indexOf(_loc2_, _loc7_)) >= 0)
				{
					_loc10_ = _loc8_ + _loc2_.length;
					if ((_loc11_ = _loc5_.indexOf("\"", _loc10_)) > _loc10_)
					{
						_loc12_ = _loc11_ - _loc10_;
						_loc9_ = (_loc13_ = _loc5_.substr(_loc10_, _loc12_)).indexOf(_loc4_) >= 0;
					}
					if (!_loc9_)
					{
						_loc6_ = (_loc6_ += _loc5_.substr(_loc7_, _loc8_ - _loc7_)) + _loc3_;
					}
					_loc7_ = _loc8_ + _loc2_.length;
				}
				else if (_loc6_.length > 0)
				{
					_loc6_ += _loc5_.substr(_loc7_);
				}
			}
			if (_loc6_.length > 0)
			{
				param1.htmlText = _loc6_;
			}
		}
		
		public static function centerContained(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number):void
		{
			var _loc6_:Number = Math.min(1, getFillAspectScale(param2, param3, param4, param5));
			var _loc7_:Number = param2 * _loc6_;
			var _loc8_:Number = param3 * _loc6_;
			param1.scaleX = param1.scaleY = _loc6_;
			param1.x = (param4 - _loc7_) / 2;
			param1.y = (param5 - _loc8_) / 2;
		}
		
		public static function centerFill(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number = 1):void
		{
			var _loc7_:Number = param2 * (param4 / param2) * param6;
			var _loc8_:Number = param3 * (param5 / param3) * param6;
			param1.scaleX = param4 / param2 * param6;
			param1.scaleY = param5 / param3 * param6;
			param1.x = (param4 - _loc7_) / 2;
			param1.y = (param5 - _loc8_) / 2;
		}
		
		public static function centerFillAspect(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number):void
		{
			var _loc6_:Number = getFillAspectScale(param2, param3, param4, param5);
			var _loc7_:Number = param2 * _loc6_;
			var _loc8_:Number = param3 * _loc6_;
			param1.scaleX = param1.scaleY = _loc6_;
			param1.x = (param4 - _loc7_) / 2;
			param1.y = (param5 - _loc8_) / 2;
		}
		
		public static function getFillAspectScale(param1:Number, param2:Number, param3:Number, param4:Number):Number
		{
			return Math.min(param3 / param1, param4 / param2);
		}
		
		public static function centerFillAspectFull(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number = 1):void
		{
			var _loc7_:Number = getFillAspectScaleFull(param2, param3, param4, param5) * param6;
			var _loc8_:Number = param2 * _loc7_;
			var _loc9_:Number = param3 * _loc7_;
			param1.scaleX = param1.scaleY = _loc7_;
			param1.x = (param4 - _loc8_) / 2;
			param1.y = (param5 - _loc9_) / 2;
		}
		
		public static function getFillAspectScaleFull(param1:Number, param2:Number, param3:Number, param4:Number):Number
		{
			return Math.max(param3 / param1, param4 / param2);
		}
		
		public static function centerFillAspectHeight(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number = 1):void
		{
			var _loc7_:Number = param5 / param3 * param6;
			var _loc8_:Number = param2 * _loc7_;
			var _loc9_:Number = param3 * _loc7_;
			param1.scaleX = param1.scaleY = _loc7_;
			param1.x = (param4 - _loc8_) / 2;
			param1.y = (param5 - _loc9_) / 2;
		}
		
		public static function setStateIndicatorBgSize(param1:MovieClip, param2:String):void
		{
			param1.header.autoSize = "right";
			param1.header.htmlText = param2;
			var _loc3_:int = int(param1.indicatorBg.width);
			param1.indicatorBg.width = _loc3_ + param1.header.width + 3;
		}
		
		public static function scaleProportionalByWidth(param1:DisplayObject, param2:Number):void
		{
			scaleProportional(param1, param2, param1.width);
		}
		
		public static function scaleProportionalByHeight(param1:DisplayObject, param2:Number):void
		{
			scaleProportional(param1, param2, param1.height);
		}
		
		public static function scaleProportional(param1:DisplayObject, param2:Number, param3:Number):void
		{
			var _loc4_:Number = param2 / param3;
			param1.scaleX *= _loc4_;
			param1.scaleY *= _loc4_;
		}
		
		public static function parsePrompts(param1:Object, param2:Object, param3:Sprite, param4:Boolean = false, param5:Function = null):Object
		{
			var _loc6_:ButtonPromptContainer = null;
			var _loc8_:Boolean = false;
			if (param2 == null && (param1 == null || param1.buttonprompts == null))
			{
				return null;
			}
			if (param1 != null && param1.buttonprompts != null && param2 != null && param2.buttonprompts != null)
			{
				if (param1.controllerType == param2.controllerType && param1.buttonprompts.length == param2.buttonprompts.length)
				{
					if (_loc8_ = isDataEqual(param1.buttonprompts, param2.buttonprompts))
					{
						return param2;
					}
				}
			}
			while (param3.numChildren > 0)
			{
				if ((_loc6_ = param3.getChildAt(0) as ButtonPromptContainer) != null)
				{
					_loc6_.onUnregister();
				}
				param3.removeChildAt(0);
			}
			if (param1 == null)
			{
				return null;
			}
			if (param1.buttonprompts == null)
			{
				return null;
			}
			_loc6_ = new ButtonPromptContainer(param1, param4, param5);
			param3.addChild(_loc6_);
			var _loc7_:Object;
			(_loc7_ = new Object()).buttonprompts = param1.buttonprompts;
			return _loc7_;
		}
		
		public static function setupIcon(param1:MovieClip, param2:String, param3:uint, param4:Boolean, param5:Boolean, param6:uint = 16777215, param7:Number = 1, param8:Number = 0, param9:Boolean = false):void
		{
			var _loc10_:ColorTransform = new ColorTransform();
			if (param9)
			{
				_loc10_.color = param6;
				if (param1.icons_cutout != null || param1.icons_cutout != undefined)
				{
					param1.icons.gotoAndStop(1);
					param1.frame.visible = false;
					param1.bg.visible = false;
					param1.icons_cutout.visible = true;
					param1.icons_cutout.gotoAndStop(param2);
					param1.icons_cutout.transform.colorTransform = _loc10_;
				}
				return;
			}
			_loc10_.color = param3;
			if (param1.icons_cutout != null || param1.icons_cutout != undefined)
			{
				param1.icons_cutout.visible = false;
				param1.icons_cutout.gotoAndStop(1);
			}
			param1.frame.visible = param4;
			param1.frame.transform.colorTransform = _loc10_;
			param1.icons.gotoAndStop(param2);
			param1.icons.transform.colorTransform = _loc10_;
			param1.bg.visible = param5;
			param1.bg.rotation = param8;
			if (param5)
			{
				_loc10_.color = param6;
				_loc10_.alphaMultiplier = param7;
				param1.bg.transform.colorTransform = _loc10_;
			}
		}
		
		public static function setTintColor(param1:Object, param2:int, param3:Boolean = true):void
		{
			var _loc4_:Number = NaN;
			if (!param3)
			{
				_loc4_ = Number(param1.alpha);
			}
			var _loc5_:Color;
			(_loc5_ = new Color()).setTint(MenuConstants.COLOR_GREY_ULTRA_LIGHT, 1);
			switch (param2)
			{
			case TINT_COLOR_BLACK: 
				_loc5_.setTint(MenuConstants.COLOR_BLACK, 1);
				break;
			case TINT_COLOR_GREY: 
				_loc5_.setTint(MenuConstants.COLOR_GREY_DARK, 1);
				break;
			case TINT_COLOR_LIGHT_GREY: 
				_loc5_.setTint(MenuConstants.COLOR_GREY_LIGHT, 1);
				break;
			case TINT_COLOR_NEARLY_WHITE: 
				_loc5_.setTint(MenuConstants.COLOR_GREY_ULTRA_LIGHT, 1);
				break;
			case TINT_COLOR_WHITE: 
				_loc5_.setTint(MenuConstants.COLOR_WHITE, 1);
				break;
			case TINT_COLOR_RED: 
				_loc5_.setTint(MenuConstants.COLOR_RED, 1);
				break;
			case TINT_COLOR_LIGHT_RED: 
				_loc5_.setTint(MenuConstants.COLOR_RED, 1);
				break;
			case TINT_COLOR_REAL_RED: 
				_loc5_.setTint(MenuConstants.COLOR_RED, 1);
				break;
			case TINT_COLOR_DARKER_GREY: 
				_loc5_.setTint(MenuConstants.COLOR_GREY_ULTRA_DARK, 1);
				break;
			case TINT_COLOR_MEDIUM_GREY: 
				_loc5_.setTint(MenuConstants.COLOR_GREY_MEDIUM, 1);
				break;
			case TINT_COLOR_ULTRA_DARK_GREY: 
				_loc5_.setTint(MenuConstants.COLOR_GREY_ULTRA_DARK, 1);
				break;
			case TINT_COLOR_MEDIUM_GREY_3: 
				_loc5_.setTint(MenuConstants.COLOR_GREY_MEDIUM, 1);
				break;
			case TINT_COLOR_GREY_DARK_2: 
				_loc5_.setTint(MenuConstants.COLOR_GREY_DARK, 1);
				break;
			case TINT_COLOR_GREY_DARK_3: 
				_loc5_.setTint(MenuConstants.COLOR_GREY_DARK, 1);
				break;
			case TINT_COLOR_GREEN: 
				_loc5_.setTint(MenuConstants.COLOR_GREEN, 1);
				break;
			case TINT_COLOR_GREEN_LIGHT: 
				_loc5_.setTint(MenuConstants.COLOR_YELLOW, 1);
				break;
			case TINT_COLOR_COLOR_GREY_GOTY: 
				_loc5_.setTint(MenuConstants.COLOR_GREY, 1);
				break;
			case TINT_COLOR_MEDIUM_GREY_GOTY: 
				_loc5_.setTint(MenuConstants.COLOR_GREY_MEDIUM, 1);
				break;
			case TINT_COLOR_SUPER_LIGHT_GREY: 
				_loc5_.setTint(MenuConstants.COLOR_GREY_LIGHT, 1);
				break;
			case TINT_COLOR_GREYBG: 
				_loc5_.setTint(MenuConstants.COLOR_GREY_LIGHT, 1);
				break;
			case TINT_COLOR_YELLOW: 
				_loc5_.setTint(MenuConstants.COLOR_YELLOW, 1);
				break;
			case TINT_COLOR_YELLOW_LIGHT: 
				_loc5_.setTint(MenuConstants.COLOR_YELLOW, 1);
				break;
			case TINT_COLOR_MAGENTA_DARK: 
				_loc5_.setTint(MenuConstants.COLOR_RED, 1);
			}
			param1.transform.colorTransform = _loc5_;
			if (!param3)
			{
				param1.alpha = _loc4_;
			}
		}
		
		public static function removeTint(param1:Object):void
		{
			param1.transform.colorTransform = new Color();
		}
		
		public static function setColor(param1:DisplayObject, param2:uint, param3:Boolean = true, param4:Number = 1):void
		{
			var _loc5_:Number = param1.alpha;
			var _loc6_:ColorTransform;
			(_loc6_ = new ColorTransform()).color = param2;
			_loc6_.alphaMultiplier = param3 ? param4 : _loc5_;
			param1.transform.colorTransform = _loc6_;
		}
		
		public static function removeColor(param1:DisplayObject):void
		{
			param1.transform.colorTransform = new ColorTransform();
		}
		
		public static function getRandomColor():uint
		{
			return Math.random() * 16777215;
		}
		
		public static function hexToMatrix(param1:Number, param2:Number, param3:Number):Array
		{
			var _loc4_:Array;
			return (_loc4_ = (_loc4_ = (_loc4_ = (_loc4_ = []).concat([((param1 & 16711680) >>> 16) / 255, 0, 0, 0, param2])).concat([0, ((param1 & 65280) >>> 8) / 255, 0, 0, param2])).concat([0, 0, (param1 & 255) / 255, 0, param2])).concat([0, 0, 0, param3, 0]);
		}
		
		public static function addDropShadowFilter(param1:*):void
		{
			var _loc2_:TextField = param1 as TextField;
			if (_loc2_ == null && ControlsMain.isVrModeActive())
			{
				return;
			}
			param1.filters = [new DropShadowFilter(2, 45, 0, 0.5, 2, 2, 1, 1)];
		}
		
		public static function removeDropShadowFilter(param1:*):void
		{
			removeFilters(param1);
		}
		
		public static function removeFilters(param1:*):void
		{
			param1.filters = [];
		}
		
		public static function addColorFilter(param1:DisplayObjectContainer, param2:Array):void
		{
			var _loc4_:ColorMatrixFilter = null;
			if (param2.length > 0 && ControlsMain.isVrModeActive())
			{
				return;
			}
			var _loc3_:Array = [];
			var _loc5_:int = 0;
			while (_loc5_ < param2.length)
			{
				_loc4_ = new ColorMatrixFilter(param2[_loc5_]);
				_loc3_.push(_loc4_);
				_loc5_++;
			}
			param1.filters = _loc3_;
		}
		
		public static function setColorFilter(param1:Sprite, param2:String = ""):void
		{
			var _loc4_:ColorMatrixFilter = null;
			var _loc5_:ColorMatrixFilter = null;
			if (ControlsMain.isVrModeActive())
			{
				return;
			}
			var _loc3_:Array = [];
			switch (param2)
			{
			case "selected": 
				_loc4_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_DEFAULT);
				_loc3_.push(_loc4_);
				break;
			case "available": 
				_loc4_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_DEFAULT);
				_loc3_.push(_loc4_);
				break;
			case "locked": 
				_loc4_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_DEFAULT);
				_loc3_.push(_loc4_);
				break;
			case "masterylocked": 
				_loc4_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_NOT_OWNED);
				_loc3_.push(_loc4_);
				break;
			case "shop": 
				_loc5_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_NOT_OWNED);
				_loc3_.push(_loc5_);
				break;
			case "download": 
				_loc5_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_NOT_OWNED);
				_loc3_.push(_loc5_);
				break;
			case "update": 
				_loc5_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_NOT_OWNED);
				_loc3_.push(_loc5_);
				break;
			case "downloading": 
				_loc5_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_NOT_OWNED);
				_loc3_.push(_loc5_);
				break;
			case "installing": 
				_loc5_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_NOT_OWNED);
				_loc3_.push(_loc5_);
				break;
			case "completed": 
				_loc4_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_DEFAULT);
				_loc3_.push(_loc4_);
				break;
			case "notcompleted": 
				_loc4_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_NOT_OWNED);
				_loc3_.push(_loc4_);
				break;
			case "objectivecompleted": 
				_loc5_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_NOT_OWNED);
				_loc3_.push(_loc5_);
				break;
			case "failed": 
				_loc4_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_NOT_OWNED);
				_loc3_.push(_loc4_);
				break;
			case "desaturated": 
				_loc4_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_DESATURATED);
				_loc3_.push(_loc4_);
				break;
			case "markedforremoval": 
				_loc4_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_BW);
				_loc3_.push(_loc4_);
				_loc5_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_DARKENED);
				_loc3_.push(_loc5_);
				break;
			case "unknown": 
				_loc4_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_NOT_OWNED);
				_loc3_.push(_loc4_);
				break;
			default: 
				_loc4_ = new ColorMatrixFilter(MenuConstants.COLOR_MATRIX_DEFAULT);
				_loc3_.push(_loc4_);
			}
			param1.filters = _loc3_;
		}
		
		public static function trySetCacheAsBitmap(param1:DisplayObject, param2:Boolean):void
		{
			if (param1 == null)
			{
				return;
			}
			if (param2 && ControlsMain.isVrModeActive())
			{
				param2 = false;
			}
			param1.cacheAsBitmap = param2;
		}
		
		public static function formatNumber(param1:Number, param2:Boolean = true, param3:uint = 0):String
		{
			var _loc9_:String = null;
			if (s_thousandsSeparator == null || s_thousandsSeparatorLocale != ControlsMain.getActiveLocale())
			{
				s_thousandsSeparator = Localization.get("UI_NUMBER_SEPARATOR_THOUSANDS");
				s_decimalSeparator = Localization.get("UI_NUMBER_SEPARATOR_DECIMALS");
				s_thousandsSeparatorLocale = ControlsMain.getActiveLocale();
			}
			var _loc4_:int;
			if ((_loc4_ = s_thousandsSeparator.length) < 1)
			{
				return String(param1);
			}
			var _loc5_:* = param1 < 0;
			param1 = param1 < 0 ? -param1 : param1;
			var _loc6_:Number = param1;
			param1 >>= 0;
			_loc6_ -= param1;
			var _loc7_:*;
			var _loc8_:Number = ((_loc7_ = String(param1)).length - 1) % 3;
			while (_loc8_ < _loc7_.length - 1)
			{
				_loc7_ = _loc7_.substr(0, _loc8_ + 1) + s_thousandsSeparator + _loc7_.substr(_loc8_ + 1);
				_loc8_ += 3 + _loc4_;
			}
			if (param3 > 0)
			{
				param3 = Math.min(20, param3);
				_loc9_ = _loc6_.toFixed(param3);
				_loc7_ = _loc7_ + s_decimalSeparator + _loc9_.substr(2);
			}
			_loc7_ = _loc5_ ? "-" + _loc7_ : _loc7_;
			if (param2)
			{
				_loc7_ = "<font face=\"$global\">" + _loc7_ + "</font>";
			}
			return _loc7_;
		}
		
		public static function getRandomInRange(param1:Number, param2:Number, param3:Boolean = true):Number
		{
			if (!param3)
			{
				return Math.random() * (param2 - param1) + param1;
			}
			return Math.round(Math.random() * (param2 - param1) + param1);
		}
		
		public static function getRandomBoolean():Boolean
		{
			return Math.random() >= 0.5;
		}
		
		public static function roundDecimal(param1:Number, param2:int):Number
		{
			var _loc3_:Number = Math.pow(10, param2);
			return Math.round(_loc3_ * param1) / _loc3_;
		}
		
		public static function getPointsOnCircleEdge(param1:Number, param2:int, param3:Number = 0):Array
		{
			var _loc5_:Point = null;
			param3 = toRadians(param3);
			var _loc4_:Array = [];
			var _loc6_:int = 0;
			while (_loc6_ < param2)
			{
				_loc4_[_loc6_] = Point.polar(param1, _loc6_ / param2 * PI * 2 + param3);
				_loc6_++;
			}
			return _loc4_;
		}
		
		public static function toDegrees(param1:Number):Number
		{
			return actualRadians(param1) * (180 / PI);
		}
		
		public static function toRadians(param1:Number):Number
		{
			return actualDegrees(param1) * (PI / 180);
		}
		
		public static function actualDegrees(param1:Number):Number
		{
			return denominate(param1, 360);
		}
		
		public static function actualRadians(param1:Number):Number
		{
			return denominate(param1, PI * 2);
		}
		
		public static function denominate(param1:Number, param2:Number):Number
		{
			var _loc3_:Number = param1;
			while (_loc3_ >= param2)
			{
				_loc3_ -= param2;
			}
			while (_loc3_ < -param2)
			{
				_loc3_ += param2;
			}
			return _loc3_;
		}
		
		public static function toPixel(param1:Number):Number
		{
			return MENU_METER_TO_PIXEL * param1;
		}
		
		public static function shuffleArray(param1:Array):Array
		{
			var _loc3_:* = undefined;
			var _loc4_:int = 0;
			var _loc2_:int = int(param1.length);
			while (_loc2_)
			{
				_loc4_ = Math.floor(Math.random() * _loc2_--);
				_loc3_ = param1[_loc2_];
				param1[_loc2_] = param1[_loc4_];
				param1[_loc4_] = _loc3_;
			}
			return param1;
		}
		
		public static function createRefPointItem(param1:Number = 20, param2:int = 16711935):Sprite
		{
			var lineLength:Number = param1;
			var color:int = param2;
			var s:Sprite = new Sprite();
			with (s)
			{
				graphics.beginFill(color, 0.8);
				graphics.drawRect(0, 0, 10, 10);
				graphics.endFill();
				graphics.lineStyle(0.5, color);
				graphics.lineTo(lineLength, 0);
				graphics.moveTo(0, 0);
				graphics.lineTo(0, lineLength);
			}
			return s;
		}
		
		public static function highlitePulsate(param1:Sprite, param2:Boolean):void
		{
			var clip:Sprite = param1;
			var start:Boolean = param2;
			Animate.kill(clip);
			if (start)
			{
				clip.alpha = 0;
				Animate.delay(clip, 2, function():void
				{
					highlitePulsateGo(clip, clip.scaleX, clip.scaleY);
				});
			}
		}
		
		private static function highlitePulsateGo(param1:Sprite, param2:Number, param3:Number):void
		{
			var clip:Sprite = param1;
			var origScaleX:Number = param2;
			var origScaleY:Number = param3;
			clip.alpha = 1;
			Animate.legacyTo(clip, 0.5, {"alpha": 0, "scaleX": origScaleX + 0.2, "scaleY": origScaleY + 0.2}, Animate.SineInOut, function():void
			{
				highlitePulsateDelay(clip, origScaleX, origScaleY);
			});
		}
		
		private static function highlitePulsateDelay(param1:Sprite, param2:Number, param3:Number):void
		{
			var clip:Sprite = param1;
			var origScaleX:Number = param2;
			var origScaleY:Number = param3;
			clip.scaleX = origScaleX;
			clip.scaleY = origScaleY;
			Animate.delay(clip, 2, function():void
			{
				highlitePulsateGo(clip, clip.scaleX, clip.scaleY);
			});
		}
		
		public static function pulsate(param1:Sprite, param2:Boolean):void
		{
		}
		
		private static function pulsateFadeIn(param1:Sprite):void
		{
			Animate.legacyTo(param1, 2, {"alpha": 0.5}, Animate.SineInOut, pulsateFadeOut, param1);
		}
		
		private static function pulsateFadeOut(param1:Sprite):void
		{
			Animate.legacyTo(param1, 2, {"alpha": 0}, Animate.SineInOut, pulsateFadeIn, param1);
		}
		
		public static function getEaseType(param1:String):int
		{
			var _loc2_:int = 0;
			switch (param1)
			{
			case "Linear": 
				_loc2_ = Animate.Linear;
				break;
			case "SineIn": 
				_loc2_ = Animate.SineIn;
				break;
			case "SineOut": 
				_loc2_ = Animate.SineOut;
				break;
			case "SineInOut": 
				_loc2_ = Animate.SineInOut;
				break;
			case "ExpoIn": 
				_loc2_ = Animate.ExpoIn;
				break;
			case "ExpoOut": 
				_loc2_ = Animate.ExpoOut;
				break;
			case "ExpoInOut": 
				_loc2_ = Animate.ExpoInOut;
				break;
			case "BackIn": 
				_loc2_ = Animate.BackIn;
				break;
			case "BackOut": 
				_loc2_ = Animate.BackOut;
				break;
			case "BackInOut": 
				_loc2_ = Animate.BackInOut;
				break;
			default: 
				_loc2_ = Animate.Linear;
			}
			return _loc2_;
		}
		
		public static function isDataEqual(param1:Object, param2:Object):Boolean
		{
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			var _loc5_:String = null;
			var _loc6_:int = 0;
			var _loc7_:String = null;
			if (param1 == null || param2 == null)
			{
				return param1 == param2;
			}
			if (param1 is Number && param2 is Number)
			{
				return param1 == param2;
			}
			if (param1 is Boolean && param2 is Boolean)
			{
				return param1 == param2;
			}
			if (param1 is String && param2 is String)
			{
				return param1 == param2;
			}
			if (param1 is Array && param2 is Array)
			{
				if (param1.length == param2.length)
				{
					_loc3_ = 0;
					while (_loc3_ < param1.length)
					{
						if (!isDataEqual(param1[_loc3_], param2[_loc3_]))
						{
							return false;
						}
						_loc3_++;
					}
					return true;
				}
				return false;
			}
			if (param1 is Object && param2 is Object)
			{
				_loc4_ = 0;
				for (_loc5_ in param1)
				{
					_loc4_++;
					if (!isDataEqual(param1[_loc5_], param2[_loc5_]))
					{
						return false;
					}
				}
				_loc6_ = 0;
				for (_loc7_ in param2)
				{
					_loc6_++;
					if (_loc6_ > _loc4_)
					{
						return false;
					}
				}
				return _loc4_ == _loc6_;
			}
			return false;
		}
	}
}

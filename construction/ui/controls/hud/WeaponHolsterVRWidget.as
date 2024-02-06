package hud
{
	import common.BaseControl;
	import common.ImageLoader;
	import common.menu.MenuConstants;
	import common.menu.MenuUtils;
	import flash.display.MovieClip;
	
	public class WeaponHolsterVRWidget extends BaseControl
	{
		
		public static const LEGALSTATE_CLEAR:int = 0;
		
		public static const LEGALSTATE_SUSPICIOUS:int = 1;
		
		public static const LEGALSTATE_ILLEGAL:int = 2;
		
		private var m_view:WeaponHolsterVRWidgetView;
		
		private var m_primaryLoader:ImageLoader;
		
		private var m_secondaryLoader:ImageLoader;
		
		private var m_currentPrimaryImage:String;
		
		private var m_currentSecondaryImage:String;
		
		public function WeaponHolsterVRWidget()
		{
			super();
			this.m_view = new WeaponHolsterVRWidgetView();
			this.m_view.visible = false;
			addChild(this.m_view);
			this.m_view.iconOnBackPri_mc.stop();
			this.m_view.iconOnBackSec_mc.stop();
			this.m_primaryLoader = new ImageLoader();
			this.m_primaryLoader.visible = false;
			this.m_view.imageHolderPri_mc.addChild(this.m_primaryLoader);
			this.m_secondaryLoader = new ImageLoader();
			this.m_secondaryLoader.visible = false;
			this.m_view.imageHolderSec_mc.addChild(this.m_secondaryLoader);
			MenuUtils.setColor(this.m_view.imageHolderPri_mc, MenuConstants.COLOR_WHITE, true, 1);
			MenuUtils.setColor(this.m_view.imageHolderSec_mc, MenuConstants.COLOR_WHITE, true, 1);
			this.m_view.imageHolderSec_mc.alpha = 0.5;
			this.m_currentPrimaryImage = "";
			this.m_currentSecondaryImage = "";
		}
		
		public function onSetData(param1:Object):void
		{
			if (param1.itemPrimary == null)
			{
				this.m_view.imageHolderPri_mc.visible = false;
				this.setLegalStateIcon(this.m_view.iconPri_mc, 0.46, LEGALSTATE_CLEAR);
				this.setWeaponOnBackIcon(this.m_view.iconOnBackPri_mc, 0.46, false);
			}
			else
			{
				this.m_view.x = param1.itemSecondary == null ? -36 : 0;
				this.m_view.imageHolderPri_mc.visible = true;
				this.setPrimaryWeaponImage(param1.itemPrimary.ridImage);
				if (param1.isPrimaryInHolster)
				{
					this.m_view.imageHolderPri_mc.alpha = 0.8;
					this.setLegalStateIcon(this.m_view.iconPri_mc, 0.46, param1.itemPrimary.legalState);
					this.m_view.iconOnBackPri_mc.x = 70.5;
					this.setWeaponOnBackIcon(this.m_view.iconOnBackPri_mc, 0.46, !!param1.itemPrimary.isLarge ? true : false);
				}
				else
				{
					this.m_view.imageHolderPri_mc.alpha = 0;
					this.setLegalStateIcon(this.m_view.iconPri_mc, 0.46, LEGALSTATE_CLEAR);
					if (param1.itemPrimary.isLarge)
					{
						this.m_view.iconOnBackPri_mc.x = param1.itemSecondary == null ? 36 : 0;
						this.setWeaponOnBackIcon(this.m_view.iconOnBackPri_mc, 0.86, true);
					}
					else
					{
						this.m_view.iconOnBackPri_mc.x = 70.5;
						this.setWeaponOnBackIcon(this.m_view.iconOnBackPri_mc, 0.46, false);
					}
				}
			}
			if (param1.itemSecondary == null)
			{
				this.m_view.imageHolderSec_mc.visible = false;
				this.setLegalStateIcon(this.m_view.iconSec_mc, 0.23, LEGALSTATE_CLEAR);
				this.setWeaponOnBackIcon(this.m_view.iconOnBackSec_mc, 0.23, false);
			}
			else
			{
				this.m_view.imageHolderSec_mc.visible = true;
				this.setSecondaryWeaponImage(param1.itemSecondary.ridImage);
				this.setLegalStateIcon(this.m_view.iconSec_mc, 0.23, param1.itemSecondary.legalState);
				this.setWeaponOnBackIcon(this.m_view.iconOnBackSec_mc, 0.23, true);
			}
		}
		
		public function onHandEnteredHolster():void
		{
			this.m_view.visible = true;
		}
		
		public function onHandExitedHolster():void
		{
			this.m_view.visible = false;
		}
		
		private function setPrimaryWeaponImage(param1:String):void
		{
			if (this.m_currentPrimaryImage != param1)
			{
				this.loadPrimaryImage(param1);
				this.m_currentPrimaryImage = param1;
			}
		}
		
		private function setSecondaryWeaponImage(param1:String):void
		{
			if (this.m_currentSecondaryImage != param1)
			{
				this.loadSecondaryImage(param1);
				this.m_currentSecondaryImage = param1;
			}
		}
		
		private function loadPrimaryImage(param1:String):void
		{
			var MAX_WIDTH:Number;
			var MAX_HEIGHT:Number = NaN;
			var REDUCED_WIDTH:Number = NaN;
			var imagePath:String = param1;
			this.m_primaryLoader.visible = false;
			MAX_WIDTH = 190;
			MAX_HEIGHT = 190;
			REDUCED_WIDTH = 120;
			this.m_primaryLoader.rotation = 0;
			this.m_primaryLoader.scaleX = this.m_primaryLoader.scaleY = 1;
			this.m_primaryLoader.loadImage(imagePath, function():void
			{
				var _loc1_:Boolean = false;
				if (m_primaryLoader.width > m_primaryLoader.height)
				{
					m_primaryLoader.rotation = -90;
					_loc1_ = true;
				}
				m_primaryLoader.width = REDUCED_WIDTH;
				m_primaryLoader.scaleY = m_primaryLoader.scaleX;
				if (m_primaryLoader.height > MAX_HEIGHT)
				{
					m_primaryLoader.height = MAX_HEIGHT;
					m_primaryLoader.scaleX = m_primaryLoader.scaleY;
				}
				m_primaryLoader.x = REDUCED_WIDTH / -2 - m_primaryLoader.width / 2;
				if (_loc1_)
				{
					m_primaryLoader.y = m_primaryLoader.height / 2 + (MAX_HEIGHT - m_primaryLoader.height) / 2;
				}
				else
				{
					m_primaryLoader.y = m_primaryLoader.height / -2 + (MAX_HEIGHT - m_primaryLoader.height) / 2;
				}
				m_primaryLoader.visible = true;
			});
		}
		
		private function loadSecondaryImage(param1:String):void
		{
			var MAX_WIDTH:Number;
			var MAX_HEIGHT:Number = NaN;
			var REDUCED_WIDTH:Number = NaN;
			var imagePath:String = param1;
			this.m_secondaryLoader.visible = false;
			MAX_WIDTH = 140;
			MAX_HEIGHT = 140;
			REDUCED_WIDTH = 88;
			this.m_secondaryLoader.rotation = 0;
			this.m_secondaryLoader.scaleX = this.m_secondaryLoader.scaleY = 1;
			this.m_secondaryLoader.loadImage(imagePath, function():void
			{
				var _loc1_:Boolean = false;
				if (m_secondaryLoader.width > m_secondaryLoader.height)
				{
					m_secondaryLoader.rotation = -90;
					_loc1_ = true;
				}
				m_secondaryLoader.width = REDUCED_WIDTH;
				m_secondaryLoader.scaleY = m_secondaryLoader.scaleX;
				if (m_secondaryLoader.height > MAX_HEIGHT)
				{
					m_secondaryLoader.height = MAX_HEIGHT;
					m_secondaryLoader.scaleX = m_secondaryLoader.scaleY;
				}
				m_secondaryLoader.x = REDUCED_WIDTH / -2 - m_secondaryLoader.width / 2;
				if (_loc1_)
				{
					m_secondaryLoader.y = m_secondaryLoader.height / 2 + (MAX_HEIGHT - m_secondaryLoader.height) / 2;
				}
				else
				{
					m_secondaryLoader.y = m_secondaryLoader.height / -2 + (MAX_HEIGHT - m_secondaryLoader.height) / 2;
				}
				m_secondaryLoader.visible = true;
			});
		}
		
		private function setLegalStateIcon(param1:MovieClip, param2:Number, param3:int):void
		{
			if (param3 != LEGALSTATE_CLEAR)
			{
				param1.gotoAndStop(!!LEGALSTATE_ILLEGAL ? "visarmed" : "susarmed");
				param1.scaleX = param2;
				param1.scaleY = param2;
				param1.visible = true;
			}
			else
			{
				param1.visible = false;
			}
		}
		
		private function setWeaponOnBackIcon(param1:MovieClip, param2:Number, param3:Boolean):void
		{
			if (param3)
			{
				param1.scaleX = param2;
				param1.scaleY = param2;
				param1.visible = true;
				param1.gotoAndPlay(1);
			}
			else
			{
				param1.visible = false;
			}
		}
	}
}

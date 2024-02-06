package menu3
{
   import common.ImageLoader;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public dynamic class Credits extends MenuElementBase
   {
       
      
      private var m_view:CreditsSectionView;
      
      private var m_loader:ImageLoader;
      
      private var COLOR_RED:String;
      
      private var COLOR_GREY_DARK:String;
      
      private var COLOR_WHITE:String;
      
      private var m_height:Number = 0;
      
      public function Credits(param1:Object)
      {
         super(param1);
         this.COLOR_RED = MenuConstants.ColorString(MenuConstants.COLOR_RED);
         this.COLOR_GREY_DARK = MenuConstants.ColorString(MenuConstants.COLOR_GREY);
         this.COLOR_WHITE = MenuConstants.ColorString(MenuConstants.COLOR_GREY_ULTRA_LIGHT);
      }
      
      override public function onSetData(param1:Object) : void
      {
         var _loc2_:TextField = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         super.onSetData(param1);
         this.m_height = 100;
         if(param1.subline != null)
         {
            _loc2_ = new TextField();
            _loc2_.width = 1065;
            _loc2_.height = 20;
            MenuUtils.setupText(_loc2_,param1.subline,param1.breadtext == true ? 18 : 22,MenuConstants.FONT_TYPE_GLOBAL,this.COLOR_GREY_DARK);
            _loc2_.multiline = true;
            _loc2_.wordWrap = true;
            _loc2_.autoSize = TextFieldAutoSize.LEFT;
            this.m_height += _loc2_.textHeight;
         }
         if(param1.images)
         {
            _loc3_ = 100;
            if(param1.subline)
            {
               _loc3_ += this.m_height;
            }
            _loc4_ = 0;
            while(_loc4_ < param1.images.length)
            {
               if(param1.images[_loc4_].paddingTop)
               {
                  _loc3_ += param1.images[_loc4_].paddingTop;
               }
               _loc3_ += param1.images[_loc4_].height + 100;
               _loc4_++;
            }
            this.m_height = Math.max(this.m_height,_loc3_);
         }
         if(param1.credits)
         {
            _loc5_ = this.m_height;
            _loc6_ = 0;
            while(_loc6_ < param1.credits.length)
            {
               _loc7_ = 0;
               while(_loc7_ < param1.credits[_loc6_].names.length)
               {
                  _loc5_ += 25;
                  _loc7_++;
               }
               _loc5_ += 30;
               _loc6_++;
            }
            this.m_height = Math.max(this.m_height,_loc5_);
         }
      }
      
      public function setCreditsVisible(param1:Boolean) : void
      {
         if(this.visible == param1)
         {
            return;
         }
         this.visible = param1;
         if(!param1)
         {
            removeChild(this.m_view);
            this.m_view = null;
         }
         else
         {
            this.createView();
         }
      }
      
      private function createView() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TextField = null;
         var _loc7_:int = 0;
         var _loc8_:TextField = null;
         this.m_view = new CreditsSectionView();
         addChild(this.m_view);
         var _loc1_:Object = getData();
         if(_loc1_.redcategoryheadline == true)
         {
            MenuUtils.setupText(this.m_view.headline_txt,_loc1_.headline,36,MenuConstants.FONT_TYPE_GLOBAL,this.COLOR_RED);
            this.m_view.removeChild(this.m_view.titlesAndNames_mc);
         }
         else
         {
            MenuUtils.setupText(this.m_view.headline_txt,_loc1_.headline,_loc1_.smallerHeadline == true ? 40 : 50,MenuConstants.FONT_TYPE_GLOBAL,this.COLOR_WHITE);
         }
         if(_loc1_.subline)
         {
            MenuUtils.setupText(this.m_view.subline_txt,_loc1_.subline,_loc1_.breadtext == true ? 18 : 22,MenuConstants.FONT_TYPE_GLOBAL,this.COLOR_GREY_DARK);
            this.m_view.subline_txt.multiline = true;
            this.m_view.subline_txt.wordWrap = true;
            this.m_view.subline_txt.autoSize = TextFieldAutoSize.LEFT;
         }
         else
         {
            this.m_view.subline_txt.visible = false;
         }
         this.m_view.separator_mc.visible = _loc1_.separator;
         if(_loc1_.images)
         {
            _loc2_ = 100;
            if(_loc1_.subline)
            {
               _loc2_ += this.m_view.subline_txt.height;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc1_.images.length)
            {
               this.m_loader = new ImageLoader();
               this.m_loader.loadImage(_loc1_.images[_loc3_].img);
               this.m_loader.x = 0;
               if(_loc1_.images[_loc3_].paddingTop)
               {
                  _loc2_ += _loc1_.images[_loc3_].paddingTop;
               }
               this.m_loader.y = _loc2_;
               _loc2_ += _loc1_.images[_loc3_].height + 100;
               this.m_view.addChild(this.m_loader);
               _loc3_++;
            }
         }
         if(_loc1_.credits)
         {
            _loc4_ = 0;
            _loc5_ = 0;
            while(_loc5_ < _loc1_.credits.length)
            {
               (_loc6_ = new TextField()).multiline = false;
               _loc6_.autoSize = TextFieldAutoSize.RIGHT;
               _loc6_.x = 0;
               _loc6_.y = _loc4_;
               MenuUtils.setupText(_loc6_,_loc1_.credits[_loc5_].title,18,MenuConstants.FONT_TYPE_GLOBAL,this.COLOR_RED);
               _loc7_ = 0;
               while(_loc7_ < _loc1_.credits[_loc5_].names.length)
               {
                  (_loc8_ = new TextField()).multiline = false;
                  _loc8_.autoSize = TextFieldAutoSize.LEFT;
                  _loc8_.antiAliasType = AntiAliasType.ADVANCED;
                  _loc8_.x = 10;
                  _loc8_.y = _loc4_;
                  MenuUtils.setupText(_loc8_,_loc1_.credits[_loc5_].names[_loc7_],18,MenuConstants.FONT_TYPE_GLOBAL,this.COLOR_GREY_DARK);
                  this.m_view.titlesAndNames_mc.addChild(_loc8_);
                  _loc4_ += 25;
                  if(_loc1_.credits[_loc5_].checkifonline)
                  {
                     if(_loc1_.credits[_loc5_].names[_loc7_] == undefined || _loc1_.credits[_loc5_].names[_loc7_] == "" || _loc1_.credits[_loc5_].names[_loc7_] == "Anonymous")
                     {
                        this.m_view.titlesAndNames_mc.visible = false;
                     }
                  }
                  _loc7_++;
               }
               this.m_view.titlesAndNames_mc.addChild(_loc6_);
               _loc4_ += 30;
               _loc5_++;
            }
         }
      }
      
      override public function onUnregister() : void
      {
         if(this.m_view)
         {
            removeChild(this.m_view);
            this.m_view = null;
         }
      }
      
      public function getCreditsHeight() : Number
      {
         return this.m_height;
      }
   }
}

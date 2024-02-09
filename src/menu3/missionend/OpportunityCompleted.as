package menu3.missionend
{
   import common.Animate;
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import flash.external.ExternalInterface;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import menu3.MenuElementBase;
   import menu3.MenuImageLoader;
   
   public dynamic class OpportunityCompleted extends MenuElementBase
   {
       
      
      private var m_view:OpportunityCompletedView;
      
      private var m_loader:MenuImageLoader;
      
      private var m_animationXpos:Number;
      
      private var m_flickerCounter:int = 0;
      
      public function OpportunityCompleted(param1:Object)
      {
         super(param1);
         this.m_view = new OpportunityCompletedView();
         addChild(this.m_view);
         this.m_view.image.alpha = 0;
         this.m_animationXpos = this.m_view.header.x;
      }
      
      override public function onUnregister() : void
      {
         this.unloadImage();
         this.killAnimations();
         super.onUnregister();
      }
      
      override public function onSetData(param1:Object) : void
      {
         super.onSetData(param1);
         var _loc2_:String = param1.header != null ? String(param1.header) : "";
         var _loc3_:String = param1.title != null ? String(param1.title) : "";
         var _loc4_:String = String(param1.image);
         MenuUtils.setupTextUpper(this.m_view.header,_loc2_,42,MenuConstants.FONT_TYPE_LIGHT,MenuConstants.FontColorWhite);
         var _loc5_:TextField = this.m_view.title;
         var _loc6_:RegExp = / /g;
         var _loc7_:String = _loc3_.replace(_loc6_,"\n");
         MenuUtils.setupTextUpper(_loc5_,_loc7_,130,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         _loc5_.wordWrap = false;
         MenuUtils.shrinkTextToFit(_loc5_,_loc5_.width,-1);
         var _loc8_:TextFormat = _loc5_.getTextFormat();
         var _loc9_:int = int(_loc8_.size);
         _loc5_.wordWrap = true;
         MenuUtils.setupTextUpper(_loc5_,_loc3_,_loc9_,MenuConstants.FONT_TYPE_BOLD,MenuConstants.FontColorWhite);
         var _loc10_:Number = -0.15;
         if(CommonUtils.getActiveTextLocaleIndex() == 11)
         {
            _loc10_ = 0.01;
         }
         (_loc8_ = _loc5_.getTextFormat()).leading = _loc9_ * _loc10_;
         _loc5_.setTextFormat(_loc8_);
         MenuUtils.shrinkTextToFit(_loc5_,_loc5_.width,_loc5_.height,9,-1,_loc10_);
         this.m_view.header.alpha = 0;
         this.m_view.title.alpha = 0;
         this.loadImage(_loc4_);
      }
      
      private function loadImage(param1:String) : void
      {
         var imagePath:String = param1;
         this.unloadImage();
         if(imagePath == null || imagePath.length == 0)
         {
            return;
         }
         this.m_loader = new MenuImageLoader();
         this.m_loader.center = true;
         this.m_view.image.addChild(this.m_loader);
         this.m_loader.loadImage(imagePath,function():void
         {
            var _loc1_:Object = null;
            var _loc2_:Number = 1;
            _loc2_ = m_loader.width / m_loader.height;
            _loc1_ = m_loader;
            var _loc3_:int = m_view.imagemask.width;
            var _loc4_:int = m_view.imagemask.height;
            _loc1_.width = _loc3_ / m_view.image.scaleX;
            _loc1_.height = _loc3_ / m_view.image.scaleY / _loc2_;
            if(m_view.image.height < _loc4_)
            {
               _loc1_.height = _loc4_ / m_view.image.scaleX;
               _loc1_.width = _loc4_ / m_view.image.scaleY * _loc2_;
            }
            playSound("ui_debrief_achievement_mission_story_complete");
            animateFlicker();
         },null);
      }
      
      public function unloadImage() : void
      {
         if(this.m_loader != null)
         {
            this.m_loader.cancelIfLoading();
            if(this.m_loader.parent != null)
            {
               this.m_loader.parent.removeChild(this.m_loader);
            }
            this.m_loader = null;
         }
      }
      
      public function playSound(param1:String) : void
      {
         ExternalInterface.call("PlaySound",param1);
      }
      
      private function animateIn() : void
      {
         this.killAnimations();
         Animate.fromTo(this.m_view.image,0.2,0,{"alpha":0},{"alpha":1},Animate.ExpoOut);
         Animate.fromTo(this.m_view.header,0.15,0.2,{"alpha":0},{"alpha":1},Animate.ExpoOut);
         Animate.addFromTo(this.m_view.header,0.3,0.2,{"x":this.m_animationXpos - 25},{"x":this.m_animationXpos},Animate.ExpoOut);
         Animate.fromTo(this.m_view.title,0.15,0.4,{"alpha":0},{"alpha":1},Animate.ExpoOut);
         Animate.addFromTo(this.m_view.title,0.4,0.4,{"x":this.m_animationXpos - 25},{"x":this.m_animationXpos},Animate.ExpoOut);
      }
      
      private function animateFlicker() : void
      {
         this.m_flickerCounter += 1;
         if(this.m_flickerCounter <= 4)
         {
            Animate.fromTo(this.m_view.image,0.1,0,{"alpha":0},{"alpha":(this.m_flickerCounter == 4 ? 0 : this.m_flickerCounter * 0.1)},Animate.ExpoOut,this.animateFlicker);
         }
         else
         {
            this.m_flickerCounter = 0;
            this.animateIn();
         }
      }
      
      private function killAnimations() : void
      {
         if(this.m_view != null)
         {
            Animate.kill(this.m_view.image);
            Animate.kill(this.m_view.header);
            Animate.kill(this.m_view.title);
         }
      }
   }
}

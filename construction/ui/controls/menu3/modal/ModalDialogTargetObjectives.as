package menu3.modal
{
   import basic.DottedLine;
   import common.Animate;
   import common.CommonUtils;
   import common.menu.MenuConstants;
   import common.menu.MenuUtils;
   import common.menu.ObjectiveUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import menu3.MenuImageLoader;
   
   public class ModalDialogTargetObjectives extends ModalDialogContainerBase
   {
       
      
      private const TARGET_IMAGE_WIDTH:Number = 693;
      
      private const TARGET_IMAGE_HEIGHT:Number = 517;
      
      private const CONDITION_IMAGE_WIDTH:Number = 315;
      
      private const CONDITION_IMAGE_HEIGHT:Number = 235;
      
      private const CONDITION_ICON_TYPE_WEAPON:String = "weapon";
      
      private const CONDITION_ICON_TYPE_DISGUISE:String = "disguise";
      
      private const CONDITION_TYPE_DEFAULT_KILL:String = "defaultkill";
      
      private const CONDITION_TYPE_CUSTOM_KILL:String = "customkill";
      
      private const CONDITION_TYPE_KILL:String = "kill";
      
      private const CONDITION_TYPE_SET_PIECE:String = "setpiece";
      
      private const CONDITION_TYPE_GAME_CHANGER:String = "gamechanger";
      
      private const CONDITION_TYPE_CUSTOM:String = "custom";
      
      private const CONTRACT_TYPE_MISSION:String = "mission";
      
      private const CONTRACT_TYPE_FLASHBACK:String = "flashback";
      
      private const CONTRACT_TYPE_ELUSIVE:String = "elusive";
      
      private const CONTRACT_TYPE_ESCALATION:String = "escalation";
      
      private const CONTRACT_TYPE_USER_CREATED:String = "usercreated";
      
      private const CONTRACT_TYPE_TUTORIAL:String = "tutorial";
      
      private const CONTRACT_TYPE_CREATION:String = "creation";
      
      private const CONTRACT_TYPE_ORBIS:String = "orbis";
      
      private const CONTRACT_TYPE_FEATURED:String = "featured";
      
      private const CONTRACT_TYPE_INVALID:String = "";
      
      private var m_contractType:String;
      
      private var m_objectiveType:String;
      
      private var m_view:ModalDialogTargetObjectivesTileView;
      
      private var m_scrollingContainer:ModalScrollingContainer;
      
      private var m_scrollPosX:Number;
      
      private var m_scrollPosY:Number;
      
      private var m_scrollWidth:Number;
      
      private var m_scrollHeight:Number;
      
      private var m_headerSeparatorLine:DottedLine;
      
      private var m_targetLoader:MenuImageLoader;
      
      private var m_weaponLoader:MenuImageLoader;
      
      private var m_disguiseLoader:MenuImageLoader;
      
      private var m_objectiveLoader:MenuImageLoader;
      
      private var m_useConditions:Boolean;
      
      private var m_showingConditions:Boolean;
      
      private var m_hasConditions:Boolean = true;
      
      private var m_conditionTitle:String;
      
      private var m_conditionIcon:String;
      
      private var m_conditions:Array;
      
      private var m_hasDescription:Boolean = false;
      
      private var m_infoTitle:String;
      
      private var m_infoIcon:String;
      
      private var m_objectiveTitle:String;
      
      private var m_objectiveIcon:String;
      
      private var m_indicatorTextObjArray:Array;
      
      private var m_anyweapon:String;
      
      private var m_anydisguise:String;
      
      private var m_killWithAnything:String;
      
      private var m_briefingFocus:Boolean;
      
      private var m_isNew:Boolean = false;
      
      private var m_selectButton:Object;
      
      private var m_backButton:Object;
      
      public function ModalDialogTargetObjectives(param1:Object)
      {
         this.m_conditions = [];
         this.m_indicatorTextObjArray = [];
         super(param1);
         m_dialogInformation.IsButtonSelectionEnabled = false;
         m_dialogInformation.AllButtonsClose = false;
         this.m_view = new ModalDialogTargetObjectivesTileView();
         this.m_view.scrollAreaReferenceClip.visible = false;
         addChild(this.m_view);
         this.m_scrollWidth = this.m_view.scrollAreaReferenceClip.width;
         this.m_scrollHeight = this.m_view.scrollAreaReferenceClip.height;
         this.m_scrollPosX = this.m_view.scrollAreaReferenceClip.x;
         this.m_scrollPosY = this.m_view.scrollAreaReferenceClip.y;
         this.m_headerSeparatorLine = new DottedLine(this.m_scrollWidth,MenuConstants.COLOR_WHITE,DottedLine.TYPE_HORIZONTAL,1,2);
         this.m_headerSeparatorLine.name = "m_headerSeparatorLine";
         this.m_headerSeparatorLine.x = this.m_scrollPosX;
         this.m_headerSeparatorLine.y = this.m_scrollPosY - 25;
         this.m_view.addChild(this.m_headerSeparatorLine);
         this.createScrollContainer();
      }
      
      override public function hide() : void
      {
         this.m_scrollingContainer.onUnregister();
         super.hide();
      }
      
      override public function getModalWidth() : Number
      {
         return 1406;
      }
      
      override public function getModalHeight() : Number
      {
         return 517;
      }
      
      override public function onSetData(param1:Object) : void
      {
         var preferDescription:Boolean;
         var descriptionText:String;
         var allConditionsAreAny:Boolean;
         var obj:Object;
         var nonAnyConditions:Array = null;
         var data:Object = param1;
         super.onSetData(data);
         this.m_objectiveType = data.type;
         this.m_contractType = data.objective.contracttype;
         this.m_useConditions = Boolean(data.useconditions) || Boolean(data.objective.displayaskill);
         this.m_briefingFocus = data.objective.briefingfocus;
         this.m_infoTitle = data.infotitle;
         this.m_infoIcon = data.infoicon;
         this.m_conditionTitle = data.conditionstitle;
         this.m_conditionIcon = data.conditionsicon;
         this.m_objectiveTitle = data.objective.title;
         this.m_objectiveIcon = data.objective.icon;
         this.m_anydisguise = data.objective.anydisguise;
         this.m_anyweapon = data.objective.anyweapon;
         this.m_killWithAnything = data.objective.killwithanything;
         preferDescription = Boolean(data.preferdescription);
         descriptionText = null;
         if(Boolean(data.objective.longdescription) && data.objective.longdescription.length > 1)
         {
            descriptionText = String(data.objective.longdescription);
            this.m_hasDescription = true;
         }
         else if(data.description)
         {
            descriptionText = String(data.description);
            this.m_hasDescription = true;
         }
         if(this.m_briefingFocus && !this.m_hasDescription)
         {
            descriptionText = String(data.objective.conditions[0].summary);
            this.m_hasDescription = true;
         }
         if(descriptionText != null)
         {
            this.createDescriptionText(descriptionText);
         }
         if(this.m_useConditions)
         {
            this.m_showingConditions = true;
         }
         this.m_targetLoader = new MenuImageLoader();
         this.m_weaponLoader = new MenuImageLoader();
         this.m_disguiseLoader = new MenuImageLoader();
         this.m_objectiveLoader = new MenuImageLoader();
         this.m_view.targetImage.addChild(this.m_targetLoader);
         this.m_targetLoader.center = false;
         this.m_weaponLoader.center = false;
         this.m_disguiseLoader.center = false;
         this.m_objectiveLoader.center = false;
         this.m_targetLoader.loadImage(data.objective.image,function():void
         {
            m_targetLoader.getImage().smoothing = true;
            MenuUtils.scaleProportionalByHeight(DisplayObject(m_targetLoader.getImage()),TARGET_IMAGE_HEIGHT);
         });
         if(this.m_objectiveType == this.CONDITION_TYPE_KILL || this.m_objectiveType == this.CONDITION_TYPE_DEFAULT_KILL)
         {
            MenuUtils.setupText(this.m_view.targetLabel,this.m_objectiveTitle,28,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
            CommonUtils.changeFontToGlobalIfNeeded(this.m_view.targetLabel);
            MenuUtils.setupIcon(this.m_view.targetIcon,this.m_objectiveIcon,MenuConstants.COLOR_WHITE,true,false);
         }
         else
         {
            this.m_view.targetIcon.visible = false;
         }
         allConditionsAreAny = true;
         if(data.objective.displayaskill)
         {
            this.setConditions(ObjectiveUtil.prepareConditions([]));
         }
         else if(data.objective.conditions)
         {
            nonAnyConditions = ObjectiveUtil.prepareConditions(data.objective.conditions,false);
            if(nonAnyConditions.length > 0)
            {
               allConditionsAreAny = false;
            }
            this.setConditions(ObjectiveUtil.prepareConditions(data.objective.conditions));
         }
         if(this.m_showingConditions && preferDescription && allConditionsAreAny)
         {
            this.m_showingConditions = false;
         }
         this.updateContent();
         obj = new Object();
         obj.buttonprompts = data.displaybuttons;
         this.setButtonPrompts(obj);
      }
      
      private function updateContent() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc1_:Number = 0.1;
         for each(_loc2_ in this.m_conditions)
         {
            Animate.kill(_loc2_.header);
            Animate.kill(_loc2_.title);
            Animate.kill(_loc2_.icon);
            Animate.kill(_loc2_);
         }
         _loc3_ = this.m_conditionTitle;
         _loc4_ = this.m_conditionIcon;
         if(this.m_showingConditions && this.m_hasConditions && !this.m_briefingFocus)
         {
            this.m_scrollingContainer.visible = false;
            for each(_loc2_ in this.m_conditions)
            {
               _loc2_.header.alpha = 0;
               _loc2_.header.x = 30;
               _loc2_.title.alpha = 0;
               _loc2_.title.x = 30;
               _loc2_.method.alpha = 0;
               _loc2_.method.x = 30;
               _loc2_.icon.alpha = 0;
               _loc2_.icon.scaleX = _loc2_.icon.scaleY = 0;
               Animate.delay(_loc2_,_loc1_,this.showCondition,_loc2_,_loc1_);
               _loc1_ += 0.05;
            }
         }
         else if(this.m_hasDescription)
         {
            _loc3_ = this.m_objectiveTitle;
            _loc4_ = this.m_objectiveIcon;
            if(!this.m_briefingFocus)
            {
               if(this.m_objectiveType == this.CONDITION_TYPE_KILL || this.m_objectiveType == this.CONDITION_TYPE_DEFAULT_KILL)
               {
                  _loc3_ = this.m_infoTitle;
                  _loc4_ = this.m_infoIcon;
               }
            }
            this.m_scrollingContainer.visible = true;
            for each(_loc2_ in this.m_conditions)
            {
               _loc2_.visible = false;
            }
         }
         MenuUtils.setupText(this.m_view.infoLabel,_loc3_,28,MenuConstants.FONT_TYPE_MEDIUM,MenuConstants.FontColorWhite);
         MenuUtils.shrinkTextToFit(this.m_view.infoLabel,this.m_scrollWidth - (this.m_view.infoLabel.x - this.m_scrollPosX),-1);
         MenuUtils.setupIcon(this.m_view.infoIcon,_loc4_,MenuConstants.COLOR_WHITE,true,false);
      }
      
      private function setConditions(param1:Array) : void
      {
         var _loc5_:ModalKillCondition = null;
         this.m_indicatorTextObjArray = [];
         var _loc2_:int = this.m_scrollPosX;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new ModalKillCondition();
            this.m_conditions.push(_loc5_);
            _loc5_.x = _loc2_;
            _loc5_.y = this.m_scrollPosY;
            MenuUtils.setupIcon(_loc5_.icon,param1[_loc4_].icon,MenuConstants.COLOR_WHITE,true,false);
            if(param1[_loc4_].type == this.CONDITION_TYPE_KILL || param1[_loc4_].type == this.CONDITION_TYPE_DEFAULT_KILL)
            {
               ObjectiveUtil.setupConditionIndicator(_loc5_,param1[_loc4_],this.m_indicatorTextObjArray,MenuConstants.FontColorWhite);
               this.setConditionImages(param1[_loc4_],_loc5_);
            }
            else
            {
               _loc5_.description.autoSize = TextFieldAutoSize.LEFT;
               _loc5_.description.width = 270;
               _loc5_.description.multiline = true;
               _loc5_.description.wordWrap = true;
               MenuUtils.setupText(_loc5_.description,param1[_loc4_].summary,18,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
               MenuUtils.truncateTextfield(_loc5_.description,9,MenuConstants.FontColorWhite);
               if(param1[_loc4_].type == this.CONDITION_TYPE_SET_PIECE)
               {
                  this.m_hasConditions = false;
                  this.setConditionImages(param1[_loc4_],_loc5_);
               }
               else if(param1[_loc4_].type == this.CONDITION_TYPE_CUSTOM_KILL)
               {
                  this.setConditionImages(param1[_loc4_],_loc5_);
               }
            }
            this.m_view.addChild(_loc5_);
            if(param1[_loc4_].type == this.CONDITION_TYPE_KILL || param1[_loc4_].type == this.CONDITION_TYPE_DEFAULT_KILL)
            {
               _loc2_ += this.CONDITION_IMAGE_WIDTH + (this.m_scrollWidth - this.CONDITION_IMAGE_WIDTH * 2);
            }
            _loc4_++;
         }
      }
      
      private function setConditionImages(param1:Object, param2:ModalKillCondition) : void
      {
         var imgLoader:MenuImageLoader = null;
         var condition:Object = param1;
         var conditionView:ModalKillCondition = param2;
         var defaultImage:String = this.getDefaultImage(condition.icon);
         imgLoader = this.getImageLoader(condition.icon);
         imgLoader.loadImage(!!condition.image ? String(condition.image) : defaultImage,function():void
         {
            imgLoader.getImage().smoothing = true;
            MenuUtils.scaleProportionalByHeight(imgLoader.getImage(),CONDITION_IMAGE_HEIGHT);
         });
         conditionView.image.addChild(imgLoader);
      }
      
      private function showCondition(param1:Object, param2:Number) : void
      {
         param1.visible = true;
         Animate.to(param1.icon,0.25,0,{
            "scaleX":1,
            "scaleY":1,
            "alpha":1
         },Animate.ExpoOut);
         Animate.to(param1.header,0.2,0.05,{
            "alpha":1,
            "x":45
         },Animate.ExpoOut);
         Animate.to(param1.title,0.2,0.1,{
            "alpha":1,
            "x":45
         },Animate.ExpoOut);
         Animate.to(param1.method,0.2,0.1,{
            "alpha":1,
            "x":45
         },Animate.ExpoOut);
      }
      
      private function setButtonPrompts(param1:Object) : void
      {
         if(param1.buttonprompts)
         {
            this.m_selectButton = param1.buttonprompts[0];
            this.m_backButton = param1.buttonprompts[1];
         }
         this.updateButtonPrompts();
      }
      
      override public function updateButtonPrompts() : void
      {
         this.m_view.buttonPrompts.removeChildren();
         this.m_view.selectButtonPrompt.removeChildren();
         var _loc1_:Object = new Object();
         _loc1_.buttonprompts = [this.m_backButton];
         addMouseEventListeners(this.m_view.buttonPrompts,1);
         MenuUtils.parsePrompts(_loc1_,null,this.m_view.buttonPrompts);
         _loc1_.buttonprompts = [this.m_selectButton];
         if(!this.m_hasDescription || !this.m_hasConditions || this.m_briefingFocus)
         {
            this.m_view.selectButtonPrompt.visible = false;
         }
         else
         {
            addMouseEventListeners(this.m_view.selectButtonPrompt,0);
         }
         MenuUtils.parsePrompts(_loc1_,null,this.m_view.selectButtonPrompt);
      }
      
      override public function onButtonPressed(param1:Number) : void
      {
         super.onButtonPressed(param1);
         if(param1 == 0 && this.m_useConditions)
         {
            this.m_showingConditions = !this.m_showingConditions;
            this.updateContent();
         }
      }
      
      private function getImageLoader(param1:String) : MenuImageLoader
      {
         switch(param1)
         {
            case this.CONDITION_ICON_TYPE_WEAPON:
               return this.m_weaponLoader;
            case this.CONDITION_ICON_TYPE_DISGUISE:
               return this.m_disguiseLoader;
            default:
               return this.m_objectiveLoader;
         }
      }
      
      private function getDefaultImage(param1:String) : String
      {
         switch(param1)
         {
            case this.CONDITION_ICON_TYPE_WEAPON:
               return this.m_anyweapon;
            case this.CONDITION_ICON_TYPE_DISGUISE:
               return this.m_anydisguise;
            default:
               return this.m_killWithAnything;
         }
      }
      
      private function createDescriptionText(param1:String) : void
      {
         var _loc2_:TextField = new TextField();
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.width = this.m_scrollWidth;
         _loc2_.multiline = true;
         _loc2_.wordWrap = true;
         _loc2_.selectable = false;
         MenuUtils.setupText(_loc2_,param1,18,MenuConstants.FONT_TYPE_NORMAL,MenuConstants.FontColorWhite);
         CommonUtils.changeFontToGlobalIfNeeded(_loc2_);
         this.m_scrollingContainer.appendEntry(_loc2_,false,_loc2_.height);
      }
      
      private function createScrollContainer() : void
      {
         if(this.m_scrollingContainer != null)
         {
            this.m_view.removeChild(this.m_scrollingContainer);
            this.m_scrollingContainer = null;
         }
         var _loc1_:Number = 30;
         this.m_scrollingContainer = new ModalScrollingContainer(this.m_scrollWidth + _loc1_,this.m_scrollHeight,_loc1_,true,"targetobjectives");
         this.m_view.addChild(this.m_scrollingContainer);
         this.m_scrollingContainer.x = this.m_scrollPosX;
         this.m_scrollingContainer.y = this.m_scrollPosY;
         this.m_scrollingContainer.visible = false;
         addMouseWheelEventListener(this.m_scrollingContainer);
      }
      
      override public function onScroll(param1:Number, param2:Boolean) : void
      {
         super.onScroll(param1,param2);
         this.m_scrollingContainer.scroll(param1,param2);
      }
   }
}

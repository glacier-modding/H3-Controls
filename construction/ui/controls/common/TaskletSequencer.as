package common
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class TaskletSequencer extends Sprite
   {
      
      public static const COMPLETE:String = "complete";
      
      private static var s_evtComplete:Event = new Event(COMPLETE);
      
      private static var s_instance:TaskletSequencer;
       
      
      public var processingTime_ms:Number = 0.25;
      
      public var debug_forceOnlyOneCallPerFrame:Boolean = false;
      
      private const FUNCTION_AVERAGE_LONG_CALL_TIME_MS:Number = 1;
      
      private const m_queueMaxProcessingTime_ms:Number = 50;
      
      private const m_queueMaxProcessingTimeVR_ms:Number = 4;
      
      private var m_nextQueue:Queue;
      
      private var m_stack:Stack;
      
      private var m_isProcessing:Boolean = false;
      
      private var m_nLastUpdateId:int = -1;
      
      public function TaskletSequencer()
      {
         this.m_nextQueue = new Queue();
         this.m_stack = new Stack();
         super();
      }
      
      public static function getGlobalInstance() : TaskletSequencer
      {
         if(s_instance == null)
         {
            s_instance = new TaskletSequencer();
            s_instance.startDaemon();
         }
         return s_instance;
      }
      
      public function addChunk(param1:Function) : void
      {
         this.m_nextQueue.enqueue(param1);
      }
      
      public function clear() : void
      {
         this.m_stack.clear();
         this.m_nextQueue.clear();
      }
      
      public function update() : void
      {
         var actualProcessingTime_ms:Number;
         var currentTime_ms:int;
         var startTime_ms:int;
         var maxTime_ms:int;
         var debug_forceOnlyOneCallPerFrame:Boolean;
         if(this.m_isProcessing || this.m_stack.isEmpty() && this.m_nextQueue.isEmpty())
         {
            return;
         }
         this.m_isProcessing = true;
         actualProcessingTime_ms = Math.max(this.processingTime_ms - this.FUNCTION_AVERAGE_LONG_CALL_TIME_MS,0);
         currentTime_ms = getTimer();
         startTime_ms = currentTime_ms;
         maxTime_ms = currentTime_ms + actualProcessingTime_ms;
         debug_forceOnlyOneCallPerFrame = false;
         if(!this.m_stack.isEmpty() && !this.m_nextQueue.isEmpty())
         {
            while(!this.m_nextQueue.isEmpty())
            {
               this.m_stack.getBottom().enqueue(this.m_nextQueue.dequeue());
            }
         }
         do
         {
            if(!this.m_nextQueue.isEmpty())
            {
               this.m_stack.push(this.m_nextQueue);
               this.m_nextQueue = new Queue();
            }
            if(this.m_stack.isEmpty())
            {
               break;
            }
            try
            {
               this.m_stack.getTop().dequeue()();
            }
            catch(err:Error)
            {
               trace("error in TaskletSequencer chunk --> " + err.getStackTrace());
            }
            if(this.m_stack.getTop().isEmpty())
            {
               this.m_stack.pop();
            }
            currentTime_ms = getTimer();
         }
         while(!(currentTime_ms >= maxTime_ms || debug_forceOnlyOneCallPerFrame));
         
         if(!this.m_nextQueue.isEmpty())
         {
            this.m_stack.push(this.m_nextQueue);
            this.m_nextQueue = new Queue();
         }
         this.m_isProcessing = false;
         if(this.m_stack.isEmpty())
         {
            dispatchEvent(s_evtComplete);
         }
      }
      
      private function startDaemon() : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = ControlsMain.getFrameCount();
         if(this.m_nLastUpdateId == _loc2_)
         {
            return;
         }
         this.m_nLastUpdateId = _loc2_;
         if(ControlsMain.isVrModeActive())
         {
            this.processingTime_ms = this.m_queueMaxProcessingTimeVR_ms;
         }
         else
         {
            this.processingTime_ms = this.m_queueMaxProcessingTime_ms;
         }
         this.update();
      }
   }
}

class Queue
{
    
   
   private var m_functions:Vector.<Function>;
   
   public function Queue()
   {
      this.m_functions = new Vector.<Function>();
      super();
   }
   
   public function enqueue(param1:Function) : void
   {
      this.m_functions.push(param1);
   }
   
   public function dequeue() : Function
   {
      return this.m_functions.shift();
   }
   
   public function isEmpty() : Boolean
   {
      return this.m_functions.length == 0;
   }
   
   public function clear() : void
   {
      this.m_functions.length = 0;
   }
}

class Stack
{
    
   
   private var m_queues:Vector.<Queue>;
   
   public function Stack()
   {
      this.m_queues = new Vector.<Queue>();
      super();
   }
   
   public function push(param1:Queue) : void
   {
      this.m_queues.push(param1);
   }
   
   public function pop() : Queue
   {
      return this.m_queues.pop();
   }
   
   public function getTop() : Queue
   {
      if(this.isEmpty())
      {
         return null;
      }
      return this.m_queues[this.m_queues.length - 1];
   }
   
   public function getBottom() : Queue
   {
      if(this.isEmpty())
      {
         return null;
      }
      return this.m_queues[0];
   }
   
   public function isEmpty() : Boolean
   {
      return this.m_queues.length == 0;
   }
   
   public function clear() : void
   {
      this.m_queues.length = 0;
   }
}

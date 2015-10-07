//+------------------------------------------------------------------+
//|                                                  Heiken Ashi.mq4 |
//|                      Copyright c 2004, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
//| For Heiken Ashi we recommend next chart settings ( press F8 or   |
//| select on menu 'Charts'->'Properties...'):                       |
//|  - On 'Color' Tab select 'Black' for 'Line Graph'                |
//|  - On 'Common' Tab disable 'Chart on Foreground' checkbox and    |
//|    select 'Line Chart' radiobutton                               |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 White
#property indicator_color3 Red
#property indicator_color4 White
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 3
#property indicator_width4 3

extern double thresholdA = 1.3;
extern double thresholdB = 5;
extern int AtrPeriod = 8;

extern int per1 = 5;
extern int m1 = 0;
extern int per2 = 13;
extern int m2 = 0;
extern int per3 = 21;
extern int m3 = 0;
extern int per4 = 34;
extern int m4 = 0;
extern int per5 = 8;
extern int m5 = 0;
extern int per6 = 26;
extern int m6 = 0;
extern int per7 = 19;
extern int m7 = 0;

//----
extern color color1 = Red;
extern color color2 = White;
extern color color3 = Red;
extern color color4 = White;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
//----
int ExtCountedBars=0;
static int barnum;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
int init()
  {
   barnum = Bars;
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM, 0, 1, color1);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM, 0, 1, color2);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM, 0, 3, color3);
   SetIndexBuffer(2, ExtMapBuffer3);
   SetIndexStyle(3,DRAW_HISTOGRAM, 0, 3, color4);
   SetIndexBuffer(3, ExtMapBuffer4);
//----
   SetIndexDrawBegin(0,10);
   SetIndexDrawBegin(1,10);
   SetIndexDrawBegin(2,10);
   SetIndexDrawBegin(3,10);
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexBuffer(3,ExtMapBuffer4);
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {   
   if(barnum!=Bars)
      {
         barnum = Bars;
         start();
         ArrayInitialize(ExtMapBuffer1,EMPTY_VALUE);
         ArrayInitialize(ExtMapBuffer2,EMPTY_VALUE);
         ArrayInitialize(ExtMapBuffer3,EMPTY_VALUE);
         ArrayInitialize(ExtMapBuffer4,EMPTY_VALUE);
      }
   double ran,VALUE1,VALUE2,VALUE3;
   if(Bars<=10) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
   int pos=Bars-ExtCountedBars-1;
   while(pos>=0)
     {
      ran = getMax(pos)-getMin(pos);
      //VALUE1=iATR(NULL,0,AtrPeriod,pos)/MathMax(ran,1*Point);
      //VALUE2= iCustom(NULL,0,"ATRvsMACD",AtrPeriod,0,pos);
      VALUE1 = iCustom(NULL,0,"ZigZag",12,5,3,0,pos);
      VALUE2 = iCustom(NULL,0,"ZigZag",12,5,3,0,pos+1);
      VALUE3 = iCustom(NULL,0,"ZigZag",12,5,3,0,pos-1);
      //if ( (VALUE1!=NULL && VALUE1>VALUE2 && VALUE1>VALUE3) || (VALUE1!=NULL && VALUE1<VALUE2 && VALUE1<VALUE3)) 
      if(VALUE1!=NULL)
       {
         ExtMapBuffer1[pos]=High[pos];
         ExtMapBuffer2[pos]=Low[pos];
        
         ExtMapBuffer3[pos]=Open[pos];
         ExtMapBuffer4[pos]=Close[pos];
       }
 	   pos--;
     }
//----
   return(0);
  }

//+------------------------------------------------------------------+


double getMax(int i){
  double ma1 = iMA(NULL,0,per1,0,m1,0,i);
  double ma2 = iMA(NULL,0,per2,0,m2,0,i);
  double ma3 = iMA(NULL,0,per3,0,m3,0,i);
  double ma4 = iMA(NULL,0,per4,0,m4,0,i);
  double ma5 = iMA(NULL,0,per5,0,m5,0,i);
  double ma6 = iMA(NULL,0,per6,0,m6,0,i);
  double ma7 = iMA(NULL,0,per7,0,m7,0,i);
  double max = MathMax(MathMax(MathMax(ma1,ma2),MathMax(ma3,ma4)),MathMax(ma5,ma6));
  max = MathMax(max,ma7);
   return(max);
}

double getMin(int i){
  double ma1 = iMA(NULL,0,per1,0,m1,0,i);
  double ma2 = iMA(NULL,0,per2,0,m2,0,i);
  double ma3 = iMA(NULL,0,per3,0,m3,0,i);
  double ma4 = iMA(NULL,0,per4,0,m4,0,i);
  double ma5 = iMA(NULL,0,per5,0,m5,0,i);
  double ma6 = iMA(NULL,0,per6,0,m6,0,i);
  double ma7 = iMA(NULL,0,per7,0,m7,0,i);
  double min = MathMin(MathMin(MathMin(ma1,ma2),MathMin(ma3,ma4)),MathMin(ma5,ma6));
  min = MathMin(min,ma7);
   return(min);
}
//+------------------------------------------------------------------+
//|                                                        Bands.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 LightSeaGreen
#property indicator_color2 LightSeaGreen
#property indicator_color3 LightSeaGreen
//---- indicator parameters
extern int    Atr_period=14;
extern int    Band_Period=14;
extern int    LastBar = 1;
extern double BandsDeviations=2.0;
//---- buffers
double MovingBuffer[];
double UpperBuffer[];
double LowerBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,MovingBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,UpperBuffer);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,LowerBuffer);
//----
   SetIndexDrawBegin(0,Band_Period);
   SetIndexDrawBegin(1,Band_Period);
   SetIndexDrawBegin(2,Band_Period);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Bollinger Bands                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k,counted_bars=IndicatorCounted();
   double deviation;
   double sum,oldval,newres;
//----
   if(Bars<=Band_Period) return(0);
//---- initial zero
   if(counted_bars<1)
      for(i=1;i<=Band_Period;i++)
        {
         MovingBuffer[Bars-i]=EMPTY_VALUE;
         UpperBuffer[Bars-i]=EMPTY_VALUE;
         LowerBuffer[Bars-i]=EMPTY_VALUE;
        }
//----
   int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;
//----
   i=Bars-Band_Period+1;
   if(counted_bars>Band_Period-1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      LowerBuffer[i]=High[iHighest(NULL,0,MODE_HIGH,Band_Period,i+LastBar)]-BandsDeviations*iATR(NULL,0,Atr_period,i);
      UpperBuffer[i]=Low[iLowest(NULL,0,MODE_LOW,Band_Period,i+LastBar)]+BandsDeviations*iATR(NULL,0,Atr_period,i);
      MovingBuffer[i] = (UpperBuffer[i]+LowerBuffer[i])/2;
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
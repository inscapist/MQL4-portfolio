//+------------------------------------------------------------------+
//|                                                     Ichimoku.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 SandyBrown
#property indicator_color2 Thistle
#property indicator_color3 Lime
#property indicator_color4 SandyBrown
#property indicator_color5 Thistle
//---- input parameters
extern int    SD_Period=14;
extern int    Band_Period=14;
extern int    LastBar = 1;
extern double BandsDeviations=1.0;
//---- buffers
double UpHis_Buffer[];
double DownHis_Buffer[];
double Middle_Buffer[];
double UpLine_Buffer[];
double DownLine_Buffer[];
//----
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//----
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexBuffer(0,UpHis_Buffer);
   SetIndexDrawBegin(0,Band_Period);
   SetIndexLabel(0,NULL);
   
   SetIndexStyle(3,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(3,UpLine_Buffer);
   SetIndexDrawBegin(3,Band_Period);
   SetIndexLabel(3,"UpLine");
//----
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexBuffer(1,DownHis_Buffer);
   SetIndexDrawBegin(1,Band_Period);
   SetIndexLabel(1,NULL);
   
   SetIndexStyle(4,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(4,DownLine_Buffer);
   SetIndexDrawBegin(4,Band_Period);
   SetIndexLabel(4,"Downline");
//----
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,Middle_Buffer);
   SetIndexLabel(2,"Middle Line");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Ichimoku Kinko Hyo                                               |
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
         UpLine_Buffer[Bars-i]=EMPTY_VALUE;
         UpHis_Buffer[Bars-i]=EMPTY_VALUE;
         DownLine_Buffer[Bars-i]=EMPTY_VALUE;
         DownHis_Buffer[Bars-i]=EMPTY_VALUE;
         Middle_Buffer[Bars-i]=EMPTY_VALUE;
        }
//----
   int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;
//----
   i=Bars-Band_Period+1;
   if(counted_bars>Band_Period-1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      DownLine_Buffer[i]=High[iHighest(NULL,0,MODE_HIGH,Band_Period,i+LastBar)]-BandsDeviations*iStdDev(NULL,0,SD_Period,0,0,0,i);
      DownHis_Buffer[i]=DownLine_Buffer[i]; 
      UpLine_Buffer[i]=Low[iLowest(NULL,0,MODE_LOW,Band_Period,i+LastBar)]+BandsDeviations*iStdDev(NULL,0,SD_Period,0,0,0,i);
      UpHis_Buffer[i]=UpLine_Buffer[i];
      Middle_Buffer[i] = (UpLine_Buffer[i]+DownLine_Buffer[i])/2;
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library bifurcation;

import 'dart:html';
import 'dart:math';
import 'dart:async';

const String ORANGE = "orange";
const int SEED_RADIUS = 1;
const int SCALE_FACTOR = 4;
const num TAU = PI * 2;
const int MAX_X = 480;
const int MAX_Y = 480;
const int MAX_X_PLOT = 500;
const int MAX_Y_PLOT = 520;

///double r = 2.0; /// bifurcation parameter
num initial_r =2.0;
num end_r = 4.0;
num seed_value = 0.5;

//const num centerX = MAX_D / 2;
//const num centerY = centerX;

final InputElement iterations_slider = querySelector("#iterations_slider");
final InputElement r_start_slider = querySelector("#r_start_slider");
final InputElement r_end_slider = querySelector("#r_end_slider");
final InputElement r_seed_slider = querySelector("#r_seed_slider");

final Element notes = querySelector("#notes");
final Element notes1 = querySelector("#notes1");
final Element notes2 = querySelector("#notes2");
final Element notes3 = querySelector("#notes3");
final num PHI = (sqrt(5) + 1) / 2;

final CanvasRenderingContext2D context =
  (querySelector("#canvas") as CanvasElement).context2D;

void main() {
  iterations_slider.onChange.listen((e) => drawLyapunov(0.0));
  r_start_slider.onChange.listen((e) => drawLyapunov(0.0));
  r_end_slider.onChange.listen((e) => drawLyapunov(0.0));
  r_seed_slider.onChange.listen((e) => drawLyapunov(0.0));

    drawLyapunov(0.0);
}

Future sleep1() {
  return new Future.delayed(const Duration(seconds: 1), () => "1");
}

/// Draw the complete figure for the current number of seeds.
void drawLyapunov(num seedOverride) {

  int xmax = MAX_X;
  int ymax = MAX_Y;
  
  context.clearRect(0, 0, MAX_X_PLOT, MAX_Y_PLOT);
  
  int j =0;
  int k = 0;
  int m = 0;
  int n = 0;
  
  num x = 0.0;
  num xplot = 0.0;
  num yplot = 0.0;
  
  

  int iterations = num.parse(iterations_slider.value);
  initial_r = num.parse(r_start_slider.value);
  end_r = num.parse(r_end_slider.value);
  if(seedOverride==0.0)
  {
    seed_value = num.parse(r_seed_slider.value);
  }
  else
  {
    seed_value = seedOverride;  
  
  }
  if(initial_r >= end_r)
  {
    //assume user wants very close ?
    end_r = initial_r+0.05;
    
  }
  
  num r = initial_r;
  
  num x_rrange = (end_r-initial_r);
  num r_step = x_rrange/xmax;
  num eps = 0.0005;
  num sum = 0.0;
  num xeps = 0.0;
  
  num lambda= 0.0;
  
  int cr = 0;
  int cg = 0;
  int cb = 0;
  
  while(r <= end_r)
  {
    // xplot value is the value of scaled to range
    //
    // e.g. start = 2, end = 4
    //
    // r = 2, xplot = 2-2 = 0
    // r = 4, xplot = 4-2 = 2
    
    // x coordinate represents value of r
    //
    xplot = xmax*(r-initial_r)/x_rrange;
    x = seed_value;
    
    xeps = x-eps;
    sum = 0.0;
    
    // calculate lyapunov exponent
   for (j = 0; j < iterations; j++)
   {
     x = r*x*(1.0-x); 
      xeps = x-eps;
       
       xeps = r*xeps*(1.0-xeps);
       num distance = (x-xeps).abs();
       sum += log(distance/eps);
   }

  num lambda = (sum/iterations);/**50;*/
 
   
   // encode the colours

   num lambdafloor = lambda.floor();
   num lambdaremainderGreen = (lambda - lambdafloor)*255;
   num lambdaremainderGreenfloor = lambdaremainderGreen.floor();
   num lambdaremainderBlue = (lambdaremainderGreen-lambdaremainderGreenfloor)*255;
   
   cr = (255 -lambdafloor.abs()).clamp(0, 255);
   cg = (lambdaremainderGreen).clamp(0, 255).floor();
   //cb = (lambdaremainderBlue).clamp(0, 255).floor();
   
   cb = 0;

   
   
   for (k = 1; k < iterations; k++)
    {
       x = r*x*(1.0-x); 
       
       
       yplot = ymax * (1.0-x);
       m = xplot.floor();
       
       n = yplot.floor();
       
       // colour is set by lyapunov exponent
       //xeps = x-eps;
              
       // xeps = r*xeps*(1.0-xeps);
       // num distance = (x-xeps).abs();
      //  sum += log(distance/eps);
       // num lambda = (sum/k);
        
       // num lambdafloor = lambda.floor();
       //  num lambdaremainderGreen = (lambda - lambdafloor)*255;
       //  num lambdaremainderGreenfloor = lambdaremainderGreen.floor();
      //   num lambdaremainderBlue = (lambdaremainderGreen-lambdaremainderGreenfloor)*255;
         
      //   cr = (255 -lambdafloor.abs()).clamp(0, 255);
      //   cg = (255-lambdaremainderGreen).clamp(0, 255).floor();
      //   cb = (255-lambdaremainderBlue).clamp(0, 255).floor();
         
         //cb = 0;
       
       drawPixel(m,n,cr,cg,cb);
    }
   
   // increment r in value no less than xcoord on screen!
   //
   r += r_step; 

  }
  
    
  notes.text = "bifurcation iterations : ${iterations} ";
  notes1.text = "rStart : ${initial_r}";
  notes2.text = " rEnd : ${end_r}";
  notes3.text = " rSeed : ${seed_value}";
  
  drawXaxisLabels(1,2);
    
  
}

/// Draw a small circle representing a seed centered at (x,y).
void drawPixel(num x, num y, int r, int g, int b) {
  context..beginPath()
         ..lineWidth = 1
         ..setStrokeColorRgb(r,g,b,1.0)
         ..strokeRect(x,y,SEED_RADIUS,SEED_RADIUS)
         ..fill()
         ..closePath()
         ..stroke();
}

/// Draw a small circle representing a seed centered at (x,y).
void drawXaxisLabels(num xstart, num xend) {
  drawXaxis();
  
    //num initial_r = 3.5;
    //num end_r = 4.0;
    num x_rrange = (end_r-initial_r);
    num rdrawstep = (x_rrange/10);
    
    for(num r=initial_r; r<=end_r;r+=rdrawstep)
    {
        num xplot = MAX_X*(r-initial_r)/x_rrange;
        drawXaxisTick(xplot);
        drawXaxisValue(xplot,r.toStringAsPrecision(3));
    }
  
}

void drawXaxis() {
  context..beginPath()
         ..lineWidth = 2
         ..setStrokeColorRgb(0,0,0,1.0)
         
         ..strokeRect(0,MAX_Y_PLOT-20,MAX_X,2)
         ..fill()
         ..closePath()
         ..stroke();
}

void drawXaxisTick(num xoffset) {

  context..beginPath()
         ..lineWidth = 2
         ..setStrokeColorRgb(0,0,0,1.0)
         
         ..strokeRect(xoffset,MAX_Y_PLOT-20,2,10)
         ..fill()
         ..closePath()
         ..stroke();
}

void drawXaxisValue(num xoffset, String xvalue) {
  //String xval = xvalue.toString();
  //context..beginPath()
  //         ..lineWidth = 2
  //         ..setStrokeColorRgb(0,255,255,1.0)
  //         ..fillText(xval, xoffset, MAX_Y_PLOT, xval.length());
  String line = "test";
  context..lineWidth = 1
           ..strokeStyle = "black"
           ..strokeText(xvalue, xoffset, MAX_Y_PLOT);
           //..fillStyle = "white"
           //..fillText(line, xvalue, MAX_Y_PLOT);
}



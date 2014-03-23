// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library bifurcation;

import 'dart:html';
import 'dart:math';

const String ORANGE = "orange";
const int SEED_RADIUS = 1;
const int SCALE_FACTOR = 4;
const num TAU = PI * 2;
const int MAX_X = 600;
const int MAX_Y = 600;
const num centerX = MAX_D / 2;
const num centerY = centerX;

final InputElement iterations_slider = querySelector("#iterations_slider");

final Element notes = querySelector("#notes");
final num PHI = (sqrt(5) + 1) / 2;

final CanvasRenderingContext2D context =
  (querySelector("#canvas") as CanvasElement).context2D;

void main() {
  iterations_slider.onChange.listen((e) => drawLyapunov());
  drawLyapunov();
}

/// Draw the complete figure for the current number of seeds.
void drawLyapunov() {

  int xmax = MAX_X;
  int ymax = MAX_Y;
  
  context.clearRect(0, 0, MAX_X, MAX_Y);
  
  int j =0;
  int k = 0;
  int m = 0;
  int n = 0;
  
  num x = 0.0;
  num xplot = 0.0;
  num yplot = 0.0;
  
  
  
  ///double r = 2.0; /// bifurcation parameter
  num initial_r = 2.0;
  num end_r = 4.0;
  
  num seed_value = 0.5;
  num r = initial_r;
  
  num x_rrange = (end_r-initial_r);
  
  int iterations = num.parse(iterations_slider.value);
  
  while(r <= end_r)
  {
    // xplot value is the value of scaled to range
    //
    // e.g. start = 2, end = 4
    //
    // r = 2, xplot = 2-2 = 0
    // r = 4, xplot = 4-2 = 2
    
    xplot = xmax*(r-initial_r)/x_rrange;
    x = seed_value;
    num eps = 0.0005;
    num xeps = x-eps;
    num sum = 0.0;
    
    // calculate lyapunov exponent
   for (j = 0; j < iterations; j++)
   {
      x = r*x*(1.0-x); 
      xeps = x-eps;
       
       xeps = r*xeps*(1.0-xeps);
       num distance = (x-xeps).abs();
       sum += log(distance/eps);
   }
   num lambda1 = (sum/iterations);
   num lambda = (sum/iterations);
   
   int cr = 0;
   int cg = 0;
   
   if(lambda < 0)
   {
    cr = 255;
   }
   else
   {
     cg = 255;
   }

   int cb = 0;
   
   for (k = 0; k < iterations; k++)
    {
       x = r*x*(1.0-x); 
       
       
       
       yplot = ymax * (1.0-x);
       m = xplot.round();
       
       n = yplot.round();
       
       // colour is set by lyapunov exponent
       
       
       drawPixel(m,n,cr,cg,cb);
    }
    
   r += 0.0005;
    
  }
  
    
  notes.text = "bifurcation iterations : ${iterations} ";
}

/// Draw a small circle representing a seed centered at (x,y).
void drawPixel(num x, num y, int r, int g, int b) {
  context..beginPath()
         ..lineWidth = 2
         ..setStrokeColorRgb(r,g,b,1.0)
         ..strokeRect(x,y,SEED_RADIUS,SEED_RADIUS)
         ..fill()
         ..closePath()
         ..stroke();
}

///void drawLine(num x1, num y1, int r, int g, int b) {
///  context..beginPath()
///         ..lineWidth = 2
 ///        ..setStrokeColorRgb(r,g,b,1.0)
 ///        ..strokeRect(x,y,SEED_RADIUS,SEED_RADIUS)
 ///        ..fill()
  ///       ..closePath()
  ///       ..stroke();
///}

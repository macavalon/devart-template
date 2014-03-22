// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library sunflower;

import 'dart:html';
import 'dart:math';

const String ORANGE = "orange";
const int SEED_RADIUS = 2;
const int SCALE_FACTOR = 4;
const num TAU = PI * 2;
const int MAX_D = 300;
const num centerX = MAX_D / 2;
const num centerY = centerX;

final InputElement slider = querySelector("#slider");
final Element notes = querySelector("#notes");
final num PHI = (sqrt(5) + 1) / 2;
int seeds = 0;
final CanvasRenderingContext2D context =
  (querySelector("#canvas") as CanvasElement).context2D;

void main() {
  slider.onChange.listen((e) => draw());
  draw();
}

/// Draw the complete figure for the current number of seeds.
void draw() {
  seeds = int.parse(slider.value);
  context.clearRect(0, 0, MAX_D, MAX_D);
  for (var i = 0; i < seeds; i++) {
    final num theta = i * TAU / PHI;
    final num r = sqrt(i) * SCALE_FACTOR;
    
    num offsetX = r * cos(theta);
    num offsetY = r * sin(theta);
    num x = centerX + offsetX;
    num y = centerY - offsetY;
    
    ///
    /// define colour components
    /// graduate colour
    /// distance from centre sets colour
    int cr =  (r.toInt()*SCALE_FACTOR).remainder(255);
    
    /// propotion to angle
    int cg =  theta.remainder(255).toInt();
    int cb = 255-cg;
    
    drawSeed(x,y,cr,cg,cb);
  }
  notes.text = "${seeds} seeds";
}

/// Draw a small circle representing a seed centered at (x,y).
void drawSeed(num x, num y, int r, int g, int b) {
  context..beginPath()
         ..lineWidth = 2
         ///..fillStyle = ORANGE
         ///..strokeStyle = ORANGE
         ///..setFillColorRgb(155, 155, 155,0.5)
         ..setStrokeColorRgb(r,g,b,1.0)
         ///..arc(x, y, SEED_RADIUS, 0, TAU, false)
         ..strokeRect(x,y,SEED_RADIUS,SEED_RADIUS)
         ..fill()
         ..closePath()
         ..stroke();
}

The first thing that stood out with the initial prototype [1st Bifurcation Test](http://macavalon.com/devart/1stBifurcationTest/bifurcationtest.html "1st Bifurcation Test]")
was how slow it was.
I reviewed the code and realised it could be improved by only calculating the logistic equations rate(r) variable, for the number of pixels on the x-axis.
I had been using a much lower step value than needed!

After this I thought, how can I better colour the value of Lyapunov Exponent value.
I decided to interpret the whole number part as the RED component, and the fraction multiplied by 255 to get GREEN component.
With the BLUE component left at zero.

I think the results speak for themselves!
[Properly Coloured Bifurcation Test](http://macavalon.com/devart/2ndBifurcationTest/bifurcationtest.html "Properly Coloured Bifurcation Test")
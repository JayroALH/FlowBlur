# FlowBlur
Directional Blur using the direction given by a normal map



I love the directional Blur effect, its in a lot of image editing software but it has a pretty big limitation. it only works in one direction (Not the band)

Lets see an example

From this image
![A gray circle](https://cloud.githubusercontent.com/assets/22602582/20998440/763df84e-bcd3-11e6-9825-deec13917707.png)

We can get to this image using a directional blur
![A directional blurred blurred gray circle](https://cloud.githubusercontent.com/assets/22602582/20998442/7838afc2-bcd3-11e6-93ca-3e1d39446264.png)

Directional blur takes only 2 parameters direction and lenght.
But that is not enought for me. So i wrote this pixel shader in order to be able to change the direction of the blur in a Flow map file


A flow map is nothing more than a normal map. you can make your own flow maps in photoshop following this article 
http://polycount.com/discussion/98983/how-to-paint-flow-anisotropic-comb-maps-in-photoshop

As you may know a normalmap is just a map where the RGB components are used as vectors,

Red is the X direction
Green is the Y direction (Note: Depending on the format of your normalmap the value of this component changes. More details below)
Blue is the Z direction 

![A Simple flow map made in 10 seconds ](https://cloud.githubusercontent.com/assets/22602582/20998436/709fe758-bcd3-11e6-8415-d192f911b02e.png)

Here is where the magic happens:

 For each pixel of the map we simply sample on current possition on the flow map and the texture file and we sum the color from the texture to an acumulator
 
Now some simple mathematics are used to convert the flow map colors from a [0 1] range to a [-1 1] range and multiply for the distance.
Using this value as a displacement we add the displacement o a vector2 sum

Then we add the displacement to the current texture coordinates and we go back to the start.


Doing all that we get this
![A Simple flow map made in 10 seconds ](https://cloud.githubusercontent.com/assets/22602582/20998448/7fe1ea40-bcd3-11e6-8f3e-a2e7b429e1a6.png)

I apologize for using such boring images but is 4 am as i wrote this code and i just want to share this. Tomorrow after some coffe i will try to upload a better exaple 
(For more details see inside the FlowBlur.fx coments) 

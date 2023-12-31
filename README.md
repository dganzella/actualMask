# actualMask
adds the ability to set an actual image Mask on Playdate -- works similar to masking in unity/cocos/photoshop and I guess most softwares that use masks
## installation

just copy source/actualMask.lua in your project, or the code below

```lua
function setAnActualMaskToImage(image, mask)
	gfx.pushContext(image:getMaskImage())
	gfx.setImageDrawMode(gfx.kDrawModeWhiteTransparent)
	mask:draw(0, 0)
	gfx.popContext()
end
```

Source: https://devforum.play.date/t/stencil-buffer-setstencilimage-throws-wrong-error-has-inconsistent-documentation/11877/9

## problem
although playdate SDK images support image masking with the method [setMaskImage](https://sdk.play.date/inside-playdate/#m-graphics.image.setMaskImage), there seems to be a problem -- it will override the resulting masked-image with black even if the souce of the image is transparent

<img alt="logic" src="readmeImgs/logic.png" width="384" height="336">

## using stencil

a solution to this issue is to use [setStencilImage](https://sdk.play.date/inside-playdate/#f-graphics.setStencilImage), but stencil has its quirks

- It has a bug -- It will throw a size error if the stencil image has any transparency, while masks treat transparency same as black (do not draw)
- Stencils must be at least 32x32, which may make you create an entire separate imagetable library just for them, if your sprites are smaller. And because of the size difference, positioning offset may need to be manually added
- If using sprites, I would need to override all drawing functions of all sprites that use images that have masks to use the stencil buffer, which would lead to more unecessary code

## explanation

let's start by having a simple 16x16 stickman being drawn in front of a diagonal pattern

<img alt="stickman" src="readmeImgs/image8.png" width="200" height="200">

```lua
img = gfx.image.new('assets/images/stickman')

function playdate.update()
	gfx.setDitherPattern(.5, gfx.image.kDitherTypeDiagonalLine)
	gfx.fillRect(0, 0, 100, 100)
	img:draw(42, 42)
end
```


<img alt="initialSituation" src="readmeImgs/image.png" width="200" height="200">

Simple and clean. Now Lets try to add a mask to it that will cover only the top 8 rows of the stickman -- their head. Remember that white means draw, black means do not draw.

<img alt="mask" src="readmeImgs/image9.png" width="200" height="200">


```lua
mask = gfx.image.new('assets/images/mask')
img:setMaskImage(mask)
```

<img alt="wtf" src="readmeImgs/image2.png" width="200" height="200">

So what happened? Although the body and feet from the stickman are not drawn as expected, there is now a black background besides the head! We do not want that, since the source image did not have any pixels set there.

Why does this happen? No Idea. But thats not what I expect from masking at all, that is for sure.

Now lets use the magic function setAnActualMaskToImage

```lua
mask = gfx.image.new('assets/images/mask')
setAnActualMaskToImage(img, mask)
```

<img alt="correct" src="readmeImgs/image3.png" width="200" height="200">

Awesome! this is how masks are supposed to work!

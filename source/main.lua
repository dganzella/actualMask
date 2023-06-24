--CoreLibs
import 'CoreLibs/graphics'
import 'CoreLibs/object'

import 'actualMask'

gfx = playdate.graphics

gfx.sprite.setAlwaysRedraw(true)
playdate.display.setRefreshRate(30)

img = gfx.image.new('assets/images/stickman')
mask = gfx.image.new('assets/images/mask')

setAnActualMaskToImage(img, mask)

---@diagnostic disable-next-line: duplicate-set-field
function playdate.update()
	gfx.setDitherPattern(.5, gfx.image.kDitherTypeDiagonalLine)
	gfx.fillRect(0, 0, 100, 100)

	img:draw(42, 42)
end

function setAnActualMaskToImage(image, mask)
	gfx.pushContext(image:getMaskImage())
	gfx.setImageDrawMode(gfx.kDrawModeWhiteTransparent)
	mask:draw(0, 0)
	gfx.popContext()
end

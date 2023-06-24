function setAnActualMaskToImage(image, mask)
	local maskCopy = mask:copy()

	gfx.pushContext(maskCopy)
	gfx.setImageDrawMode(gfx.kDrawModeFillBlack)
	image:draw(0, 0)
	gfx.setImageDrawMode(gfx.kDrawModeXOR)
	mask:draw(0, 0)
	gfx.popContext()

	image:setMaskImage(maskCopy)
end

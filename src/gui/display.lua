local Display = class('Display')

function Display:initialize()
	local styles = ikkuna.Styles:new()
	styles:loadFile('src/res/theme.css')

	self.root = ikkuna.Widget:new()

	local width, height = love.graphics.getDimensions()
	self.root:setExplicitSize(width, height)

	local child = ikkuna.Widget:new()
	child:setExplicitSize(100, 100)
	child.onClick:connect(function() print('onClick()') return true end)
	child.onDoubleClick:connect(function() print('onDoubleClick()') return true end)
	child.onDragStart:connect(function() print('onDragStart()') return true end)
	child.onDragMove:connect(function() print('onDragMove()') return true end)
	child.onDragEnd:connect(function() print('onDragEnd()') return true end)
	child.onResize:connect(function() print('onResize()') end)
	child.onHoverChange:connect(function(widget, hovered) return true end)
	self.root:addChild(child)

	self.draggingWidget = nil
	self.hoveredWidget = nil
	self.focusedWidget = nil
end

function Display:update(delta)
	self.root:update(delta)
end

function Display:draw()
	self.root:draw()
end

function Display:onResize(width, height)
	self.root:setExplicitSize(width, height)
end

function Display:onKeyPressed(key, code, repeated)
	return self.root:onKeyPressed(key, code, repeated)
end

function Display:onKeyReleased(key, code)
	return self.root:onKeyReleased(key, code, repeated)
end

function Display:onMousePressed(x, y, button, touch, presses)
	local widget = self.root:getChildAt(x, y)
	if widget then
		local result = widget:onMousePressed(x, y, button, touch, presses)
		if result then
			if widget.dragging then
				self.draggingWidget = widget
			end

			if widget ~= self.focusedWidget then
				if self.focusedWidget then
					self.focusedWidget.onFocusChange:emit(self.focusedWidget, false)
					self.focusedWidget = nil
				end

				if widget.focusable then
					self.focusedWidget = widget
					self.focusedWidget.onFocusChange:emit(self.focusedWidget, true)
				end
			end
		end

		return result
	end

	return false
end

function Display:onMouseReleased(x, y, button, touch, presses)
	if self.draggingWidget then
		return self.draggingWidget:onMouseReleased(x, y, button, touch, presses)
	end

	local widget = self.root:getChildAt(x, y)
	if widget then
		return widget:onMouseReleased(x, y, button, touch, presses)
	end

	return false
end

function Display:onMouseMoved(x, y, dx, dy, touch)
	if self.draggingWidget then
		return self.draggingWidget:onMouseMoved(x, y, dx, dy, touch)
	end

	local widget = self.root:getChildAt(x, y)
	if self.hoveredWidget and (not widget or widget ~= self.hoveredWidget) then
		self.hoveredWidget:setHovered(false)
		self.hoveredWidget = nil
	end

	if widget then
		if widget:onMouseMoved(x, y, dx, dy, touch) then
			local result = widget:setHovered(true)
			if result then
				self.hoveredWidget = widget
			end

			return result
		end
	end

	return false
end

ikkuna.Display = Display

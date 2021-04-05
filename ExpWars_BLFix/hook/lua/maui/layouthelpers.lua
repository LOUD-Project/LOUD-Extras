
---- MORE LAYOUT HELPERS, BY MANIMAL
function AtBottomHorizontalCenterIn(control, parent, offset)
    offset = offset or 0
    control.Bottom:Set(function() return math.floor(parent.Bottom() - (offset * pixelScaleFactor)) end)
    control.Left:Set(
        function()
            return math.floor(parent.Left() + (((parent.Width() / 2) - (control.Width() / 2)) + (offset * pixelScaleFactor)))
        end)
end

---- MORE LAYOUT HELPERS, BY MANIMAL
function AtTopHorizontalCenterIn(control, parent, offset)
    offset = offset or 0
    control.Top:Set(function() return math.floor(parent.Top() + (offset * pixelScaleFactor)) end)
    control.Left:Set(
        function()
            return math.floor(parent.Left() + (((parent.Width() / 2) - (control.Width() / 2)) + (offset * pixelScaleFactor)))
        end)
end

---- MORE LAYOUT HELPERS, BY MANIMAL
function AtLeftVerticalCenterIn(control, parent, offset)
    offset = offset or 0
    control.Left:Set(function() return math.floor(parent.Left() + (offset * pixelScaleFactor)) end)
    control.Top:Set(
        function()
            return math.floor(parent.Top() + (((parent.Height() / 2) - (control.Height() / 2)) + (offset * pixelScaleFactor)))
        end)
end

---- MORE LAYOUT HELPERS, BY MANIMAL
function AtRightVerticalCenterIn(control, parent, offset)
    offset = offset or 0
    control.Right:Set(function() return math.floor(parent.Right() - (offset * pixelScaleFactor)) end)
    control.Top:Set(
        function()
            return math.floor(parent.Top() + (((parent.Height() / 2) - (control.Height() / 2)) + (offset * pixelScaleFactor)))
        end)
end

---- MORE LAYOUT HELPERS, BY MANIMAL
function AtLeftBottomIn(control, parent, leftOffset, bottomOffset)
    leftOffset = leftOffset or 0
    bottomOffset = bottomOffset or 0
    control.Left:Set(function() return math.floor(parent.Left() + (leftOffset * pixelScaleFactor)) end)
    control.Bottom:Set(function() return math.floor(parent.Bottom() - (bottomOffset * pixelScaleFactor)) end)
end

---- MORE LAYOUT HELPERS, BY MANIMAL
function AtRightBottomIn(control, parent, rightOffset, bottomOffset)
    rightOffset = rightOffset or 0
    bottomOffset = bottomOffset or 0
    control.Right:Set(function() return math.floor(parent.Right() - (rightOffset * pixelScaleFactor)) end)
    control.Top:Set(function() return math.floor(parent.Top() + (bottomOffset * pixelScaleFactor)) end)
end

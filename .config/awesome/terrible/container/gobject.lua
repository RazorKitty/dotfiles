---------------------------------------------------------------------------
--- a container that binds a GObject.Object to a widget
--
-- @author RazorKitty
-- @classmod terrible.container.gobject
---------------------------------------------------------------------------
local lgi = require('lgi')
local gtable = require('gears.table')
local base = require('wibox.widget.base')
local wibox = require('wibox')

local gobject = { mt = {} }


function gobject.set_widget(self, widget)
    if widget then
        base.check_widget(widget)
    end
    self._private.widget = widget
    self:emit_signal("widget::layout_changed")
end

function gobject.get_widget(self)
    return self._private.widget
end


function gobject.get_children(self)
    return {self._private.widget}
end

function gobject.set_children(self, children)
    assert(type(children) == 'table', 'children must be a table')
    self:set_widget(children[1])
end


function gobject.layout(self, context, ...)
    return { base.place_widget_at(self._private.widget, 0, 0, ...) }
end

function gobject.fit(self, context, ...)
    return base.fit_widget(self, context, self._private.widget, ...)
end


-- internal use only
function gobject._refresh(self)
    for _,pspec in pairs(self._private.object._class:list_properties()) do
        self._private._handler(self._private.object, pspec)
    end
end


function gobject.set_handlers(self, handlers)
    assert(type(handlers) == 'table', 'handlers must be a table')
    if self._private.object then
        self:_refresh()
    end
    self._private.handlers = handlers
end

function gobject.get_handlers(self)
    return self._private.handlers or {}
end


function gobject.set_object(self, object)
    -- if we have an object disconnect its notifyer
    if self._private.object then
        self._private.object.on_notify = nil
    end

    -- if we get nil remove our object and end
    if not object then
        self._private.object = nil
        return 
    end
    
    -- be sure we have an object that we can work with
    assert(lgi.GObject.Object:is_type_of(object), 'object must be a class instance that subclasses GObject.Object')
    
    self._private.object = object
    -- attach the handler
    self._private.object.on_notify = self._private._handler

    -- initialise call the handlers to initialise the widet
    self:_refresh()
end

function gobject.get_object(self)
    return self._private.object
end


function gobject.new(self, object, child)
    -- get our base widget
    local ret = base.make_widget(nil, nil, {enable_properties = true})

    -- create a handler for this instance
    function ret._private._handler(obj, pspec)
        local name = pspec.name:gsub('-','_')
        -- if we have a handler call it
        if ret.handlers[name] then
            ret.handlers[name](ret)
        end
        
        -- support a catch all handler
        if ret.handlers['all'] then 
            ret.handlers['all'](ret, name)
        end
        
        -- emit signals for external code to attach to
        ret:emit_signal('object::'..name)
    end

    if child then
        ret:set_widget(child)
    end

    if object then
        ret:set_object(child)
    end

    return gtable.crush(ret, gobject, true)
end

gobject.mt.__call = gobject.new

return setmetatable(gobject, gobject.mt)


-----------------------------------------mechanism-----------------------------------------

local observe
local subscribe

observe = function( s )
	local c, mt = {}
    mt = {
    	__bind__ = {},
        __index = function(_, k)
            return mt[k]
        end,
        __newindex = function(_, k, v)
            local o = mt[k]
      		if o ~= v then
      			mt[k] = v
      			for i, e in ipairs( mt.__bind__[k] or {} ) do
      				e(v, o)
      			end
      		end
        end
    }
    setmetatable(c, mt)
    for k, v in pairs( s ) do
		if type(v) == "table" then
			c[k] = observe(v)
		else
			c[k] = s[k]
		end
	end
    return c
end

subscribe = function( t, k, f )
	local b = t.__bind__
	if not b[k] then
		b[k] = setmetatable( {}, { __mode = "kv" } )
	end
	b[k][#b+1] = f
end 

--------------------------------------cocos-lua-wraper----------------------------------------

local bind

bind = function( t, k, f, ui )
	ui.__cb__ = function( ... )
		if not tolua.isnull(ui) then
			f(...)
		end
	end
	subscribe(t, k, ui.__cb__)
end


cc.exports.Vue = {
	bind = bind,
	observe = observe
}
-----------------------------------------test----------------------------------------

-- local t = observe({
--     x = 123,
--     z = {
--     	a = 1,
--     	c = {
--     		b = "a"
--     	}
--     }
-- })

-- local test = function( v, o )
-- 	print( v, o )
-- end
-- subscribe(t, "x", test)


-- subscribe(t.z.c, "b", function( v, o )
-- 	print( v, o )
-- end)


-- t.x = 250
-- -- test = nil
-- collectgarbage()
-- -- -- print( test )
-- t.x = 10
-- -- t.z.c.b = "y"

-- -- local a = {}
-- -- local target = {123}
-- -- t = {}
-- -- t[1] = target
-- -- t[2] = {4,5,6}
-- -- t[3] = function( ... )
-- -- 	print( "zz" )
-- -- end
-- -- a[1] = t
-- -- setmetatable( t, {__mode = "kv"} )
-- -- for k, v in pairs( t ) do
-- -- 	print( k, v )
-- -- end
-- -- collectgarbage()
-- -- print( "-------------" )
-- -- for k, v in pairs( t ) do
-- -- 	print( k, v )
-- -- end
-- -- target = nil
-- -- collectgarbage()
-- -- print( "-------------" )
-- -- for k, v in pairs( t ) do
-- -- 	print( k, v )
-- -- end
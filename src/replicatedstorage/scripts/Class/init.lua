local Utils = require(game.ReplicatedStorage.Scripts.Utils)
local Class = {}

local _newInstance = function(methodTable_classT, ...)
    -- Creates a completely new object and shallow-copies all functions from methodTable_classT into it
    -- Allows metamethods to be defined directly in the class because they will be copied into the metatable
    -- TODO: "loop in gettable" when null members are created in constructor

    local methodTable_instanceT = {}
    local methodTable_metatableInstanceT = {}

    for k,v in pairs(getmetatable(methodTable_classT)) do
        methodTable_metatableInstanceT[k] = v
    end

    for k,v in pairs(methodTable_classT) do
        methodTable_instanceT[k] = v
        if string.sub(k,1,2) == "__" then
            methodTable_metatableInstanceT[k] = v
        end
    end

    --[[local methodTable_metatableInstanceT = {}
    for k,v in pairs(getmetatable(methodTable_classT)) do
        methodTable_metatableInstanceT[k] = v
    end]]
    --[[if methodTable_instanceT.__tostring then
        methodTable_metatableInstanceT.__tostring = methodTable_instanceT.__tostring
    end]]
    --methodTable_metatableInstanceT.__index = methodTable_instanceT

    setmetatable(methodTable_instanceT, methodTable_metatableInstanceT)


    --setmetatable(methodTable_instanceT, getmetatable(classT))
    if not methodTable_instanceT._className then
        Utils.logError("Expected _className not found")
    end
    if not methodTable_instanceT._new then
        Utils.logError("Expected _new not found")
    end

    -- Until now we have only been manipulating "method tables" to make all functions inherit properly in our new instance
    -- Calling _new makes the instance stateful by invoking constructor logic
    return methodTable_instanceT:_new(...)
end

Class.classDefinition --[[<T,U extends Object>]] = function(--[[U]] methodTable_baseClassU)
    local methodTable_classT = {}

    for k,v in pairs(methodTable_baseClassU) do
        methodTable_classT[k] = v
    end

    local methodTable_metatableClassT = {}
    -- Match methods in T first before looking elsewhere
    methodTable_metatableClassT.__index = methodTable_classT
    -- ClassT(arg) will call _newInstance(arg)
    methodTable_metatableClassT.__call = _newInstance
    setmetatable(methodTable_classT, methodTable_metatableClassT)

    return methodTable_classT, methodTable_baseClassU
end

return Class

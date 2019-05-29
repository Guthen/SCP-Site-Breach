-----------------------------
--  > SCP - Site Breach <  --
--    > sh_entity.lua <    --
-----------------------------

local Entity = FindMetaTable( "Entity" )

--  > Variables <  --

--  > Meta Functions <  --

function Entity:isDoor()
    return string.find( self:GetClass(), "door" )
end

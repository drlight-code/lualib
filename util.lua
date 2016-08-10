function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function table_print (tt, indent, done)
   done = done or {}
   indent = indent or 0
   if type(tt) == "table" then
      local sb = {}
      for key, value in pairs (tt) do
         table.insert(sb, string.rep (" ", indent)) -- indent it
         if type (value) == "table" and not done [value] then
            done [value] = true
            table.insert(sb, key .. " {\n");
            table.insert(sb, table_print (value, indent + 2, done))
            table.insert(sb, string.rep (" ", indent)) -- indent it
            table.insert(sb, "}\n");
         elseif "number" == type(key) then
            table.insert(sb, string.format("\"%s\"\n", tostring(value)))
         else
            table.insert(sb, string.format(
                            "%s = \"%s\"\n", tostring (key), tostring(value)))
         end
      end
      return table.concat(sb)
   else
      return tt .. "\n"
   end
end

function to_string( tbl )
   if  "nil"       == type( tbl ) then
      return tostring(nil)
   elseif  "table" == type( tbl ) then
      return table_print(tbl)
   elseif  "string" == type( tbl ) then
      return tbl
   else
      return tostring(tbl)
   end
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy

    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end

    return copy
end

function equals(t1, t2)
   if t1 == t2 then
       return true
   end
   if type(t1) ~= "table" or type(t2) ~= "table" then
       return false
   end
   local v2
   for k,v1 in pairs(t1) do
       v2 = t2[k]
       if v1 ~= v2 and not equals(v1, t2[k]) then
           return false
       end
   end
   for k in pairs(t2) do
       if t1[k] == nil then
           return false
       end
   end
   return true
end

function remove(t, value)
   for k, v in pairs(t) do
      if v == value then
         table.remove(t, k)
      end
   end
end

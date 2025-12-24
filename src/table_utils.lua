local copy_module = require "copy"

local function merge(table_1, table_2) 
  local new_table = {}
  local table_1_copy = copy_module.copy(table_1)
  local table_2_copy = copy_module.copy(table_2)

  for key, value in pairs(table_1_copy) do
    new_table[key] = value
  end

  for key, value in pairs(table_2_copy) do
    new_table[key] = value
  end

  return new_table
end

local function assoc(key, value, t) 
  local new_table = {}
  new_table[key] = value
  
  return merge(new_table, t)
end

local function pick(keys, t) 
  local new_table = {}
  local t_copy = copy_module.copy(t)

  for _, key in ipairs(keys) do
    if t_copy[key] ~= nil then 
      new_table[key] = t_copy[key]
    end
  end

  return new_table
end

local function omit(keys, t) 
  local t_copy = copy_module.copy(t)
  
  for _, key in ipairs(keys) do
    if t_copy[key] ~= nil then 
      t_copy[key] = nil
    end
  end

  return t_copy
end

local function get_in(path, t) 
  local t_copy = copy_module.copy(t)

  local curr = t_copy
  for _, key in ipairs(path) do 
    if curr[key] ~= nil then 
      curr = curr[key]
    else 
      return nil
    end 
  end

  return curr 
end

local function update_in(path, fn, t) 
  local new_table = copy_module.copy(t)

  local function update(index, curr) 
    local key = path[index]
    if curr[key] ~= nil then
      if index == #path then 
        curr[key] = fn(curr[key])
      else     
        update(index + 1, curr[key])
      end
    end
  end

  update(1, new_table)

  return new_table 
end

return {
  assoc = assoc,
  merge = merge,
  pick = pick,
  omit = omit,
  get_in = get_in,
  update_in = update_in
}
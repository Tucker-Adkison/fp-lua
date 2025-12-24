local copy_module = require "copy"

local function concat_tables(table_1, table_2) 
  local new_table = {}
  local table_1_copy = copy_module.copy(table_1)
  local table_2_copy = copy_module.copy(table_2)

  for i = 1, #table_1 do
    table.insert(new_table, table_1_copy[i])
  end

  for i = 1, #table_2 do
    table.insert(new_table, table_2_copy[i])
  end

  return new_table
end

return {
  concat_tables = concat_tables
}

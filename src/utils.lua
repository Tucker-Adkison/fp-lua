local function concat_tables(table_1, table_2) 
  local new_table = {}

  for i = 1, #table_1 do
    table.insert(new_table, table_1[i])
  end

  for i = 1, #table_2 do
    table.insert(new_table, table_2[i])
  end

  return new_table
end

return {
  concat_tables = concat_tables
}
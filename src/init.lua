local curry_module = require 'fp-lua.curry'
local table_utils = require 'fp-lua.table_utils'

local FP = {
    curry = curry_module.curry,
    partial = curry_module.partial,
    merge = table_utils.merge 
    assoc = table_utils.assoc 
    pick = table_utils.pick 
    omit = table_utils.omit 
    get_in = table_utils.get_in
    update_in = table_utils.update_in
}
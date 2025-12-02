local utils_module = require 'utils'

local function curry(fn, arity)
  arity = arity or 2

  return function(...)
    local args = {...}
    if #args >= arity then
      return fn(...)
    else
      return curry(function(...)
        return fn(table.unpack(utils_module.concat_tables(args, {...})))
      end, arity - #args)
    end
  end
end

local function partial(fn, ...)
  local fixed_args = {...}

  return function(...) 
    local args = {...}

    return fn(table.unpack(utils_module.concat_tables(fixed_args, args)))
  end
end

return {
  curry = curry,
  partial = partial
}
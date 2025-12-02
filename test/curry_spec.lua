local curry_module = require 'curry'

describe('test curry', function() 
  it('currying works as exected', function() 
    local add = curry_module.curry(function(a, b, c) 
      return a + b + c
    end, 3)

    assert.are.equals(18, add(5, 6, 7))
    assert.are.equals(18, add(5)(6)(7))
    assert.are.equals(add(5, 6, 7), add(5)(6)(7))

    assert.are.equals("function", type(add(5)))
    assert.are.equals("function", type(add(5, 6)))
    assert.are.equals("function", type(add(5)(6)))
  end)

  it('partial works as exected', function() 
    local add3 = curry_module.partial(function(a, b, c) 
      return a + b + c
    end, 3)

    assert.are.equals(12, add3(4, 5))
  end)
end)
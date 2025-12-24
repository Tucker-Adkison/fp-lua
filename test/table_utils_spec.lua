local table_utils = require 'table_utils'

describe('test assoc', function() 
  it('copies table and adds new key with value', function() 
    local data = {name = "Alice"}
    local new_data = table_utils.assoc("age", 30, data)

    assert.are.equal("Alice", new_data.name)
    assert.are.equal(30, new_data.age)
    assert.are.equal(nil, data.age)
  end)
end)

describe('test pick', function() 
  it('copies table and picks keys to new table', function() 
    local data = {name = "Alice", age = 30, height = "5"}
    local new_data = table_utils.pick({"name", "age"}, data)

    assert.are.equal("Alice", new_data.name)
    assert.are.equal(30, new_data.age)
    assert.are.equal(nil, new_data.height)
  end)
end)

describe('test omit', function() 
  it('copies table and omits keys in new table', function() 
    local data = {name = "Alice", age = 30, height = "5"}
    local new_data = table_utils.omit({"name", "age"}, data)

    assert.are.equal(nil, new_data.name)
    assert.are.equal(nil, new_data.age)
    assert.are.equal("5", new_data.height)
  end)
end)

describe('test get_in', function() 
  it('get_in works as expected', function() 
    local data = {user = {age = 2}}
    local elem = table_utils.get_in({"user", "age"}, data)

    assert.are.equal(elem, 2)
  end)

  it('get_in does not fail if key is not present in table', function() 
    local data = {user = {height = 2}}
    local elem = table_utils.get_in({"user", "age"}, data)

    assert.are.equals(nil, elem)
  end)
end)

describe('test update_in', function() 
  it('update_in works as exected', function() 
    local data = {user = {age = 2}}
    local updated_data = table_utils.update_in(
      {"user", "age"},
      function(age) return age + 1 end,
      data
    )

    assert.are.equals(2, data.user.age)
    assert.are.equals(3, updated_data.user.age)
  end)

  it('update_in does not fail if key is not present in table', function() 
    local data = {user = {height = 2}}
    local updated_data = table_utils.update_in(
      {"user", "age"},
      function(age) return age + 1 end,
      data
    )

    assert.are.equals(2, updated_data.user.height)
  end)
end)
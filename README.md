# fp-lua

A functional programming library for Lua inspired by Haskell and Elixir, designed to make data transformations concise and composable.

## Overview

fp-lua provides a comprehensive set of functional utilities with automatic currying, enabling you to write clean, declarative code without multiple loops or intermediate variables.

**Before:**

```lua
local active_emails = {}
for _, user in ipairs(users) do
  if user.active then
    if user.email then
      table.insert(active_emails, user.email)
    end
  end
end
```

**After:**

```lua
local active_emails = pipe(
  filter(prop("active")),
  map(prop("email")),
  compact
)(users)
```

## Features

- **Auto-curried functions** - All core functions support partial application
- **Composable pipelines** - Build complex transformations from simple pieces
- **Immutable operations** - Work with data without mutating original structures
- **Rich standard library** - Map, filter, fold, scan, chunk, partition, and more
- **Zero dependencies** - Pure Lua implementation

## Installation

### Manual

Clone this repository and require the module:

```lua
local FP = require("fp-lua")
```

## Quick Start

```lua
local FP = require("fp-lua")

-- Import functions you'll use
local map, filter, pipe = FP.map, FP.filter, FP.pipe
local prop, gt = FP.prop, FP.gt

-- Transform data
local users = {
  {name = "Alice", age = 30, active = true},
  {name = "Bob", age = 25, active = false},
  {name = "Charlie", age = 35, active = true}
}

-- Get names of active users over 25
local result = pipe(
  filter(prop("active")),
  filter(function(u) return u.age > 25 end),
  map(prop("name"))
)(users)

-- Result: {"Alice", "Charlie"}
```

## Core Concepts

### Auto-Currying

All functions are automatically curried, meaning you can call them with fewer arguments and get back a function waiting for the rest:

```lua
-- These are equivalent:
map(double, numbers)
map(double)(numbers)

-- Partial application
local get_names = map(prop("name"))
get_names(users)
get_names(customers)
```

### Function Composition

Build complex operations from simple functions:

```lua
-- compose: right-to-left (mathematical style)
local process = compose(
  sum,
  map(double),
  filter(is_positive)
)

-- pipe: left-to-right (data flow style)
local process = pipe(
  filter(is_positive),
  map(double),
  sum
)
```

## API Reference

### List Transformations

#### `map(fn, list)`

Transform each element in a list.

```lua
map(function(x) return x * 2 end, {1, 2, 3})
-- Result: {2, 4, 6}
```

#### `filter(predicate, list)`

Keep elements that satisfy the predicate.

```lua
filter(function(x) return x > 2 end, {1, 2, 3, 4})
-- Result: {3, 4}
```

#### `flat_map(fn, list)`

Map then flatten one level.

```lua
flat_map(function(x) return {x, x * 2} end, {1, 2})
-- Result: {1, 2, 2, 4}
```

### Folds and Scans

#### `foldl(fn, acc, list)`

Reduce from left with an accumulator.

```lua
foldl(function(acc, x) return acc + x end, 0, {1, 2, 3})
-- Result: 6
```

#### `foldr(fn, acc, list)`

Reduce from right with an accumulator.

```lua
foldr(function(x, acc) return acc .. x end, "", {"a", "b", "c"})
-- Result: "cba"
```

#### `scanl(fn, acc, list)`

Like foldl but returns all intermediate results.

```lua
scanl(function(acc, x) return acc + x end, 0, {1, 2, 3})
-- Result: {0, 1, 3, 6}
```

#### `scanr(fn, acc, list)`

Like foldr but returns all intermediate results.

```lua
scanr(function(x, acc) return acc + x end, 0, {1, 2, 3})
-- Result: {6, 5, 3, 0}
```

### Slicing

#### `take(n, list)`

Take first n elements.

```lua
take(2, {1, 2, 3, 4})
-- Result: {1, 2}
```

#### `drop(n, list)`

Drop first n elements.

```lua
drop(2, {1, 2, 3, 4})
-- Result: {3, 4}
```

#### `take_while(predicate, list)`

Take elements while predicate is true.

```lua
take_while(function(x) return x < 3 end, {1, 2, 3, 4})
-- Result: {1, 2}
```

#### `drop_while(predicate, list)`

Drop elements while predicate is true.

```lua
drop_while(function(x) return x < 3 end, {1, 2, 3, 4})
-- Result: {3, 4}
```

### Chunking and Windowing

#### `chunk(size, list)`

Split into chunks of specified size.

```lua
chunk(2, {1, 2, 3, 4, 5})
-- Result: {{1, 2}, {3, 4}, {5}}
```

#### `chunk_by(fn, list)`

Split into chunks when fn returns a new value.

```lua
chunk_by(function(x) return x % 2 end, {1, 3, 2, 4, 5})
-- Result: {{1, 3}, {2, 4}, {5}}
```

#### `window(size, list)`

Create sliding windows of specified size.

```lua
window(2, {1, 2, 3, 4})
-- Result: {{1, 2}, {2, 3}, {3, 4}}
```

#### `split(predicate, list)`

Split list at elements matching predicate.

```lua
split(function(x) return x == 0 end, {1, 2, 0, 3, 4})
-- Result: {{1, 2}, {3, 4}}
```

#### `partition(predicate, list)`

Split into two lists: matching and non-matching.

```lua
partition(function(x) return x % 2 == 0 end, {1, 2, 3, 4})
-- Result: {{2, 4}, {1, 3}}
```

### Predicates

#### `all(predicate, list)`

Check if all elements satisfy predicate.

```lua
all(function(x) return x > 0 end, {1, 2, 3})
-- Result: true
```

#### `any(predicate, list)`

Check if any element satisfies predicate.

```lua
any(function(x) return x > 5 end, {1, 2, 3})
-- Result: false
```

### Combinators

#### `compose(...fns)`

Compose functions right-to-left.

```lua
local f = compose(add_one, double, square)
f(3)
-- Evaluates: add_one(double(square(3)))
-- = add_one(double(9))
-- = add_one(18)
-- = 19
```

#### `pipe(...fns)`

Compose functions left-to-right.

```lua
local f = pipe(square, double, add_one)
f(3)
-- Evaluates: add_one(double(square(3)))
-- = 19
```

#### `flip(fn)`

Reverse the order of a function's first two arguments.

```lua
local subtract = function(a, b) return a - b end
local flipped = flip(subtract)
flipped(3, 10)
-- Result: 7 (computes 10 - 3)
```

#### `identity(x)`

Return the argument unchanged.

```lua
identity(5)
-- Result: 5
```

#### `const(x)`

Return a function that always returns x.

```lua
local always_five = const(5)
always_five(1, 2, 3)
-- Result: 5
```

### Currying

#### `curry(fn, arity)`

Make a function auto-curried.

```lua
local add = curry(function(a, b, c)
  return a + b + c
end, 3)

add(1)(2)(3)     -- 6
add(1, 2)(3)     -- 6
add(1, 2, 3)     -- 6
```

#### `partial(fn, ...args)`

Partially apply arguments to a function.

```lua
local add = function(a, b, c)
  return a + b + c
end

local add5 = partial(add, 5)
add5(2, 3)
-- Result: 10
```

### Table Operations

#### `assoc(key, value, table)`

Return new table with key set to value (immutable).

```lua
assoc("age", 30, {name = "Alice"})
-- Result: {name = "Alice", age = 30}
```

#### `merge(table1, table2)`

Merge two tables (immutable).

```lua
merge({a = 1}, {b = 2})
-- Result: {a = 1, b = 2}
```

#### `pick(keys, table)`

Select only specified keys from table.

```lua
pick({"name", "age"}, {name = "Alice", age = 30, city = "NYC"})
-- Result: {name = "Alice", age = 30}
```

#### `omit(keys, table)`

Exclude specified keys from table.

```lua
omit({"password"}, {name = "Alice", password = "secret"})
-- Result: {name = "Alice"}
```

#### `get_in(path, table)`

Get nested value by path.

```lua
get_in({"user", "address", "city"}, data)
```

#### `update_in(path, fn, table)`

Update nested value by path (immutable).

```lua
update_in(
  {"user", "age"},
  function(age) return age + 1 end,
  data
)
```

### Utilities

#### `prop(key)`

Extract a property from a table.

```lua
map(prop("name"), users)
-- Extracts all names from users
```

#### `pluck(key, list)`

Extract a property from each table in a list.

```lua
pluck("name", users)
-- Same as: map(prop("name"), users)
```

#### `compact(list)`

Remove nil values.

```lua
compact({1, nil, 2, nil, 3})
-- Result: {1, 2, 3}
```

#### `uniq(list)`

Remove duplicates.

```lua
uniq({1, 2, 2, 3, 1})
-- Result: {1, 2, 3}
```

#### `count(list)` or `count(predicate, list)`

Count elements or elements matching predicate.

```lua
count({1, 2, 3})
-- Result: 3

count(function(x) return x > 2 end, {1, 2, 3, 4})
-- Result: 2
```

#### `append(list1, list2)`

Concatenate two lists.

```lua
append({1, 2}, {3, 4})
-- Result: {1, 2, 3, 4}
```

### Comparison Helpers

```lua
eq(5)         -- function(x) return x == 5 end
gt(5)         -- function(x) return x > 5 end
lt(5)         -- function(x) return x < 5 end
gte(5)        -- function(x) return x >= 5 end
lte(5)        -- function(x) return x <= 5 end
not_(fn)      -- function(...) return not fn(...) end
both(f, g)    -- function(x) return f(x) and g(x) end
either(f, g)  -- function(x) return f(x) or g(x) end
```

## License

MIT License - see LICENSE file for details

## Roadmap

- [x] Currying
- [ ] Table Operations
- [ ] Comparison Helpers
- [ ] List Transformations
- [ ] Folds and Scans
- [ ] Slicing
- [ ] Chunking and Windowing
- [ ] Predicates
- [ ] Combinators
- [ ] Utilities

---

Made with ❤️ for the Lua community

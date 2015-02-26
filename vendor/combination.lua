local Combination = {}

function Combination.combine(arr, r)
  -- do noting if r is bigger then length of arr
  if(r > #arr) then
    return {}
  end

  --for r = 0 there is only one possible solution and that is a combination of lenght 0
  if(r == 0) then
    return {}
  end

  if(r == 1) then
    -- if r == 1 than retrn only table with single elements in table
    -- e.g. {{1}, {2}, {3}, {4}}

    local return_table = {}
    for i=1,#arr do
      table.insert(return_table, {arr[i]})
    end

    return return_table
  else
    -- else return table with multiple elements like this
    -- e.g {{1, 2}, {1, 3}, {1, 4}}

    local return_table = {}

    --create new array without the first element
    local arr_new = {}
    for i=2,#arr do
      table.insert(arr_new, arr[i])
    end

    --combinations of (arr-1, r-1)
    for i, val in pairs(Combination.combine(arr_new, r-1)) do
      local curr_result = {}
      table.insert(curr_result, arr[1]);
      for j,curr_val in pairs(val) do
        table.insert(curr_result, curr_val)
      end
      table.insert(return_table, curr_result)
    end

    --combinations of (arr-1, r)
    for i, val in pairs(Combination.combine(arr_new, r)) do
      table.insert(return_table, val)
    end

    return return_table
  end
end

function Combination.combinations(list, min, max)
  min = min or 1
  max = max or #list

  local output = {}
  for i=min,max do
    for i,val in ipairs(Combination.combine(list, i)) do
      table.insert(output, val)
    end
  end

  return output
end

function Combination.joined(list, min, max)
  local combinations = Combination.combinations(list, min, max)

  local output = {}
  for i,v in pairs(combinations) do
    table.insert(output, table.concat(v))
  end

  return output
end

return Combination
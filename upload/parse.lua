-- Module table
local M = {}

--- Returns array of digit values after each search_term  in a given string
function M.get_num_values(json_text, search_term)
  local arrivals = {}
  local pattern = '"' .. search_term .. '"%s*:%s*"?(%d+)"?'
  for num in json_text:gmatch(pattern) do
    table.insert(arrivals, num)
  end
  return arrivals
end

-- prints the results with up to max arrivals, or 'no arrivals' if none
-- prefers realtime to scheduled
function M.arrival_printing(json_text)
  local max = 3
  
  local arrivals = M.get_num_values(json_text, "realtimeArrival")
  --we want the realtime ideally but it may not be there
  if #arrivals == 0 then
    arrivals = M.get_num_values(json_text, "scheduledArrival")
    if #arrivals == 0 then
      print("No arrivals.")
    end
  else
    for i = 1, math.min(#arrivals, max) do
      if i == 1 then
        print("First arrival:", arrivals[1])
      elseif i == 2 then
        print("next arrivals:")
        print(" " .. arrivals[i])
      else
        print(" " .. arrivals[i])
      end
    end
  end

end

---------------------- TEST with example json ------------------------
function M.test_arrival_extraction()
  local json_text = [[
   {"data":{"stop":{"name":"Haapaniemi","stoptimesWithoutPatterns":[{"realtimeArrival":42870,"headsign":"Rautatientori"},{"realtimeArrival":42936,"headsign":"Rautatientori"},{"realtimeArrival":42947,"headsign":"Rautatientori"},{"realtimeArrival":42969,"headsign":"Rautatientori"},{"realtimeArrival":42974,"headsign":"Rautatientori"}]}}}
  ]]
  
  M.arrival_printing(json_text)
end


M.test_arrival_extraction()
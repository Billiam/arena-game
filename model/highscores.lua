local sha1 = require('vendor.sha1')
local Serializer = require('vendor.smallfolk')

local defaults = {
  FILENAME = 'scores.conf',
  LIMIT = 15,
  KEY = "yes, it's very easy",
  DATA = {
    {'aaa', 200000, 1},
    {'aaa', 190000, 1},
    {'aaa', 180000, 1},
    {'aaa', 170000, 1},
    {'aaa', 160000, 1},
    {'aaa', 150000, 1},
    {'aaa', 140000, 1},
    {'aaa', 130000, 1},
    {'aaa', 120000, 1},
    {'aaa', 110000, 1},
    {'aaa', 100000, 1},
    {'aaa', 90000, 1},
    {'aaa', 80000, 1},
    {'aaa', 70000, 1},
    {'aaa', 60000, 1},
    {'aaa', 50000, 1},
  }
}

local Highscores = {}

local data

function Highscores:data()
  if not data then
    data = self:load() or defaults.DATA
  end

  return data
end

function Highscores:load()
  local savedScores = love.filesystem.read(defaults.FILENAME)

  -- Unable to read highscore files
  if not savedScores then
    return false
  end

  local scoreData, signature = savedScores:match("^(.+)@@@@@sig=([a-zA-Z0-9]+)$")

  -- unable to find data/sig
  if not (scoreData and signature) then
    return false
  end

  -- invalid signature
  if sha1.hmac(defaults.KEY, scoreData) ~= signature then
    return false
  end

  local success, parsed = pcall(
    function()
      return Serializer.loads(scoreData)
    end
  )

  -- not unserializable
  if not success then
    return false
  end

  return parsed
end

function Highscores:save()
  local serialized = Serializer.dumps(self:data())

  local signed = serialized .. "@@@@@sig=" .. sha1.hmac(defaults.KEY, serialized)

  love.filesystem.write(defaults.FILENAME, signed)
end

local highscoreSort = function(a, b)
  if a[2] == b[2] then
    return a[3] < b[3]
  end

  return b[2] < a[2]
end

function Highscores:add(name, score)
  local scores = self:data()

  table.insert(scores, {name, score, os.time()})

  table.sort(
    scores,
    highscoreSort
  )

  while #scores > defaults.LIMIT do
    table.remove(scores, #data)
  end

  self:save()
end

return Highscores
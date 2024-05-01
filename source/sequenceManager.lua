class('sequenceManager').extends()


---@class sequenceManager
---@field sequenceMap table< string, table< string, sequencer > >
---@field addSequencer fun(self: sequenceManager, sequencer: sequencer, ownerId: string, sequencerId: string? )
---@field clearSequencer fun(self: sequenceManager, ownerId: string , sequencerId: string )
---@field clearAllSequencersOfOwner fun(self: sequenceManager, ownerId: string )
---@field clearAllSequencers fun(self: sequenceManager)
---@field update fun(self: sequenceManager)
---@field pauseAllSequencesOfOwner fun(self: sequenceManager, ownerId: string )
---@field resumeAllSequencesOfOwner fun(self: sequenceManager, ownerId: string )
---@field pauseSequencer fun(self: sequenceManager, ownerId: string, sequencerId: string  )
---@field resumeSequencer fun(self: sequenceManager, ownerId: string, sequencerId: string  )
---@field processOwner fun(self: sequenceManager, seqs: table<string, sequencer> )

---@param t any
---@return string
function tblGetId(t)
    return string.format('%p', t)
end

---@param self sequenceManager
function sequenceManager:init()
    self.sequenceMap = {}
end

---@param self sequenceManager
---@param sequencer sequencer
---@param ownerId string
---@param sequencerId string?
function sequenceManager:addSequencer(sequencer, ownerId, sequencerId)
    if self.sequenceMap[ownerId] == nil then
        self.sequenceMap[ownerId] = {}
    end

    local finalId = sequencerId

    if finalId == nil then
        finalId = tblGetId(sequencer)
    end

    self.sequenceMap[ownerId][finalId] = sequencer
end

---@param self sequenceManager
---@param ownerId string
---@param sequencerId string
function sequenceManager:clearSequencer(ownerId, sequencerId)
    self.sequenceMap[ownerId][sequencerId] = nil
end

---@param self sequenceManager
---@param ownerId string
function sequenceManager:clearAllSequencersOfOwner(ownerId)
    self.sequenceMap[ownerId] = nil
end

---@param self sequenceManager
function sequenceManager:clearAllSequencers()
    self.sequenceMap = {}
end

---@param self sequenceManager
function sequenceManager:update()
    for _, seqsOfOwner in pairs(self.sequenceMap) do
        self:processOwner(seqsOfOwner)
    end
end

---@param self sequenceManager
---@param ownerId string
function sequenceManager:pauseAllSequencesOfOwner(ownerId)
    for _, v in pairs(self.sequenceMap[ownerId]) do
        v:pause()
    end
end

---@param self sequenceManager
---@param ownerId string
function sequenceManager:resumeAllSequencesOfOwner(ownerId)
    for _, v in pairs(self.sequenceMap[ownerId]) do
        v:resume()
    end
end

---@param self sequenceManager
---@param ownerId string
---@param sequencerId string
function sequenceManager:pauseSequencer(ownerId, sequencerId)
    self.sequenceMap[ownerId][sequencerId]:pause()
end

---@param self sequenceManager
---@param ownerId string
---@param sequencerId string
function sequenceManager:resumeSequencer(ownerId, sequencerId)
    self.sequenceMap[ownerId][sequencerId]:resume()
end

---@param self sequenceManager
---@param seqs table<string, sequencer>
function sequenceManager:processOwner(seqs)
    local seqsToRemove = {}

    for k, seq in pairs(seqs) do
        seq:update()

        if seq.finished then
            table.insert(seqsToRemove, k)
        end
    end

    for _, toRemove in ipairs(seqsToRemove) do
        seqs[toRemove] = nil
    end
end

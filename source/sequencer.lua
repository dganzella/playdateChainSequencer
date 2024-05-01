---@class sequencer
---@field actionList table[]
---@field timeCountMs integer
---@field repeatForever boolean
---@field finished boolean
---@field prevVal number?
---@field paused boolean
---@field currIndex integer
---@field dtms number
---@field update fun(self: sequencer)
---@field pause fun(self: sequencer)
---@field resume fun(self: sequencer)
---@field advanceAction fun(self: sequencer)
---@field getFpsMs fun(self: sequencer): number

class('sequencer').extends()

---@param self sequencer
---@param actions table[]
---@param repeatForever boolean
function sequencer:init(actions, repeatForever)
	self.actionList = actions
	self.currIndex = 1
	self.prevVal = 0
	self.timeCountMs = 0
	self.paused = false
	self.repeatForever = repeatForever
	self.dtms = 1000 / playdate.display.getRefreshRate()
end

---@param self sequencer
function sequencer:update()
	if not self.finished and not self.paused then
		local currAction = self.actionList[self.currIndex]

		if currAction.type == SequenceTypes.Call then
			currAction.call()
			self:advanceAction()
			self:update()
		else
			self.timeCountMs += self.dtms

			local delayOrTime = 0

			if currAction.type == SequenceTypes.Delay then
				delayOrTime = currAction.delay
			elseif currAction.type == SequenceTypes.Progress then
				delayOrTime = currAction.progress.time

				local timeMax = math.min(self.timeCountMs, delayOrTime)

				local ease = currAction.progress.ease

				if ease == nil then
					ease = playdate.easingFunctions.linear
				end

				local val = ease(timeMax, 0, 1, currAction.progress.time)

				local diff = val - self.prevVal

				self.prevVal = val

				currAction.progress.update(val, diff)
			end
			if self.timeCountMs >= delayOrTime then
				self.timeCountMs -= delayOrTime
				self:advanceAction()
			end
		end
	end
end

---@param self sequencer
function sequencer:pause()
	self.paused = true
end

---@param self sequencer
function sequencer:resume()
	self.paused = false
end

---@param self sequencer
function sequencer:advanceAction()
	self.prevVal = 0
	self.currIndex += 1

	if self.currIndex > #self.actionList then
		if self.repeatForever then
			self.currIndex = 1
		else
			self.finished = true
		end
	end
end

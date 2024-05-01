# playdateChainSequencer
A chain-animation sequencer for playdate. Useful for cutscenes and general animations.

May provide a more straightforward way of programming than using playdate's timers or blinkers.

## how it works

The usage is very simple. There are only 3 types of **Actions**: Delay, Call and Progress

**Delay** is used to add a time delay to the chain

**Call** is used to call a generic function

**Progress** will provide a 0 to 1 value over time, both total accumulated and the difference on the last update, with any easing curve

By chaining **Actions** in an array, either line by line or using for loops, you can then create a **sequencer**.

Then you add the sequencer to the **SequenceManager**, and assign to an owner and optionally give it an ID.

You can pause/resume and clear unfinished sequencers, either individually or by owner.

Sequencers may also loop forever, which in that case, they require to be cleared to stop.

## installation

copy **ActionTypes.lua**, **sequencer.lua** and **sequenceManager.lua** to your project

## basic usage

```lua
import 'ActionTypes'
import 'sequencer'
import 'sequenceManager'

seqMng = sequenceManager()

local actionList = {}

table.insert(actionList, {
	type = ActionTypes.Progress,
	progress = {
		time = 2000,
		ease = playdate.easingFunctions.outSine,
		update = function(acc, diff)
			print('accumulated value', acc, 'difference this update', diff)
		end
	}
})

table.insert(actionList, {
	type = ActionTypes.Call,
	call = function()
		print('will wait for 3 seconds...')
	end
})


table.insert(actionList, { type = ActionTypes.Delay, delay = 3000 })

table.insert(actionList, {
	type = ActionTypes.Call,
	call = function()
		print('waited!')
	end
})

seqMng:addSequencer(sequencer(actionList), 'owner identifier')


function playdate.update()
	seqMng:update()
end
```
## documentation

```lua
---@class sequenceManager
---@field addSequencer fun(self: sequenceManager, sequencer: sequencer, ownerId: string, sequencerId: string? )
---@field clearSequencer fun(self: sequenceManager, ownerId: string , sequencerId: string )
---@field clearAllSequencersOfOwner fun(self: sequenceManager, ownerId: string )
---@field clearAllSequencers fun(self: sequenceManager)
---@field update fun(self: sequenceManager)
---@field pauseAllSequencesOfOwner fun(self: sequenceManager, ownerId: string )
---@field resumeAllSequencesOfOwner fun(self: sequenceManager, ownerId: string )
---@field pauseSequencer fun(self: sequenceManager, ownerId: string, sequencerId: string  )
---@field resumeSequencer fun(self: sequenceManager, ownerId: string, sequencerId: string  )
```

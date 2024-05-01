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
**output**

```
accumulated value	0.02617695	difference this update	0.02617695
accumulated value	0.05233596	difference this update	0.02615901
accumulated value	0.0784591	difference this update	0.02612314
accumulated value	0.1045285	difference this update	0.02606936
accumulated value	0.1305262	difference this update	0.02599773
accumulated value	0.1564345	difference this update	0.02590828
accumulated value	0.1822355	difference this update	0.02580105
accumulated value	0.2079117	difference this update	0.02567618
accumulated value	0.2334454	difference this update	0.02553371
accumulated value	0.258819	difference this update	0.02537365
accumulated value	0.2840154	difference this update	0.02519631
accumulated value	0.309017	difference this update	0.02500167
accumulated value	0.3338069	difference this update	0.02478987
accumulated value	0.358368	difference this update	0.02456111
accumulated value	0.3826835	difference this update	0.02431548
accumulated value	0.4067367	difference this update	0.02405319
accumulated value	0.4305111	difference this update	0.02377445
accumulated value	0.4539905	difference this update	0.02347943
accumulated value	0.4771588	difference this update	0.02316824
accumulated value	0.5	difference this update	0.02284119
accumulated value	0.5224985	difference this update	0.02249858
accumulated value	0.544639	difference this update	0.02214044
accumulated value	0.5664062	difference this update	0.02176726
accumulated value	0.5877852	difference this update	0.02137899
accumulated value	0.6087614	difference this update	0.02097613
accumulated value	0.6293203	difference this update	0.02055895
accumulated value	0.649448	difference this update	0.02012765
accumulated value	0.6691305	difference this update	0.01968253
accumulated value	0.6883545	difference this update	0.01922399
accumulated value	0.7071066	difference this update	0.01875216
accumulated value	0.7253743	difference this update	0.01826769
accumulated value	0.7431448	difference this update	0.01777041
accumulated value	0.7604059	difference this update	0.01726115
accumulated value	0.7771459	difference this update	0.01674002
accumulated value	0.7933533	difference this update	0.0162074
accumulated value	0.8090171	difference this update	0.01566374
accumulated value	0.8241262	difference this update	0.01510918
accumulated value	0.8386706	difference this update	0.01454437
accumulated value	0.8526402	difference this update	0.0139696
accumulated value	0.8660255	difference this update	0.0133853
accumulated value	0.8788172	difference this update	0.01279169
accumulated value	0.8910066	difference this update	0.01218945
accumulated value	0.9025854	difference this update	0.01157874
accumulated value	0.9135455	difference this update	0.01096016
accumulated value	0.9238797	difference this update	0.01033413
accumulated value	0.9335805	difference this update	0.009700835
accumulated value	0.9426416	difference this update	0.009061098
accumulated value	0.9510567	difference this update	0.008415043
accumulated value	0.9588199	difference this update	0.007763207
accumulated value	0.9659259	difference this update	0.007106066
accumulated value	0.97237	difference this update	0.006444097
accumulated value	0.9781477	difference this update	0.005777657
accumulated value	0.983255	difference this update	0.005107343
accumulated value	0.9876884	difference this update	0.004433393
accumulated value	0.9914449	difference this update	0.003756523
accumulated value	0.994522	difference this update	0.00307703
accumulated value	0.9969174	difference this update	0.002395391
accumulated value	0.9986296	difference this update	0.001712203
accumulated value	0.9996573	difference this update	0.001027763
accumulated value	1.0	difference this update	0.0003426671
will wait for 3 seconds...
waited!
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

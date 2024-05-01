--CoreLibs
import 'CoreLibs/graphics'
import 'CoreLibs/object'
import 'CoreLibs/sprites'

import 'SequenceTypes'
import 'sequencer'
import 'sequenceManager'

gfx = playdate.graphics
geo = playdate.geometry

playdate.display.setRefreshRate(30)
gfx.sprite.setAlwaysRedraw(true)

---@type sequenceManager
seqMng = sequenceManager()

local actionList = {}

table.insert(actionList, {
	type = SequenceTypes.Progress,
	progress = {
		time = 2000,
		ease = playdate.easingFunctions.outSine,
		update = function(acc, diff)
			print('accumulated value', acc, 'difference this update', diff)
		end
	}
})

table.insert(actionList, {
	type = SequenceTypes.Call,
	call = function()
		print('will wait for 3 seconds...')
	end
})


table.insert(actionList, { type = SequenceTypes.Delay, delay = 3000 })

table.insert(actionList, {
	type = SequenceTypes.Call,
	call = function()
		print('waited!')
	end
})

seqMng:addSequencer(sequencer(actionList), 'owner identifier')

---@diagnostic disable-next-line: duplicate-set-field
function playdate.update()
	gfx.sprite.update()
	seqMng:update()
end

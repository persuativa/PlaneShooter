require "gtween"
require "com.jessewarden.planeshooter.utils.TweenUtils"

StageIntroScreen = {}

function StageIntroScreen:new(title, description)

	local screen = display.newGroup()
	
	function screen:init(title, description)
		local stageNumberText = display.newText(screen, title, 0, 0, native.systemFont, 32)
		screen:initChild("stageNumberText", stageNumberText)

		local line = display.newLine(screen, 0, 0, 100, 0)
		screen:initChild("line", line)

		local titleText = display.newText(screen, description, 0, 0, native.systemFont, 18)
		screen:initChild("titleText", titleText)

		self:createReadyAndGo()
	end

	function screen:createReadyAndGo()
		if self.readyText ~= nil then
			self.readyText:removeSelf()
		end

		if self.goText ~= nil then
			self.goText:removeSelf()
		end

		local readyText = display.newText(screen, "Ready?", 0, 0, native.systemFont, 14)
		screen:initChild("readyText", readyText)

		local goText = display.newText(screen, "GO!", 0, 0, native.systemFont, 14)
		screen:initChild("goText", goText)
	end

	function screen:initChild(name, child)
		screen:insert(child)
		screen[name] = child
		child.isVisible = false
	end

	function screen:show()
		self:createReadyAndGo()

		local stage = display.getCurrentStage()

		local stageNumberText = self.stageNumberText
		local line = self.line
		local titleText = self.titleText

		stageNumberText.isVisible = true
		local sideX = stage.width + 100
		stageNumberText.x = sideX
		stageNumberText.alpha = 0
		local centerX = stage.width / 2
		local startY = stage.height * 0.2

		stageNumberText.y = startY
		startY = startY + stageNumberText.height + 2

		line.isVisible = true
		line.x = sideX
		line.y = startY
		line.alpha = 0
		startY = startY + line.height + 20

		titleText.isVisible = true
		titleText.x = sideX
		titleText.y = startY
		titleText.alpha = 0

		local tweenSpeed = 0.5

		if line.tween ~= nil then
			transition.cancel(line.tween)
		end
		local lineCenter = centerX - 50
		line.tween = gtween.new(line, tweenSpeed, {x=lineCenter, alpha=1}, 
			{ease=gtween.easing.outBack})

		TweenUtils.stopTween(stageNumberText.tween)
		stageNumberText.tween = gtween.new(stageNumberText, tweenSpeed, {x=centerX, alpha=1}, 
			{ease=gtween.easing.outBack, delay=0.2})

		TweenUtils.stopTween(titleText.tween)
		titleText.tween = gtween.new(titleText, tweenSpeed, {x=centerX, alpha=1}, 
			{ease=gtween.easing.outBack, delay=1.5})	
		titleText.tween.onComplete = function(e)
			screen:onShowComplete()
		end
	end

	function screen:onShowComplete()
		local stageNumberText = self.stageNumberText
		local line = self.line
		local titleText = self.titleText
		local tweenSpeed = 0.3
		local delay = 2
		local left = -200
		if line.tween ~= nil then
			transition.cancel(line.tween)
		end
		line.tween = gtween.new(line, tweenSpeed, {x=left, alpha=0}, 
			{ease=gtween.easing.inExponential, delay=delay})

		delay = delay + .3
		TweenUtils.stopTween(stageNumberText.tween)
		stageNumberText.tween = gtween.new(stageNumberText, tweenSpeed, {x=-250, alpha=0}, 
			{ease=gtween.easing.inExponential, delay=delay})

		delay = delay + .2
		TweenUtils.stopTween(titleText.tween)
		titleText.tween = gtween.new(titleText, tweenSpeed, {x=left, alpha=0}, 
			{ease=gtween.easing.inExponential, delay=delay})
		titleText.tween.onComplete = function(e)
			screen:onShowStageComplete()
		end
	end

	function screen:onShowStageComplete()
		local stage = display.getCurrentStage()
		local readyText = self.readyText
		local goText = self.goText
		local tweenSpeed = 0.3
		local startY = -20
		local middle = stage.height / 2 - readyText.height / 2

		readyText.x = stage.width / 2 - readyText.width / 2
		readyText.y = startY
		readyText.isVisible = true
		readyText.alpha = 0

		goText.x = stage.width / 2 - goText.width / 2
		goText.y = startY
		goText.isVisible = true
		goText.alpha = 0

		TweenUtils.stopTween(readyText.tween)
		readyText.tween = gtween.new(readyText, tweenSpeed, {y=middle, alpha=1}, 
			{ease=gtween.easing.outBack})
		readyText.tween.onComplete = function(e)
			screen:onReadyInMiddle()
		end		
	end

	function screen:onReadyInMiddle()
		local readyText = self.readyText
		local goText = self.goText
		local bottom = stage.height + 20
		local tweenSpeed = 0.3
		local middle = stage.height / 2 - readyText.height / 2
		local delay = 0.5
		local w2 = readyText.width * 2
		local h2 = readyText.height * 2

		TweenUtils.stopTween(readyText.tween)
		readyText.tween = gtween.new(readyText, tweenSpeed, {y=bottom, alpha=0, width=w2, height=h2}, 
			{ease=gtween.easing.inExponential, delay=1})

		TweenUtils.stopTween(goText.tween)
		goText.tween = gtween.new(goText, tweenSpeed, {y=middle, alpha=1}, 
			{ease=gtween.easing.outExponential, delay=1.2})
		goText.tween.onComplete = function()
			screen:onGoInMiddle()
		end
	end

	function screen:onGoInMiddle()
		print("after after: ", self.readyText.width)


		local tweenSpeed = 0.5
		local goText = self.goText
		local tweenSpeed = 0.5
		TweenUtils.stopTween(goText.tween)
		goText.tween = gtween.new(goText, tweenSpeed, {rotation=360}, 
			{ease=gtween.easing.inBack, delay=1})
		goText.tween.onComplete = function()
			screen:onFinal()
		end
	end

	function screen:onFinal()
		local goText = self.goText
		local tweenSpeed = 1
		local bottom = stage.height + 20
		local w2 = goText.width * 2
		local h2 = goText.height * 2
		TweenUtils.stopTween(goText.tween)
		goText.tween = gtween.new(goText, tweenSpeed, {y=bottom, alpha=0, width=w2, height=h2}, 
			{ease=gtween.easing.outExponential})
		goText.tween.onComplete = function()
			screen:dispatchEvent({name="onScreenAnimationCompleted", target=screen})
		end
	end

	function screen:hide()
		local stageNumberText = self.stageNumberText
		local line = self.line
		local titleText = self.titleText
		local readyText = self.readyText
		local goText = self.goText

		TweenUtils.stopTween(stageNumberText.tween)
		TweenUtils.stopTween(line.tween)
		TweenUtils.stopTween(titleText.tween)
		TweenUtils.stopTween(readyText.tween)
		TweenUtils.stopTween(goText.tween)

		
	end

	function screen:hideText(text)
		text.isVisible = false
		text.alpha = 0
	end

	screen:init(title, description)

	return screen
end

return StageIntroScreen
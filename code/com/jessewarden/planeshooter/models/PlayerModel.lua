PlayerModel = {}

function PlayerModel:new()
	local model        = {}
	
	model.hitPoints    = 10
	model.maxHitPoints = 10
	
	model.weight       = 0
	model.maxWeight    = 10
	
	model.defense      = 0
	model.maxDefense   = 10

	model.power        = 0
	model.maxPower 	   = 10
	
	model.gun          = nil
	model.cannon       = nil
	model.missile      = nil
	model.body         = nil
	model.engine       = nil

	function model:setHitPoints(value)
		value = math.max(value, 0)
		if value > self.maxHitPoints then value = self.maxHitPoints end
		self.hitPoints = value
		Runtime:dispatchEvent({target=self, name="PlayerModel_hitPointsChanged"})
	end

	function model:getHitpointsPercentage()
		return self.hitPoints / self.maxHitPoints
	end

	function model:recalculateSpecs()
		local weight  = 0
		local defense = 0
		local power   = 0

		if self.gun ~= nil then
			weight = weight + self.gun.weight
		end

		if self.cannon ~= nil then
			weight = weight + self.cannon.weight
		end

		if self.missile ~= nil then
			weight = weight + self.missile.weight
		end

		if self.body ~= nil then
			weight = weight + self.body.weight
			defense = defense + self.body.defense
		end

		if self.engine ~= nil then
			weight = weight + self.engine.weight
			power = power + self.engine.power
		end

		self.weight  = weight
		self.defense = defense
		self.power   = power
		Runtime:dispatchEvent({name="PlayerModel_specsChanged", target=self})
	end


	-- [jwarden 10.1.2012] TODO: handle better type checking of what you're passing in here.

	function model:equipGun(gun)
		assert(gun ~= nil, "You cannot pass a nil gun.")
		local old = self.gun
		self.gun = gun
		self:recalculateSpecs()
		local evt = {name="PlayerModel_gunChanged", target=self, old=old, value=self.gun}
		Runtime:dispatchEvent(evt)
	end

	function model:removeGun()
		if self.gun ~= nil then
			local old = self.gun
			self.gun = nil
			self:recalculateSpecs()
			local evt = {name="PlayerModel_gunChanged", target=self, old=old}
			Runtime:dispatchEvent(evt)
			return old
		end
	end

	function model:equipCannon(cannon)
		assert(cannon ~= nil, "You cannot pass a nil cannon.")
		local old = self.cannon
		self.cannon = cannon
		self:recalculateSpecs()
		local evt = {name="PlayerModel_cannonChanged", target=self, old=old, value=self.cannon}
		Runtime:dispatchEvent(evt)
	end

	function model:removeCannon()
		if self.cannon ~= nil then
			local old = self.cannon
			self.cannon = nil
			self:recalculateSpecs()
			local evt = {name="PlayerModel_cannonChanged", target=self, old=old}
			Runtime:dispatchEvent(evt)
			return old
		end
	end

	function model:equipMissile(missile)
		assert(missile ~= nil, "You cannot pass a nil missile.")
		local old = self.missile
		self.missile = missile
		self:recalculateSpecs()
		local evt = {name="PlayerModel_missileChanged", target=self, old=old, value=self.missile}
		Runtime:dispatchEvent(evt)
	end

	function model:removeMissile()
		if self.missile ~= nil then
			local old = self.missile
			self.missile = nil
			self:recalculateSpecs()
			local evt = {name="PlayerModel_missileChanged", target=self, old=old}
			Runtime:dispatchEvent(evt)
			return old
		end
	end

	function model:equipEngine(engine)
		assert(engine ~= nil, "You cannot pass a nil engine.")
		local old = self.engine
		self.engine = engine
		self:recalculateSpecs()
		local evt = {name="PlayerModel_engineChanged", target=self, old=old, value=self.engine}
		Runtime:dispatchEvent(evt)
	end

	function model:removeEngine()
		if self.engine ~= nil then
			local old = self.engine
			self.engine = nil
			self:recalculateSpecs()
			local evt = {name="PlayerModel_engineChanged", target=self, old=old}
			Runtime:dispatchEvent(evt)
			return old
		end
	end

	function model:equipBody(bodyVO)
		assert(bodyVO ~= nil, "You cannot pass a nil bodyVO.")
		local old = self.body
		self.body = bodyVO
		self:recalculateSpecs()
		local evt = {name="PlayerModel_bodyChanged", target=self, old=old, value=self.body}
		Runtime:dispatchEvent(evt)
	end

	function model:removeBody()
		if self.body ~= nil then
			local old = self.body
			self.body = nil
			self:recalculateSpecs()
			local evt = {name="PlayerModel_bodyChanged", target=self, old=old}
			Runtime:dispatchEvent(evt)
			return old
		end
	end

	--[[
	function model:setScore(value)
		assert(value, "You must pass in a valid score value.")
		if value < 0 then value = 0 end
		self.score = value
		Runtime:dispatch({target=self, name="PlayerModel:scoreChanged"})
	end
	

	function model:addToScore(value)
		assert(value ~= nil, "You must pass in a valid score value to add.")
		if(value > 0) then
			self:setScore(self.score + value)
		end
	end
	]]--

	return model
end

return PlayerModel
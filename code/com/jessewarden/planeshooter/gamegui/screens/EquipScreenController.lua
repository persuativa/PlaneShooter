

EquipScreenController = {}

function EquipScreenController:new()
	local controller       = {}
	controller.equipModel  = nil
	controller.equipScreen = nil

	function controller:initialize(equipModel, playerModel, equipScreen)
		self.equipModel  = equipModel
		self.playerModel = playerModel
		self.equipScreen = equipScreen

		equipScreen:addEventListener("onEquipGun", self)
		equipScreen:addEventListener("onRemoveGun", self)
		equipScreen:addEventListener("onEquipEngine", self)
		equipScreen:addEventListener("onRemoveEngine", self)
		equipScreen:addEventListener("onEquipBody", self)
		equipScreen:addEventListener("onRemoveBody", self)

		equipScreen:setGuns(equipModel.guns)
		equipScreen:setEngines(equipModel.engines)
		equipScreen:setBodies(equipModel.bodies)

		equipScreen:setEquippedGun(playerModel.gun)
		equipScreen:setEquippedEngine(playerModel.engine)
		equipScreen:setEquippedBody(playerModel.body)

		Runtime:addEventListener("PlayerModel_specsChanged", self)
		Runtime:addEventListener("PlayerModel_gunChanged", self)
		Runtime:addEventListener("PlayerModel_engineChanged", self)
		Runtime:addEventListener("PlayerModel_bodyChanged", self)

		self:PlayerModel_specsChanged()

	end
	
	function controller:destroy()
		--Runtime:removeEventListener("EquipModel_gunsChanged", self)
	end

	function controller:PlayerModel_gunChanged(event)
		self.equipScreen:setEquippedGun(self.playerModel.gun)
	end

	function controller:PlayerModel_engineChanged(evnet)
		self.equipScreen:setEquippedEngine(self.playerModel.engine)
	end

	function controller:PlayerModel_bodyChanged(event)
		self.equipScreen:setEquippedBody(self.playerModel.body)
	end

	function controller:onEquipEngine(event)
		print("EquipScreenController::onEquipEngine")
		local equippedEngine = self.playerModel:removeEngine()
		print("equippedEngine after removed: ", equippedEngine)
		if equippedEngine ~= nil then
			self.equipModel.engines:addItem(equippedEngine)
		end
		print("event.vo: ", event.vo.classType)
		self.equipModel.engines:removeItem(event.vo)
		self.playerModel:equipEngine(event.vo)
	end

	function controller:onRemoveEngine(event)
		self.equipScreen:setEquippedEngine(nil)
		local oldEngine = self.playerModel:removeEngine()
		self.equipModel.engines:addItem(oldEngine)
	end

	function controller:onEquipGun(event)
		-- already have a gun equipped? If so, move it back
		local equippedGun = self.playerModel:removeGun()
		print("equippedGun: ", equippedGun)
		if equippedGun ~= nil then
			self.equipModel.guns:addItem(equippedGun)
		end

		self.equipModel.guns:removeItem(event.vo)

		-- take new gun and equip it to the player
		print("event.vo: ", event.vo)
		self.playerModel:equipGun(event.vo)
	end

	function controller:onRemoveGun(event)
		self.equipScreen:setEquippedGun(nil)
		-- unequip our gun
		local oldGun = self.playerModel:removeGun()
		-- put back in our inventory
		self.equipModel.guns:addItem(oldGun)
	end

	function controller:onEquipBody(event)
		-- already have a body equipped? If so, move it back
		local equippedBody = self.playerModel:removeBody()
		print("equippedBody: ", equippedBody)
		if equippedBody ~= nil then
			self.equipModel.bodies:addItem(equippedBody)
		end

		self.equipModel.bodies:removeItem(event.vo)

		-- take new gun and equip it to the player
		print("event.vo: ", event.vo)
		self.playerModel:equipBody(event.vo)
	end

	function controller:onRemoveBody(event)
		self.equipScreen:setEquippedBody(nil)
		-- unequip our gun
		local oldBody = self.playerModel:removeBody()
		-- put back in our inventory
		self.equipModel.bodies:addItem(oldBody)
	end

	function controller:PlayerModel_specsChanged(event)
		--local field = self.equipScreen.infoTextBox
		local model = self.playerModel
		local view = self.equipScreen
		view.progressWeight:setProgress(model.weight, model.maxWeight)
		view.progressPower:setProgress(model.power, model.maxPower)
		view.progressDefense:setProgress(model.defense, model.maxDefense)
	end
	
	return controller
end
	
return EquipScreenController
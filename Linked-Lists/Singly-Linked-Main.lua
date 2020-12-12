local LinkedLists = {}

local Bindable = Instance.new("BindableEvent")
Bindable.Name = "NodeAdded"
LinkedLists.NodeAdded = Bindable

LinkedLists.__index = LinkedLists

local function RepeatedAppend(Values, LinkedList)
	for _, v in pairs(Values) do
		LinkedList:Append(v)
	end
end

local function IterateLinkedList(List)
	local CurrentNode = List
	local Index = 0
	return function()
		Index = Index + 1
		CurrentNode = CurrentNode.NextNode
		local Value = CurrentNode and CurrentNode.Value
		return CurrentNode, Value, Index
	end
end

function LinkedLists.New(Value, ...)
	
	local LinkedList =  setmetatable({
		["Length"] = 0
	}, LinkedLists)
	
	if Value then
		LinkedList:Create(Value, ...)
	end
	
	return LinkedList
	
end

function LinkedLists:Create(Value, ...)
	
	if self.NextNode then
		warn("Don't run LinkedList:Create() on a linked list with a head") 
		return self:Append(...)
	end
	
	local ValueOfNode = {
		["Value"] = Value
	}
	
	self.NextNode = ValueOfNode
	self.Length = self.Length + 1
	self.NodeAdded:Fire(ValueOfNode)
	
	if ... then
		RepeatedAppend({...}, self)
	end
end

function LinkedLists:Append(Value, ...)
	
	local last = self.NextNode
	for Table, Value in IterateLinkedList(self) do
		last = Table
	end
	
	local ValueOfNode = {
		["Value"] = Value
	}
	
	last.NextNode = ValueOfNode
	self.Length = self.Length + 1
	self.NodeAdded:Fire(ValueOfNode)
	
	if ... then
		return RepeatedAppend({...}, self)
	end
end

function LinkedLists:Remove(Index) -- Index : number or string
	
	local TypeOfIndex = type(Index)
	local IsNumber = TypeOfIndex == "number"
	local IsString = TypeOfIndex == "string"
	local Index = IsNumber and Index or IsString and string.lower(Index) == "head"  and 1 or IsString and string.lower(Index) == "tail" and self.Length
	if self.Length < Index or not Index then warn("Improper argument sent") return end
	
	local LastNode, CurrentNode = self, self
	
	for Count = 1, Index do
		
		CurrentNode = CurrentNode.NextNode or error("Node not found")

		if Count == Index then
			
			LastNode.NextNode = CurrentNode.NextNode
			CurrentNode = nil
			break
			
		end
		
		LastNode = CurrentNode
	end
	
end

LinkedLists.Iterate = IterateLinkedList
return LinkedLists

--[[

-- Some Basic Usage :

local LinkedList = LinkedLists.New() -- Creates a new LinkedList Table
LinkedList:Create("z") -- Adds a new head node
LinkedList:Append("P") -- Appends the list and adds a value
LinkedList:Append(".") -- Same as above

for Table, Value in IterateLinkedList(LinkedList) do -- Loops through list and return the Node and Value the Node Holds
    print(Table, Value)
end


-- Example of what a linked list is : 

local Node4 = {Value = "a", NextNode = nil}
local Node3 = {Value = "b", NextNode = Node4}
local Node2 = {Value = "c", NextNode = Node3}
local Node1 = {Value = "d", NextNode = Node2}


print(Node1.NextNode.Value)
]]

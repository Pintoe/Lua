local LinkedLists = {}

local Bindable = Instance.new("BindableEvent")
Bindable.Name = "NodeAdded"
LinkedLists.NodeAdded = Bindable

LinkedLists.__index = LinkedLists

local function RepeatedAppend(Values, LinkedList) -- Values : Table of values to be added, LinkedList : Linked List
	for _, v in ipairs(Values) do
		LinkedList:Append(v)
	end
end

local function IterateLinkedList(List) -- List : Linked List
	local CurrentNode = List
	local Index = 0
	return function()
		Index = Index + 1
		CurrentNode = CurrentNode.NextNode
		local Value = CurrentNode and CurrentNode.Value
		return CurrentNode, Value, Index
	end
end

local function UpdateTail(LinkedList) -- LinkedList : Linked List
	LinkedList.Tail = LinkedList.Tail and LinkedList.Tail.NextNode or LinkedList.Tail or LinkedList.NextNode
end

function LinkedLists.New(Value, ...) -- Value : Any Variable
	
	local LinkedList =  setmetatable({
		["Length"] = 0
	}, LinkedLists)
		
	if Value then
		LinkedList:Create(Value, ...)
	end
	
	return LinkedList
	
end

function LinkedLists:Create(Value, ...) -- Value : Any Variable
	
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
	UpdateTail(self)
	if ... then
		RepeatedAppend({...}, self)
	end
end

function LinkedLists:Insert(Index, Value) -- Value : Any Variable | Index : number
	
	Value = type(Index) == "number" and Value
	Index = Index >= 1 and Index < self.Length and Index
	if not Index or not Value then error("Improper Argument recieved", Value) end
	
	local Node = {
		["Value"] = Value
	}
	
	local LastNode = self
	
	for Count = 1, Index do
		
		LastNode = LastNode.NextNode or error("Node not found")
		
		if Count == Index then
			
			local NodeInFront = LastNode.NextNode
			LastNode.NextNode = Node
			Node.NextNode = NodeInFront
			
		end
	end
end
function LinkedLists:Append(Value, ...) -- Value : Any Variable
		
	local ValueOfNode = {
		["Value"] = Value
	}
	
	self.Tail.NextNode = ValueOfNode
	self.Length = self.Length + 1
	self.NodeAdded:Fire(ValueOfNode)
	UpdateTail(self)
	
	if ... then
		return RepeatedAppend({...}, self)
	end
end

function LinkedLists:Remove(Index) -- Index : number 
	
	local Index = type(Index) == "number" and Index or error()
	if self.Length < Index or not Index then warn("Improper argument sent") return end
	
	local LastNode, CurrentNode = self, self
	
	for Count = 1, Index do
		
		CurrentNode = CurrentNode.NextNode or error("Node not found")

		if Count == 0 then
			
			LastNode.NextNode = CurrentNode.NextNode
			CurrentNode = nil
			break
			
		end
		
		LastNode = CurrentNode
	end
	
end

function LinkedLists:Peek(Index) -- Index : number
	
	local Index = type(Index) == "number" and Index 
	if self.Length < Index or not Index then warn("Improper argument sent") return end
	
	local Node = self
	for i = 1, Index do
		Node = Node.NextNode
		if i == 0 then
			break
		end
	end
	return Node
end

function LinkedLists:GetHead()
	return self.NextNode	
end

function LinkedLists:GetTail()
	return self.Tail
end
LinkedLists.Iterate = IterateLinkedList
return LinkedLists


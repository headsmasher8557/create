# create

A rewrite of RbxUtility's Create, which is a function for easy creation of Roblox instances.

It accepts a `string` which is the classname of the object to be created, and returns another function that can be called with a table with numeric keys assigned to children and properties to be set.

### Examples

The following is an example of how it can be used to create an Instance tree, along with some other scripted behaviors, such as running code when created and connecting functions to signals.

```lua
local model = Create"Model"{
	Name = "Coolest model of all time",
	Create"Humanoid"{
		Name = "Really awesome humanoid",
		MaxHealth = math.random(20, 100),
		[Create] = function(self)
			self.Health = self.MaxHealth
		end,
		[Create.E"Died"] = function(self)
			print(string.format("Oh no! %s has died!", self.Name))
		end
	},
	-- Parent is always assigned last, regardless of where you set it
	Parent = workspace
}
```

In addition to `Create`, the rewrite also adds a `Create.Set` function that allows you to modify an already existing Instance.

```lua
Create.Set(workspace.Baseplate){
	BrickColor = BrickColor.Random(),
	Name = "Not a Baseplate"
}
```
It also returns the same Instance that was passed into it:
```lua
-- This is equivalent to Create"Part"{}
-- Since there are no parameters given, this is also the same as Instance.new""
local part = Create.Set(Instance.new"Part"){}
```
Below is a more complex example of a part that changes color every second.
```lua
local part = Create"Part"{
	Size = Vector3.new(5,1,5),
	Name = "Dance Floor Tile",
	[Create] = function(self)
		-- The constructor function runs synchronously, so we're spawning a new thread
		task.spawn(function()
			while true do
				self.BrickColor = BrickColor.Random()
				task.wait(1)
			end
		end)
	end,
	[Create.E"Touched"] = function(self, hit)
		local humanoid = hit.Parent:FindFirstChildWhichIsA'Humanoid'
		if humanoid then
			print(string.format("%s stepped on the dance floor!", humanoid.Parent.Name))
		end
	end,
	Parent = workspace
}
```
### Other info

On top of that, the rewrite provides alternate function names which are listed below:
- For `Create.Set`:
	- `Create.set`
- For `Create.Event`:
	- `Create.event`
	- `Create.E`,
	- `Create.e`

There are also **two** available versions of Create:
- `create-basic.lua` is a very *very* simplistic version of Create, which includes `set` as well. It serves as an alternative to those that don't need any of the function features. **None of the examples above apply to this, as it doesn't have any implementation for `[Create]=function` or `[Create.E"e"]=function`.**
- `create.lua` is the main version that provides function features.

## Setting up

Create is just one Lua module, so you can pick either `create.lua` or `create-basic.lua` and add it to your project to require whenever it's needed.

If you're in an environment where you cannot add/require any modules, you can wrap the source around a `do` enclosure and set `Create` inside it instead of returning. Most approaches to this problem work fine if you know what you're doing, though.
```lua
local Create
do
	-- source goes here
	-- remove the last line (return Create_PrivImpl)
	Create = Create_PrivImpl
end

local part = Create"Part"{
	Name = "Transparent",
	Transparency = 0.5
}
```
For create-basic, you only need to paste the source and get rid of the return.

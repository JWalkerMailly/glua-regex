
-- @module regex
-- @author WLKRE
module("regex", package.seeall)

-- @field DHTML _env a static instance of DHTML reused across various functions
local _env

--- Returns a static DHTML instance.
-- @local
-- @param function callback lua callback from js
-- @return DHTML
local function GetEnv(callback)

	if (!IsValid(_env)) then
		_env = vgui.Create("DHTML")
		_env:SetAllowLua(true)
		_env:AddFunction("lua", "output", function(result)

			local output = util.JSONToTable(result) || result

			_env.callback(output)
		end)
	end

	-- abusing pass by reference out of scope
	_env.callback = callback

	return _env
end

--- Javascript boilerplate for regex to lua.
-- Builds javascript using the supplied regex code.
-- @local
-- @param string code regex code
-- @param string str regex input string
-- @param string exp regular expression
-- @param string flags regex flags (default: /gm)
-- @param vararg ...
-- @return string the javascript boilerplate code
local function Boilerplate(code, str, exp, flags, ...)

	local args = ""
	local varargs = {...}

	for i = 1, #varargs do
		args = args .. [[var arg]] .. i .. [[ = "]] .. varargs[i] .. [[";]]
	end

	local boilerplate = args .. [[

		var str = "]] .. str .. [[";
		var exp = /]] .. exp .. [[/]] .. (flags || "gm") .. [[;

		var result = ]] .. code .. [[;

		lua.output(JSON.stringify(result));
	]]

	return boilerplate
end

--- Javascript evaluator.
-- Main entry point for all regex functions. Prepares the environment,
-- builds/runs the javascript code and passes the result to the lua callback.
-- @local
-- @param string code regex code
-- @param string str regex input string
-- @param string exp regular expression
-- @param function callback the lua callback to pass the result to
-- @param string flags regex flags (default: /gm)
-- @param vararg ...
local function Run(code, str, exp, callback, flags, ...)

	local env = GetEnv(callback)
	local js  = Boilerplate(code, str, exp, flags, ...)

	env:RunJavascript(js)
end

--- Regular Expression Test.
-- @function
-- @param string str regex input string
-- @param string exp regular expression
-- @param function callback the lua callback to pass the result to
-- @param string flags regex flags (default: /gm)
function Test(str, exp, callback, flags)
	Run("exp.test(str)", str, exp, function(output) callback(tobool(output)) end, flags)
end

--- Regular Expression Exec.
-- @function
-- @param string str regex input string
-- @param string exp regular expression
-- @param function callback the lua callback to pass the result to
-- @param string flags regex flags (default: /gm)
function Exec(str, exp, callback, flags)
	Run("exp.exec(str)", str, exp, callback, flags)
end

--- Regular Expression Search.
-- @function
-- @param string str regex input string
-- @param string exp regular expression
-- @param function callback the lua callback to pass the result to
-- @param string flags regex flags (default: /gm)
function Search(str, exp, callback, flags)
	Run("str.search(exp)", str, exp, function(output) callback(tonumber(output)) end, flags)
end

--- Regular Expression Replace.
-- @function
-- @param string str regex input string
-- @param string exp regular expression
-- @param string replace the text used to replace the expression
-- @param function callback the lua callback to pass the result to
-- @param string flags regex flags (default: /gm)
function Replace(str, exp, replace, callback, flags)
	Run("str.replace(exp, arg1)", str, exp, callback, flags, replace)
end

--- Regular Expression Match.
-- @function
-- @param string str regex input string
-- @param string exp regular expression
-- @param function callback the lua callback to pass the result to
-- @param string flags regex flags (default: /gm)
function Match(str, exp, callback, flags)
	Run("str.match(exp)", str, exp, callback, flags)
end

--- Regular Expression Split.
-- @function
-- @param string str regex input string
-- @param string exp regular expression
-- @param function callback the lua callback to pass the result to
-- @param string flags regex flags (default: /gm)
function Split(str, exp, callback, flags)
	Run("str.split(exp)", str, exp, callback, flags)
end
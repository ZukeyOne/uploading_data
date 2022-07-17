-- ---
-- -- Finds out the name of the current branch
-- -- @return {nil|git branch name}
-- ---
-- function get_git_branch(git_dir)
--     git_dir = git_dir or get_git_dir()

--     -- If git directory not found then we're probably outside of repo
--     -- or something went wrong. The same is when head_file is nil
--     local head_file = git_dir and io.open(git_dir..'/HEAD')
--     if not head_file then return end

--     local HEAD = head_file:read()
--     head_file:close()

--     -- if HEAD matches branch expression, then we're on named branch
--     -- otherwise it is a detached commit
--     local branch_name = HEAD:match('ref: refs/heads/(.+)')

--     return branch_name or 'HEAD detached at '..HEAD:sub(1, 7)
-- end

-- ---
-- -- Gets the .git directory
-- -- copied from clink.lua
-- -- clink.lua is saved under %CMDER_ROOT%\vendor
-- -- @return {bool} indicating there's a git directory or not
-- ---
-- -- function get_git_dir(path)
-- -- MOVED INTO CORE

-- ---
-- -- Gets the status of working dir
-- -- @return {bool} indicating true for clean, false for dirty
-- ---
-- function get_git_status()
--     local file = io.popen("git --no-optional-locks status --porcelain 2>nul")
--     for line in file:lines() do
--         file:close()
--         return false
--     end
--     file:close()
--     return true
-- end

-- ---
-- -- Gets the conflict status
-- -- @return {bool} indicating true for conflict, false for no conflicts
-- ---
-- function get_git_conflict()
--     local file = io.popen("git diff --name-only --diff-filter=U 2>nul")
--     for line in file:lines() do
--         file:close()
--         return true;
--     end
--     file:close()
--     return false
-- end

-- -- * Segment object with these properties:
-- ---- * isNeeded: sepcifies whether a segment should be added or not. For example: no Git segment is needed in a non-git folder
-- ---- * text
-- ---- * textColor: Use one of the color constants. Ex: colorWhite
-- ---- * fillColor: Use one of the color constants. Ex: colorBlue
-- local segment = {
--     isNeeded = false,
--     text = "",
--     textColor = 0,
--     fillColor = 0
-- }

-- ---
-- -- Sets the properties of the Segment object, and prepares for a segment to be added
-- ---
-- local function init()
--     segment.isNeeded = get_git_dir()    
--     if segment.isNeeded then
--         -- if we're inside of git repo then try to detect current branch
--         local branch = get_git_branch(git_dir)
--         if branch then
--             -- Has branch => therefore it is a git folder, now figure out status
--             local gitStatus = get_git_status()
--             local gitConflict = get_git_conflict()
--             segment.text = " "..plc_git_branchSymbol.." "..branch.." "


--             if gitConflict then
--                 segment.textColor = segmentColors.conflict.text
--                 segment.fillColor = segmentColors.conflict.fill
--                 if plc_git_conflictSymbol then
--                     segment.text = segment.text..plc_git_conflictSymbol
--                 end 
--                 return
--             end 

--             if gitStatus then
--                 segment.textColor = segmentColors.clean.text
--                 segment.fillColor = segmentColors.clean.fill
--                 segment.text = segment.text..""
--                 return
--             end

--             segment.textColor = segmentColors.dirty.text
--             segment.fillColor = segmentColors.dirty.fill
--             segment.text = segment.text.."± "
--         end
--     end
-- end 

-- ---
-- -- Uses the segment properties to add a new segment to the prompt
-- ---
-- local function addAddonSegment()
--     init()
--     if segment.isNeeded then 
--         addSegment(segment.text, segment.textColor, segment.fillColor)
--     end 
-- end 

-- -- Register this addon with Clink
-- clink.prompt.register_filter(addAddonSegment, 62)
-- ANSI Foreground Colors
ansiFgClrBlack = "30"
ansiFgClrRed = "31"
ansiFgClrGreen = "32"
ansiFgClrYellow = "33"
ansiFgClrBlue = "34"
ansiFgClrMagenta = "35"
ansiFgClrCyan = "36"
ansiFgClrWhite = "37"
-- ANSI Background Colors
ansiBgClrBlack = "40"
ansiBgClrRed = "41"
ansiBgClrGreen = "42"
ansiBgClrYellow = "43"
ansiBgClrBlue = "44"
ansiBgClrMagenta = "45"
ansiBgClrCyan = "46"
ansiBgClrWhite = "47"

-- Colors
colorBlack = {
	foreground = ansiFgClrBlack,
	background = ansiBgClrBlack
}
colorRed = {
	foreground = ansiFgClrRed,
	background = ansiBgClrRed
}
colorGreen = {
	foreground = ansiFgClrGreen,
	background = ansiBgClrGreen
}
colorYellow = {
	foreground = ansiFgClrYellow,
	background = ansiBgClrYellow
}
colorBlue = {
	foreground = ansiFgClrBlue,
	background = ansiBgClrBlue
}
colorMagenta = {
	foreground = ansiFgClrMagenta,
	background = ansiBgClrMagenta
}
colorCyan = {
	foreground = ansiFgClrCyan,
	background = ansiBgClrCyan
}
colorWhite = {
	foreground = ansiFgClrWhite,
	background = ansiBgClrWhite
}

local segmentTime = {
    isNeeded = true,
    text = "",
    textColor = colorWhite, 
    fillColor = colorMagenta
}

local segmentAdb = {
    isNeeded = true,
    text = "",
    textColor = colorWhite, 
    fillColor = colorGreen
}

local a = ""

local function adb_prompt()
    -- t = io.popen('adb devices')
    -- a = t:read("*all")
    deviceTable = {}
    deviceNumber = 0
    for line in a:gmatch("([^\n]*)\n?") do
        if(string.find(line, "List of devices attached") == nil and string.find(line, "device"))
            then
            for w in line:gmatch("%S+") do
                table.insert(deviceTable, w)
                deviceNumber = deviceNumber + 1
                break
            end
        elseif(string.find(line, "List of devices attached") == nil and string.find(line, "offline"))
            then
            for w in line:gmatch("%S+") do
                table.insert(deviceTable, w.."(offline)")
                deviceNumber = deviceNumber + 1
                break
            end
        end
    end
    if(deviceNumber > 0)
        then
        adbText = " adb["..deviceNumber.."]:"
        for i, device in pairs(deviceTable) do
            adbText = adbText.." <"..device..">"
        end
        adbText = adbText.." "
        segmentAdb.text = adbText
        addSegment(segmentAdb.text, segmentAdb.textColor, segmentAdb.fillColor)
    end
    co = coroutine.create(function()
        -- t = io.popen('adb devices')
        -- a = t:read("*all")
        a = "List of devices attached\ncf263b7f device\nemulator-5554 offline\n192.168.1.6:5555 device"
        coroutine.resume(co2)
    end)
    coroutine.resume(co)
end

local function time_prompt()
    time = os.date("%X")
    segmentTime.text = " "..time.." "
    addSegment(segmentTime.text, segmentTime.textColor, segmentTime.fillColor)
end

clink.prompt.register_filter(time_prompt, 56)
clink.prompt.register_filter(adb_prompt, 57)
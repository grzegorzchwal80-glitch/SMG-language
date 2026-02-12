---@diagnostic disable: lowercase-global

local cmds = arg[1]
local cmds3 = arg[3]
local executeCommand =
'cmd /c "cd C:\\Users\\PC\\Documents\\myProject\\Files\\SMGinterpreter\\source && nasm -f win32 data.asm -o data.obj"'
local fs = {}

function fs.write(path, data)
    local f = io.open(path, "wb")
    if not f then return false end
    f:write(data)
    f:close()
    return true
end

local function Interpreter(input, allowIncludes)
    local inpute = io.open(input, "r"):read("*a")
    if inpute == nil then
        error("Error: Input file is empty or could not be read.", 1)
        os.exit(1)
    end
    if string.find(inpute, "main:", 1, true) == nil then
        error("Couldnt find main. Perhaps u gave it a different name, like glb start or glb begin, or forgot to add it?",
            1)
        os.exit(1)
    end
    if string.find(inpute, "endmain", 1, true) == nil then
        error("Couldnt find endmain. Did you forget to add it?", 1)
        os.exit(1)
    end

    local insideMain = false
    local lineNumber = 0
    local asm = {}
    local header = { "section .text" }

    for line in inpute:gmatch("[^\r\n]+") do
        lineNumber = lineNumber + 1
        local trimmed = (line or ""):gsub("\r", ""):match("^%s*(.-)%s*$") or ""
        local allowed = false

        if trimmed == "main:" then
            insideMain = true
            table.insert(asm, "main:")
        elseif trimmed == "endmain" then
            insideMain = false
            table.insert(asm, "ret")
            table.insert(asm, "; endmain")
        else
            if not insideMain then
                allowed = trimmed == "" or
                    trimmed:match("^%-%-") or
                    trimmed:match("^glb") or
                    trimmed:match("^dat%.") or
                    trimmed:match("^dd")

                if allowIncludes then
                    allowed = allowed or trimmed:match("^include%s+([%w_]+)")
                end

                if not allowed then
                    error("Error: Code found outside main at line " .. lineNumber, 1)
                end

                if trimmed:match("^glb%s+(%S+)") then
                    local sym = trimmed:match("^glb%s+(%S+)")
                    table.insert(header, "global " .. sym)
                elseif trimmed:match("^include%s+([%w_]+)") then
                    local sym = trimmed:match("^include%s+([%w_]+)")
                    table.insert(header, "extern " .. sym)
                end
            else
                if trimmed:match("^(%w+):$") then
                    table.insert(asm, trimmed)
                elseif trimmed ~= "" and not trimmed:match("^%-%-") then
                    local cmd, args = trimmed:match("^(%S+)%s*(.*)$")
                    local handler = smgToAsm[cmd]
                    if not handler then
                        error("Unknown instruction '" .. tostring(cmd) .. "' at line " .. lineNumber, 1)
                    end
                    table.insert(asm, handler(args, lineNumber))
                end
            end
        end
    end

    return table.concat(header, "\n") .. "\n" .. table.concat(asm, "\n")
end

local registers = { "eax", "ebx", "ecx", "edx", "esi", "edi", "esp", "ebp" }

smgToAsm = {
    set = function(args, lineNumber)
        local reg, val = args:match("(%w+)%s*,%s*(%S+)")
        if not reg or not val then
            error("Invalid set syntax at line " .. lineNumber)
        end
        local str = val:match('"(.-)"')
        if str then
            return "; set with string literal, handle in data section: " .. str
        end
        return "mov " .. reg .. ", " .. val
    end,

    plus = function(args)
        local reg, val = args:match("(%w+)%s*,%s*(%S+)")
        return "add " .. reg .. ", " .. val
    end,

    minus = function(args)
        local reg, val = args:match("(%w+)%s*,%s*(%S+)")
        return "sub " .. reg .. ", " .. val
    end,

    Times = function(args)
        return "mul " .. args
    end,

    divide = function(args)
        return "div " .. args
    end,

    go = function(args)
        return "jmp " .. args
    end,

    compare = function(args)
        return "cmp " .. args
    end,

    XOR = function(args)
        return "xor " .. args
    end,

    AND = function(args)
        return "and " .. args
    end,

    OR = function(args)
        return "or " .. args
    end,
    wait = function()
        return "nop "
    end,
    dword = function()
        return "dword"
    end,
    input = function(args)
        return "in " .. args
    end,

    output = function(args)
        return "out " .. args
    end,
    cli = function(args)
        return "cli " .. args
    end,
    sti = function(args)
        return "sti" .. args
    end,
    stop = function()
        return "hlt "
    end,

    call = function(args, line)
        local parts = {}
        for p in args:gmatch("[^,]+") do
            parts[#parts + 1] = p:match("^%s*(.-)%s*$")
        end
        local fn = parts[1]
        if not fn or fn == "" then error("Invalid call syntax at line " .. line) end
        local out = {}
        for i = #parts, 2, -1 do out[#out + 1] = "push " .. parts[i] end
        out[#out + 1] = "call " .. fn
        local n = #parts - 1
        if n > 0 then out[#out + 1] = "add esp, " .. (n * 4) end
        return table.concat(out, "\n")
    end,

    goiflseql = function(args)
        return "jle " .. args
    end,

    goeq = function(args)
        return "je " .. args
    end,

    gogreq = function(args)
        return "jge " .. args
    end,

    gogr = function(args)
        return "jg " .. args
    end,
}

if cmds == nil then
    print("Error: No command provided. Use -f, -i <filename.smg>")
    os.exit(1)
end

if cmds == "-v" then
    print(
        "SMG programming language compiler v1.0.1 \n License: GNU v3 with exceptions. \n Author: mangykirb on github, urlocaltangomangle on roblox. \n This can be used for anything, like OS dev, commercial products, games, or just general use.")
    os.exit(1)
end

if cmds == "smg" then
    print("SMG444444444444444444444444444444444444444444 HELL YEH !!!!!!!!!")
end
if cmds:lower() == "-setpath" then
    path = arg[3]
end
if cmds3 == "-bin" then
    executeCommand =
        'cmd /c cd' .. path .. '&& nasm -f bin data.asm -o data.bin'
elseif cmds3 == "-elf" then
    executeCommand =
        'cmd /c cd ' .. path .. '&& nasm -f elf data.asm -o data.o'
end

if cmds == "-f" then
    local arg2 = arg[2]
    if arg2 == nil then
        print("Error: No filename provided after -f")
        os.exit(1)
    end
    if string.sub(arg2, -4) ~= ".smg" then
        print("Error: File must have a .smg extension")
        os.exit(1)
    end

    local file = io.open(arg2, "r")
    if not file then
        print("Error: Could not open file " .. arg2)
        os.exit(1)
    end

    local read = file:read("*a")
    file:close()

    if not string.find(read, "glb main", 1, true) then
        error("During line of glb ..., expected main not other.", 1)
        os.exit(1)
    end

    local allowIncludes = false
    for _, c in ipairs(arg) do
        if c == "-i" then
            allowIncludes = true
            break
        end
    end

    local asm = Interpreter(arg2, allowIncludes)
    fs.write("data.asm", asm)
    os.execute(executeCommand)
end

--HELPIMINCAVE ALSO VIBECODED THIS WHOLE THING BOO THEM BOO BOOO BOOO BOO

local Deobfuscator = {}

local function readCode(payload, position)
    local length = tonumber(payload:sub(position, position), 36)
    if not length then
        error("Invalid encoded payload: missing token length", 3)
    end

    position = position + 1
    local token = payload:sub(position, position + length - 1)
    if #token ~= length then
        error("Invalid encoded payload: truncated token", 3)
    end

    local code = tonumber(token, 36)
    if not code then
        error("Invalid encoded payload: token is not base 36", 3)
    end

    return code, position + length
end

function Deobfuscator.decode(payload)
    if type(payload) ~= "string" then
        error("Deobfuscator.decode expects an encoded string", 2)
    end
    if #payload == 0 then
        return ""
    end

    local dictionary = {}
    for code = 0, 255 do
        dictionary[code] = string.char(code)
    end

    local position = 1
    local firstCode
    firstCode, position = readCode(payload, position)
    local previous = dictionary[firstCode]
    if not previous then
        error("Invalid encoded payload: initial code is outside the byte range", 2)
    end

    local output = { previous }
    local nextCode = 256

    while position <= #payload do
        local code
        code, position = readCode(payload, position)

        local current = dictionary[code]
        if not current then
            if code ~= nextCode then
                error("Invalid encoded payload: unknown dictionary code", 2)
            end
            current = previous .. previous:sub(1, 1)
        end

        dictionary[nextCode] = previous .. current:sub(1, 1)
        output[#output + 1] = current
        previous = current
        nextCode = nextCode + 1
    end

    return table.concat(output)
end

function Deobfuscator.deobfuscate(source)
    if type(source) ~= "string" then
        error("Deobfuscator.deobfuscate expects source text", 2)
    end

    local payload = source:match("local%s+c%s*=%s*E%s*`([^`]*)`")
    if not payload then
        error("Could not find an encoded payload in the source", 2)
    end

    return Deobfuscator.decode(payload)
end

return Deobfuscator

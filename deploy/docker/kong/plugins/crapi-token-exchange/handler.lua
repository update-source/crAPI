local http = require "resty.http"
local cjson = require "cjson.safe"

local CrapiTokenExchangeHandler = {
  VERSION  = "1.0.0",
  PRIORITY = 900,
}

local function fetch_new_token(conf)
    local httpc = http.new()
    local res, err = httpc:request_uri(conf.crapi_login_url, {
        method = "POST",
        ssl_verify = false,
        body = cjson.encode({
            email = conf.service_email,
            password = conf.service_password
        }),
        headers = {
            ["Content-Type"] = "application/json",
        }
    })

    if not res then
        kong.log.err("Failed to call crAPI login: ", err)
        return nil, err
    end

    -- BẮT LỖI TẬN TAY NẾU BACKEND TỪ CHỐI (SAI PASS, LỖI MẠNG...)
    if res.status ~= 200 then
        kong.log.err("crAPI Backend rejected login! Status: ", res.status, " | Body: ", res.body)
        return nil, "crAPI returned HTTP " .. tostring(res.status)
    end

    local body, decode_err = cjson.decode(res.body)
    if not body or not body.token then
        kong.log.err("Failed to decode crAPI token. Body was: ", res.body)
        return nil, "Invalid JSON or missing token"
    end

    return body.token
end

function CrapiTokenExchangeHandler:access(conf)
    local cache_key = "crapi_service_token_cache"

    local token, err = kong.cache:get(cache_key, { ttl = conf.token_ttl }, fetch_new_token, conf)

    if err or not token then
        kong.log.err("Could not retrieve crAPI token: ", err)
        return kong.response.exit(500, { message = "Internal Server Error: Token Exchange Failed" })
    end

    kong.service.request.set_header("Authorization", "Bearer " .. token)
end

return CrapiTokenExchangeHandler
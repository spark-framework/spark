local Spark = exports['spark']:Spark()

local URL = "https://api.ipify.org?format=json"

local text, status = Spark.Network:HTTP(URL, 'GET')
if status == 200 then
    local ip = json.decode(text)
    if ip["ip"] then
        print("HTTP test passed with success! " .. ip["ip"])
    end
else
    print("HTTP test failed! status code " + status)
end
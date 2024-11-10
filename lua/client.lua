local mouse = false
local chatLoaded = false

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:addSuggestions')
RegisterNetEvent('chat:addMode')
RegisterNetEvent('chat:removeMode')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEntered')

--deprecated, use chat:addMessage
AddEventHandler('chatMessage', function(author, color, text, tagData)

  Debug('chatMessage event', 'info')

  local args = { text }
  
  if author ~= "" then
    table.insert(args, 1, author)
  end

  SendNUIMessage({
    type = 'ON_MESSAGE',
    data = {
      args = args,
      mode = '_global',
    }
  })
end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
  print(msg)

  Debug('serverPrint event', 'info')

  if msg == '' or msg == nil then return end
  

  SendNUIMessage({
    type = 'ON_MESSAGE',
    data = {
      templateId = 'print',
      multiline = true,
      args = { msg },
      mode = '_global'
    }
  })
end)

-- addMessage
local addMessage = function(message)

  Debug('Adding message', 'info')

  if type(message) == 'string' then
    message = {
      args = { message }
    }
  end

  Debug(Dump(message), 'debug')
  
  SendNUIMessage({
    type = 'ON_MESSAGE',
    data = message
  })

end

exports('addMessage', addMessage)
AddEventHandler('chat:addMessage', addMessage)

-- addSuggestion
local addSuggestion = function(name, help, params)
  SendNUIMessage({
    type = 'ON_SUGGESTION_ADD',
    data = {
      name = name,
      help = help,
      params = params or nil
    }
  })
end

exports('addSuggestion', addSuggestion)
AddEventHandler('chat:addSuggestion', addSuggestion)

AddEventHandler('chat:addSuggestions', function(suggestions)

  Debug('Adding suggestions', 'info')

  for _, suggestion in ipairs(suggestions) do

    SendNUIMessage({
      type = 'ON_SUGGESTION_ADD',
      data = suggestion
    })

  end

end)


AddEventHandler('chat:removeSuggestion', function(name)
  SendNUIMessage({
    type = 'ON_SUGGESTION_REMOVE',
    name = name
  })
end)

AddEventHandler('chat:addMode', function(mode)
  SendNUIMessage({
    type = 'ON_MODE_ADD',
    mode = mode
  })
end)

AddEventHandler('chat:removeMode', function(name)
  SendNUIMessage({
    type = 'ON_MODE_REMOVE',
    name = name
  })
end)


AddEventHandler('chat:clear', function()
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
end)

RegisterCommand('clearchat', function()
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
end)

RegisterNUICallback('chatResult', function(data, cb)
  startDotTyping(false)
  SetNuiFocus(false)
  if data.message:sub(1, 1) == '/' then
    Debug('/Command entered: ' .. data.message, 'debug')
    ExecuteCommand(data.message:sub(2))
    if um.logs.commandChat then
      TriggerServerEvent('um-chat:server:logs:addLogs', 'commandChat', data.message, 'black')
    end
  else
    if um.chat.commandChat.onlyCommand then return end
    local id = PlayerId()
    Debug('Message entered: ' .. data.message, 'debug')
    TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), _, data.message)
  end
  cb('ok')
end)


local function refreshCommands()
  if GetRegisteredCommands then
    local registeredCommands = GetRegisteredCommands()

    local suggestions = {}

    for _, command in ipairs(registeredCommands) do
        if IsAceAllowed(('command.%s'):format(command.name)) and command.name ~= 'openChat' then
            table.insert(suggestions, {
                name = '/' .. command.name,
                help = ''
            })
        end
    end

    TriggerEvent('chat:addSuggestions', suggestions)
  end
end


AddEventHandler('onClientResourceStart', function(resName)
  Wait(500)
  refreshCommands()
  Debug(resName .. ' started', 'debug')
  Debug('Resource started', 'info')
end)

AddEventHandler('onClientResourceStop', function(resName)
  Wait(500)
  refreshCommands()
  Debug(resName .. ' stopped', 'debug')
  Debug('Resource stop', 'warn')
end)

RegisterNUICallback('loaded', function(_, cb)
  Debug('NUI is loaded', 'info')
  TriggerServerEvent('chat:init')
  refreshCommands()
  while um.chat.commandChat == nil or um.chat == nil or not next(um.chat) do
    Debug('Waiting for config', 'warn')
    Wait(100)
  end
  SendNUIMessage({type = 'setConfig', data = um.chat})
  chatLoaded = true
  cb('ok')
end)

RegisterNUICallback('forceConfig', function(_, cb)
  Debug('Force confing', 'info')
  SendNUIMessage({type = 'setConfig', data = um.chat})
  cb('ok')
end)

RegisterNUICallback('chatClose', function(_, cb)
  Debug('Chat closed', 'info')
  mouse = false
  SetNuiFocus(false,false)
  startDotTyping(false)
  cb('ok')
end)

RegisterNUICallback('openMouse', function(_, cb)
  mouse = not mouse
  SetNuiFocus(true, mouse)
  Debug('Mouse: ' ..tostring(mouse), 'info')
  cb('ok')
end)

RegisterKeyMapping('openChat', 'Open Chat', 'keyboard', 't')

RegisterCommand('openChat', function()
  if not chatLoaded then return Debug('Chat waiting for nui') end
  SendNUIMessage({
    type = 'ON_OPEN'
  })
  SetNuiFocus(true)
  Debug('Chat opened', 'info')
  startDotTyping(true)
end, false)

Citizen.CreateThread(function()
  SetTextChatEnabled(false)
  SetNuiFocus(false)
end)

openMenu = false

local main_menu = RageUI.CreateMenu("Magasin", "Intéraction")
local sub_menu = RageUI.CreateSubMenu(main_menu, "Paiment", "Intéraction")

main_menu.Closed = function()
    openMenu = false
end

local List = {
    Label = {"Aucun", "Nourriture", "Boisson"},
    Index = 1,
    aucun = false,
    nourriture = false,
    boisson = false
}

-- local Builder = {}

function OpenShop()
    if openMenu then
        openMenu = true
        RageUI.Visible(main_menu, true)
    else
        openMenu = true
        RageUI.Visible(main_menu, true)
    end

    CreateThread(function()
        while openMenu do
            Wait(1)

            RageUI.IsVisible(main_menu, function()

                RageUI.Checkbox("Ouvrir le menu", nil, checked, {}, {
                    onChecked = function()
                        checked = true
                    end,
                    onUnchecked = function()
                        checked = false
                    end,
                    onSelected = function(Index)
                        checked = Index
                    end
                })

                if checked then
                
                RageUI.Separator("~g~Bienvenue : ~w~" .. GetPlayerName(PlayerId()))

                -- RageUI.Button("Pain", nil, {RightBadge = RageUI.BadgeStyle.Franklin}, true, {
                --     onSelected = function()
                --         print("Achat de pain")
                --     end
                -- })

                RageUI.List("Filtre :", List.Label, List.Index, nil, {}, true, {
                    onListChange = function(Index, Item)
                        List.Index = Index
                        if Index == 1 then
                            List.aucun, List.nourriture, List.boisson = true, false, false
                        elseif Index == 2 then
                            List.aucun, List.nourriture, List.boisson = false, true, false
                        elseif Index == 3 then
                            List.aucun, List.nourriture, List.boisson = false, false, true
                        end
                    end
                })

                RageUI.Line()

                if List.aucun then
                    for _, item in pairs(Config.Food) do
                        RageUI.Button(item.label, nil, {RightLabel = "~g~"..item.price.."~s~$"}, true, {
                            onSelected = function()
                                -- item.name = Builder.name 
                                -- item.label = Builder.label 
                                -- item.price = Builder.price 
                                infoToSubMenu(item)
                            end
                        }, sub_menu)
                    end

                    RageUI.Line()

                    for _, item in pairs(Config.Drink) do
                        RageUI.Button(item.label, nil, {RightLabel = "~g~"..item.price.."~s~$"}, true, {
                            onSelected = function()
                                -- item.name = Builder.name 
                                -- item.label = Builder.label 
                                -- item.price = Builder.price
                                infoToSubMenu(item) 
                            end
                        }, sub_menu)
                    end
                end

                if List.nourriture then
                    for _, item in pairs(Config.Food) do
                        RageUI.Button(item.label, nil, {RightLabel = "~g~"..item.price.."~s~$"}, true, {
                            onSelected = function()
                                -- item.name = Builder.name 
                                -- item.label = Builder.label 
                                -- item.price = Builder.price 
                                infoToSubMenu(item)
                            end
                        }, sub_menu)
                    end
                end

                if List.boisson then
                    for _, item in pairs(Config.Drink) do
                        RageUI.Button(item.label, nil, {RightLabel = "~g~"..item.price.."~s~$"}, true, {
                            onSelected = function()
                                -- item.name = Builder.name 
                                -- item.label = Builder.label 
                                -- item.price = Builder.price 
                                infoToSubMenu(item)
                            end
                        }, sub_menu)
                    end
                end
            else
                RageUI.Line()
                RageUI.Separator("Veuiller cocher la case")
            end
            end)

            RageUI.IsVisible(sub_menu, function()
                
                RageUI.Separator(("Nom de l'article : ~b~%s"):format(label))
                RageUI.Separator(("Prix : ~g~%s~s~$"):format(price))
            
                RageUI.Line()

                RageUI.Button("→→→ Payer en liquide", nil, {RightBadge = RageUI.BadgeStyle.Star}, true, {
                    onSelected = function()
                        local info = 'liquide'
                        TriggerServerEvent('shop:buyItem', info, label, name, price)
                    end
                })

                RageUI.Button("→→→ Payer en CB", nil, {RightBadge = RageUI.BadgeStyle.Star}, true, {
                    onSelected = function()
                        local info = 'cb'
                        TriggerServerEvent('shop:buyItem', info, label, name, price)
                    end
                })

            end)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        local interval = 1000
        for _,v in pairs(Config.Position) do
            local playerPos = GetEntityCoords(PlayerPedId())
            local dst = #(playerPos - v)
            if dst <= 5.0 then
                interval = 0
                DrawMarker(23, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
                if dst <= 2.0 then
                    Visual.Subtitle("Appuyez sur ~b~[E]~s~ pour ouvrir le magasin")
                    if IsControlJustPressed(1, 51) then
                        OpenShop()
                    end
                end
            end
        end
        Wait(interval)
    end
end)

function infoToSubMenu(item)
    label = item.label
    name = item.name
    price = item.price
end
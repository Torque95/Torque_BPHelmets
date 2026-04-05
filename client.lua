-- client.lua

local headBones = {
    [31086] = true, -- SKEL_Head
    [39317] = true, -- SKEL_Neck_1
}

-- Event to handle incoming damage
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        local weaponHash = args[7]
        local isMelee = args[10]

        if not DoesEntityExist(victim) or not DoesEntityExist(attacker) then return end
        if victim ~= PlayerPedId() then return end -- Only process local player being shot

        local boneHit = GetPedLastDamageBone(victim)
        if boneHit then
            boneHit = tonumber(boneHit)
            if headBones[boneHit] then
                -- Headshot detected
                -- Force-enable critical hits just in case
                SetPedSuffersCriticalHits(victim, true)

                -- Wait a bit to ensure GTA damage was applied
                Wait(10)

                -- Check if ped still alive (helmet "blocked" it)
                if not IsEntityDead(victim) then
                    -- Apply fatal damage manually
                    SetEntityHealth(victim, 0)
                    -- Optional: notify for debug
                     print("Bypassing helmet protection: Headshot override kill applied.")
                end
            end
        end
    end
end)


local verticalRecoilStrengthM4A1 = {8, 8, 8, 10} -- Các mức độ giật dọc theo thời gian (M4A1)
local horizontalRecoilStrengthM4A1 = {1, 1, 0, 0} -- Các mức độ giật ngang theo thời gian (M4A1)

local verticalRecoilStrengthBeryl = {9, 10, 11, 12} -- Các mức độ giật dọc theo thời gian (Beryl)
local horizontalRecoilStrengthBeryl = {1, 1, 1, -1} -- Các mức độ giật ngang theo thời gian (Beryl)

local verticalRecoilStrengthAKM = {6, 7, 8, 9} -- Các mức độ giật dọc theo thời gian (AKM)
local horizontalRecoilStrengthAKM = {0, -1, -1, 0} -- Các mức độ giật ngang theo thời gian (AKM)

local currentMode = 1 -- Chế độ hiện tại (1, 2 hoặc 3)

function SwitchMode()
    currentMode = currentMode + 1
    if currentMode > 3 then
        currentMode = 1
    end
    OutputLogMessage("Chế độ hiện tại: " .. currentMode .. "\n")
end

function GetCurrentRecoil()
    if currentMode == 1 then
        return verticalRecoilStrengthM4A1, horizontalRecoilStrengthM4A1
    elseif currentMode == 2 then
        return verticalRecoilStrengthBeryl, horizontalRecoilStrengthBeryl
    else
        return verticalRecoilStrengthAKM, horizontalRecoilStrengthAKM
    end
end

function OnEvent(event, arg)
    if event == "MOUSE_BUTTON_PRESSED" and arg == 5 then -- Nhấn nút chuột phụ (ví dụ: nút số 5) để đổi chế độ
        SwitchMode()
    end

    if IsKeyLockOn("Capslock") then
        if IsMouseButtonPressed(3) then -- Khi nhấn giữ chuột phải (ADS)
            local verticalRecoilStrength, horizontalRecoilStrength = GetCurrentRecoil()
            local startTime = GetRunningTime()
            repeat
                if IsMouseButtonPressed(1) then -- Khi nhấn giữ chuột trái (bắn)
                    local elapsedTime = GetRunningTime() - startTime -- Thời gian đã trôi qua
                    local verticalRecoil = verticalRecoilStrength[math.min(math.floor(elapsedTime / 1000) + 1, #verticalRecoilStrength)]
                    local horizontalRecoil = horizontalRecoilStrength[math.min(math.floor(elapsedTime / 1000) + 1, #horizontalRecoilStrength)]

                    -- Di chuyển chuột với giá trị giật tính toán được
                    MoveMouseRelative(horizontalRecoil, verticalRecoil)

                    Sleep(3) -- Thời gian giữa các lần di chuyển chuột
                else
                    -- Nếu ngừng bắn, reset giật
                    MoveMouseRelative(0, 0)
                end
            until not IsMouseButtonPressed(3)
        end
    end
end

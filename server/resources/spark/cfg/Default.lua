local Default =  {
    Coords = vector3(235.71, -411.25, 50.13),
    Health = 150,

    Customization = {
        model = "mp_m_freemode_01"
    },

    Weapons = {}
}

for i = 0, 19 do
    Default.Customization[i] = {0, 0}
end

return Default
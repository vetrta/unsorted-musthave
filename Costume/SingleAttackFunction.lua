function CustomLua_Burst()
  local mainClass,subClass = UnitClass("player");
  local fullClass = mainClass..subClass;
  local functionName = "Burst_" .. fullClass;

  if not _G[functionName] then
    CustomLuaNotice("No burst rotation available for " .. fullClass);
    return;
  end

  _G[functionName]();
end

function CustomLua_AoE()
  local mainClass,subClass = UnitClass("player");
  local fullClass = mainClass..subClass;
  local functionName = "AoE_" .. fullClass;

  if not _G[functionName] then
    CustomLuaNotice("No AoE rotation available for " .. fullClass);
    return;
  end

  _G[functionName]();
end

function CustomLua_Farm()
  local mainClass,subClass = UnitClass("player");
  local fullClass = mainClass..subClass;
  local functionName = "Farm_" .. fullClass;

  if not _G[functionName] then
    CustomLuaNotice("No farm rotation available for " .. fullClass);
    return;
  end

  _G[functionName]();
end

function CustomLua_Support()
  local mainClass,subClass = UnitClass("player");
  local fullClass = mainClass..subClass;
  local functionName = "Support_" .. fullClass;

  if not _G[functionName] then
    CustomLuaNotice("No support rotation available for " .. fullClass);
    return;
  end

  _G[functionName]();
end

---@diagnostic disable: lowercase-global, undefined-global

-- ##########
-- # == Configuration ==
-- #
-- name for alternative, global preset store table
local globalPresetStoreName = 'shivaPresetStore'
-- #
-- ##########

-- CONSTANTS
local COLOR_GRP_BACKGROUND = '000000DB'
local COLOR_TEXTDEFAULT = 'FFFFFFD0'
local COLOR_DIGIT_BUTTONS = '2BA3D5C7'
local COLOR_FN_BUTTONS = 'FFAC0098'
local COLOR_MSG_DISPLAY = '2B84D5D7'
local COLOR_MSG_DISPLAY_TXT = 'FFFFFFD0'
local COLOR_INFO_DISPLAY = '53ED26A6'
local COLOR_INFO_DISPLAY_TxT = '86F17DD2'
local FADEIN = true
local FADEM = false
local DEBUG = false
local BLINKCONTROLS = 7
local BLINKDISPLAYS = 7
local PRESETNAMEID = 'preset_name'
local PRESETIDID = 'preset_id'
local RESERVED = 'shivaReserved'
local CB_ALL = 0
local CB_ONLYPASTE = 1
-- keyboard targets
local KBDTARGETACTIVEPRESET = 'activePresetName'
local KBDTARGETNEWSAVE = 'newSave'
-- CONTROLS
local presetModuleMain = self.parent
local presetModule = self.parent.children
local shiva = {
  -- groups
  groupDirectLoad = presetModule.groupDirectLoad.children,
  groupDirectLoadButtonsMain = presetModule.groupDirectLoadButtons,
  groupDirectLoadButtons = presetModule.groupDirectLoadButtons.children,
  grpManagerMain = presetModule.grpManager,
  grpManager = presetModule.grpManager.children,
  groupRunSettingsMain = presetModule.groupRunSettings,
  groupRunSettings = presetModule.groupRunSettings.children,
  groupKeyboardMain = root.children.app.children.keyboard.children.groupKeyboard,
  groupKeyboard = root.children.app.children.keyboard.children.groupKeyboard.children,
  grpBlock = presetModule.grpBlock,
  borderGroupBottom = presetModule.borderGroupBottom,
  allPages= {},
  -- settings
  presetStore = nil,
  workStore = presetModule.workStore.children,
  skinSettings = presetModule.skinSettings.children,
  blinkFader = presetModule.blinkFader,
  blinkText = presetModule.blinkText,
  stBtnEnableDebug = presetModule.groupRunSettings.children.stBtnEnableDebug,
  stBtnGrpFadeOnDirectLoad = presetModule.groupRunSettings.children.stBtnGrpFadeOnDirectLoad.children.labelDisplay,
  stLblShowControlCount = presetModule.groupRunSettings.children.stLblShowControlCount,
  stLblPresetRoot = presetModule.groupRunSettings.children.stLblPresetRoot,
  -- Manager buttons and displays
  dspInfo = presetModule.grpManager.children.dspInfo,
  lcdMessage = presetModule.grpManager.children.lcdMessage,
  btnFnLoad = presetModule.grpManager.children.btnFnLoad,
  btnFnEnter = presetModule.grpManager.children.btnFnEnter,
  btnFnSave = presetModule.grpManager.children.btnFnSave,
  fdrCrossfade = presetModule.grpManager.children.fdrCrossfade,
  lblFadeMode = presetModule.grpManager.children.lblFadeMode,
  dspSelected = presetModule.grpManager.children.dspSelected,
  lblRestore = presetModule.grpManager.children.lblRestore,
  lblClearWork = presetModule.grpManager.children.lblClearWork,
  -- Direct load row on top
  lblDirectHeading = presetModule.groupDirectLoad.children.lblDirectHeading,
  dspDirectInfo = presetModule.groupDirectLoad.children.dspDirectInfo,
  -- Menus
  menuContext = presetModule.menuContext,
  obxdMovie = presetModuleMain.parent.children.background.children.starwars,
  obxdLogo = presetModuleMain.parent.children.background.children.logo
}
-- LOCAL
local handlers = {}
local state = {
  -- from where to get controls
  rootName = nil,
  presetRootCtrl = '',
  -- some collections
  allControls = nil,
  currValues = {},
  presetValues = {},
  fadeValues = {},
  oldValues = {},
  clipBoard = {},
  -- misc.
  modifiedText = '',
  selectedPreset = 0,
  presetModified = false,
  maxPreset = 0,
  selectedIsEmpty = false,
  collapsed = false,
  ignoreToggle = false,
  lastPage = nil,
  bankSize = 130,
  -- Target where to put the text from keyboard after edit
  kbdTarget = '',
  -- keep track of working state stack
  lastWork = 0,
  -- crossfade states
  fadeStartTime = 0,
  autoFade = true,
  fading = false,
  fadeStartValue = 0.0,
  fadeStep = -1,
  fadeMax = 100,
  -- blink controls ;)
  blinkControls = {},
  blinking = 0,
  blinkTextControls = {},
  textBlinkg = 0,
  changedControls = {},
  blinkSrcTextColors = {},
  -- = periodic updates =
  msgLcdDelay = 2000,
  msgLcdSent = 0,
  msgLcd = '',
  -- crossfade update
  fadeDelay = 30,
  fadeLast = 0,
  -- slow update
  relaxDelay = 2000,
  relaxLast = 0,
  --fast update
  hurryDelay = 300,
  hurryLast = 0,
  --slow control setting process
  slowSetDelay = 20,
  slowSetLast = 0,
}

-- === INIT  ===

function init()
  initDebug()
  log('INIT processor..')
  initShiva()
  log('Max preset: ' .. state.maxPreset)
  registerHandlers()
  applyLayout()
  initConfig()
  clearWork()
  initPreset()
  disableFade()
  initCrossfade()
  getAllCurrentValues(true)
  initGui()
end

function initDebug()
  if shiva.stBtnEnableDebug.values.x == 0 then
    DEBUG = false
  else
    DEBUG = true
  end
  logDebug('#### Debug logging ENABLED. ####')
end

function initShiva()
  local gs = presetModuleMain.parent.parent.children[globalPresetStoreName]
  if gs ~= nil then
    local s = gs.parent.name .. '.' .. gs.name
    log('FOUND GLOBAL PRESET STORE TABLE: ' .. s)
    shiva.presetStore = gs.children
  else
    shiva.presetStore = presetModule.shivaPresetStore.children
    log('Using default internal preset store table: ' .. presetModule.shivaPresetStore.name)
  end
  state.maxPreset = #shiva.presetStore - 1
  shiva.allPages = {
    shiva.groupDirectLoadButtonsMain,
    shiva.grpManagerMain,
    shiva.groupRunSettingsMain,
    shiva.groupKeyboardMain,
  }
end

function initConfig()
  log('Initializing config')
  initDebug()
  state.rootName = shiva.groupRunSettings.stLblPresetRoot.values.text
  state.presetRootCtrl = state.rootName == '' and root or root:findByName(state.rootName, true)
  if state.presetRootCtrl == nil then
    log('WARNING! Control group "' .. state.rootName .. '" not found! Using root!')
    shiva.groupRunSettings.stLblShowRoot.values.text = 'GROUP NAME ERROR! Using root!'
    lcdMessageDelayed('WARNING! base group error!')
    state.presetRootCtrl = root
  else
    shiva.groupRunSettings.stLblShowRoot.values.text = 'Group found :)'
  end
  state.allControls = nil
  state.autoFade = false
  toggleFadeMode()
  lcdMessage('Controls Select:\n' .. getSelectModeStr())
end

function initGui()
  -- ensure all controls show in the right state
  -- TODO: Currently not used ..way!! too complicated with dynamic text colors!!
  -- maybe this can still be done as local msg between label and button,
  -- have to think ..
  for i = 11, 20 do
    -- save button colors to tag .. :(
    shiva.groupDirectLoadButtons[i].tag = Color.toHexString(shiva.groupDirectLoadButtons[i].properties.textColor)
  end
  updateDirectLoadButtons()
  updateLabelFade()
  ignoreToggle = false
  if showingEditor() then
    showEditor()
  elseif showingCollapsed() then
    state.collapsed = true
    showCollapsed()
  elseif showingDirectLoad then
    showDirectLoad()
  else
    showEditor()
  end
  lcdMessage('Controls Select:\n' .. getSelectModeStr())
  lcdMessageDelayed('Welcome to\n"Shiva"\nPreset Module')
  log('Init finished.')
  log('== Welcome to "Shiva" Preset Module! Happy Jamin\' :-) ==')
end

function cycleView()
  if shiva.menuContext.visible then return end
  if showingKeyboard() then return end
  if showingRunSettings() then
    initConfig()
    if state.lastPage ~= showRunSettings then
      showLastPage()
    elseif state.collapsed then
      showCollapsed()
    else
      showEditor()
    end
    return
  end
  if showingDirectLoad() then
    if state.collapsed then showCollapsed() else showEditor() end
  elseif showingEditor() then
    showDirectLoad()
  elseif showingCollapsed() then
    showDirectLoad()
  else
    showEditor()
  end
end

function initPreset()
  if getSelectedPreset() == nil then selectPreset(0) end
  local presetNo = getActivePreset()
  if presetNo == nil then
    presetNo = 0
  else
    presetNo = math.max(0, math.min(state.maxPreset, presetNo))
  end
  -- cleanest way to get a sane initial state if no presets exist..
  selectPreset(presetNo)
  if not applySelectedPreset() then activateSelectedPreset() end
end

-- === CALLBACK HANDLERS ===

function onReceiveNotify(cmd, val)
  if cmd == 'blinkFader' then
    blinkControls(val)
  elseif cmd == 'blinkText' then
    blinkTextControls(val)
  elseif cmd == 'kbdClose' then
    saveKeyboardValue(val)
  elseif cmd == 'pagePlusDirectLoad' or cmd == 'pageMinusDirectLoad' then
    prgSwitchDirect(cmd)
  elseif cmd == 'longTap' then
    if val == shiva.dspSelected.name then
      showContextMenu()
    elseif val == 'lblDirectEdit' then
      state.ignoreToggle = true
      showRunSettings()
    elseif string.match(val, '^direct[0-9]+$') then
      local p = string.sub(val, 7)
      selectPreset(p)
      if loadSelectedPreset() then showContextMenu() else showContextMenu(CB_ONLYPASTE) end
    end
  end
end

function update()
  local now = getMillis()
  updateFast(now)
  updateSlow(now)
  updateFade(now)
end

function registerHandlers()
  handlers = {
    btnFnEnter = loadOrSave,
    btnFnLoad = toggleLoad,
    btnFnSave = toggleSave,
    fdrCrossfade = fadeStart,
    fadeState = fadeUpdate,
    lcdMessage = lcdTap,
    -- btnToggleEdit = toggleEdit,
    -- btnFnKbdClose = saveKeyboardValue,
    lblFadeMode = toggleFadeMode,
    btnRestore = restoreWork,
    btnClearWork = clearWork,
    btnMinusBank = bankSwitch,
    btnPlusBank = bankSwitch,
    btnMinusPrg = prgSwitch,
    btnPlusPrg = prgSwitch,
    btnMinusDirectBankLoad = bankSwitchDirect,
    btnPlusDirectBankLoad = bankSwitchDirect,
    btnMinusDirectPrgLoad = prgSwitchDirect,
    btnPlusDirectPrgLoad = prgSwitchDirect,
    pagerDirectPageLoad = pageSwitchDirect,
    lblDirectHeading = toggleCollapse,
    lblDirectEdit = toggleEdit,
    dspInfo = addChangedControlsToBlink,
    entryCut = clipBoardCut,
    entryCopy = clipBoardCopy,
    entryPaste = clipBoardPaste,
    entryDelete = deletePreset,
    -- Run Settings
    stBtnRandomize = executeRandomize,
    stBtnClearPreset = purgePresetStore,
    stBtnSelectMidi = discoverControls,
    stBtnSelectOsc = discoverControls,
    stLblPresetRoot = discoverControls,
  }
end

function onValueChanged()
  local cmd = self.values.text
  self.values.text = '' -- reset command
  if string.match(cmd, '^direct[0-9]+') then
    -- same for direct select buttons
    directSelect(cmd)
  elseif string.match(cmd, '^[0-9]+$') then
    -- all digit buttons handled by same function
    addDigitToPreset(cmd)
  else
    -- call other handlers if present
    for c, h in pairs(handlers) do
      if c == cmd then
        logDebug('Command: ' .. c)
        h(cmd)
      end
    end
  end
end

-- === CALLBACK HELPER FUNCTIONS ===

function discoverControls()
  initConfig()
  state.allControls = nil
  getAllCurrentValues(true)
  shiva.stLblShowControlCount.values.text = 'found controls: ' .. #state.allControls
  addControlToTextBlink(shiva.stLblShowControlCount)
  for id, c in pairs(state.allControls) do
    addControlToBlink(c)
  end
  state.blinking = BLINKCONTROLS
end

function blinkControls(val)
  if state.blinking <= 0 then return end
  for k, v in pairs(state.blinkControls) do
    v.ctrl.properties.color.a = val
    if v.ctrl.properties.textColor ~= nil then
      v.ctrl.properties.textColor.a = val
    end
  end
end

function blinkTextControls(val)
  if val == 1 then
    for id, v in pairs(state.blinkTextControls) do
      logDebug('Remove text blink: ' .. v.ctrl.name)
      v.ctrl.properties.textColor.a = v.at
      state.blinkTextControls[id] = nil
    end
  else
    for id, v in pairs(state.blinkTextControls) do
      v.ctrl.properties.textColor.a = val
    end
  end
end

function updateFast(now)
  if itIsTimeTo('hurry', now) then
    updateBlinking()
  end
end

function updateSlow(now)
  showMsgLcdDelayed(now)
  if itIsTimeTo('relax', now) then
    -- just resets the fader to zero whenever it's safe to do so
    if not state.fading and crossfaderNotTouched() then
      if not state.autoFade then
        shiva.fdrCrossfade.values.x = 1.0
      else
        shiva.fdrCrossfade.values.x = 0.0
      end
    end
        -- check if the user changed some of our precious controls..
    if getActivePreset() == getSelectedPreset() then checkModified() end
  end
end

function updateFade(now)
  if itIsTimeTo('fade', now) then
    if not state.autoFade or state.fadeStep < 0 then return end
    if state.fadeStep == 0 then
      disableFade()
      applySelectedPreset()
    end
    applyFadeValues()
    updateFadeValues()
    if math.fmod(state.fadeStep, 10) == 0 then
      local s = (getMillis() - now) / state.fadeDelay
      shiva.grpManager.fdrLoad.values.x = 0.5 * (shiva.grpManager.fdrLoad.values.x + s)
      if s > 0.9 then shiva.grpManager.fdrLoad.color.r = 1
      elseif s > 0.8 then shiva.grpManager.fdrLoad.color.r = 0.5
      else shiva.grpManager.fdrLoad.color.r = 0 end
    end
  end
end

function updateBlinking()
  if state.blinking > 0 then
    shiva.blinkFader.values.x = 1
    state.blinking = state.blinking - 1
  else
    for id, v in pairs(state.blinkControls) do
      logDebug('Resetting control after blink: ' .. v.ctrl.name)
      v.ctrl.properties.color.a = v.a
      if v.ctrl.properties.textColor ~= nil then
        v.ctrl.properties.textColor.a = v.at
      end
      state.blinkControls[id] = nil
    end
  end
end

-- === COMMAND HANDLERS ===

function loadOrSave()
  disableFade()
  if userWantsToSave() then
    saveToSelectedPreset()
    shiva.btnFnSave.values.x = 0
  elseif userWantsToLoad() then
    cacheWork()
    applySelectedPreset()
    shiva.btnFnLoad.values.x = 0
  else
    lcdMessage('select function\nload or save')
  end
end

function toggleLoad()
  showSelectMessage()
  if shiva.btnFnLoad.values.x == 0 then
    lcdMessage(getSelectedPresetName())
  else
    lcdMessage('enter to load')
  end
end

function toggleSave()
  showSelectMessage()
  if shiva.btnFnSave.values.x == 0 then
    if getSelectedPreset() == getActivePreset() then
      lcdMessage(getActivePresetName())
    else
      lcdMessage(getSelectedPresetName())
    end
  else
    if state.selectedIsEmpty then
      lcdMessage('ENTER NAME:\ntap here')
    else
      lcdMessage('enter to save')
    end
  end
end

function fadeStart()
  if not state.autoFade then return end
  if shiva.btnFnLoad.values.x ~= 1 then
    lcdMessage('enable load!')
  elseif state.fadeStep > 0 then
    state.fadeStartTime = getMillis()
    shiva.btnFnLoad.values.x = 0
    -- cacheWork()
    initCrossfade()
    startFading()
    applySelectedPreset()
  end
end

function fadeUpdate()
  if not state.autoFade then
    if shiva.btnFnLoad.values.x ~= 1 and not state.fading then
      lcdMessage('enable load!')
    else
      shiva.btnFnLoad.values.x = 0
      initCrossfade()
      startFading()
      applyManualFade(shiva.fdrCrossfade.values.x)
    end
  elseif state.autoFade then
    if crossfaderNotTouched() then
      if not userWantsToLoad() then return end
      if shiva.fdrCrossfade.values.x == 0 then
        lcdMessage(getSelectedPresetName())
        return
      end
    end
    -- get value from User
    local v = makeCrossfaderCurvy()
    if v > 0 then
      v = math.max(5, v)
      lcdMessage('fade ' .. string.format("%.2f", 1.1 * v * state.fadeDelay / 1000) .. ' s')
      state.fadeStep = v
      state.fadeMax = v
    else
      lcdMessage('fade abort')
      state.fadeStep = 0
      state.fadeMax = 100
    end
  end
end

function lcdTap()
  if userWantsToSave() and state.selectedIsEmpty then
    state.kbdTarget = KBDTARGETNEWSAVE
    startKeyboard(self.ID, getSelectedPresetName())
  elseif userWantsToLoad() then
    -- when load is active, sync back to showing selected preset
    lcdMessage(getSelectedPresetName())
  elseif getActivePreset() ~= getSelectedPreset() then
    -- When out of sync (other msg), restore all displays to active preset.
    -- If name was already modified through kbd entry, save that value first!
    local s = getActivePresetName()
    selectActivePreset()
    loadSelectedPreset()
    setActivePresetName(s)
    lcdMessage(getActivePresetName())
    addDisplaysToBlink()
  elseif shiva.lcdMessage.values.text ~= getActivePresetName() then
    lcdMessage(getActivePresetName())
  else
    lcdMessage(getActivePreset())
    -- finally, when showing active preset, provide acctive preset name entry
    state.kbdTarget = KBDTARGETACTIVEPRESET
    startKeyboard(self.ID, getActivePresetName())
  end
end

function addDisplaysToBlink()
  addControlToBlink(shiva.dspSelected)
  addControlToBlink(shiva.dspDirectInfo)
  addControlToBlink(shiva.dspInfo)
  state.blinking = BLINKDISPLAYS
end

function toggleEdit()
  if state.ignoreToggle then
    state.ignoreToggle = false
    return
  end
  -- selectActivePreset()
  cycleView()
  updateDirectLoadButtons()
  -- if collapsed() and showingDirectLoad() then showCollapsed()
  -- elseif showingDirectLoad() then showEditor()
  -- else
  --   showDirectLoad()
  --   updateDirectLoadButtons()
  -- end
end

function directSelect(cmd)
  if userReleasedDirectLoadButttons() then
    -- If the whole parent control does not register any touch anmyore,
    -- we can be sure the user has released, either outside the parent,
    -- or on the final button choice. So, we can select.
    local presetNo = string.sub(cmd, 7)
    selectPreset(presetNo)
    if directLoad() then updateDirectLoadButtons() end
  else
    updateDirectLoadButtons()
  end
end

function directLoad()
  -- set optional fade for direct load
  local i = tonumber(shiva.stBtnGrpFadeOnDirectLoad.values.text)
  if i == nil then i = 0 end
  i = math.floor(i)
  if i > 0 then
    state.fadeStep = i
    state.fadeMax = i
    state.autoFade = true
    initCrossfade()
    startFading()
  end
  shiva.btnFnLoad.values.x = 0
  if not applySelectedPreset() then
    disableFade()
    return false
  end
  return true
end

function addChangedControlsToBlink()
  logDebug('Add changed controls to blink')
  for id, c in pairs(state.changedControls) do
    addControlToBlink(c)
  end
  state.blinking = BLINKCONTROLS
end

function prgSwitch(up)
  up = up == 'btnPlusPrg'
  local presetNo = getSelectedPreset() or 0
  w = presetNo
  local b
  if up then
    presetNo = presetNo == state.maxPreset and 0 or presetNo + 1
  else
    presetNo = presetNo == 0 and state.maxPreset or presetNo - 1
  end
  selectPreset(presetNo)
  loadSelectedPreset()
end

function prgSwitchDirect(up)
  up = up == 'btnPlusDirectPrgLoad' or up == 'pagePlusDirectLoad'
  local presetNo = getSelectedPreset() or 0
  presetNo = presetNo - math.fmod(presetNo, 10)
  if up then
    presetNo = presetNo + 10
    if presetNo > state.maxPreset then presetNo = 0 end
  else
    presetNo = presetNo - 10
    if presetNo < 0 then presetNo = state.maxPreset - 9 end
  end
  logDebug('Switching bank: ' .. presetNo)
  selectPreset(presetNo)
  updateDirectLoadButtons(presetNo)
end

function pageSwitchDirect()
  local presetNo = getSelectedPreset() or 0
  local bankPage = shiva.groupDirectLoadButtons.pagerDirectPageLoad.values.x
  local result = math.floor(presetNo - math.fmod(presetNo, state.bankSize) + bankPage * 10)
  log('Switching bank: ' .. result)
  selectPreset(result)
  updateDirectLoadButtons(result)
end

function bankSwitch(up)
  up = up == 'btnPlusBank'
  local presetNo = getSelectedPreset() or 0
  presetNo = presetNo - math.fmod(presetNo, state.bankSize)
  if up then
    presetNo = presetNo + state.bankSize
    if presetNo > state.maxPreset then presetNo = 0 end
  else
    presetNo = presetNo - state.bankSize
    if presetNo < 0 then presetNo = state.maxPreset - state.bankSize + 1 end
  end
  logDebug('Switching bank: ' .. presetNo)
  selectPreset(presetNo)
end

function bankSwitchDirect(up)
  up = up == 'btnPlusDirectBankLoad'
  local presetNo = getSelectedPreset() or 0
  local p = presetNo
  presetNo = presetNo - math.fmod(presetNo, state.bankSize)
  if up then
    presetNo = presetNo + state.bankSize
    if presetNo > state.maxPreset then presetNo = 0 end
  else
    -- if not on preset zero, stay on start of current bank
    if p == presetNo then presetNo = presetNo - state.bankSize end
    if presetNo < 0 then presetNo = state.maxPreset - state.bankSize + 1 end
  end
  logDebug('Switching bank: ' .. presetNo)
  selectPreset(presetNo)
  updateDirectLoadButtons(presetNo)
end

function toggleCollapse()
  if state.collapsed then
    if not showingCollapsed() then
      showCollapsed()
      state.collapsed = true
    else
      if state.lastPage == showDirectLoad then
        showEditor()
      else
        showLastPage()
      end
      state.collapsed = false
    end
  else
    showCollapsed()
    state.collapsed = true
  end
end

function clipBoardCut()
  -- TODO: workaround ..not realy sure why I still get a msg even though its disable..?
  if not shiva.menuContext.children.entryCut.properties.interactive then return end
  logDebug('clipboard cut')
  if state.presetModified then
    hideContextMenu()
    lcdMessage('cannot cut\npreset modified')
    return
  end
  state.clipBoard = json.fromTable(state.presetValues)
  deletePreset()
  updateDirectLoadButtons()
  hideContextMenu()
  lcdMessage('cut to clipboard\npreset ' .. getSelectedPreset())
end

function clipBoardCopy()
  -- TODO: workaround ..not realy sure why I still get a msg even though its disable..?
  if not shiva.menuContext.children.entryCopy.properties.interactive then return end
  logDebug('clipboard copy')
  if state.presetModified then
    hideContextMenu()
    lcdMessage('cannot copy\npreset modified')
    return
  end
  state.clipBoard = json.fromTable(state.presetValues)
  updateDirectLoadButtons()
  hideContextMenu()
  lcdMessage('copied to clipboard\npreset ' .. getSelectedPreset())
end

function clipBoardPaste()
  -- TODO: workaround ..not realy sure why I still get a msg even though its disable..?
  if not shiva.menuContext.children.entryPaste.properties.interactive then return end
  logDebug('clipboard paste')
  if state.clipBoard == nil then
    hideContextMenu()
    lcdMessage('cannot paste\nno clipboard')
    return
  end
  shiva.presetStore[getSelectedPreset() + 1].values.text = state.clipBoard
  updateDirectLoadButtons()
  hideContextMenu()
  lcdMessage('pasted to\npreset ' .. getSelectedPreset())
end

function deletePreset()
  -- TODO: workaround ..not realy sure why I still get a msg even though its disable..?
  if not shiva.menuContext.children.entryDelete.properties.interactive then return end
  logDebug('clipboard delete')
  shiva.presetStore[getSelectedPreset() + 1].values.text = ''
  updateDirectLoadButtons()
  hideContextMenu()
  lcdMessage('delete\npreset ' .. getSelectedPreset())
end

function executeRandomize()
  randomizeControlsNow()
end

-- === GUI HANDLERS ===

function hideObxdLogo()
  shiva.obxdMovie.properties.visible = false
  shiva.obxdLogo.properties.visible = false
end

function showObxdLogo()
  shiva.obxdMovie.properties.visible = false
  shiva.obxdLogo.properties.visible = true
end

function hideAllPages()
  saveLastPage()
  for i=1,#shiva.allPages do shiva.allPages[i].properties.visible = false end
  shiva.lblDirectHeading.properties.visible = true
  shiva.borderGroupBottom.properties.visible = false
  showObxdLogo()
end

function showEditor()
  hideAllPages()
  shiva.borderGroupBottom.visible = true
  shiva.grpManagerMain.visible = true
  hideObxdLogo()
end

function showDirectLoad()
  hideAllPages()
  shiva.lblDirectHeading.visible = false
  shiva.borderGroupBottom.visible = true
  shiva.groupDirectLoadButtonsMain.visible = true
  hideObxdLogo()
end

function showCollapsed()
  hideAllPages()
end

function showRunSettings()
  hideAllPages()
  shiva.borderGroupBottom.visible = true
  shiva.groupRunSettingsMain.visible = true
  hideObxdLogo()
end

function showLastPage()
  if state.lastPage ~= nil then
    state.lastPage()
  else
    showEditor()
  end
end

function saveLastPage()
  state.lastPage = nil
  if showingCollapsed() then state.lastPage = nil
  elseif showingDirectLoad() then state.lastPage = showDirectLoad
  elseif showingEditor() then state.lastPage = showEditor
  elseif showingRunSettings() then state.lastPage = showRunSettings
  elseif showingKeyboard() then state.lastPage = showKeyboard
  else state.lastPage = showEditor end
end

function collapsed()
  return state.collapsed
end

function showingCollapsed()
  return not (
    showingDirectLoad() or
    showingEditor() or
    showingRunSettings() or
    showingKeyboard()
  )
end

function showingEditor()
  return shiva.grpManagerMain.visible
end

function showingRunSettings()
  return shiva.groupRunSettingsMain.visible
end

function showingDirectLoad()
  return shiva.groupDirectLoadButtonsMain.visible
end

function showingKeyboard()
  return shiva.groupKeyboardMain.visible
end

function showKeyboard()
  hideAllPages()
  shiva.borderGroupBottom.visible = true
  shiva.groupKeyboardMain.visible = true
  hideObxdLogo()
end

function startKeyboard(target, text)
  showKeyboard()
  shiva.groupKeyboardMain:notify(target, text)
end

-- === PRESET VALUES HANDLING, LOADING AND SAVING ===

function isPresetEmpty(p)
  return getJsonFromPresetStore(p) == false
end

function saveToSelectedPreset()
  -- Saves current control values to the selected preset
  local presetNo = getSelectedPreset()
  state.allControls = nil
  getAllCurrentValues(true)
  if state.selectedIsEmpty then
    state.currValues[RESERVED][PRESETNAMEID] = getSelectedPresetName()
  end
  logDebug('Saving to preset: ' .. presetNo .. ' - ' .. getSelectedPresetName())
  -- grid index starts at 1
  shiva.presetStore[presetNo + 1].values.text = json.fromTable(state.currValues)
  state.presetValues = state.currValues
  infoMessage('saved ' .. getIndexInBank(presetNo))
  logDebug('Saved values: ' .. json.fromTable(state.currValues))
  setActivePreset(presetNo)
  applySelectedPreset()
end

function loadSelectedPreset()
  -- load currently selected preset values
  local presetNo = getSelectedPreset()
  logDebug('Loading preset: ' .. presetNo)
  local jsonValues = getJsonFromPresetStore(presetNo)
  if not jsonValues then
    lcdMessage('load error\npreset empty')
    setSelectedPresetName(getBankString(presetNo))
    state.selectedIsEmpty = true
    return false
  end
  state.selectedIsEmpty = false
  state.presetValues = json.toTable(jsonValues)
  ensurePresetDefaultName(presetNo)
  setSelectedPresetName(state.presetValues[RESERVED][PRESETNAMEID])
  lcdMessage(getSelectedPresetName())
  showSelectMessage()
  return true
end

function applySelectedPreset()
  -- loads and applies the currently selected preset
  local result = loadSelectedPreset()
  if not result then return false end
  activateSelectedPreset()
  if writeToControls(state.presetValues) then
    showDynamicInfoForActivePreset()
  else
    infoMessage('loaded with errors!')
  end
  return true
end

function getNameFromPreset(p)
  local jsonValues = getJsonFromPresetStore(p)
  if not jsonValues then return '' end
  local n
  if json.toTable(jsonValues)[RESERVED] ~= nil then
    n = json.toTable(jsonValues)[RESERVED][PRESETNAMEID]
  end
  if n == nil then return p .. ' [unknown]' end
  return n
end

function getJsonFromPresetStore(presetNo)
  -- grid index starts at 1
  local result = shiva.presetStore[presetNo + 1].values.text
  if (result == nil or not string.match(result, '^{.+}$')) then
    logDebug('Preset empty while loading: ' .. presetNo)
    return false
  end
  logDebug('Preset json data loaded: ' .. presetNo)
  logDebug('Found values:')
  logDebug(result)
  return result
end

function getActivePresetName()
  return shiva.lcdMessage.tag
end

function setActivePresetName(s)
  logDebug('Setting active preset name: ' .. s)
  shiva.lcdMessage.tag = s
end

function getActivePreset()
  return tonumber(shiva.dspInfo.tag)
end

function setActivePreset(presetNo)
  shiva.dspInfo.tag = presetNo
end

function activateSelectedPreset()
  setActivePreset(getSelectedPreset())
  setActivePresetName(getSelectedPresetName())
  lcdMessage(getActivePresetName())
end

function getSelectedPresetName()
  return tostring(shiva.dspSelected.tag)
end

function setSelectedPresetName(s)
  shiva.dspSelected.tag = s
end

function getBankString(p)
  return 'Bank' .. math.floor(p/state.bankSize) .. ' P' .. getIndexInBank(p)
end

function getBankStringShort(p)
  return 'B' .. math.floor(p/state.bankSize) .. ' P' .. getIndexInBank(p)
end

  function getIndexInBank(p)
  return math.fmod(p, state.bankSize)
end

function getBank(p)
  return math.floor(p/state.bankSize)
end

function getSelectedPreset()
  -- returns the currently selected preset number.
  return state.selectedPreset
end

function selectActivePreset()
  -- Restores all displays and selected no. to active preset
  showDynamicInfoForActivePreset()
  selectPreset(getActivePreset())
  lcdMessage(getActivePresetName())
end

function selectPreset(presetNo)
  -- Saves the passed value as the currently selected preset number.
  -- The selected preset is eligible for loading and applying.
  shiva.dspSelected.values.text = getIndexInBank(presetNo)
  state.selectedPreset = presetNo
  -- Show bank and preset in bankk no.
  shiva.dspDirectInfo.values.text = getBankString(presetNo)
  showSelectMessage(presetNo)
  logDebug('New selected preset: ' .. getSelectedPreset())
end

function ensurePresetDefaultName(presetNo)
  -- Provides a simple default value if empty
  if state.presetValues[RESERVED] == nil then
    state.presetValues[RESERVED] = {}
  end
  if state.presetValues[RESERVED][PRESETNAMEID] == nil then
    state.presetValues[RESERVED][PRESETNAMEID] = 'preset ' .. presetNo
  end
end

function showSelectMessage(presetNo)
  presetNo = presetNo or getSelectedPreset()
  if presetNo == getActivePreset() then
    showDynamicInfoForActivePreset()
    return
  end
  local s
  if userWantsToLoad() then
    s = 'load ' .. getBankStringShort(presetNo)
  elseif shiva.btnFnSave.values.x == 1 then
    s = 'save ' .. getBankStringShort(presetNo)
  else
    s = 'select ' .. getBankStringShort(presetNo)
  end
  infoMessage(s)
end

-- === CONTROL VALUE HANDLING ===

function controlEligible(c)
  -- special internal controls we always save with the preset
  special = {
    RESERVED
  }
  for i = 1, #special do
    if c.ID == special[i] then return true end
  end
  if c.ID == presetModuleMain.ID then
    -- log('Excluded myself: ' .. c.parent.name .. '.' ..c.name)
    return false
  end
  -- always ignore manually excluded controls!
  if string.match(c.tag, '^noshiva.*') then
    -- log('Excluded by "noshiva": ' .. c.parent.name .. '.' ..c.name)
    return false
  end
  -- Check if MIDI msg attached
  if (
    shiva.groupRunSettings.stBtnSelectMidi.values.x == 1 and
    #c.messages.MIDI > 0
  ) then return true end
  -- Check if OSC msg attached
  if (
    shiva.groupRunSettings.stBtnSelectOsc.values.x == 1 and
    #c.messages.OSC > 0
  ) then return true end
  -- Check if special tag prefix "shiva"
  if string.match(c.tag, '^shiva.*') then return true end
  -- logDebug('No msg found on: ' .. c.parent.name .. '.' ..c.name)
  return false
end

function getAllControls(pid, r)
  -- Registers all applicable controls in state.allControls
  r = r == nil and 1 or r + 1
  local c = pid == root.ID and root or root:findByID(pid, true)
  -- logDebug('Level ' .. r .. ' - Check control: ' .. c.parent.name .. '.' .. c.name)
  if c == nil then
    log('ERROR finding preset root control!')
    return
  end
  for i = 1, #c.children do
    if not (
      c.children[i].ID == presetModuleMain.ID or
      string.match(c.children[i].tag, '^noshiva.*')
    ) then
      getAllControls(c.children[i].ID, r)
    end
  end
  if controlEligible(c) then
    -- log('Found control: ' .. c.parent.name .. '.' ..c.name)
    table.insert(state.allControls, c)
  end
end

function getValueType(c)
  -- annoying workaround :( check needed since if c.values.x does not exist,
  -- it is equel to nil, but querying it also outputs a warning in script
  -- console that I do not know how to turn of..
  local result = 0
  for i = 1, #c.values.keys do
    if c.values.keys[i] == 'x' then
      result = result + 1
    elseif c.values.keys[i] == 'y' then
      result = result + 2
    elseif c.values.keys[i] == 'text' then
      result = result + 4
    end
  end
  return 0
end

function getAllCurrentValues(verbose)
  if verbose == nil then verbose = false end
  if verbose then
    if state.rootName == '' then
      log('Preset base group. Using whole control surface')
    else
      log('Preset base group name: ' .. state.presetRootCtrl.name)
      log('Preset base group has tag: ' .. state.presetRootCtrl.tag)
    end
    log('Searching controls..')
  end
  local id = state.presetRootCtrl.ID
  if state.allControls == nil then
    state.allControls = {}
    getAllControls(id)
  end
  state.currValues = {}
  local count = 0
  local valueName = ''
  local ctrlName = ''
  for k, c in pairs(state.allControls) do
    id = c.ID
    ctrlName = c.name
    if #c.values.keys == 0 then
      if verbose then log('SKIP control ' .. c.parent.name .. '.' .. ctrlName) end
    else
      if verbose then logDebug(
      'Add control ' .. c.parent.name .. '.' .. ctrlName)
      end
      count = count + 1
      state.currValues[id] = {}
      for i=1, #c.values.keys do
        valueName = c.values.keys[i]
        if valueName ~= 'touch' then
          state.currValues[id][valueName] = c.values[valueName]
          state.currValues[id][valueName .. 'Default'] = c:getValueField(valueName, ValueField.DEFAULT)
        end
      end
    end
  end
  state.currValues[RESERVED] = {}
  state.currValues[RESERVED][PRESETNAMEID] = getActivePresetName()
  logDebug('Name set to: ' .. state.currValues[RESERVED][PRESETNAMEID])
  -- only used by restore work
  state.currValues[RESERVED][PRESETIDID] = getActivePreset()
  if verbose then log('Controls found: ' .. count) end
end

function writeToControls(values)
  local err = false
  local ctrlName = ''
  local ctrl
  for id, value in pairs(values) do
    if id ~= RESERVED then
      ctrl = state.presetRootCtrl:findByID(id, true)
      if type(value) ~= 'table' then
        log('WARNING: Old invalid literal value stored, SKIPPING control ID: ' .. id)
        err = true
      elseif ctrl == nil then
        log('WARNING: Invalid control ID: ' .. id)
        err = true
      elseif not controlEligible(ctrl) then
        log('WARNING: Control not eligible anymore: ' .. ctrl.parent.name .. '.' .. ctrl.name .. ' - ' .. id)
        err = true
      else
        ctrlName = ctrl.name
        if #ctrl.values.keys == 0 then
          log('Warning. Control does not have any values.')
        else
          logDebug(
          'Apply values to control ' .. ctrl.parent.name .. '.' .. ctrlName)
          for i=1, #ctrl.values.keys do
            valueName = ctrl.values.keys[i]
            if valueName ~= 'touch' then
              ctrl:setValueField(valueName, ValueField.DEFAULT, value[valueName .. 'Default'])
              ctrl.values[valueName] = value[valueName]
            end
          end
        end
      end
    end
  end
  if state.autoFade and state.fadeStep < 1 then shiva.fdrCrossfade.values.x = 0 end
  return not err
end

-- === CROSSFADING ===

function initCrossfade()
  logDebug('Init value fading..')
  if state.autoFade then
    state.fadeStartValue = shiva.fdrCrossfade.values.x
    getAllCurrentValues()
    state.fadeValues = {}
    state.oldValues = {}
    for k, values in pairs(state.currValues) do
      copyValues(values, state.fadeValues, k)
      copyValues(values, state.oldValues, k)
    end
    if state.fadeStep > 0 then
      state.fadeStep = state.fadeMax
      updateFadeSlider()
    else
      state.fadeStep = -1
    end
  elseif not state.fading then
    getAllCurrentValues()
    state.fadeValues = {}
    state.oldValues = {}
    for k, values in pairs(state.currValues) do
      copyValues(values, state.fadeValues, k)
      copyValues(values, state.oldValues, k)
    end
    state.fadeStep = -1
  end
end

function updateFadeValues()
  local d = 0
  for k, v in pairs(state.presetValues) do
    updateSingleFadeValue(k)
  end
  if state.autoFade then
    state.fadeStep = state.fadeStep - 1
    updateFadeSlider()
  end
end

function updateSingleFadeValue(k)
  if state.fadeValues[k] == nil then
    log('Warning! Control to fade was nil!')
    return
  end
  for n,v in pairs(state.fadeValues[k]) do
    if (
      state.presetValues[k][n] == nil or
      type(state.presetValues[k][n]) == 'string'
    ) then
      state.fadeValues[k][n] = state.presetValues[k][n]
    else
      d = (state.presetValues[k][n] - state.oldValues[k][n]) / state.fadeMax
      if state.autoFade then
        state.fadeValues[k][n] = state.fadeValues[k][n] + d
      else
        state.fadeValues[k][n] = state.oldValues[k][n] + (d * (state.fadeMax - state.fadeStep))
      end
    end
  end
end

function copyValues(source,target, key)
  if target[key] == nil then target[key] = {} end
  for n,v in pairs(source) do
    target[key][n] = source[n]
    target[key][n] = source[n]
  end
end

function updateFadeSlider()
  shiva.fdrCrossfade.values.x = state.fadeStartValue * state.fadeStep * (1 / state.fadeMax)
end

function applyFadeValues()
  -- applies the current fader values
  if not state.fading then return end
  writeToControls(state.fadeValues)
  infoMessage('fading ' .. getIndexInBank(getSelectedPreset()), false)
  p = state.fadeMax / 10
  s1 = string.rep('=', math.ceil((state.fadeMax - state.fadeStep) / p))
  s2 = string.rep(' ', (state.fadeMax / p) - #s1)
  if state.fadeStep == 0 and not state.autoFade then
    lcdMessage('..FADING..\n' .. 'release!', false)
  else
    local d = ''
    if state.autoFade then d = string.format("%.1f", (getMillis() - state.fadeStartTime) / 1000) end
    lcdMessage('..FADING.. ' .. d .. '\n' .. '[' .. s1 .. s2 .. ']', false)
  end
end

function applyManualFade(newValue)
  state.fadeStep = math.floor(state.fadeMax * newValue)
  if state.fadeStep == 0 and crossfaderNotTouched() then
    -- end manual fade when user releases fader in zero position
    disableFade()
    applySelectedPreset()
  end
  applyFadeValues()
  updateFadeValues()
end

function updateLabelFade()
  s = state.autoFade and 'FADE IN' or 'FADE M'
  logDebug('MODE: ' .. s)
  shiva.lblFadeMode.values.text = s
end

-- === WORK CACHE HANDLING ===

function isWorkEmpty()
  s = shiva.workStore[state.lastWork + 1].values.text
  if s == nil or s == '' then return true end
  if not string.match(s, '^{.+}$') then return true end
  return false
end

function cacheWork()
  log('Saving current work in progress..')
  getAllCurrentValues()
  if not state.presetModified and getSelectedPreset() == getActivePreset() then return end
  state.lastWork = math.fmod(state.lastWork + 1, 10)
  shiva.workStore[state.lastWork + 1].values.text = json.fromTable(state.currValues)
  updateRestoreBtn()
  -- will never show anyway
  -- infoMessage('work cached')
end

function restoreWork()
  if isWorkEmpty() then
    infoMessage('no work cache')
    return
  end
  local jsonValues = shiva.workStore[state.lastWork + 1].values.text -- index starts at 1
  logDebug('Found values:' .. jsonValues)
  state.currValues = json.toTable(jsonValues)
  -- restore previously active preset if any
  if (
    state.currValues[RESERVED] ~= nil and
    state.currValues[RESERVED][PRESETIDID] ~= nil
  ) then
    selectPreset(state.currValues[RESERVED][PRESETIDID])
    applySelectedPreset()
  end
  -- now restore
  writeToControls(state.currValues)
  lcdMessage(state.currValues[RESERVED][PRESETNAMEID])
  shiva.workStore[state.lastWork + 1].values.text = ''
  state.lastWork = (state.lastWork <= 0) and 9 or (state.lastWork - 1)
  updateRestoreBtn()
  infoMessage('work restore')
end

function clearWork()
  log('Clearing working state cache..')
  for i = 1, #shiva.workStore do
    shiva.workStore[i].values.text = ''
  end
  state.lastWork = 0
  updateRestoreBtn()
  infoMessage('work cleared')
end

function updateRestoreBtn()
  local s = shiva.workStore[state.lastWork + 1].values.text
  if string.match(s, '^{.+}$') then
    shiva.lblRestore.properties.textColor = 1
    shiva.lblClearWork.properties.textColor = 1
    local c = 0
    for i = 1, #shiva.workStore do
      if string.match(shiva.workStore[i].values.text, '^{.+}$') then c = c + 1 end
    end
    -- shiva.lblRestore.values.text = 'RST WRK [' .. c .. ']'
  else
    -- shiva.lblRestore.values.text = 'RST WRK'
    shiva.lblRestore.properties.textColor = 0.3
    shiva.lblClearWork.properties.textColor = 0.3
  end
end

function purgePresetStore()
  log('Clear all presets enabled! CLEARING ALL PRESETS NOW!')
  for i = 1, #shiva.presetStore do
    shiva.presetStore[i].values.text = ''
  end
end

function randomizeControlsNow()
  logDebug('Randomizing all control values!')
  getAllCurrentValues()
  for k,c in pairs(state.allControls) do
    logDebug('Randomizing ' .. c.name)
    if c.type == ControlType.BUTTON then
      c.values.x = math.random(0,1)
    else
      if c.values.x ~= nil then c.values.x = math.random() end
      if c.values.y ~= nil then c.values.y = math.random() end
    end
  end
end

-- === APPLY SKIN LAYOUT SETTINGS ===

function applySkinGeneric()
  types = {
    'BUTTON',
    'LABEL',
    'TEXT',
  }
  local ctrls
  local c
  for i = 1, #types do
    ctrls = self.parent:findAllByType(ControlType[types[i]], true)
    logDebug('Applying buttons')
    for _,ctrl in pairs(ctrls) do
      if string.match(ctrl.name, '^btn.+') then
        logDebug('btn: ' .. ctrl.name)
        ctrl.properties.color = shiva.skinSettings.templateButton.properties.color -- default was 66D1FFD9
        ctrl.properties.background = shiva.skinSettings.templateButton.properties.background
        ctrl.properties.outline = shiva.skinSettings.templateButton.properties.outline
        ctrl.properties.outlineStyle = shiva.skinSettings.templateButton.properties.outlineStyle
        ctrl.properties.cornerRadius = shiva.skinSettings.templateButton.properties.cornerRadius
        ctrl.properties.textSize = shiva.skinSettings.templateButton.properties.textSize
        ctrl.properties.font = shiva.skinSettings.templateButton.properties.font
      end
      if string.match(ctrl.name, '^btnMinus.+') or string.match(ctrl.name, '^btnPlus.+') then
        logDebug('btn: ' .. ctrl.name)
        ctrl.properties.textSize = shiva.skinSettings.templateButton.properties.textSize - 3
      end
      if string.match(ctrl.name, '^btnFn.+') then
        logDebug('btn: ' .. ctrl.name)
        if (
          ctrl.parent.name == "groupKeyboard" and
          ctrl.type == ControlType.LABEL
        ) then
          ctrl.properties.background = false
        else
          ctrl.properties.background = shiva.skinSettings.templateFunctions.properties.background
        end
        ctrl.properties.color = shiva.skinSettings.templateFunctions.properties.color -- default was 66D1FFD9
        ctrl.properties.outline = shiva.skinSettings.templateFunctions.properties.outline
        ctrl.properties.outlineStyle = shiva.skinSettings.templateFunctions.properties.outlineStyle
        ctrl.properties.cornerRadius = shiva.skinSettings.templateFunctions.properties.cornerRadius
        ctrl.properties.textSize = shiva.skinSettings.templateFunctions.properties.textSize
        ctrl.properties.font = shiva.skinSettings.templateFunctions.properties.font
      end
      if ctrl.parent.name == 'groupDirectLoadButtons' and string.match(ctrl.name, '^[0-9]+$') then
        if string.match(ctrl.name, '^[0-9]+$') then
          logDebug('btnDirect: ' .. ctrl.name)
          ctrl.properties.color = shiva.skinSettings.templateButtonDirect.properties.color -- default was 66D1FFD9
          ctrl.properties.background = shiva.skinSettings.templateButtonDirect.properties.background
          ctrl.properties.outline = shiva.skinSettings.templateButtonDirect.properties.outline
          ctrl.properties.outlineStyle = shiva.skinSettings.templateButtonDirect.properties.outlineStyle
          ctrl.properties.cornerRadius = shiva.skinSettings.templateButtonDirect.properties.cornerRadius
          ctrl.properties.textSize = shiva.skinSettings.templateButtonDirect.properties.textSize
          ctrl.properties.textSize = shiva.skinSettings.templateButtonDirect.properties.textColor
          ctrl.properties.font = shiva.skinSettings.templateButtonDirect.properties.font
        end
        if string.match(ctrl.name, '^lblDirect[0-9]+$') then
          logDebug('btnDirect: ' .. ctrl.name)
          ctrl.properties.cornerRadius = shiva.skinSettings.templateButtonDirect.properties.cornerRadius
          ctrl.properties.textSize = shiva.skinSettings.templateButtonDirect.properties.textSize
          ctrl.properties.textSize = shiva.skinSettings.templateButtonDirect.properties.textColor
          ctrl.properties.font = shiva.skinSettings.templateButtonDirect.properties.font
        end
      end
      if string.match(ctrl.name, '^btnPlusDirect.+') or string.match(ctrl.name, '^btnMinusDirect.+') then
        logDebug('btnPageDirect: ' .. ctrl.name)
        ctrl.properties.color = shiva.skinSettings.templatePageButtonDirect.properties.color -- default was 66D1FFD9
        ctrl.properties.background = shiva.skinSettings.templatePageButtonDirect.properties.background
        ctrl.properties.outline = shiva.skinSettings.templatePageButtonDirect.properties.outline
        ctrl.properties.outlineStyle = shiva.skinSettings.templatePageButtonDirect.properties.outlineStyle
        ctrl.properties.cornerRadius = shiva.skinSettings.templatePageButtonDirect.properties.cornerRadius
        ctrl.properties.textSize = shiva.skinSettings.templatePageButtonDirect.properties.textSize - 3
        ctrl.properties.textColor = shiva.skinSettings.templatePageButtonDirect.properties.textColor
        ctrl.properties.font = shiva.skinSettings.templatePageButtonDirect.properties.font
      end
    end
    logDebug('Applying labels..')
    for _,ctrl in pairs(ctrls) do
      if string.match(ctrl.name, '^lbl.+') then
        logDebug('lbl: ' .. ctrl.name)
        ctrl.properties.color = shiva.skinSettings.templateLabel.properties.color -- default was 66D1FFD9
        ctrl.properties.textColor = shiva.skinSettings.templateLabel.properties.textColor -- default was FFFFFFD0
        ctrl.properties.background = shiva.skinSettings.templateLabel.properties.background
        ctrl.properties.outline = shiva.skinSettings.templateLabel.properties.outline
        ctrl.properties.outlineStyle = shiva.skinSettings.templateLabel.properties.outlineStyle
        ctrl.properties.cornerRadius = shiva.skinSettings.templateLabel.properties.cornerRadius
        ctrl.properties.textSize = shiva.skinSettings.templateLabel.properties.textSize
        ctrl.properties.font = shiva.skinSettings.templateLabel.properties.font
      end
      logDebug('Applying displays..')
      if string.match(ctrl.name, '^dsp.+') then
        logDebug('dsp: ' .. ctrl.name)
        ctrl.properties.color = shiva.skinSettings.templateDisplay.properties.color -- default was 66D1FFD9
        ctrl.properties.textColor = shiva.skinSettings.templateDisplay.properties.textColor -- default was FFFFFFD0
        ctrl.properties.background = shiva.skinSettings.templateDisplay.properties.background
        ctrl.properties.outline = shiva.skinSettings.templateDisplay.properties.outline
        ctrl.properties.outlineStyle = shiva.skinSettings.templateDisplay.properties.outlineStyle
        ctrl.properties.cornerRadius = shiva.skinSettings.templateDisplay.properties.cornerRadius
        ctrl.properties.textSize = shiva.skinSettings.templateDisplay.properties.textSize
        ctrl.properties.font = shiva.skinSettings.templateDisplay.properties.font
      end
      logDebug('Applying digits..')
      if string.match(ctrl.name, '^[0-9]+$') then
        logDebug('Digits: ' .. ctrl.name)
        ctrl.properties.color = shiva.skinSettings.templateDigits.properties.color -- default was 66D1FFD9
        ctrl.properties.textColor = shiva.skinSettings.templateDigits.properties.textColor -- default was FFFFFFD0
        ctrl.properties.background = shiva.skinSettings.templateDigits.properties.background
        ctrl.properties.outline = shiva.skinSettings.templateDigits.properties.outline
        ctrl.properties.outlineStyle = shiva.skinSettings.templateDigits.properties.outlineStyle
        ctrl.properties.cornerRadius = shiva.skinSettings.templateDigits.properties.cornerRadius
        ctrl.properties.textSize = shiva.skinSettings.templateDigits.properties.textSize
        ctrl.properties.font = shiva.skinSettings.templateDigits.properties.font
      end
      if string.match(ctrl.name, '^button[0-9]+$') then
        logDebug('Digits: ' .. ctrl.name)
        ctrl.properties.color = shiva.skinSettings.templateDigits.properties.color -- default was 66D1FFD9
        ctrl.properties.textColor = shiva.skinSettings.templateDigits.properties.textColor -- default was FFFFFFD0
        ctrl.properties.background = false
        ctrl.properties.outline = shiva.skinSettings.templateDigits.properties.outline
        ctrl.properties.outlineStyle = shiva.skinSettings.templateDigits.properties.outlineStyle
        ctrl.properties.cornerRadius = shiva.skinSettings.templateDigits.properties.cornerRadius
        ctrl.properties.textSize = shiva.skinSettings.templateDigits.properties.textSize
        ctrl.properties.font = shiva.skinSettings.templateDigits.properties.font
      end
      if string.match(ctrl.name, '^[0-9]+filler$') then
        logDebug('Digits: ' .. ctrl.name)
        c = Color(
          shiva.skinSettings.templateDigits.properties.color.r,
          shiva.skinSettings.templateDigits.properties.color.g,
          shiva.skinSettings.templateDigits.properties.color.b,
          shiva.skinSettings.templateDigits.properties.color.a / 2.0
        )
        ctrl.properties.color = c -- default was 66D1FFD9
        ctrl.properties.textColor = shiva.skinSettings.templateDigits.properties.textColor -- default was FFFFFFD0
        ctrl.properties.background = shiva.skinSettings.templateDigits.properties.background
        ctrl.properties.outline = shiva.skinSettings.templateDigits.properties.outline
        ctrl.properties.outlineStyle = shiva.skinSettings.templateDigits.properties.outlineStyle
        ctrl.properties.cornerRadius = shiva.skinSettings.templateDigits.properties.cornerRadius
        ctrl.properties.textSize = shiva.skinSettings.templateDigits.properties.textSize
        ctrl.properties.font = shiva.skinSettings.templateDigits.properties.font
      end
    end
    logDebug('Applying text displays..')
    for _,ctrl in pairs(ctrls) do
      if string.match(ctrl.name, '^lcd.+') then
        logDebug('lcd: ' .. ctrl.name)
        ctrl.properties.color = shiva.skinSettings.templateLCD.properties.color
        ctrl.properties.textColor = shiva.skinSettings.templateLCD.properties.textColor
        ctrl.properties.background = shiva.skinSettings.templateLCD.properties.background
        ctrl.properties.outline = shiva.skinSettings.templateLCD.properties.outline
        ctrl.properties.outlineStyle = shiva.skinSettings.templateLCD.properties.outlineStyle
        ctrl.properties.cornerRadius = shiva.skinSettings.templateLCD.properties.cornerRadius
        ctrl.properties.textSize = shiva.skinSettings.templateLCD.properties.textSize
        ctrl.properties.font = shiva.skinSettings.templateLCD.properties.font
      end
    end
  end
end

function applySkinSingle(c, t)
  logDebug('Applying special: ' .. c.name)
  c.properties.color = t.properties.color -- 60FF74EB
  if c.properties.textColor ~= nil then
    c.properties.textColor = t.properties.textColor -- 60FF74EB
  end
  c.properties.background = t.properties.background
  c.properties.outline = t.properties.outline
  c.properties.outlineStyle = t.properties.outlineStyle
  c.properties.cornerRadius = t.properties.cornerRadius
  c.properties.textSize = t.properties.textSize
end

function applyLayout()
  if shiva.skinSettings.applyLayout.values.x == 0 then return end
  log('Applying layout..')
  applySkinGeneric()
  applySkinSingle(shiva.lblDirectHeading, shiva.skinSettings.templateHeading)
  -- TODO: Workaround, cause the blinking tends to kill the text color...
  shiva.lcdMessage.properties.textColor = COLOR_MSG_DISPLAY_TXT
end

-- === GUI STATE HANDLING ===

function userWantsToLoad()
  return shiva.btnFnLoad.values.x == 1
end

function crossfaderNotTouched()
  return not shiva.fdrCrossfade.values.touch
end

function userWantsToSave()
  return shiva.btnFnSave.values.x == 1
end

function userReleasedDirectLoadButttons()
  return not shiva.groupDirectLoadButtonsMain.values.touch
end

-- === UTILS ===

function log(s)
  print(s)
end

function logDebug(s)
  if DEBUG == true then
    print(s)
  end
end

function infoMessage(s, blink)
  -- Prints a message to the single line message display
  logDebug('message: ' .. s)
  if blink ~= false then
    addControlToTextBlink(shiva.dspInfo)
    addControlToTextBlink(shiva.dspDirectInfo)
  end
  shiva.dspInfo.values.text = s
end

function lcdMessage(s, blink)
  -- Prints a message to the multiline message "lcd display"
  logDebug('LCD msg: ' .. s)
  if blink ~= false then
    addControlToTextBlink(shiva.lcdMessage)
  end
  shiva.lcdMessage.values.text = s
end

function lcdMessageDelayed(s, blink)
  state.msgLcdSent = getMillis()
  state.msgLcd = s
end

function showMsgLcdDelayed(now)
  if (
    state.msgLcdSent > 0 and
    (now - state.msgLcdSent > state.msgLcdDelay)
  ) then
    lcdMessage(state.msgLcd)
    state.msgLcd = ''
    state.msgLcdSent = 0
  end
end

function makeCrossfaderCurvy()
  return math.floor((shiva.fdrCrossfade.values.x ^ 2) * 750)
end

function itIsTimeTo(what, now)
  if (now - state[what .. 'Last'] > state[what .. 'Delay']) then
    if not state.fading and what == 'fade' then return false end
    state[what .. 'Last'] = now
    return true
  end
  return false
end

function showContextMenu(mode)
  mode = mode == nil and CB_ALL or mode
  local s = '= Preset ' .. getSelectedPreset() .. ' ='
  if not state.presetModified then
    s = '= Preset ' .. getSelectedPreset() .. ' ='
  else
    s = '= *Preset ' .. getSelectedPreset() .. '* ='
    mode = CB_ONLYPASTE
  end
  if mode == CB_ONLYPASTE then
    shiva.menuContext.children.entryCut.properties.interactive = false
    shiva.menuContext.children.entryCut.properties.textColor = 0.1
    shiva.menuContext.children.entryCopy.properties.interactive = false
    shiva.menuContext.children.entryCopy.properties.textColor = 0.1
    shiva.menuContext.children.entryPaste.properties.interactive = true
    shiva.menuContext.children.entryPaste.properties.textColor = COLOR_TEXTDEFAULT
    shiva.menuContext.children.entryDelete.properties.interactive = false
    shiva.menuContext.children.entryDelete.properties.textColor = 0.1
  else
    shiva.menuContext.children.entryCut.properties.interactive = true
    shiva.menuContext.children.entryCut.properties.textColor = COLOR_TEXTDEFAULT
    shiva.menuContext.children.entryCopy.properties.interactive = true
    shiva.menuContext.children.entryCopy.properties.textColor = COLOR_TEXTDEFAULT
    shiva.menuContext.children.entryPaste.properties.interactive = true
    shiva.menuContext.children.entryPaste.properties.textColor = COLOR_TEXTDEFAULT
    shiva.menuContext.children.entryDelete.properties.interactive = true
    shiva.menuContext.children.entryDelete.properties.textColor = COLOR_TEXTDEFAULT
  end
  shiva.grpBlock.visible = true
  shiva.menuContext.children[1].values.text = '= Preset ' .. getSelectedPreset() .. ' ='
  shiva.menuContext.properties.visible = true
end

function hideContextMenu()
  shiva.menuContext.properties.visible = false
  shiva.grpBlock.visible = false
end

function checkModified()
  if (
    state.fading or
    getSelectedPreset() ~= getActivePreset()
  ) then
    return
  end
  local m = false
  getAllCurrentValues(false)
  for id, v in pairs(state.presetValues) do
    if id ~= RESERVED then
      c = state.presetRootCtrl:findByID(id, true)
      if valuesChanged(state.currValues[id], state.presetValues[id]) then
        logDebug('Value changed: ' .. id)
        m = true
        if c ~= nil and state.changedControls[id] == nil then
          logDebug('Add to changed controls: ' .. c.name)
          state.changedControls[id] = c
        end
      else
        if c ~= nil and state.changedControls[id] ~= nil then
          logDebug('Remove from changed controls: ' .. c.name)
          state.changedControls[id] = nil
        end
      end
    end
  end
  state.presetModified = m
  state.modifiedText = m and '*' or ''
  if shiva.btnFnLoad.values.x == 0 and shiva.btnFnSave.values.x == 0 then
    showDynamicInfoForActivePreset()
  end
end

function valuesChanged(current, preset)
  if type(preset) ~= 'table' or type(current) ~= 'table' then return preset == current end
  for k,v in pairs(current) do
    if current[k] ~= preset[k] then return true end
  end
  return false
end

function saveKeyboardValue(text)
  if state.kbdTarget == KBDTARGETNEWSAVE then
    showEditor()
    setSelectedPresetName(text)
    lcdMessage(getSelectedPresetName())
  elseif state.kbdTarget == KBDTARGETACTIVEPRESET then
    showEditor()
    setActivePresetName(text)
    lcdMessage(getActivePresetName())
  end
end

function showDynamicInfoForActivePreset()
  local p = getActivePreset()
  local s = getBankString(p)
  infoMessage(state.modifiedText .. s .. state.modifiedText, false)
end

function toggleFadeMode()
  state.autoFade = not state.autoFade
  updateLabelFade()
  if not state.autoFade then
    initCrossfade()
    -- shiva.fdrCrossfade.properties.cursor = true
    shiva.fdrCrossfade:setValueField('x', ValueField.CURRENT, 1.0)
    shiva.fdrCrossfade:setValueField('x', ValueField.DEFAULT, 1.0)
    lcdMessage('select mode\nmanual fade')
  else
    shiva.fdrCrossfade:setValueField('x', ValueField.CURRENT, 0.0)
    shiva.fdrCrossfade:setValueField('x', ValueField.DEFAULT, 0.0)
    -- shiva.fdrCrossfade.properties.cursor = false
    lcdMessage('select mode\nauto fade')
  end
end

function startFading()
  state.fading = true
  for i = 1, #shiva.grpManager do
    if shiva.grpManager[i].tag ~= 'ignore' then
      shiva.grpManager[i].properties.interactive = false
    end
  end
end

function disableFade()
  logDebug('Disable fader..')
  shiva.fdrCrossfade.values.x = not state.autoFade and 1.0 or 0.0
  state.fading = false
  state.fadeStep = 0
  for i = 1, #shiva.grpManager do
    if shiva.grpManager[i].tag ~= 'ignore' then
      shiva.grpManager[i].properties.interactive = true
    end
  end
end

function addDigitToPreset(s)
  -- Adds the passed digit to current preset number,
  -- also handles resetting if new value makes no sense.
  logDebug('Received new digit: ' .. s)
  v = getSelectedPreset()
  if (v == nil or v == 0) then
    v = s
  else
    v = getSelectedPreset() .. s
  end
  if tonumber(v) > state.maxPreset then
    v = s
  end
  selectPreset(v)
  loadSelectedPreset()
end

function addControlToBlink(c)
  local id = c.ID
  if (
    state.blinkControls[id] == nil and
    state.blinkTextControls[id] == nil
  ) then
    logDebug('Adding: ' .. c.name)
    local at
    if c.properties.textColor ~= nil then
      at = c.properties.textColor.a
    else
      at = nil
    end
    state.blinkControls[id] = {
      ctrl = c,
      a = c.properties.color.a,
      at = at,
    }
  else
    logDebug('Already blinking: ' .. c.name)
  end
end

function addControlToTextBlink(c)
  local id = c.ID
  if state.blinking > 0 then return end
  if state.blinkTextControls[id] == nil then
    logDebug('Adding text: ' .. c.name)
    state.blinkTextControls[id] = {
      ctrl = c,
      at = c.properties.textColor.a,
    }
    if shiva.blinkText.values.x == 1 then
      shiva.blinkText.values.x = 0
    end
  else
    logDebug('Already blinking text: ' .. c.name)
  end
end

function updateDirectLoadButtons(p)
  if p == nil then p = getSelectedPreset() end
  -- the page in the bank, from 0 ..12
  bankPage = math.floor(math.fmod(p, state.bankSize)/10)
  local s = getActivePreset()
  m = math.fmod(p, 10)
  p = p - m
  shiva.groupDirectLoadButtons.pagerDirectPageLoad.values.x = bankPage
  for i = 1, 10 do
    -- buttons are 1..10, labels are 11..10
    shiva.groupDirectLoadButtons[i + 10].values.text = getNameFromPreset(p + i - 1)
    -- addControlToTextBlink(shiva.groupDirectLoadButtons[i + 10])
    shiva.groupDirectLoadButtons[i].tag = 'direct' .. p + i - 1
    shiva.groupDirectLoadButtons[i].values.x = (p + i -1) == s and 1 or 0
  end
end

function getSelectModeStr()
  local t = {}
  if shiva.groupRunSettings.stBtnSelectMidi.values.x == 1 then table.insert(t, 'MIDI') end
  if shiva.groupRunSettings.stBtnSelectOsc.values.x == 1 then table.insert(t, 'OSC') end
  if #t == 0 then table.insert(t, '"shiva"') end
  return table.concat(t, ' + ')
end

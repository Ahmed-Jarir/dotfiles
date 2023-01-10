--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
import XMonad
import System.IO
import System.Exit
import XMonad.Actions.CycleWS
import Codec.Binary.UTF8.String
import Graphics.X11.ExtraTypes.XF86

import qualified Data.Map        as M
import qualified XMonad.StackSet as W

--hooks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
--end hooks

--utils
import XMonad.Util.Run
import XMonad.Util.Cursor
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Util.ClickableWorkspaces
--end utils

--layouts
import XMonad.Layout.Spacing
import XMonad.Layout.Fullscreen
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Tabbed (simpleTabbed)
import XMonad.Layout.Grid (Grid(..))
--end layouts

--Data
import Data.Monoid
import Data.Maybe (fromJust, isJust)

--end Data

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--

myTerminal      = "kitty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = zipWith (++) (map show [1..]) (map (": " ++) ["DEV","NET","UNI","DOC","GDV","VRM","CHT","MUS","VID"])
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..]

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices
-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

--scratchpads
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)

    , ((modm .|. shiftMask, xK_m     ), namedScratchpadAction scratchpads "cmus")
    , ((modm .|. shiftMask, xK_t     ), namedScratchpadAction scratchpads "term")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster)

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
    --
    -- , ((modm              , xK_f     ), sendMessage (Toggle "Full"))

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "pkill xmobar; pkill trayer; xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | gxmessage -file -"))
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    ++

    --
    --next and prev ws keybindings
    --
    [((mod1Mask,               xK_h     ), prevWS)
    ,((mod1Mask,               xK_l     ), nextWS)
    ]



------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
layoutSpacing i = spacingRaw False (Border 0 i 0 i) True (Border i 0 i 0) True
myLayout = avoidStruts (tiled ||| tabbed ||| grid)
  where
    tabbed = layoutSpacing 10 $ simpleTabbed
    grid   = layoutSpacing 10 $ Grid
    tiled  = layoutSpacing 10 $ Tall nmaster delta ratio
    nmaster= 1
    ratio  = 1/2
    delta  = 1/100

------------------------------------------------------------------------

myManageHook = composeAll
                  [
                  isFullscreen --> doFullFloat
                  , className =? "MPlayer"                  --> doFloat
                  , className =? "Gimp"                     --> doFloat
                  , className =? ".blueman-manager-wrapped" --> doFloat

                  , className =? "Login"                    --> doCenterFloat
                  , className =? "zoom"                     --> doCenterFloat
                  , className =? "Gxmessage"                --> doCenterFloat

                  , resource  =? "desktop_window"           --> doIgnore
                  , resource  =? "kdesktop"                 --> doIgnore

                  , className =? "Virt-manager"             --> doShift ( myWorkspaces !! 5 )
                  , className =? "discord"                  --> doShift ( myWorkspaces !! 6 )
                  , className =? "Whatsapp-for-linux"       --> doShift ( myWorkspaces !! 6 )] <+> namedScratchpadManageHook scratchpads

scratchpads = [
                  NS "cmus" "kitty --title music cmus" (title =? "music") nsDim
                , NS "term" "kitty --title terminal" (title =? "terminal") nsDim
              ]
    where
        nsDim = customFloating $ W.RationalRect 0.05 0.05 0.9 0.9
------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

--myLogHook = return() 
myStartupHook = do
    setDefaultCursor xC_left_ptr
    spawnOnce "blueman-applet &"
    spawnOnce "virt-manager &"
    spawnOnce "discord &"
    spawnOnce "compton &"
    spawnOnce "kitty &"
    spawnOnce "dunst &"
    spawnOnce "sxhkd &"

myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ def  { ppOutput = hPutStrLn h }

main = do 

    xmproc0 <- spawnPipe "xmobar -x 0 ~/dotfiles/xmonad/xmobart.config"
    xmproc1 <- spawnPipe "xmobar -x 0 ~/dotfiles/xmonad/xmobarb.config"
    xmproc2 <- spawnPipe "sleep 2; trayer --align right --widthtype request --edge bottom --height 16 --tint 0x1B2430 --transparent true --alpha 0"


    xmonad $ ewmhFullscreen $ ewmh $ docks defaults {
        logHook = dynamicLogWithPP $ filterOutWsPP [scratchpadWorkspaceTag] $ xmobarPP
        { ppOutput = \x -> hPutStrLn xmproc0 x 
            , ppCurrent = xmobarColor "#D6D5A8" "" . wrap ("<box type=Bottom width=2 mt=2 color=" ++ "#D6D5A8" ++ ">")"</box>"
            , ppVisible = xmobarColor "#F6E3C5" "" . clickable
            , ppHidden = xmobarColor  "#F6E3C5" "" . clickable
            , ppVisibleNoWindows = Just (xmobarColor "#51557E" "" . clickable)
            , ppHiddenNoWindows = xmobarColor "#51557E" ""
            , ppUrgent = xmobarColor "#C4001D" "" . wrap "!""!"
            , ppSep =  "<fn=1> | </fn>"
            , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
            , ppTitle = xmobarColor "#B4FF9F" "" 

        }

 
    }

defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook <+> manageDocks,
        handleEventHook    = myEventHook,
        logHook            = return(),
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The modifier key is 'super' . Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "--dmenus",
    "mod-d  ytmp menu",
    "mod-s  ssh menu",
    "mod-o  power menu",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "alt-l   Move client to the next workspace",
    "alt-h   Move client to the prev workspace",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]

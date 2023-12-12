---@diagnostic disable: undefined-global

-- Requires

require "secrets"

-- Helper functions

function BindAppShortcut(keyStroke, appName)
    hs.hotkey.bind({"ctrl", "cmd"}, keyStroke, function()
        hs.application.launchOrFocus(appName)
    end)
end

function BindCommandShortcut(keyStroke, command)
    hs.hotkey.bind({"ctrl", "cmd"}, keyStroke, function()
        os.execute(command)
    end)
end

function BindPasswordShortcut(passwordIndex)
    print("Binding password shortcut for: "..passwordIndex)
    hs.hotkey.bind({"cmd"}, passwordIndex, function()
        hs.eventtap.keyStrokes(passwordIndex..PasswordSuffix)
        hs.eventtap.keyStroke({}, "return")
    end)
end

function SearchBook(bookName)
    bookName = bookName:gsub(' by ', ' ')
    bookName = bookName:gsub(' %- ', ' ')
    bookName = bookName:gsub('.', '')
    bookName = bookName:gsub("'", '')
    local bookReviewSearchUrl = "https://duckduckgo.com/?va=q&t=hd&q=\\"..bookName.."+site%3Agoodreads.com&ia=web"
    local bookDownloadSearchUrl = "https://libgen.is/fiction/?q="..bookName.."&criteria=&language=English&format=epub"
    os.execute("open '"..bookReviewSearchUrl.."'")
    os.execute("open '"..bookDownloadSearchUrl.."'")
    hs.timer.doAfter(0.5, function()
        hs.eventtap.keyStroke({"ctrl", "shift"}, "tab")
    end)
end

-- App shortcuts

BindAppShortcut("c", "Calendar")
BindAppShortcut("f", "Finder")
BindAppShortcut("g", "Google Chrome")
BindAppShortcut("i", "iTerm")
BindAppShortcut("n", "Notes")
BindAppShortcut("o", "Microsoft Outlook")
BindAppShortcut("p", "Spotify")
BindAppShortcut("r", "Reminders")
BindAppShortcut("s", "Signal")
BindAppShortcut("v", "Visual Studio Code")
BindAppShortcut("w", "WhatsApp")

-- Command shortcuts

BindCommandShortcut("d", "open ~/Downloads")

-- Other hotkeys

-- Search for highlighted book
hs.hotkey.bind({"alt", "cmd"}, "b", function()
    -- Backup the existing clipboard
    local clipboardContents = hs.pasteboard.getContents()

    -- Copy the highlighted text, and get the book name
    hs.eventtap.keyStroke({"cmd"}, "c")
    local bookName = hs.pasteboard.getContents()
    
    SearchBook(bookName)

    -- Restore the original clipboard
    hs.pasteboard.setContents(clipboardContents)
end)


-- Search for book via prompt
hs.hotkey.bind({"ctrl", "cmd"}, "b", function()
    local button, bookName = hs.dialog.textPrompt("Book search", "Please a book title to search for:", "", "OK", "Cancel")
    if button == "OK" then
        SearchBook(bookName)
    end
end)

-- Password
for passwordIndex = 1, 9, 1 do
    BindPasswordShortcut(tostring(passwordIndex))
end

-- BindPasswordShortcut("1")

-- Login to work
hs.hotkey.bind({"ctrl", "cmd"}, "l", function()
    local app = hs.application.get("Citrix Viewer")
    if app then
        hs.application.launchOrFocus("Citrix Viewer")
    else
        local button, value = hs.dialog.textPrompt("Token", "Please enter your token:", "", "OK", "Cancel")
        if button == "OK" then 
            hs.urlevent.openURL(LoginUrl)
            hs.timer.doAfter(2, function()
                hs.eventtap.keyStrokes(LoginUser)
                hs.eventtap.keyStroke({}, "tab")
                hs.eventtap.keyStrokes(LoginTokenPrefix)
                hs.eventtap.keyStrokes(value)
                hs.eventtap.keyStroke({}, "return")
            end)
        end
    end
end)

-- Reload Hammerspoon config
hs.hotkey.bind({"cmd", "ctrl"}, "/", function()
    hs.alert.show("Reloading config...")
    hs.timer.doAfter(1, function() 
        hs.reload()
      end)
end)
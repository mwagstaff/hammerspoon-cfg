---@diagnostic disable: undefined-global

-- Requires

require "secrets"

-- Functions

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

function SearchBook(bookName)
    bookName = bookName:gsub(' by ', ' ')
    bookName = bookName:gsub(' %- ', ' ')
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

-- Reload Hammerspoon config
hs.hotkey.bind({"ctrl", "cmd"}, "/", function()
    hs.reload()
end)

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
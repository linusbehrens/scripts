#!/usr/bin/env swift
// fzf_gui.swift — A minimal graphical fuzzy finder for macOS
// ---------------------------------------------------------
// Reads newline‑separated items from STDIN, shows a small Cocoa window
// with an incremental fuzzy search, prints the chosen item(s) to STDOUT,
// then exits. Designed for macOS 11+ (Swift 5.7 +).

import Cocoa

// MARK: – Fuzzy matching (simple subsequence, case‑insensitive)
func fuzzyMatch(_ pattern: String, _ candidate: String) -> Bool {
    guard !pattern.isEmpty else { return true }
    let p = pattern.lowercased(), c = candidate.lowercased()
    var idx = c.startIndex
    for ch in p {
        guard let found = c[idx...].firstIndex(of: ch) else { return false }
        idx = c.index(after: found)
    }
    return true
}

// MARK: – App Delegate + UI
class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate, NSSearchFieldDelegate {
    let allItems: [String]
    var filtered: [String]

    private var window: NSWindow!
    private var table: NSTableView!
    private var search: NSSearchField!

    init(items: [String]) {
        self.allItems = items
        self.filtered = items
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        let width: CGFloat = 600, height: CGFloat = 400
        window = NSWindow(contentRect: .init(x: 0, y: 0, width: width, height: height),
                          styleMask: [.titled, .closable, .resizable],
                          backing: .buffered,
                          defer: false)
        window.title = "fzf-gui"
        window.center()

        // Search field
        search = NSSearchField(frame: .init(x: 0, y: height - 36, width: width, height: 24))
        search.placeholderString = "Type to filter…"
        search.action = #selector(filterContent)
        search.target = self
        search.focusRingType = .none
        window.contentView?.addSubview(search)

        // Table inside scroll view
        let scroll = NSScrollView(frame: .init(x: 0, y: 0, width: width, height: height - 36))
        scroll.hasVerticalScroller = true
        table = NSTableView(frame: scroll.bounds)
        table.allowsEmptySelection = false
        table.allowsMultipleSelection = false
        table.doubleAction = #selector(acceptSelection)
        table.target = self
        table.delegate = self
        table.dataSource = self

        let col = NSTableColumn(identifier: .init("items"))
        col.width = width
        table.addTableColumn(col)
        table.headerView = nil
        scroll.documentView = table
        window.contentView?.addSubview(scroll)

        window.makeKeyAndOrderFront(nil)
    }

    // DataSource
    func numberOfRows(in tableView: NSTableView) -> Int { filtered.count }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let id = NSUserInterfaceItemIdentifier("cell")
        let cell = tableView.makeView(withIdentifier: id, owner: self) as? NSTextField ?? {
            let tf = NSTextField(labelWithString: "")
            tf.identifier = id
            return tf
        }()
        cell.stringValue = filtered[row]
        return cell
    }

    // Live filter
    @objc private func filterContent() {
        let query = search.stringValue
        filtered = query.isEmpty ? allItems : allItems.filter { fuzzyMatch(query, $0) }
        table.reloadData()
        if !filtered.isEmpty {
            table.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
        }
    }

    // Accept via double‑click or Return
    @objc private func acceptSelection() { outputAndQuit() }

    func controlTextDidEndEditing(_ notification: Notification) {
        if let event = NSApp.currentEvent, event.keyCode == 36 { // Return key
            outputAndQuit()
        }
    }

    private func outputAndQuit() {
        guard !filtered.isEmpty else { NSApp.terminate(nil); return }
        let row = table.selectedRow >= 0 ? table.selectedRow : 0
        print(filtered[row])
        fflush(stdout)
        NSApp.terminate(nil)
    }
}

// MARK: – Read STDIN & launch
var items: [String] = []
while let line = readLine() { items.append(line) }

if items.isEmpty {
    fputs("fzf_gui: nothing to read on STDIN\n", stderr)
    exit(EXIT_FAILURE)
}

let app = NSApplication.shared
app.setActivationPolicy(.regular)
let delegate = AppDelegate(items: items)
app.delegate = delegate
app.activate(ignoringOtherApps: true)
app.run()

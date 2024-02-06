var lib = fl.getDocumentDOM().library;
lib.selectNone();
var items = lib.items;
var renamedCount = 0;
var errorCount = 0;

function isNameTaken(name) {
    for (var i = 0; i < lib.items.length; i++) {
        if (lib.items[i].name === name) {
            return true;
        }
    }
    return false;
}

fl.showIdleMessage(false);

for (var i = 0; i < items.length; i++) {
    var item = items[i];
    if (item.linkageClassName && item.linkageClassName !== "undefined") {
        var oldName = item.name;
        var newName = item.linkageClassName;

        if (newName !== oldName) {
            if (!isNameTaken(newName)) {
                try {
                    lib.selectItem(oldName)
                    lib.renameItem(newName);
                    fl.trace("Renamed '" + oldName + "' to '" + newName + "'");
                    renamedCount++;
                } catch (e) {
                    fl.trace("Error renaming '" + oldName + "' to '" + newName + "': " + e.message);
                    errorCount++;
                }
            } else {
                fl.trace("Skipped renaming: '" + newName + "' is already taken.");
                errorCount++;
            }
        }
    }
}

fl.showIdleMessage(true);
fl.trace("Renaming complete. Total renamed items: " + renamedCount + ". Errors or skipped items: " + errorCount);

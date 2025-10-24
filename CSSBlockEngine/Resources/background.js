const timestamp = new Date().toISOString();

browser.runtime.sendMessage({
    op: "heartbeat",
    timestamp
});

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log("[Background] Received message:", request);

    if (request.type == "content_request:enabled") {
        browser.runtime.sendNativeMessage("application.id", {message: "request:enabled_status"}, function(response) {
            console.log("[Background] Enabled status response:", response);
            sendResponse({
                "background_response:enabled": response["delivery:enabled_status"]
            });
        });
        return true;
    }

    if (request.type == "content_request:cosmetic_rules") {
        browser.runtime.sendNativeMessage("application.id", {message: "request:cosmetic_rules"}, function(response) {
            console.log("[Background] Cosmetic rules response:", response);
            const rules = response["delivery:cosmetic_rules"] || [];
            console.log("[Background] Loaded " + rules.length + " cosmetic rules");
            sendResponse({
                "background_response:cosmetic_rules": rules
            });
        });
        return true;
    }
    
    if (request.type == "cosmetic_blocked") {
        console.log("[Background] Cosmetic blocked count:", request.count);
        return true;
    }

    return true;
});

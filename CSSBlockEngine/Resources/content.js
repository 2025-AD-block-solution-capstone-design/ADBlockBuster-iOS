// Safari Content Script for Cosmetic Filtering

class SafariCosmeticFilter {
    constructor(ruleset = []) {
        this.ruleset = ruleset;
        this.blockedCount = 0;
    }

    parseCSS(styleString) {
        const styleObj = {};
        const parts = styleString.split(';');
        for (const part of parts) {
            const colonIndex = part.indexOf(':');
            if (colonIndex === -1) continue;

            const prop = part.substring(0, colonIndex).trim();
            const value = part.substring(colonIndex + 1).trim();

            if (prop && value) {
                styleObj[prop] = value;
            }
        }
        return styleObj;
    }

    isDomainMatch(currentDomain, ruleDomains) {
        if (!ruleDomains || ruleDomains === null) {
            return true;
        }

        if (Array.isArray(ruleDomains)) {
            return ruleDomains.some(domain => {
                return currentDomain === domain || currentDomain.endsWith('.' + domain);
            });
        }

        return false;
    }

    async getMatchedSelectors() {
        const result = {};
        const currentDomain = location.hostname;

        console.log("[Cosmetic] Processing " + this.ruleset.length + " rules for domain: " + currentDomain);

        for (const rule of this.ruleset) {
            if (!this.isDomainMatch(currentDomain, rule.domains)) {
                continue;
            }

            let elements;
            try {
                elements = document.querySelectorAll(rule.selector);
            } catch (err) {
                console.warn("[Cosmetic] Invalid selector skipped: \"" + rule.selector + "\"", err);
                continue;
            }

            if (elements.length === 0) continue;

            let css;
            if (rule.action.type === 'hide') {
                css = { display: 'none' };
            } else if (rule.action.type === 'style' && rule.action.value) {
                css = this.parseCSS(rule.action.value);
            } else {
                continue;
            }

            const matched = Array.from(elements).map(el => ({
                element: el,
                css: css,
                domains: rule.domains
            }));

            if (matched.length > 0) {
                if (!result[rule.selector]) {
                    result[rule.selector] = [];
                }
                result[rule.selector] = result[rule.selector].concat(matched);
            }
        }

        return result;
    }

    async applyInlineCSS(matchedSelectors) {
        let blockedCount = 0;
        for (const selector in matchedSelectors) {
            for (const { element, css } of matchedSelectors[selector]) {
                if (element.dataset.adHidden) continue;

                for (const prop in css) {
                    element.style.setProperty(prop, css[prop], 'important');
                }
                element.dataset.adHidden = 'true';
                blockedCount++;
            }
        }

        if (blockedCount > 0) {
            this.blockedCount += blockedCount;
            console.log("[Cosmetic] Applied CSS to " + blockedCount + " elements");
        }
    }

    async removeElements(matchedSelectors) {
        let removedCount = 0;
        for (const selector in matchedSelectors) {
            for (const { element } of matchedSelectors[selector]) {
                if (element.dataset.adRemoved) continue;

                if (!(element instanceof HTMLImageElement)) {
                    try {
                        element.remove();
                        removedCount++;
                    } catch (err) {
                        console.warn("[Cosmetic] Failed to remove element: \"" + selector + "\"", err);
                    }
                }
                element.dataset.adRemoved = 'true';
            }
        }

        if (removedCount > 0) {
            this.blockedCount += removedCount;
            console.log("[Cosmetic] Removed " + removedCount + " elements");
        }
    }

    async observeDynamicContent() {
        const observer = new MutationObserver(async (mutations) => {
            const matchedSelectors = await this.getMatchedSelectors();
            await this.applyInlineCSS(matchedSelectors);
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });

        console.log("[Cosmetic] Dynamic content observer started");
    }

    sendStatistics() {
        if (this.blockedCount > 0) {
            browser.runtime.sendMessage({
                type: "cosmetic_blocked",
                count: this.blockedCount
            }).catch(err => {
                console.warn("[Cosmetic] Failed to send statistics:", err);
            });
        }
    }
}

async function initCosmeticFilter() {
    console.log("[Cosmetic] 🚀 Starting initialization...");

    try {
        console.log("[Cosmetic] 📡 Requesting enabled status...");
        const enabledResponse = await browser.runtime.sendMessage({
            type: "content_request:enabled"
        });

        console.log("[Cosmetic] 📡 Enabled response:", enabledResponse);

        if (!enabledResponse || !enabledResponse["background_response:enabled"]) {
            console.log("[Cosmetic] ❌ Extension is disabled");
            return;
        }

        console.log("[Cosmetic] ✅ Extension is enabled, loading rules...");

        const rulesResponse = await browser.runtime.sendMessage({
            type: "content_request:cosmetic_rules"
        });

        const ruleset = rulesResponse["background_response:cosmetic_rules"] || [];

        console.log("[Cosmetic] 📦 Rules response:", rulesResponse);
        console.log("[Cosmetic] 📦 Ruleset:", ruleset);

        if (ruleset.length === 0) {
            console.log("[Cosmetic] ❌ No rules received");
            return;
        }

        console.log("[Cosmetic] ✅ Received " + ruleset.length + " rules");

        console.log("[Cosmetic] First 5 rules:");
        for (let i = 0; i < Math.min(5, ruleset.length); i++) {
            const rule = ruleset[i];
            console.log(`  ${i + 1}. domains=${JSON.stringify(rule.domains)}, selector=${rule.selector}`);
        }

        const cosmeticFilter = new SafariCosmeticFilter(ruleset);

        const matchedSelectors = await cosmeticFilter.getMatchedSelectors();

        const matchCount = Object.keys(matchedSelectors).length;
        console.log("[Cosmetic] 🎯 Found " + matchCount + " matching selectors");

        await cosmeticFilter.applyInlineCSS(matchedSelectors);
        await cosmeticFilter.observeDynamicContent();

        cosmeticFilter.sendStatistics();

    } catch (error) {
        console.error("[Cosmetic] ❌ Initialization error:", error);
    }
}

console.log("[Cosmetic] 📝 Script loaded, waiting for DOM...");

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initCosmeticFilter);
} else {
    initCosmeticFilter();
}

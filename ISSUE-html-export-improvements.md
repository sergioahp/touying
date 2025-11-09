# Issue: HTML Export - Missing theme styling, table support, and need for visual testing tools

**Created**: 2025-11-09
**Status**: Open
**Priority**: High
**Labels**: enhancement, html-export, testing, tooling, claude-code

---

## Summary

HTML export is partially working but has several issues with visual fidelity and lacks proper testing infrastructure.

## Issues Found During Testing

### 1. Theme Styling Loss
Most theme-specific styling has disappeared in HTML export:
- ✗ Grid layouts (ignored by Typst HTML export)
- ✗ Decorative lines and borders
- ✗ Complex layouts with headers/footers
- ✗ Theme-specific positioning and spacing
- ✓ Basic colors preserved
- ✓ Text content renders
- ✓ Animations work (pause, uncover, only, alternatives)

### 2. Tables Not Working
- HTML export does not render tables properly
- Need to investigate if this is a Typst limitation or fixable

### 3. Testing Infrastructure Gap

**Critical Problem**: Claude Code cannot view rendered HTML in browser

During development, we encountered a major blocker:
- Claude Code can read HTML source files
- Claude Code **CANNOT** see what the HTML actually looks like in a browser
- Had to rely on user feedback: "metropolis theme is completely empty"
- Debugging required trial and error without visual feedback
- **Session was interrupted** - Claude Code stopped working during debugging, requiring restart

**Impact**:
- Cannot verify CSS styling works correctly
- Cannot see if animations render properly
- Cannot validate visual layout matches expectations
- Cannot catch visual regressions
- Development significantly slower without visual feedback

### Proposed Solution: MCP for Web Page Interaction

We need a Model Context Protocol (MCP) server that allows Claude Code to:
- Launch a browser and view HTML files
- Take screenshots of rendered pages
- Potentially interact with the page (click, scroll, test navigation)
- Compare visual output against expectations

**Potential MCP Options**:
1. [Playwright MCP](https://github.com/microsoft/playwright) - Browser automation
2. [Puppeteer MCP](https://github.com/puppeteer/puppeteer) - Chrome DevTools Protocol
3. Custom MCP using Selenium/WebDriver
4. Browser extension that exposes screenshots via MCP

**Benefits**:
- Visual verification during development
- Catch styling issues immediately
- Test animations and transitions visually
- Compare HTML output against PDF reference
- Automated visual regression testing
- Faster debugging iteration

## Environment

- **Typst Version**: 0.14.0 (dd1e6e94)
- **Branch**: `origin/claude/typst-native-html-export-011CUxuzdostxzRp6GBMjycd`
- **Commit**: f8ee2ae (with fixes)
- **Platform**: Linux 6.12.35

## Current State

### Working ✓
- JavaScript initialization (with guard to prevent multiple init)
- Basic slide navigation (keyboard/touch)
- Animations (pause, uncover, only, alternatives)
- Math equations (rendered as SVG)
- Code blocks with syntax highlighting
- Basic theme colors
- Text rendering and formatting
- Lists (ordered/unordered)
- Links

### Not Working ✗
- Table rendering
- Grid layouts (Typst HTML limitation)
- Complex theme styling
- Decorative elements (lines, borders)
- Some alignment features (show: align ignored)
- Header/footer complex layouts
- Some components that rely on grid/alignment

### Themes Tested
- ✓ **Simple** - works well (minimal styling, good baseline)
- ⚠️ **Metropolis** - content works, most styling lost (headers, footers, lines)
- ⚠️ **University** - content works, styling limited
- ❓ **Stargazer** - not fully tested (preventive fix applied)
- ❓ **Dewdrop** - not tested
- ❓ **Aqua** - not tested

## Test Files Generated

Working HTML examples:
- `test-simple-fixed.html` - Simple theme with animations
- `test-metro-final.html` - Metropolis theme (content works)
- `test-uni-fixed.html` - University theme (content works)
- `test-output-fixed.html` - Comprehensive feature test
- `test-minimal.html` - Hand-crafted baseline test

## Debugging Session Notes

During the debugging session:
1. **Initial issue**: All HTML pages showed blank screens
   - Root cause: Multiple JavaScript initializations conflicting
   - Fix: Added `window.touyingInitialized` guard

2. **Metropolis/University empty**: Content was completely missing
   - Root cause: `show: std.align.with()` being ignored by Typst HTML export, causing content to disappear
   - Fix: Conditional application of align rules (`if target() != "html"`)

3. **Claude Code interruption**: Session stopped working mid-debugging
   - Required manual file path communication to user
   - Slowed down iteration significantly

4. **No visual feedback**: All HTML verification required user testing
   - "kind of working" - couldn't verify what this meant without screenshots
   - "theming has disappeared" - couldn't see how much was lost

## Next Steps

### Immediate (High Priority)

1. **Install MCP for browser interaction**
   - Research existing MCP servers for browser automation
   - Configure for local development
   - Document setup process
   - Test with Touying HTML files

2. **Document HTML export limitations**
   - Clear list of supported vs unsupported features
   - Migration guide for theme authors
   - CSS fallbacks for Typst limitations

### Short Term

3. **Fix table rendering**
   - Test if tables work at all in Typst HTML export
   - Implement workaround or clearly document limitation
   - Consider CSS-based table fallback

4. **Test remaining themes**
   - Dewdrop, Aqua, Stargazer
   - Document which themes work best with HTML
   - Create "HTML-friendly" theme variants if needed

5. **Improve CSS styling**
   - Add fallback styles for missing Typst features
   - Improve slide layout/positioning
   - Better typography and spacing

### Long Term

6. **Visual regression testing**
   - Screenshot-based tests using MCP
   - Compare HTML vs PDF output
   - Automate in CI

7. **Enhanced navigation**
   - Slide thumbnails/overview
   - Progress indicator improvements
   - Better mobile support

8. **Speaker notes and presentation mode**
   - Separate window for speaker notes
   - Timer and slide preview

## Related Files

**Core HTML Export**:
- `src/html-utils.typ` - HTML export utilities, CSS/JS injection
- `src/core.typ` - Modified slide rendering for HTML target (line 2312)
- `src/slides.typ` - HTML initialization (lines 51, 136-137)

**Theme Fixes**:
- `themes/metropolis.typ:91-104` - Conditional align for HTML
- `themes/university.typ:103-114` - Conditional align for HTML
- `themes/stargazer.typ:99-110` - Conditional align for HTML

**Documentation**:
- `HTML_EXPORT.md` - Feature documentation (from previous work)

**Test Files** (not committed):
- Various `test-*.typ` and `test-*.html` files for validation

## References

- Typst HTML export tracking issue: https://github.com/typst/typst/issues/5512
- Branch commit: f8ee2ae
- Original feature commit: a79581f
- Upstream closed issue: https://github.com/touying-typ/touying/issues/233 (moved to fork)

---

**Note**: This issue was created as a markdown file because issues are disabled on the fork repository.

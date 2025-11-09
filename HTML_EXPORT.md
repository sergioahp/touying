# Native HTML Export Support for Touying

Touying now supports native HTML export using Typst 0.14.0's experimental HTML features.

## Requirements

- **Typst 0.14.0 or later** (0.13.0 minimum, 0.14.0 recommended for better HTML support)
- Must compile with `--features html` flag

## Features

### ✅ Implemented

- **Text and Formatting**: Full text rendering with bold, italic, lists, headings
- **Math Equations**: Rendered as SVG graphics (inline and block)
- **Code Blocks**: Syntax-highlighted code blocks with language detection
- **Slide Structure**: Each slide wrapped in semantic HTML divs
- **CSS Styling**: Slide transitions, animations, and responsive design
- **Navigation**: Keyboard controls (arrows, space, PageUp/PageDown, Home/End)
- **Mobile Support**: Touch gestures for slide navigation
- **Progress Bar**: Visual progress indicator
- **Slide Counter**: Shows current slide and subslide numbers

### 🎨 Animations (Partial Support)

Due to Typst's current HTML export limitations, animations work differently:
- **PDF**: Uses subslides (multiple pages) - fully functional
- **HTML**: Content is pre-rendered for each animation state - working but needs enhancement

Functions supported:
- `#pause` - Progressive reveal
- `#uncover()` - Show content on specific subslides
- `#only()` - Show content exclusively on specific subslides
- `#alternatives()` - Cycle through alternatives

## Usage

### Compiling to HTML

```bash
# Basic HTML export
typst compile --features html presentation.typ output.html

# Compile to both PDF and HTML
typst compile --features html presentation.typ output.pdf
typst compile --features html presentation.typ output.html
```

### Example Presentation

```typst
#import "themes/simple.typ": *

#show: simple-theme.with(aspect-ratio: "16-9")

#title-slide[
  = My Presentation

  Author Name
]

== First Slide

This is regular text with *bold* and _italic_.

#pause

Lists work great:
- Item 1
- Item 2
- Item 3

== Math Equations

Inline: $E = m c^2$

Block equation:
$ sum_(n=1)^infinity 1/n^2 = pi^2/6 $

== Code Example

```python
def hello():
    print("Hello from Touying!")
```
```

### Compile Commands

```bash
# Generate HTML (requires Typst 0.14.0+)
typst compile --features html presentation.typ presentation.html

# Generate PDF (backward compatible)
typst compile --features html presentation.typ presentation.pdf

# Generate PNG slides for preview
typst compile --features html presentation.typ slides-{n}.png --format png
```

## HTML Output Structure

The generated HTML includes:

- **CSS Styling**: Embedded styles for slides, animations, navigation
- **JavaScript**: Slide navigation and animation control
- **Semantic HTML**: Proper HTML5 structure
- **SVG Graphics**: Math equations and diagrams
- **Syntax Highlighting**: Colored code blocks

## Navigation Controls

### Keyboard

- `→` / `Space` / `PageDown` - Next slide/subslide
- `←` / `PageUp` - Previous slide/subslide
- `Home` - First slide
- `End` - Last slide

### Mobile/Touch

- Swipe left - Next slide
- Swipe right - Previous slide

## Technical Implementation

### Files Modified/Created

- `src/html-utils.typ` - HTML export utilities and CSS/JS injection
- `src/core.typ` - Modified slide rendering for HTML target
- `src/slides.typ` - Added HTML support initialization
- `src/utils.typ` - Animation functions (unchanged for compatibility)

### Key Functions

**HTML Utilities** (`html-utils.typ`):
- `inject-presentation-css()` - Injects CSS styling
- `inject-navigation-js()` - Adds JavaScript navigation
- `html-slide()` - Wraps slides in HTML divs
- `fix-math()` - Renders math as SVG
- `fix-code()` - Wraps code blocks
- `fix-image()` - Handles images

**Core Rendering** (`core.typ`):
- Modified `touying-slide()` to detect HTML target
- Conditional page settings (PDF only)
- HTML slide wrapping for proper structure

## Limitations

### Current HTML Export Limitations (Typst 0.14.0)

1. **Page Settings**: Cannot use `set page()` in HTML mode
2. **Animations**: CSS/JS animations work but are simpler than PDF subslides
3. **Some Alignments**: May not render exactly as in PDF
4. **Hide Elements**: Limited support for `hide()`

### Workarounds Applied

- Slides use `<div>` containers instead of page breaks
- Animations pre-render all states
- Math rendered as SVG frames
- Code blocks use Typst's built-in syntax highlighting

## Browser Compatibility

Tested and working in:
- ✅ Chrome/Chromium 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+

## Future Enhancements

### Planned Features

- [ ] Better animation support with CSS transitions between states
- [ ] Interactive elements (clickable links in SVG diagrams)
- [ ] Embedded videos and iframes
- [ ] More transition effects
- [ ] Speaker notes in separate window
- [ ] PDF export button from HTML
- [ ] Fullscreen API support
- [ ] Slide thumbnails/overview mode

### Potential Improvements

- Custom themes for HTML (separate from PDF themes)
- JavaScript-based plugins for extensions
- Export to reveal.js or other HTML slide frameworks
- Real-time collaboration features

## Examples

See `test-html-export.typ` for a comprehensive example covering:
- Text and lists
- Math equations (inline and block)
- Code blocks (Python, Rust)
- Animations (uncover, only, pause)
- Tables and grids
- Nested lists
- Links and references

## Compatibility

The HTML export is fully backward compatible:
- ✅ PDF compilation still works
- ✅ Existing themes unchanged
- ✅ All animation functions work as before
- ✅ No breaking changes to existing code

Simply add `--features html` when compiling to enable HTML support.

## Contributing

To improve HTML export:

1. Test with different content types
2. Report issues with specific examples
3. Suggest CSS/JavaScript enhancements
4. Submit pull requests for new features

## License

Same as Touying project.

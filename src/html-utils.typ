// HTML export utilities for Touying
// Provides helper functions for native HTML export with animations and transitions

#import "utils.typ"

/// Detect if we're compiling to HTML
#let is-html-target() = context {
  target() == "html"
}

/// Inject global CSS styles for presentations
#let inject-presentation-css(theme-colors: (:)) = context {
  if target() == "html" {
    let primary = theme-colors.at("primary", default: rgb("#0074d9"))
    let secondary = theme-colors.at("secondary", default: rgb("#001f3f"))
    let text-color = theme-colors.at("neutral-darkest", default: rgb("#000000"))
    let bg-color = theme-colors.at("neutral-lightest", default: rgb("#ffffff"))

    let css-content = "
      /* Reset and base styles */
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: 'New Computer Modern', 'Latin Modern Roman', 'Computer Modern', serif;
        background: #333;
        overflow: hidden;
        color: " + text-color.to-hex() + ";
      }

      /* Slide container */
      .touying-slide {
        position: relative;
        width: 100vw;
        height: 100vh;
        background: " + bg-color.to-hex() + ";
        page-break-after: always;
        display: none;
        padding: 2em;
        overflow: hidden;
      }

      .touying-slide.active {
        display: flex;
        flex-direction: column;
        animation: slideIn 0.5s ease-in-out;
      }

      /* Slide transitions */
      @keyframes slideIn {
        from {
          opacity: 0;
          transform: translateX(50px);
        }
        to {
          opacity: 1;
          transform: translateX(0);
        }
      }

      @keyframes fadeIn {
        from {
          opacity: 0;
        }
        to {
          opacity: 1;
        }
      }

      /* Animation support */
      .touying-hidden {
        visibility: hidden;
      }

      .touying-uncover {
        transition: opacity 0.3s ease-in-out;
      }

      .touying-uncover.visible {
        opacity: 1;
      }

      .touying-uncover:not(.visible) {
        opacity: 0;
      }

      .touying-only.visible {
        display: inline;
        animation: fadeIn 0.3s ease-in-out;
      }

      .touying-only:not(.visible) {
        display: none;
      }

      /* Navigation controls */
      .touying-nav {
        position: fixed;
        bottom: 2em;
        right: 2em;
        display: flex;
        gap: 1em;
        z-index: 1000;
      }

      .touying-nav button {
        padding: 0.5em 1em;
        background: " + primary.to-hex() + ";
        color: white;
        border: none;
        border-radius: 0.25em;
        cursor: pointer;
        font-size: 1em;
        transition: background 0.2s;
      }

      .touying-nav button:hover {
        background: " + secondary.to-hex() + ";
      }

      .touying-nav button:disabled {
        opacity: 0.5;
        cursor: not-allowed;
      }

      /* Slide counter */
      .touying-counter {
        position: fixed;
        bottom: 2em;
        left: 2em;
        color: " + text-color.to-hex() + ";
        font-size: 0.9em;
        background: rgba(255, 255, 255, 0.9);
        padding: 0.5em 1em;
        border-radius: 0.25em;
        z-index: 1000;
      }

      /* Math equations */
      .touying-math svg {
        background: transparent;
      }

      .touying-math.block {
        display: block;
        margin: 1em auto;
        text-align: center;
      }

      .touying-math.inline {
        display: inline-block;
        vertical-align: middle;
      }

      /* Code blocks */
      .touying-code {
        margin: 1em 0;
        border-radius: 0.5em;
        overflow: hidden;
      }

      /* Images and diagrams */
      .touying-image {
        max-width: 100%;
        height: auto;
        display: block;
        margin: 1em auto;
      }

      .touying-diagram {
        margin: 1em auto;
        display: block;
      }

      /* Progress bar */
      .touying-progress {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 0.25em;
        background: rgba(0, 0, 0, 0.1);
        z-index: 1000;
      }

      .touying-progress-bar {
        height: 100%;
        background: " + primary.to-hex() + ";
        transition: width 0.3s ease;
      }

      /* Print styles */
      @media print {
        body {
          background: white;
        }

        .touying-slide {
          display: flex !important;
          page-break-after: always;
        }

        .touying-nav,
        .touying-counter,
        .touying-progress {
          display: none !important;
        }
      }

      /* Subslide animations */
      .touying-subslide {
        display: none;
      }

      .touying-subslide.active {
        display: contents;
      }
    "

    html.elem("style", css-content)
  }
}

/// Inject JavaScript for slide navigation and animations
#let inject-navigation-js() = context {
  if target() == "html" {
    // JavaScript needs to be in a string
    let js-content = ```
      let currentSlide = 0;
      let currentSubslide = 0;
      let slides = [];
      let subslides = [];

      function initSlideshow() {
        slides = document.querySelectorAll('.touying-slide');
        if (slides.length === 0) return;

        slides.forEach((slide, idx) => {
          const subslideCount = parseInt(slide.dataset.subslides || '1');
          subslides[idx] = subslideCount;
        });

        showSlide(0, 0);
        updateControls();
        updateProgress();
      }

      function showSlide(slideIdx, subslideIdx) {
        if (slideIdx < 0 || slideIdx >= slides.length) return;

        slides.forEach(s => s.classList.remove('active'));
        slides[slideIdx].classList.add('active');

        currentSlide = slideIdx;
        currentSubslide = subslideIdx;

        const slide = slides[slideIdx];
        const elements = slide.querySelectorAll('[data-visible-subslides]');
        elements.forEach(el => {
          const visibleSubslides = el.dataset.visibleSubslides;
          if (isVisible(visibleSubslides, subslideIdx + 1)) {
            el.classList.add('visible');
          } else {
            el.classList.remove('visible');
          }
        });

        updateCounter();
        updateProgress();
      }

      function isVisible(visibleSubslides, currentIdx) {
        const ranges = visibleSubslides.split(',').map(s => s.trim());
        for (const range of ranges) {
          if (range.includes('-')) {
            const parts = range.split('-');
            const start = parts[0] ? parseInt(parts[0]) : 1;
            const end = parts[1] ? parseInt(parts[1]) : Infinity;
            if (currentIdx >= start && currentIdx <= end) return true;
          } else {
            if (parseInt(range) === currentIdx) return true;
          }
        }
        return false;
      }

      function nextStep() {
        const maxSubslides = subslides[currentSlide] || 1;
        if (currentSubslide + 1 < maxSubslides) {
          showSlide(currentSlide, currentSubslide + 1);
        } else if (currentSlide + 1 < slides.length) {
          showSlide(currentSlide + 1, 0);
        }
        updateControls();
      }

      function prevStep() {
        if (currentSubslide > 0) {
          showSlide(currentSlide, currentSubslide - 1);
        } else if (currentSlide > 0) {
          const prevSlideSubslides = subslides[currentSlide - 1] || 1;
          showSlide(currentSlide - 1, prevSlideSubslides - 1);
        }
        updateControls();
      }

      function updateControls() {
        const prevBtn = document.getElementById('touying-prev');
        const nextBtn = document.getElementById('touying-next');

        if (prevBtn) {
          prevBtn.disabled = currentSlide === 0 && currentSubslide === 0;
        }

        if (nextBtn) {
          const maxSubslides = subslides[currentSlide] || 1;
          const isLastSubslide = currentSubslide === maxSubslides - 1;
          const isLastSlide = currentSlide === slides.length - 1;
          nextBtn.disabled = isLastSlide && isLastSubslide;
        }
      }

      function updateCounter() {
        const counter = document.getElementById('touying-counter');
        if (counter) {
          const total = slides.length;
          const maxSubslides = subslides[currentSlide] || 1;
          let text = (currentSlide + 1) + ' / ' + total;
          if (maxSubslides > 1) {
            text += ' (' + (currentSubslide + 1) + '/' + maxSubslides + ')';
          }
          counter.textContent = text;
        }
      }

      function updateProgress() {
        const progressBar = document.getElementById('touying-progress-bar');
        if (progressBar) {
          const totalSteps = slides.length;
          const progress = ((currentSlide + 1) / totalSteps) * 100;
          progressBar.style.width = progress + '%';
        }
      }

      document.addEventListener('keydown', (e) => {
        if (e.key === 'ArrowRight' || e.key === ' ' || e.key === 'PageDown') {
          e.preventDefault();
          nextStep();
        } else if (e.key === 'ArrowLeft' || e.key === 'PageUp') {
          e.preventDefault();
          prevStep();
        } else if (e.key === 'Home') {
          e.preventDefault();
          showSlide(0, 0);
          updateControls();
        } else if (e.key === 'End') {
          e.preventDefault();
          const lastIdx = slides.length - 1;
          const lastSubslides = subslides[lastIdx] || 1;
          showSlide(lastIdx, lastSubslides - 1);
          updateControls();
        }
      });

      let touchStartX = 0;
      document.addEventListener('touchstart', (e) => {
        touchStartX = e.touches[0].clientX;
      });

      document.addEventListener('touchend', (e) => {
        const touchEndX = e.changedTouches[0].clientX;
        const diff = touchStartX - touchEndX;
        if (Math.abs(diff) > 50) {
          if (diff > 0) {
            nextStep();
          } else {
            prevStep();
          }
        }
      });

      if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initSlideshow);
      } else {
        initSlideshow();
      }
    ```.text

    html.elem("script", js-content)
  }
}

/// Wrap content in an HTML slide container
#let html-slide(slide-number: 1, subslide-count: 1, body) = context {
  if target() == "html" {
    // Create a div with data attributes for JavaScript
    html.div(class: "touying-slide")[
      #metadata((
        kind: "touying-slide",
        slide-number: slide-number,
        subslide-count: subslide-count
      ))
      #body
    ]
  } else {
    body
  }
}

/// Create HTML navigation controls
#let html-navigation() = context {
  if target() == "html" {
    // Simple navigation placeholders - JavaScript will handle the actual functionality
    html.div(class: "touying-nav")[Navigation controls will appear here]
  }
}

/// Fix math rendering for HTML
#let fix-math(eq) = context {
  if target() == "html" {
    // Use specific color for proper SVG rendering
    set text(fill: rgb("#0a090b"))
    if eq.block {
      html.div(class: "touying-math block")[
        #html.frame(eq)
      ]
    } else {
      box(html.span(class: "touying-math inline")[
        #html.frame(eq)
      ])
    }
  } else {
    eq
  }
}

/// Wrap code blocks for HTML
#let fix-code(code-block) = context {
  if target() == "html" {
    html.div(class: "touying-code")[
      #code-block
    ]
  } else {
    code-block
  }
}

/// Wrap images for HTML
#let fix-image(img) = context {
  if target() == "html" {
    html.div(class: "touying-image")[
      #img
    ]
  } else {
    img
  }
}

/// Wrap diagrams (CeTZ, Fletcher) for HTML using frames
#let fix-diagram(diagram) = context {
  if target() == "html" {
    html.div(class: "touying-diagram")[
      #html.frame(diagram)
    ]
  } else {
    diagram
  }
}

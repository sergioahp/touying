// Test file for HTML export functionality
// This tests all major features: equations, code, images, animations, etc.

#import "themes/simple.typ": *

#show: simple-theme.with(aspect-ratio: "16-9")

#title-slide[
  = HTML Export Test Presentation

  Testing native HTML export with animations

  Touying Presentation Framework
]

== Slide 1: Basic Text and Lists

This is a basic slide with regular text.

#pause

*Features to test:*
- Text rendering and copyability
- List formatting
- Bold and _italic_ text
- #pause Special characters: α, β, γ, ∀, ∃, ∈

== Slide 2: Math Equations

Inline math: $E = m c^2$ and $integral_0^infinity e^(-x^2) dif x = sqrt(pi)/2$

#pause

Block equations:

$ sum_(n=1)^infinity 1/n^2 = pi^2/6 $

#pause

$ mat(
  1, 2, 3;
  4, 5, 6;
  7, 8, 9
) $

== Slide 3: Code Blocks

Here's some Python code:

```python
def fibonacci(n):
    """Calculate the nth Fibonacci number."""
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

# Test the function
for i in range(10):
    print(f"F({i}) = {fibonacci(i)}")
```

#pause

And some Rust:

```rust
fn main() {
    let numbers = vec![1, 2, 3, 4, 5];
    let sum: i32 = numbers.iter().sum();
    println!("Sum: {}", sum);
}
```

== Slide 4: Animations with `uncover`

#uncover("1-")[First item appears immediately]

#uncover("2-")[Second item appears on step 2]

#uncover("3-")[Third item appears on step 3]

#uncover("4-")[Fourth item appears on step 4]

== Slide 5: Animations with `only`

#only("1")[Only visible on step 1]

#only("2")[Only visible on step 2]

#only("3")[Only visible on step 3]

#only("1,3")[Visible on steps 1 and 3]

#only("2-")[Visible from step 2 onwards]

== Slide 6: Mixed Animations

Content that's always visible.

#pause

#uncover("2-")[This content reserves space even when hidden]

#only("3-")[This content doesn't reserve space when hidden]

#pause

Final content appears on step 4.

== Slide 7: Complex Math

The quadratic formula:

$ x = (-b plus.minus sqrt(b^2 - 4a c)) / (2a) $

#pause

Euler's identity (most beautiful equation):

$ e^(i pi) + 1 = 0 $

#pause

Maxwell's equations:

$ nabla dot bold(E) &= rho / epsilon_0 \
  nabla dot bold(B) &= 0 \
  nabla times bold(E) &= - (partial bold(B)) / (partial t) \
  nabla times bold(B) &= mu_0 bold(J) + mu_0 epsilon_0 (partial bold(E)) / (partial t) $

== Slide 8: Tables and Grids

#table(
  columns: (1fr, 1fr, 1fr),
  [*Feature*], [*PDF*], [*HTML*],
  [Text Selection], [Limited], [Full],
  [Animations], [Subslides], [CSS/JS],
  [File Size], [Large], [Small],
  [SEO Friendly], [No], [Yes],
)

#pause

Both formats should work!

== Slide 9: Nested Lists and Formatting

1. *First level*
   - Nested bullet
   - Another nested item
     - Third level
       - Fourth level

2. *Second item*
   a. Numbered nested
   b. Another numbered
      i. Even deeper

#pause

3. Final item with #text(fill: red)[colored text] and `inline code`.

== Slide 10: Alternatives

#alternatives[
  First alternative
][
  Second alternative
][
  Third alternative
][
  Fourth alternative
]

== Slide 11: Links and References

External links should work:
- Visit #link("https://typst.app")[Typst]
- Check #link("https://github.com/touying-typ/touying")[Touying on GitHub]

#pause

Internal references and cross-links.

== Final Slide: Summary

*What we tested:*

#uncover("2-")[✓ Text rendering and formatting]
#uncover("3-")[✓ Math equations (inline and block)]
#uncover("4-")[✓ Code blocks with syntax highlighting]
#uncover("5-")[✓ Animations (uncover, only, pause)]
#uncover("6-")[✓ Tables and grids]
#uncover("7-")[✓ Lists (ordered, unordered, nested)]

#uncover("8-")[
  *Both PDF and HTML outputs should work!*
]

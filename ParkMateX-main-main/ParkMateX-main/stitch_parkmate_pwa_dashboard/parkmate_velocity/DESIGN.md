# Design System Specification: The Urban Architecture

## 1. Overview & Creative North Star
**Creative North Star: "The Architectural Concierge"**

This design system rejects the cluttered, "utility-first" look of traditional utility apps in favor of a high-end, editorial experience. It treats the mobile screen as a premium physical environment. We move beyond "standard" PWA layouts by using **intentional asymmetry, deep tonal layering, and sophisticated typography** that feels more like a luxury fintech dashboard than a parking tool.

The goal is to instill a sense of "Quiet Authority." We achieve this through "The Breathing Room" principle: using hyper-generous whitespace and removing structural noise (like lines and boxes) to let the critical data—availability and location—command the user’s focus.

---

## 2. Colors & Surface Philosophy

The palette is anchored in a deep, authoritative blue (`primary: #000666`), balanced by a pristine, airy background. 

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders to section off content. Physical boundaries must be defined solely through background color shifts or subtle tonal transitions.
*   **Surface-to-Surface Transition:** Place a `surface_container_low` card on a `surface` background. The shift in hex value is the border.

### Surface Hierarchy & Nesting
Treat the UI as a series of stacked, premium materials. Use the `surface_container` tiers to create depth:
1.  **Base Layer:** `surface` (#f7f9fb)
2.  **Sectioning:** `surface_container_low` (#f2f4f6) for secondary grouping.
3.  **Active Elements:** `surface_container_lowest` (#ffffff) for primary interactive cards to create a "lifted" feel.

### The "Glass & Signature" Rule
*   **Glassmorphism:** For floating headers or navigation bars, use `surface` at 80% opacity with a `backdrop-blur` of 20px. This ensures the map or list content feels integrated, not cut off.
*   **Signature Textures:** Apply a subtle linear gradient to main CTAs transitioning from `primary` (#000666) to `primary_container` (#1a237e) at a 135-degree angle. This adds "soul" and prevents the deep blue from feeling flat.

---

## 3. Typography

The system utilizes a dual-font strategy to balance character with legibility.

*   **Editorial Authority (Manrope):** Used for `display` and `headline` roles. Manrope’s geometric yet warm nature provides a modern, fintech-adjacent feel. Use wide tracking (-1%) for a premium, custom look.
*   **Functional Precision (Inter):** Used for `title`, `body`, and `label` roles. Inter is the workhorse, chosen for its exceptional x-height and readability in high-stress environments (like driving).

**Key Scale:**
- **Headline-LG (Manrope, 2rem):** Used for arrival times or "Spot Found" success states.
- **Title-MD (Inter, 1.125rem):** The primary weight for parking lot names.
- **Label-SM (Inter, 0.6875rem):** Used for secondary metadata like "Distance" or "Price per hour."

---

## 4. Elevation & Depth

### The Layering Principle
Depth is achieved via **Tonal Layering**. Avoid traditional shadows for static elements. 
*   **Example:** A `surface_container_lowest` card sitting on a `surface_container_low` section creates a natural, soft lift.

### Ambient Shadows
When a floating effect is required (e.g., a "Reserve Now" sticky button):
*   **Blur:** 24px - 40px.
*   **Opacity:** 4% - 6%.
*   **Color:** Use a tinted version of `on_surface` (#191c1e) to mimic natural light. Never use pure black shadows.

### The "Ghost Border" Fallback
If accessibility requires a container edge, use a **Ghost Border**: 
*   Token: `outline_variant` (#c6c5d4) at 15% opacity. High-contrast, 100% opaque borders are strictly forbidden.

---

## 5. Components

### Cards & Lists
*   **Rule:** Forbid the use of divider lines.
*   **Execution:** Separate list items using `16px` of vertical whitespace (Spacing Scale). Use `surface_container_low` for the background of even-numbered items if a visual distinction is necessary, or simply rely on typography hierarchy.
*   **Roundedness:** Use `md` (0.75rem / 12px) for all content cards to maintain the "Soft Minimalism" feel.

### Primary Buttons
*   **Style:** `primary` (#000666) background with `on_primary` (#ffffff) text.
*   **Radius:** `lg` (1rem) for a friendly yet professional "pill-like" appearance.
*   **Internal Padding:** 16px vertical / 24px horizontal.

### Status Chips (Availability)
*   **Available:** Background: `secondary_container` (#7bf8a1) | Text: `on_secondary_container` (#007239).
*   **Occupied:** Background: `tertiary_fixed` (#ffdad7) | Text: `on_tertiary_fixed_variant` (#8e101c).
*   **Style:** Minimalist, no icon, uppercase `label-sm` typography with +5% letter spacing.

### Smart Input Fields
*   **Style:** "Understated Elegance." No background fill. Use a `surface_container_highest` (#e0e3e5) bottom-stroke (2px). Upon focus, transition the stroke to `primary` and add a very subtle 4% `primary_fixed` glow.

### Additional Specific Components
*   **The "Spot Occupancy" Heatmap:** Use soft-edged circles in `secondary` and `tertiary` with 20% opacity pulses to indicate real-time sensor data.
*   **The Proximity Slider:** A custom-styled slider using `primary` for the track and a `surface_container_lowest` thumb with an ambient shadow for high-end tactile feedback.

---

## 6. Do’s and Don’ts

### Do
*   **Do** use asymmetrical margins (e.g., 24px left, 16px right) on editorial headers to create a custom, non-templated look.
*   **Do** use `body-lg` for primary instructions. Bold, clear communication reduces cognitive load for users in cars.
*   **Do** leverage `surface_bright` for active states in navigation menus.

### Don’t
*   **Don’t** use a divider line between the header and the body. Use a shift from `surface_container_high` to `surface` instead.
*   **Don’t** use pure black (#000000) for text. Always use `on_surface` (#191c1e) to maintain a soft, premium contrast.
*   **Don’t** crowd the interface. If a screen feels full, increase the `md` or `lg` spacing tokens and hide secondary information behind a "Details" chevron.
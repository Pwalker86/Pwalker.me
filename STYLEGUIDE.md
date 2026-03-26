# Blogging Site Style Guide

This guide captures the visual direction and responsive behavior for a modern editorial blog.

## Visual direction

- Editorial, clean, and warm rather than app-like.
- High readability with serif-forward typography and generous line-height.
- Calm slate + blue palette with amber accents for emphasis.
- Soft surfaces, rounded corners, and restrained shadows.

## Design tokens

### Color

- Ink: `#0f172a`
- Surface: `#f8fafc`
- Border: `#cbd5e1`
- Primary: `#1e3a8a`
- Accent: `#f59e0b`

### Typography

- Primary font stack: `"Source Serif 4", "Iowan Old Style", "Palatino Linotype", "Book Antiqua", Palatino, Georgia, serif`
- Heading sizes:
  - Hero: `text-4xl` -> `sm:text-5xl` -> `lg:text-6xl`
  - Section title: `text-2xl` -> `sm:text-3xl`
- Body copy: `text-base` with `leading-8` for long-form readability.

### Spacing and shape

- Base rhythm: 8px increments.
- Common paddings: `p-4`, `p-5`, `p-7`, `p-8`.
- Radius: `rounded-xl` and `rounded-2xl` for cards/surfaces.

## Responsive rules

- `sm` (640px+): increase spacing and headline scale.
- `md` (768px+): introduce 2-column layouts for content and cards.
- `lg` (1024px+): enable article + sidebar compositions.
- `xl` (1280px+): expand listing grids to 3 columns.

### Phone (default)

- Single-column flow for all core reading actions.
- Keep tap targets >= 44px height.
- Prioritize headline, excerpt, and primary action above fold.

### Tablet (`md`)

- Two-column card feeds.
- Balanced gutters and larger text blocks.
- Keep article body dominant; secondary modules move below or beside body.

### Desktop (`lg`+)

- Article body plus contextual aside (TOC/author/recommended posts).
- Wider hero treatments with controlled reading measure (`~72ch`).
- Grid-heavy index pages with clear visual hierarchy.

## Component guidance

- Blog cards: category, title, short excerpt, metadata row, clear CTA.
- Inputs/buttons: rounded and high-contrast focus states.
- Tags/chips: subtle backgrounds with semantic color families.
- Code blocks: dark background with strong contrast and horizontal scrolling.

## Motion and background

- Use subtle elevation and y-axis hover transitions on cards (`hover:-translate-y-1`).
- Favor restrained transitions (`duration-300`) over continuous effects.
- Background can include soft gradients or low-contrast radial glows.

## Implementation references

- Live guide page: `app/views/style_guides/show.html.erb`
- Token and shared styles: `app/assets/tailwind/application.css`
- Route: `config/routes.rb`

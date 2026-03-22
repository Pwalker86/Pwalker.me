# Gemini Code Assist Style Guide — Pwalker.me

> Gemini Code Assist reads this file from `.gemini/styleguide.md`.
> For a full project description, see [`AGENTS.md`](../AGENTS.md) in the repository root.

---

## Project overview

**Pwalker.me** is a personal website / blog built with **Ruby on Rails 8**.

Stack at a glance:

| Concern | Technology |
|---------|-----------|
| Web framework | Rails 8 |
| Background jobs | Solid Queue |
| Realtime / SPA navigation | Hotwire (Turbo Drive, Frames, Streams) |
| JS behaviour | Stimulus JS |
| Styling | Tailwind CSS |
| Primary test framework | Minitest (with Capybara for system tests) |

---

## Style preferences

### Ruby / Rails

- Ruby 3.3+, Rails 8.x conventions throughout.
- 2-space indentation; single-quoted strings unless interpolation is required.
- `snake_case` for methods and variables; `CamelCase` for classes and modules;
  `SCREAMING_SNAKE_CASE` for constants.
- Avoid `unless` with complex conditions; prefer `if !`.
- Guard clauses over nested `if` blocks.
- Prefer `&.` (safe navigation) over `if obj.present?` chains where appropriate.
- Use `frozen_string_literal: true` magic comment on all Ruby files.

### Views (ERB / Tailwind)

- Use Rails tag helpers (`link_to`, `button_to`, `form_with`) rather than raw HTML.
- Wrap independently-updatable regions in Turbo Frames: `<turbo-frame id="unique-id">`.
- Use Tailwind utility classes directly; avoid `style=""` attributes.
- Mobile-first responsive design with `sm:`, `md:`, `lg:`, `xl:` prefixes.

### JavaScript (Stimulus)

- ES2022+; modules only (no global variables).
- Controllers in `app/javascript/controllers/<name>_controller.js`.
- `camelCase` for JS identifiers; `kebab-case` for HTML attribute values.
- No jQuery; use the Stimulus / Turbo APIs and native DOM APIs.

### Tailwind configuration

- Extend rather than override the default Tailwind theme in `tailwind.config.js`.
- Use `safelist` for dynamically constructed class names.

---

## Testing requirements

All code contributions **must** include tests.  No feature or fix is complete without them.

| Code being added | Required test file |
|------------------|--------------------|
| Model (validation, scopes, methods) | `test/models/<model>_test.rb` |
| Controller / route | `test/requests/<resource>_test.rb` |
| Background job | `test/jobs/<name>_job_test.rb` |
| User-facing UI / Turbo interaction | `test/system/<feature>_test.rb` |
| Stimulus controller (non-trivial) | `test/javascript/<name>_controller_test.js` |

Test commands:

```bash
bin/rails test            # unit + integration
bin/rails test:system     # Capybara system tests
```

---

## Solid Queue — job conventions

- All jobs extend `ApplicationJob` and live in `app/jobs/`.
- Jobs must be **idempotent** (safe to run more than once).
- Use `retry_on <ErrorClass>, wait: :polynomially_longer, attempts: 5`.
- Use `discard_on <ErrorClass>` for unrecoverable errors.
- Queue names are defined in `config/solid_queue.yml`.

---

## Security guidelines

- Always use `strong_parameters`.
- Use Rails CSRF protection (`protect_from_forgery`).
- Never commit secrets; use `bin/rails credentials:edit` or ENV variables.
- Sanitise user input before rendering with `sanitize` / `html_escape`.
- Add indexes to foreign keys and frequently queried columns in migrations.

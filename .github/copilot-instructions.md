# GitHub Copilot Instructions — Pwalker.me

This file configures GitHub Copilot's behaviour for the **Pwalker.me** project.
For a full description of the project stack and conventions, see [`AGENTS.md`](../AGENTS.md)
in the repository root.

---

## Project summary

**Pwalker.me** is a personal website built with **Rails 8**, using:

- **Hotwire** (Turbo Drive · Turbo Frames · Turbo Streams) for SPA-like navigation
- **Stimulus JS** for lightweight front-end behaviour
- **Tailwind CSS** for utility-first styling
- **Solid Queue** for background job processing

---

## Code-generation rules

### General

- Always generate **Ruby on Rails 8** compatible code.
- Follow the Rails conventions: RESTful routes, MVC separation, Rails helpers/partials.
- Use `bin/rails generate` scaffolds/generators when creating new resources; adjust the
  generated boilerplate rather than writing it from scratch.

### Tests — required for every suggestion

Copilot **must** generate tests alongside any new feature or bug-fix:

| What you're adding | Where the test goes |
|--------------------|---------------------|
| Model logic / validations | `test/models/<model>_test.rb` |
| Controller actions / routes | `test/requests/<resource>_test.rb` |
| Background jobs | `test/jobs/<name>_job_test.rb` |
| Stimulus controller behaviour | JS test in `test/javascript/` |
| User-facing UI flow | `test/system/<feature>_test.rb` (Capybara) |

Use Minitest (`ActiveSupport::TestCase`) for unit/integration tests.
Use `ApplicationSystemTestCase` (Capybara + Selenium) for system tests.
Always use fixtures or FactoryBot-compatible helpers — no hardcoded data in tests.

### Turbo / Hotwire

- Wrap partials in `<turbo-frame id="...">` when they will be refreshed independently.
- Use `turbo_stream` responses (`.turbo_stream.erb`) for multi-element updates.
- Avoid full-page reloads when a Turbo solution exists.

### Stimulus JS

- New controllers live in `app/javascript/controllers/<name>_controller.js`.
- Register them via the auto-loader in `app/javascript/controllers/index.js`.
- Use `data-controller`, `data-action`, and `data-<controller>-<value>-value` attributes only.

### Tailwind CSS

- Use utility classes inline in ERB — no inline `style=""` attributes.
- Mobile-first: apply base styles without a prefix; use `sm:`, `md:`, `lg:` for breakpoints.
- Extract to `@apply` in `application.tailwind.css` only for heavily reused component patterns.

### Solid Queue jobs

- Subclass `ApplicationJob`; place in `app/jobs/`.
- Jobs must be **idempotent**.
- Add `retry_on` / `discard_on` with appropriate error classes.
- Always pair with a `test/jobs/<name>_job_test.rb`.

### Security

- Always use `strong_parameters` (`params.require(...).permit(...)`).
- Escape user-supplied output with Rails helpers (`html_escape`, `sanitize`).
- Do not suggest committing credentials; use Rails credentials or ENV vars.

### Style

- 2-space indentation, no trailing whitespace.
- Follow standard Ruby naming: `snake_case` for methods/variables, `CamelCase` for classes.
- Prefer explicit `return` only when needed for early exit; otherwise let implicit return work.

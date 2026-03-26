# Pwalker.me — AI Agent Instructions

> **Single source of truth** for all AI coding agents.
> This file is read by **GitHub Copilot** (via `.github/copilot-instructions.md`),
> **Gemini Code Assist** (via `.gemini/styleguide.md`), **OpenAI Codex**, and any other
> agent that follows the `AGENTS.md` convention.  The tool-specific files in
> `.github/` and `.gemini/` simply point here — all guidelines live in this file.

---

## Project overview

**Pwalker.me** is a personal website / blog built with **Ruby on Rails 8**.

### Design system reference

- The canonical visual and responsive design reference is `STYLEGUIDE.md`.
- For UI, layout, and responsive behavior changes, align implementation with `STYLEGUIDE.md`.

### Core technology stack

| Layer | Technology |
|-------|-----------|
| Server framework | Rails 8 (Ruby) |
| Background jobs | Solid Queue (built-in Rails 8 adapter) |
| Frontend reactivity | Hotwire: **Turbo** (Turbo Drive, Turbo Frames, Turbo Streams) + **Stimulus JS** |
| CSS | **Tailwind CSS** (via `tailwindcss-rails` gem) |
| Database | SQLite (development / test) — PostgreSQL (production) |
| Testing | Minitest (Rails default), with fixtures and system tests via Capybara / Selenium |

---

## Rails best practices — mandatory for every change

1. **Follow the Rails Way.**  Use conventions: RESTful routes, thin controllers, fat-free
   models (move business logic to service objects / concerns when models grow large),
   and Rails helpers/partials for views.

2. **Tests are not optional.**  Every new feature, bug-fix, or refactor **must** include
   corresponding tests.  At minimum:
   - A **model test** (`test/models/`) for any new or changed model logic.
   - A **controller / request test** (`test/controllers/` or `test/requests/`) for every
     new or changed route/action.
   - An **integration / system test** (`test/system/`) for any user-facing behaviour,
     especially anything involving Turbo or Stimulus.
   - A **job test** (`test/jobs/`) for every new or changed Solid Queue job.
   - Run the full test suite with `bin/rails test && bin/rails test:system` before submitting.

3. **Do not break existing tests.**  Run `bin/rails test` after every completed feature or update.

4. **Keep controllers thin.**  Business logic belongs in models, service objects
   (`app/services/`), or jobs — not in controllers or views.

5. **Avoid N+1 queries.**  Use `includes`, `preload`, or `eager_load` where appropriate.
   Add a Bullet gem note if relevant.

6. **Security first.**
   - Use `strong_parameters` in every controller.
   - Never store secrets in the codebase — use Rails credentials (`bin/rails credentials:edit`)
     or environment variables via `.env` (not committed).
   - Sanitise all user input; prefer `html_escape` / `sanitize` helpers in views.
   - Use `protect_from_forgery with: :exception` (default) for HTML forms.

7. **Database migrations.**
   - Always add indexes for foreign keys and columns used in `WHERE` / `ORDER BY`.
   - Make migrations reversible (`change` method or explicit `up`/`down`).
   - Never modify existing migrations — create new ones.

8. **Code style.**
   - Follow the [Ruby Style Guide](https://rubystyle.guide/).
   - Run `bin/rubocop` (if configured) before committing.
   - Use 2-space indentation; no trailing whitespace.

---

## Hotwire / Turbo guidelines

- Prefer **Turbo Frames** for partial page updates scoped to a DOM region.
- Prefer **Turbo Streams** (via ActionCable or standard redirects) for
  multi-element or cross-frame updates.
- Keep **Turbo Drive** enabled by default; opt-out individual links/forms only
  when truly necessary (`data-turbo="false"`).
- Test Turbo interactions with system tests; assert on the DOM state *after* the
  stream/frame update completes.

---

## Stimulus JS guidelines

- One controller per distinct behaviour; name files `app/javascript/controllers/<name>_controller.js`.
- Register controllers via the auto-loader in `app/javascript/controllers/index.js`.
- Use `data-controller`, `data-action`, and `data-<controller>-<value>-value` HTML
  attributes — no jQuery-style DOM querying.
- Keep Stimulus controllers small; heavy logic belongs in server-side code delivered
  via Turbo.
- Add JavaScript unit tests for Stimulus controllers where behaviour is non-trivial.

---

## Tailwind CSS guidelines

- Use utility classes directly in ERB/HTML; avoid writing custom CSS unless absolutely
  necessary.
- Extract repeated utility combinations into Tailwind `@apply` rules in
  `app/assets/stylesheets/application.tailwind.css` only when a component is reused
  many times.
- Follow a mobile-first approach; use responsive prefixes (`sm:`, `md:`, `lg:`, `xl:`).
- Do not purge classes dynamically generated at runtime (use `safelist` in
  `tailwind.config.js` if needed).

---

## Solid Queue guidelines

- Define jobs in `app/jobs/` as subclasses of `ApplicationJob`.
- Keep jobs idempotent: running the same job twice should not cause side effects.
- Handle errors with `rescue_from` and configure retry behaviour via
  `retry_on` / `discard_on` as appropriate.
- Write a `test/jobs/<name>_job_test.rb` for every job class.
- For queue configuration, edit `config/solid_queue.yml`; document any new queues
  in this file under the "Queue definitions" section.

---

## Running the application locally

```bash
# Install dependencies
bundle install
yarn install

# Set up the database
bin/rails db:setup

# Start the dev server (Solid Queue is started automatically in development)
bin/dev
```

---

## Running tests

```bash
# All unit + integration tests
bin/rails test

# System tests (requires a browser driver)
bin/rails test:system

# Everything
bin/rails test && bin/rails test:system
```

---

## File / directory conventions

```
app/
  controllers/          # Thin controllers only
  jobs/                 # Solid Queue jobs (ApplicationJob subclasses)
  models/               # ActiveRecord models + service objects
  services/             # Plain Ruby service objects
  javascript/
    controllers/        # Stimulus controllers
  views/                # ERB templates using Turbo Frames/Streams
  assets/
    stylesheets/        # application.tailwind.css

config/
  solid_queue.yml       # Solid Queue configuration
  routes.rb             # RESTful routes

test/
  models/
  controllers/
  requests/
  jobs/
  system/               # Capybara system tests
  fixtures/
```

---

## Pull-request checklist

Before marking a PR ready for review, confirm:

- [ ] All new code has corresponding tests.
- [ ] `bin/rails test && bin/rails test:system` passes with no failures.
- [ ] No N+1 queries introduced (verify with logs or Bullet).
- [ ] Migrations are reversible and include appropriate indexes.
- [ ] No secrets committed to source control.
- [ ] Tailwind classes are utility-first; no unnecessary custom CSS added.
- [ ] Stimulus controllers are registered in `index.js`.
- [ ] Solid Queue jobs are idempotent and have retry logic.

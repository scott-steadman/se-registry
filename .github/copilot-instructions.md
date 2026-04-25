```md
# Copilot instructions for se-registry

Most application code lives in `ruby/rails`. Run repository commands from that directory unless a task explicitly targets the repo root.

## Build, test, and lint commands

```bash
cd ruby/rails
bin/setup --skip-server
```

`bin/setup` installs gems, runs `bin/rails db:prepare`, and clears logs/tmp. `config/database.yml` pulls its connection URL from Rails credentials unless `DATABASE_URL` is set; CI uses `DATABASE_URL=postgres://postgres:postgres@localhost:5432`.

```bash
cd ruby/rails
bin/dev
# or
bin/rails server -b 0.0.0.0
```

```bash
cd ruby/rails
bin/rubocop
bin/brakeman --no-pager
bin/importmap audit
```

```bash
cd ruby/rails
RAILS_ENV=test DATABASE_URL=postgres://postgres:postgres@localhost:5432 bin/rails db:test:prepare test test:system
```

Run a single test file:

```bash
cd ruby/rails
RAILS_ENV=test DATABASE_URL=postgres://postgres:postgres@localhost:5432 bin/rails test test/models/user_test.rb
```

Run a single test by line:

```bash
cd ruby/rails
RAILS_ENV=test DATABASE_URL=postgres://postgres:postgres@localhost:5432 bin/rails test test/models/user_test.rb:5
```

Coverage and test-email tasks are custom rake tasks:

```bash
cd ruby/rails
bin/rails test:coverage
TO=user@example.com bin/rails test:emails
```

System tests use Selenium with headless Chrome (`test/application_system_test_case.rb`), so browser-capable environments need Chrome available.

## High-level architecture

This repository currently contains one Rails 8 app in `ruby/rails`. It uses PostgreSQL, Importmap/Turbo, Action Cable, Authlogic, acts-as-taggable-on, and Minitest.

The main domain model is:

- `User` owns `gifts` and `events`.
- `Friendship` is a self-referential join on the `friends` table that connects users to other users.
- `Giving` joins users to gifts through the `givings` table and tracks gifting intent.
- `Event` uses real STI through `events.event_type`, with `Occasion` and `Reminder` as subclasses.

Routing has two layers: top-level routes (`/gifts`, `/friends`, `/events`, etc.) operate on the current user, while nested `/users/:user_id/...` routes let admins inspect or manage another user’s data. `ApplicationController#page_user` is the gatekeeper here: non-admins are forced back to `current_user`.

Authentication is handled by Authlogic through `UserSession` and `ApplicationController#user_session` / `#current_user`. Action Cable presence also depends on Authlogic session state: `ApplicationCable::Connection` reads the session key `user/for_authentication_credentials_id`, and `PresenceChannel` subscribes the current user to friend presence broadcasts.

Views are versioned. `ApplicationController#add_ui_version_to_view_path` prepends `app/views/v2` when `ui_version` is set or the current user has one; login and registration explicitly opt into v2. `ApplicationHelper` also expands `stylesheet_link_tag :v2` and `javascript_include_tag :v2` into all v2 asset files.

Background/domain maintenance is mostly implemented as jobs and rake tasks:

- `Presence::AppearJob` / `Presence::DisappearJob` broadcast friend online/offline events.
- `UserNotifier` and `lib/tasks/registry.rake` send reminder and occasion emails.
- `Event::ForExpiration` plus `registry:update_events` advance recurring events or delete expired non-recurring ones.

## Key conventions

`User` and `Gift` intentionally disable STI with `inheritance_column = :_type_disabled`, but the app still uses subclass wrappers such as `User::ForAuthentication`, `User::ForNotifying`, `User::ForPresence`, and `Gift::ForGiving`. When code needs specialized behavior, it usually casts records with `becomes(...)` instead of changing table inheritance. `Event` is the exception: it does use STI.

Preserve the custom `model_name` overrides on `User` and `Gift`. They exist so forms, route helpers, and polymorphic behavior continue to use the base resource names even when a record has been cast with `becomes(...)`.

Gift visibility is stored in the `gifts.visibility` text column, using values like `secret` and `hidden`. The controller logic is asymmetric on purpose:

- owners do **not** see `secret` gifts in their own index
- other viewers do **not** see `hidden` gifts

Creating a gift for another user forces `visibility = 'secret'` and automatically adds the creator as a giver.

Tagging is done through acts-as-taggable-on. `Gift#tag_names=` splits on commas or whitespace, and `Gift#urls` / `#urls=` map between a single stored `url` string and multiple links in the UI.

Controller tests and model tests rely heavily on helper constructors in `test/test_helper.rb` (`create_user`, `create_gift`, `create_event`, `login_as`, etc.) instead of fixtures for setup. Minitest parallelization is enabled globally there, and Mocha is available for expectations/stubs.

If you touch the v2 front end, follow the BEMIT/ITCSS naming and file-organization rules documented in `app/assets/stylesheets/v2/README.md`.
```


# How to recreate the app

1. Create a branch so you can diff and back out cleanly.
2. From `ruby/`, rename `rails` to `rails-old`.
3. Create a clean gemset for bootstrapping Rails and install the target Rails version there.
4. Generate a fresh app from `ruby/`:
   `rails _8.1.3_ new registry --database=postgresql --skip-bundle --skip-keeps --skip-git`
5. Rename `registry` to `rails`.
6. Restore repo-specific files that are not part of fresh Rails boilerplate, including:
   `.bash_history` (if you want to preserve it), `.bundle`, `.gitattributes`, `.gitignore`,
   `.rubocop.yml`, the `.ruby-version` symlink, `.vscode`, `AGENTS.md`, `README.md`,
   `agent-docs`, credentials, and other app-specific source, tests, assets, tasks, and scripts.
7. Recreate keep files Rails skipped: `touch rails/vendor/.keep rails/log/.keep`.
8. Restore missing files first, then resolve the remaining diffs in files that Rails also generated
   such as `Gemfile`, `Dockerfile`, `config/application.rb`, `config/environments/*`,
   `config/routes.rb`, and layout/controller helpers.
9. Prefer the new Rails boilerplate where possible, then re-apply registry-specific behavior.
10. Run setup, lint, and tests.
11. Have a human review the diff.
12. Remove `rails-old` once you no longer need it.
13. Commit, merge, push, and remove the temporary gemset.

## Why

To ensure that rails files we haven't touched are up to date,
and to remove cruft that accumulates with each upgrade.

## Resolving diffs

Try to keep the new rails boilerplate and put
app-specific updates after the boilerplate if possible.

Do not use `bundle exec rails new` after moving `rails` out of the way. Once the app directory has
been renamed, there is no app `Gemfile` left to execute against, so use the installed `rails`
executable from the clean bootstrap gemset instead.

## Example

```sh
git switch -c recreate-app

cd ruby
mv rails rails-old

rbenv gemset init new-rails
gem install rails -v 8.1.3
rails _8.1.3_ new registry --database=postgresql --skip-bundle --skip-keeps --skip-git
mv registry rails

mkdir -p rails/.bundle rails/.vscode rails/config/credentials
cp -p rails-old/.bash_history rails/.bash_history
cp -p rails-old/.bundle/config rails/.bundle/
cp -p rails-old/.gitattributes rails/.gitignore rails-old/.rubocop.yml rails/
ln -s "$(readlink rails-old/.ruby-version)" rails/.ruby-version
cp -pr rails-old/.vscode/. rails/.vscode/
cp -pr rails-old/agent-docs rails/
cp -p rails-old/AGENTS.md rails-old/README.md rails/
cp -pr rails-old/config/credentials/. rails/config/credentials/
cp -p rails-old/config/master.key rails/config/master.key
touch rails/vendor/.keep rails/log/.keep

rsync -a --ignore-existing \
  --exclude='.bash_history' \
  --exclude='log/*' \
  --exclude='tmp/***' \
  --exclude='vendor/bundle/***' \
  --exclude='public/coverage/***' \
  rails-old/ rails/

# resolve remaining diffs by hand

cd rails
bundle config set --local clean 'true'
bundle config set --local path 'vendor/bundle'
bundle install
bin/setup --skip-server
bin/rubocop
bin/brakeman --no-pager
bin/importmap audit
RAILS_ENV=test DATABASE_URL=postgres://postgres:postgres@localhost:5432 bin/rails db:test:prepare test test:system
```

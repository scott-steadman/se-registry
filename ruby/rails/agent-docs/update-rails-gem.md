# How to upgrade the rails gem in place

- create a branch so we can revert to master if things go awry
- update the rails version in the Gemfile
- remove Gemfile.lock
- run bundle install
- run bundle exec app:update
- resolve diffs
- run bundle exec rails test
- fix warnings, deprecations, and broken tests
- have human review code
- commit changes
- merge into master
- git push master
- delete branch

## Resolving diffs

Try to keep the new rails boilerplate and put
app-specific updates after the boilerplate if possible.

## Example

  ```sh
  git co -b update_rails

  # Update the rails line in Gemfile

  rm Gemfile.lock
  bundle install

  bundle exec rails app:update

  # resolve diffs

  bundle exec rails test

  git add -p
  git commit -v
  git co master
  git merge update_rails
  git push
  git branch -d update_rails
  ```

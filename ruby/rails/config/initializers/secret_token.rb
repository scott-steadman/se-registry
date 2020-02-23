# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Registry::Application.config.secret_key_base = ENV['SECRET_TOKEN'] || '0085940ca99e266b89dbb0854e2a8dc8fda0c6246b6f024a6bbc71a190b62fc8bf5c6655fdf9332c91b8626d17c7a41c151f46755fff7f149cdd3be384b5751e'

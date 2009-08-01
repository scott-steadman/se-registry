if defined?(ExceptionNotifier)
  ExceptionNotifier.exception_recipients = %w(gifts-exceptions@stdmn.com)
  ExceptionNotifier.sender_address = %w(gift-error@stdmn.com)
end

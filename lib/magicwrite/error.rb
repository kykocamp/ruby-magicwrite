module MagicWrite
  class Error < StandardError
    class BadRequest < Error; end
    class Unauthorized < Error; end
    class PaymentRequired < Error; end
    class Forbidden < Error; end
    class NotFound < Error; end
    class MethodNotAllowed < Error; end
    class RequestTimeout < Error; end
    class Conflict < Error; end
    class UnprocessableEntity < Error; end
    class TooManyRequests < Error; end
    class InternalServerError < Error; end
    class NotImplemented < Error; end
    class BadGateway < Error; end
    class ServiceUnavailable < Error; end
    class GatewayTimeout < Error; end
    class UnknownError < Error; end
  end
end

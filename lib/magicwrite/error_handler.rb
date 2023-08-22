module MagicWrite
  class ErrorHandler
    HTTP_CODE = {
      400 => MagicWrite::Error::BadRequest,
      401 => MagicWrite::Error::Unauthorized,
      402 => MagicWrite::Error::PaymentRequired,
      403 => MagicWrite::Error::Forbidden,
      404 => MagicWrite::Error::NotFound,
      405 => MagicWrite::Error::MethodNotAllowed,
      408 => MagicWrite::Error::RequestTimeout,
      409 => MagicWrite::Error::Conflict,
      422 => MagicWrite::Error::UnprocessableEntity,
      429 => MagicWrite::Error::TooManyRequests,
      500 => MagicWrite::Error::InternalServerError,
      501 => MagicWrite::Error::NotImplemented,
      502 => MagicWrite::Error::BadGateway,
      503 => MagicWrite::Error::ServiceUnavailable,
      504 => MagicWrite::Error::GatewayTimeout
    }.freeze

    def initialize(response)
      @response = response
      @status = response.status
    end

    def raise_error
      raise error_class, response.reason_phrase
    end

    private

    attr_reader :response, :status

    def error_class
      HTTP_CODE[status] || MagicWrite::Error::UnknownError
    end
  end
end

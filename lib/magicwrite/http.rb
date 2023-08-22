module MagicWrite
  module HTTP
    def get(path:, parameters: {})
      build_response(conn.get(uri(path: path)) do |request|
        request.headers = headers
        request.body = parameters.to_json
      end)
    end

    def json_post(path:, parameters:)
      build_response(conn.post(uri(path: path)) do |request|
        if parameters[:stream].respond_to?(:call)
          request.options.on_data = to_json_stream(user_proc: parameters[:stream])
          parameters[:stream] = true
        elsif parameters[:stream]
          raise ArgumentError, 'The stream parameter must be a Proc or have a #call method'
        end

        request.headers = headers
        request.body = parameters.to_json
      end)
    end

    def json_put(path:, parameters:)
      build_response(conn.put(uri(path: path)) do |request|
        if parameters[:stream].respond_to?(:call)
          request.options.on_data = to_json_stream(user_proc: parameters[:stream])
          parameters[:stream] = true
        elsif parameters[:stream]
          raise ArgumentError, 'The stream parameter must be a Proc or have a #call method'
        end

        request.headers = headers
        request.body = parameters.to_json
      end)
    end

    def multipart_post(path:, parameters: nil)
      build_response(conn(multipart: true).post(uri(path: path)) do |request|
        request.headers = headers.merge({ 'Content-Type' => 'multipart/form-data' })
        request.body = multipart_parameters(parameters)
      end)
    end

    def delete(path:)
      build_response(conn.delete(uri(path: path)) do |request|
        request.headers = headers
      end)
    end

    private

    def build_response(response)
      return parsed_response(response) if response.status.between?(200, 299)

      MagicWrite::ErrorHandler.new(response).raise_error
    end

    def parsed_response(response)
      return unless response

      to_json(response.body)
    end

    def to_json(string)
      return unless string

      JSON.parse(string)
    rescue JSON::ParserError
      JSON.parse(string.gsub("}\n{", '},{').prepend('[').concat(']'))
    end

    def to_json_stream(user_proc:)
      proc do |chunk, _|
        chunk.scan(/(?:data|error): (\{.*\})/i).flatten.each do |data|
          user_proc.call(JSON.parse(data))
        rescue JSON::ParserError
          # Ignore invalid JSON.
        end
      end
    end

    def conn(multipart: false)
      Faraday.new do |faraday|
        faraday.options[:timeout] = MagicWrite.configuration.request_timeout
        faraday.request(:multipart) if multipart
      end
    end

    def uri(path:)
      File.join(MagicWrite.configuration.uri_base, path)
    end

    def headers
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{MagicWrite.configuration.access_token}"
      }
    end

    def multipart_parameters(parameters)
      parameters&.transform_values do |value|
        next value unless value.is_a?(File)

        Faraday::UploadIO.new(value, '', value.path)
      end
    end
  end
end

module MagicWrite
  module HTTP
    def get(path:, parameters: {})
      to_json(conn.get(uri(path: path)) do |req|
        req.headers = headers
        req.body = parameters.to_json
      end&.body)
    end

    def json_post(path:, parameters:)
      to_json(conn.post(uri(path: path)) do |req|
        if parameters[:stream].respond_to?(:call)
          req.options.on_data = to_json_stream(user_proc: parameters[:stream])
          parameters[:stream] = true
        elsif parameters[:stream]
          raise ArgumentError, 'The stream parameter must be a Proc or have a #call method'
        end

        req.headers = headers
        req.body = parameters.to_json
      end&.body)
    end

    def json_put(path:, parameters:)
      to_json(conn.put(uri(path: path)) do |req|
        if parameters[:stream].respond_to?(:call)
          req.options.on_data = to_json_stream(user_proc: parameters[:stream])
          parameters[:stream] = true
        elsif parameters[:stream]
          raise ArgumentError, 'The stream parameter must be a Proc or have a #call method'
        end

        req.headers = headers
        req.body = parameters.to_json
      end&.body)
    end

    def multipart_post(path:, parameters: nil)
      to_json(conn(multipart: true).post(uri(path: path)) do |req|
        req.headers = headers.merge({ 'Content-Type' => 'multipart/form-data' })
        req.body = multipart_parameters(parameters)
      end&.body)
    end

    def delete(path:)
      to_json(conn.delete(uri(path: path)) do |req|
        req.headers = headers
      end&.body)
    end

    private

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
      Faraday.new do |f|
        f.options[:timeout] = MagicWrite.configuration.request_timeout
        f.request(:multipart) if multipart
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

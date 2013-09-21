# encoding: utf-8
# Something removed Something added
# Origin https://github.com/rascov/PlurkOAuth
require 'oauth'
require 'json'

class Plurk
    def initialize(key, secret)
        @key, @secret = key, secret
        @consumer = OAuth::Consumer.new(@key, @secret, {
            :site               => 'http://www.plurk.com',
            :scheme             => :header,
            :http_method        => :post,
            :request_token_path => '/OAuth/request_token',
            :access_token_path  => '/OAuth/access_token',
            :authorize_path     => '/OAuth/authorize'
        })
    end
    # output: authorize url
    def get_authorize_url
        @request_token = @consumer.get_request_token
        return @request_token.authorize_url
    end

    # case 1: has access token already
    # input: access token, access token secret
    # case 2: no access token, auth need
    # input: verification code    
    def authorize(key, secret=nil)
        @access_token = case secret
                                           when nil then
                                             @request_token.get_access_token :oauth_verifier=>key
                                           else
                                             OAuth::AccessToken.new(@consumer, key, secret)
                                        end
        return @access_token
    end

    # input: plurk APP url, options in hash
    # output: result in JSON
    def req(url, body=nil, headers=nil)
        # For those APIs which does not need to be authorized (e.g. /APP/Profile/getPublicProfile)
        @access_token = OAuth::AccessToken.new(@consumer, nil, nil) if @access_token==nil
        resp = @access_token.post(url, body, headers).body
        return JSON.parse(resp)
    end
    
    def post(content ,qualifier = ":" ,lang = "tr_ch")
        @content, @qualifierualifier, @lang = content, qualifier, lang
        $log.logger ("posted a message \"%s\"" % [@content])
        json = $plurk.req('/APP/Timeline/plurkAdd',{:content=>@content, :qualifier=>@qualifier, :lang=>@lang},)
    end
    
    def res( id, content, qualifier = ":" )
        @id, @content, @qualifier = id, content, qualifier
        $plurk.req('/APP/Responses/responseAdd',{:id=>@id, :content=>@content, :qualifier=>@qualifier},)
    end
end

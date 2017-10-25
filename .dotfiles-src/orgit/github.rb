require 'net/http'
require 'json'
require 'base64'

class Orgit
  class Github
    class Repo
      attr_reader :name, :default_branch, :sha, :pushed_at
      def initialize(name, default_branch, sha, pushed_at)
        @name = name
        @default_branch = default_branch
        @sha = sha
        @pushed_at = pushed_at
      end
    end

    def initialize(token)
      @token = token
    end

    def repos
      rs = []
      STDERR.print("\x1b[1;3;34m%\x1b[0;3m retrieving repository list...")
      Net::HTTP.start('meta-cache.shopifycloud.com', 443, use_ssl: true) do |http|
        req = Net::HTTP::Get.new('/world')
        req['Authorization'] = "bearer #{@token}"
        res = http.request(req)
        raise unless res.code.to_i == 200
        JSON.parse(res.body).each do |data|
          rs << Repo.new(
            *data.values_at('name', 'default_branch_name', 'default_branch_sha', 'pushed_at')
          )
        end
      end
      STDERR.puts(" done!\x1b[0m")
      rs
    end
  end
end

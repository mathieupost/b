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
      STDERR.print('retrieving repository list...')
      Net::HTTP.start('api.github.com', 443, use_ssl: true) do |http|
        cursor = nil
        loop do
          new_repos, cursor = get_after(http, cursor)
          break if cursor.nil?
          rs.concat(new_repos)
          STDERR.print('.')
        end
      end
      STDERR.puts(' done!')
      rs
    end

    private

    def get_after(http, after)
      res = http.post('/graphql', query_data(after), auth_header)
      raise res.inspect unless res.code.to_i == 200
      data = parse_response(res.body)
    end

    def parse_response(data)
      edges = JSON.parse(data)
        .fetch('data')
        .fetch('viewer')
        .fetch('organization')
        .fetch('repositories')
        .fetch('edges')

      return [], nil if edges.empty?

      cursor = edges.last.fetch('cursor')
      repo_data = edges.map { |e| e.fetch('node') }
      repos = repo_data.map do |repo|
        name = repo.fetch('name')
        dbr = repo.fetch('defaultBranchRef')
        # can be nil if empty repo
        default_branch = dbr ? dbr.fetch('name') : 'master'
        pushed_at = Time.parse(repo.fetch('pushedAt'))
        sha = if dbr
          sha64 = dbr
            .fetch('target')
            .fetch('id')
          Base64.decode64(sha64).split(':').last
        else
          nil
        end
        Repo.new(name, default_branch, sha, pushed_at)
      end
      [repos, cursor]
    rescue KeyError, NoMethodError
      STDERR.puts(data)
      raise
    end

    def auth_header
      { 'Authorization' => "bearer #{@token}" }
    end

    def query_data(after)
      { 'query' => format_query(after) }.to_json
    end

    def format_query(after)
      args = "first: 100"
      args << ", after: \"#{after}\"" if after
      <<~GRAPHQL
        query {
          viewer {
            organization(login: "Shopify") {
              repositories(#{args}) {
                edges {
                  cursor
                  node {
                    pushedAt
                    name
                    defaultBranchRef {
                      name
                      target {
                        id
                      }
                    }
                  }
                }
              }
            }
          }
        }
      GRAPHQL
    end
  end
end

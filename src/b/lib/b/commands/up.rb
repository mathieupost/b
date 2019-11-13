# frozen_string_literal: true
require('b')
require('open3')

module B
  module Commands
    class Up < B::Command
      B_DIR = '/b'

      def self.help
        "fetch the latest version of the repo and run darwin-rebuild or nixos-rebuild as appropriate"
      end

      def call(_args, _name)
        if dirty?
          warn("can't update #{B_DIR} because it is not clean; using current state")
        else
          checkout_master
          pull_master
          update_submodules
        end

        if mac?
          darwin_rebuild
        else
          nixos_rebuild
        end
      end

      private

      def mac?
        RUBY_PLATFORM =~ /darwin/
      end

      def dirty?
        _, err, stat = Open3.capture3('git', '-C', B_DIR, 'diff', '--quiet')
        return false if stat.success?
        return true if err.strip.empty?
        bail("git diff failed: #{err}")
      end

      def checkout_master
        oe, stat = Open3.capture2e('git', '-C', B_DIR, 'checkout', 'master')
        bail("git checkout failed: #{oe}") unless stat.success?
      end

      def pull_master
        oe, stat = Open3.capture2e('git', '-C', B_DIR, 'pull', 'origin', 'master')
        bail("git pull failed: #{oe}") unless stat.success?
      end

      def update_submodules
        oe, stat = Open3.capture2e('git', '-C', B_DIR, 'submodule', 'update', '--init')
        bail("git submodule update failed: #{oe}") unless stat.success?
      end

      def darwin_rebuild
        exec('darwin-rebuild', 'switch')
      end

      def nixos_rebuild
        exec('sudo', 'nixos-rebuild', 'switch')
      end

      def bail(msg)
        abort("\x1b[1;31m#{msg}\x1b[0m")
      end

      def warn(msg)
        STDERR.puts("\x1b[1;33m#{msg}\x1b[0m")
      end
    end
  end
end

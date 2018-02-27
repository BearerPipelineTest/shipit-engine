module Shipit
  class DeploySpec
    module RubygemsDiscovery
      def discover_deploy_steps
        discover_gem || super
      end

      def discover_gem
        publish_gem if gem?
      end

      def discover_review_checklist
        discover_gem_checklist || super
      end

      def discover_gem_checklist
        if gem?
          [%(<strong>Don't forget to add a tag before deploying!</strong> You can do this with:
            git tag v<strong>x.y.z</strong> && git push --tags)]
        end
      end

      def gem?
        !!gemspec
      end

      def gemspec
        Dir[file('*.gemspec').to_s].first
      end

      def publish_gem
        ["assert-gem-version-tag #{gemspec}", 'bundle exec rake release']
      end
    end
  end
end

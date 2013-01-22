require 'sprockets/helpers/rails_helper'

module Sprockets
  module Helpers
    module RailsHelper
      def javascript_include_tag_with_enforced_precompile(*sources)
        sources_without_options(sources).each do |source|
          ensure_asset_will_be_precompiled!(source, 'js') if enforce_precompile?
        end
        javascript_include_tag_without_enforced_precompile(*sources)
      end
      alias_method_chain :javascript_include_tag, :enforced_precompile

      def stylesheet_link_tag_with_enforced_precompile(*sources)
        sources_without_options(sources).each do |source|
          ensure_asset_will_be_precompiled!(source, 'css') if enforce_precompile?
        end
        stylesheet_link_tag_without_enforced_precompile(*sources)
      end
      alias_method_chain :stylesheet_link_tag, :enforced_precompile


      private

      def sources_without_options(sources)
        sources.last.is_a?(Hash) && sources.last.extractable_options? ? sources[0..-2] : sources
      end

      def enforce_precompile?
        Rails.application.config.assets.enforce_precompile
      end

      def ensure_asset_will_be_precompiled!(source, ext)
        return if asset_paths.is_uri?(source)
        asset_file = asset_environment.resolve(asset_paths.rewrite_extension(source, nil, ext))
        unless asset_environment.send(:logical_path_for_filename, asset_file, Rails.application.config.assets.precompile)
          raise AssetPaths::AssetNotPrecompiledError.new("#{asset_file} must be added to config.assets.precompile, " <<
                                                         "otherwise it won't be precompiled for production!")
        end
      end
      
    end
  end
end

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
        enforce_precompile = Rails.application.config.assets.enforce_precompile

        if enforce_precompile.is_a? Proc
          enforce_precompile.call
        else
          enforce_precompile
        end
      end

      def asset_list
        ignored = Rails.application.config.assets.ignore_for_precompile || []
        precompile = Rails.application.config.assets.precompile || []
        precompile + ignored
      end

      def ensure_asset_will_be_precompiled!(source, ext)
        source = source.to_s
        return if asset_paths.is_uri?(source)
        asset_file = asset_environment.resolve(asset_paths.rewrite_extension(source, nil, ext))
        unless asset_environment.send(:logical_path_for_filename, asset_file, asset_list)

          # Allow user to define a custom error message
          error_message_proc = Rails.application.config.assets.precompile_error_message_proc

          error_message = if error_message_proc
            error_message_proc.call(asset_file)
          else
            "#{File.basename(asset_file)} must be added to config.assets.precompile, otherwise it won't be precompiled for production!"
          end

          raise AssetPaths::AssetNotPrecompiledError.new(error_message)
        end
      end
    end
  end
end

# frozen_string_literal: true

require_relative "superlink/version"
require "uri-builder"
require "active_support/concern"
require "active_support/core_ext/module/delegation"

module Superlink
  class Error < StandardError; end

  class Builder < URI::Builder::DSL
    attr_reader :model

    def join(*segments)
      super(*route(*segments))
    end

    def format(format)
      @format = format
      self
    end

    def clear_format
      @format = nil
      self
    end

    def uri
      super.clone.tap do |uri|
        uri.path = "#{uri.path}.#{@format}" if @format
        # Check if the route exists in the routes.rb file
        unless Rails.application.routes.recognize_path(uri.path)
          raise ActionController::UrlGenerationError, "No route matches [#{uri.path}]"
        end
      end
    end

    def self.parse(...)
      new URI(...)
    end

    def initialize_copy(original)
      super
      @uri = original.uri
    end

    protected

    def route(*segments)
      segments.flat_map do |it|
        if it.respond_to?(:to_model)
          @model = it.to_model
          [it.model_name.route_key, it.to_param]
        elsif it.respond_to?(:model_name)
          it.model_name.route_key
        elsif it.respond_to?(:to_param)
          it.to_param
        else
          it.to_s
        end
      end
    end
  end

  module Helpers
    extend ActiveSupport::Concern

    included do
      helper_method :url, :path
    end

    def url(...)
      @url ||= Builder.parse(request.url)
      @url.clone.join(...)
    end

    def path
      url.path
    end
  end

  module Phlex
    delegate :url, to: :helpers

    def xlink_to(target, *segments, **, &content)
      if target.nil? and segments.empty?
        return # Render nothing if we link to nothing
      elsif target.is_a? URI::Builder::DSL and segments.empty?
        builder = target
        url = builder.uri
        model = builder.model
        href = helpers.request.host == url.host ? url.path : url.to_s

        a(href:, **) {
          if content&.lambda? and model
            render content.call model
          elsif content
            render content
          else
            render url.to_s
          end
        }
      else
        xlink_to(helpers.url.join(target, *segments), **, &content)
      end
    end
    alias :xshow :xlink_to

    def xedit(*segments, **, &content)
      xlink_to(*segments.push(:edit), **, &content)
    end

    def xcreate(*segments, **, &content)
      xlink_to(*segments.push(:new), **, &content)
    end

    def xdestroy(*segments, confirm: "Are you sure?", **, &content)
      xlink_to(*segments, data_turbo: { method: :delete, confirm: }, **, &content)
    end
  end
end

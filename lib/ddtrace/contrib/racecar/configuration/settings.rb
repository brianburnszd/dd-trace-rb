require 'ddtrace/contrib/configuration/settings'
require 'ddtrace/contrib/racecar/ext'

module Datadog
  module Contrib
    module Racecar
      module Configuration
        # Custom settings for the Racecar integration
        class Settings < Contrib::Configuration::Settings
          option  :analytics_enabled,
                  default: -> { env_to_bool(Ext::ENV_ANALYTICS_ENABLED, false) },
                  lazy: true

          option  :analytics_sample_rate,
                  default: -> { env_to_float(Ext::ENV_ANALYTICS_SAMPLE_RATE, 1.0) },
                  lazy: true

          option :service_name, default: Ext::SERVICE_NAME
          option :tracer, default: Datadog.tracer do |value|
            (value || Datadog.tracer).tap do |v|
              # Make sure to update tracers of all subscriptions
              Events.subscriptions.each do |subscription|
                subscription.tracer = v
              end
            end
          end
        end
      end
    end
  end
end

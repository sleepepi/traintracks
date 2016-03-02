# frozen_string_literal: true

module TrainingGrant
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 12
    TINY = 5
    BUILD = 'pre' # nil, 'pre', 'beta1', 'beta2', 'rc', 'rc2'

    STRING = [MAJOR, MINOR, TINY, BUILD].compact.join('.').freeze
  end
end

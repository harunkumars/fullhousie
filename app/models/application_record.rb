class ApplicationRecord < ActiveRecord::Base
  include RichEnums
  self.abstract_class = true
end

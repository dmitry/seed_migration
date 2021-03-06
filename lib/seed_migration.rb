require "seed_migration/version"
require "seed_migration/engine"

module SeedMigration
  autoload :Migrator, "seed_migration/migrator" # Is it needed ?
  autoload :Migration, "seed_migration/migration"
  autoload :RegisterEntry, "seed_migration/register_entry"

  @@registrar = Set.new
  mattr_accessor :registrar

  class << self
    def register(model, &block)
      unregister model
      entry = RegisterEntry.new(model)
      entry.instance_eval &block if block_given?

      self.registrar << entry
    end

    def unregister(model)
      self.registrar.delete_if { |entry| entry.model == model }
    end
  end
end

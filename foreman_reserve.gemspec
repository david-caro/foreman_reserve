# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "foreman_reserve"
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joseph Mitchell Magen", "David Caro"]
  s.date = "2013-02-05"
  s.description = "Plugin engine for Foreman to reserve a host"
  s.email = "jmagen@redhat.com"
  s.extra_rdoc_files = ["LICENSE.txt", "README.rdoc"]
  s.files = [".document", "Gemfile", "Gemfile.lock", "LICENSE.txt",
             "README.rdoc", "Rakefile", "VERSION",
             "app/controllers/foreman_reserve/api/hosts_controller.rb",
             "app/models/foreman_reserve/host_extensions.rb",
             "config/routes.rb", "foreman_reserve.gemspec",
             "lib/foreman_reserve/engine.rb", "lib/foreman_reserve.rb",
             "lib/rails/railties/tasks.rake", "test/helper.rb",
             "test/test_foreman_reserve.rb"]
  s.homepage = "http://github.com/david-caro/foreman_reserve"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Plugin engine for Foreman to allocate hosts"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.2.2"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.2.2"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.2.2"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
  end
end

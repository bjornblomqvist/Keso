# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{keso}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Darwin"]
  s.date = %q{2010-10-29}
  s.description = %q{Cottage cheees with lots of relational theory. Or mabye not so much theory =(}
  s.email = %q{darwin@markkonsulter.se}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "keso.gemspec",
     "lib/keso.rb",
     "lib/realvar.rb",
     "lib/values/attribute.rb",
     "lib/values/heading.rb",
     "lib/values/immutable_hash.rb",
     "lib/values/immutable_set.rb",
     "lib/values/relation.rb",
     "lib/values/tuple.rb",
     "spec/attribute_spec.rb",
     "spec/heading_spec.rb",
     "spec/immutable_hash_spec.rb",
     "spec/immutable_set_spec.rb",
     "spec/relation_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/tuple_spec.rb"
  ]
  s.homepage = %q{http://github.com/bjornblomqvist/keso}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Cottage cheees with lots of relational theory}
  s.test_files = [
    "spec/attribute_spec.rb",
     "spec/heading_spec.rb",
     "spec/immutable_hash_spec.rb",
     "spec/immutable_set_spec.rb",
     "spec/relation_spec.rb",
     "spec/spec_helper.rb",
     "spec/tuple_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end


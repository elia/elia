# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{elia}
  s.version = "2.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Elia Schito"]
  s.date = %q{2009-12-30}
  s.description = %q{useful stuff...}
  s.email = %q{perlelia@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/bit_fields.rb",
     "lib/elia.rb",
     "lib/errno_knows.rb",
     "lib/file_with_read_buffer.rb",
     "lib/indifferent_reader.rb",
     "lib/ini.rb",
     "lib/io_string.rb",
     "lib/path_operator.rb",
     "lib/process_extensions.rb",
     "lib/ruby19.rb",
     "lib/ruby19/binread.rb",
     "lib/ruby19/fiber.rb",
     "lib/ruby19/tmm1-fiber18-a37a4c3/README",
     "lib/ruby19/tmm1-fiber18-a37a4c3/Rakefile",
     "lib/ruby19/tmm1-fiber18-a37a4c3/lib/compat/continuation.rb",
     "lib/ruby19/tmm1-fiber18-a37a4c3/lib/compat/fiber.rb",
     "lib/ruby19/tmm1-fiber18-a37a4c3/lib/fiber18.rb",
     "lib/ruby19/tmm1-fiber18-a37a4c3/test/test_fiber.rb",
     "lib/sass_support.rb",
     "lib/sass_support/_border_radius.sass",
     "lib/sass_support/_glider.sass",
     "lib/scoe.rb",
     "lib/scoe/generic_link.rb",
     "lib/scoe/server.rb",
     "lib/scoe/setup.rb",
     "lib/scoe/tm.rb",
     "lib/slapp.rb",
     "lib/string_nibbles.rb",
     "lib/world_logger.rb",
     "spec/lib/bit_fields_spec.rb",
     "spec/lib/ccsds_spec.rb",
     "spec/lib/elia_spec.rb",
     "spec/lib/fiber/alive_spec.rb",
     "spec/lib/fiber/current_spec.rb",
     "spec/lib/fiber/new_spec.rb",
     "spec/lib/fiber/resume_spec.rb",
     "spec/lib/fiber/shared/resume.rb",
     "spec/lib/fiber/transfer_spec.rb",
     "spec/lib/fiber/yield_spec.rb",
     "spec/lib/indifferent_reader_spec.rb",
     "spec/lib/ini_spec.rb",
     "spec/lib/path_operator_spec.rb",
     "spec/lib/process_extensions_spec.rb",
     "spec/lib/string_nibbles_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/elia/elia}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Elia Schito's utility belt}
  s.test_files = [
    "spec/lib/bit_fields_spec.rb",
     "spec/lib/ccsds_spec.rb",
     "spec/lib/elia_spec.rb",
     "spec/lib/fiber/alive_spec.rb",
     "spec/lib/fiber/current_spec.rb",
     "spec/lib/fiber/new_spec.rb",
     "spec/lib/fiber/resume_spec.rb",
     "spec/lib/fiber/shared/resume.rb",
     "spec/lib/fiber/transfer_spec.rb",
     "spec/lib/fiber/yield_spec.rb",
     "spec/lib/indifferent_reader_spec.rb",
     "spec/lib/ini_spec.rb",
     "spec/lib/path_operator_spec.rb",
     "spec/lib/process_extensions_spec.rb",
     "spec/lib/string_nibbles_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end


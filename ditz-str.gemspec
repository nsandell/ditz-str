# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ditz-str}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nils F. Sandell"]
  s.date = %q{2011-12-03}
  s.description = %q{Modification of the ditz issue tracking originally created by William Morgan.  First new feature is a portable web server for interacting with the issue system.}
  s.email = %q{nils.sandell@systemstechnologyresearch.com}
  s.executables = ["ditz-str"]
  s.extra_rdoc_files = [
    "LICENSE",
    "LICENSE.txt",
    "README.rdoc",
    "README.txt"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "LICENSE.txt",
    "README.rdoc",
    "README.txt",
    "Rakefile",
    "VERSION",
    "bin/ditz-str",
    "bugs/issue-02615b8c3dd0382c92f350ce2158ecfe94d11ef8.yaml",
    "bugs/issue-06a3bbf35a60c4da2d8ea0fdc86164263126d6b2.yaml",
    "bugs/issue-0c00c1d7fdffaad304e62d79d9b3d5e92547055b.yaml",
    "bugs/issue-20dad4b4533d6d76d496fe5970098f1eb8efd561.yaml",
    "bugs/issue-360ae6529dbc66358fde6b532cbea79ece37a670.yaml",
    "bugs/issue-5177d61bf3c2783f71ef63e6e2c5e720247ef699.yaml",
    "bugs/issue-695b564c210da1965a2bb38eef782178aead6952.yaml",
    "bugs/issue-7d0ce6429a9fb5fa09ce3376a8921a5ecb7ecfe5.yaml",
    "bugs/issue-a04462fa22ab6e1b02cfdd052d1f6c6f491f08f5.yaml",
    "bugs/issue-bca54ca5107eabc3b281701041cc36ea0641cbdd.yaml",
    "bugs/issue-d0c7d04b014d705c5fd865e4d487b5e5b6983c33.yaml",
    "bugs/issue-f94b879842aa0274aa74fc2833252d4a06ec65cc.yaml",
    "bugs/project.yaml",
    "data/ditz-str/blue-check.png",
    "data/ditz-str/close.rhtml",
    "data/ditz-str/component.rhtml",
    "data/ditz-str/dropdown.css",
    "data/ditz-str/dropdown.js",
    "data/ditz-str/edit_issue.rhtml",
    "data/ditz-str/green-bar.png",
    "data/ditz-str/green-check.png",
    "data/ditz-str/header.gif",
    "data/ditz-str/header_over.gif",
    "data/ditz-str/index.rhtml",
    "data/ditz-str/issue.rhtml",
    "data/ditz-str/issue_table.rhtml",
    "data/ditz-str/new_component.rhtml",
    "data/ditz-str/new_issue.rhtml",
    "data/ditz-str/new_release.rhtml",
    "data/ditz-str/plugins/git-sync.rb",
    "data/ditz-str/plugins/git.rb",
    "data/ditz-str/plugins/issue-claiming.rb",
    "data/ditz-str/red-check.png",
    "data/ditz-str/release.rhtml",
    "data/ditz-str/style.css",
    "data/ditz-str/unassigned.rhtml",
    "data/ditz-str/yellow-bar.png",
    "ditz-str.gemspec",
    "lib/ditzstr.rb",
    "lib/ditzstr/brick.rb",
    "lib/ditzstr/file-storage.rb",
    "lib/ditzstr/hook.rb",
    "lib/ditzstr/html.rb",
    "lib/ditzstr/lowline.rb",
    "lib/ditzstr/model-objects.rb",
    "lib/ditzstr/model.rb",
    "lib/ditzstr/operator.rb",
    "lib/ditzstr/trollop.rb",
    "lib/ditzstr/util.rb",
    "lib/ditzstr/view.rb",
    "lib/ditzstr/views.rb",
    "man/ditz.1",
    "test/helper.rb",
    "test/test_ditz-str.rb"
  ]
  s.homepage = %q{http://github.com/nsandell/ditz-str}
  s.licenses = ["GPL"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Customized STR version of ditz issue tracking system (original by William Morgan).}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_runtime_dependency(%q<trollop>, [">= 1.9"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<trollop>, [">= 1.9"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<trollop>, [">= 1.9"])
  end
end

require 'ditzstr/view'
require 'ditzstr/html'

module DitzStr

class ScreenView < View
  def initialize project, config, device=$stdout
    @device = device
    @config = config
  end

  def format_log_events events
    return "none" if events.empty?
    events.reverse.map do |time, who, what, comment|
      "- #{what} (#{who.shortened_email}, #{time.ago} ago)" +
      (comment =~ /\S/ ? "\n" + comment.gsub(/^/, "  > ") : "")
    end.join("\n")
  end
  private :format_log_events

  def render_issue issue
    status = case issue.status
    when :closed
      "#{issue.status_string}: #{issue.disposition_string}"
    else
      issue.status_string
    end
    desc = if issue.desc.size < 80 - "Description: ".length
      issue.desc
    else
      "\n" + issue.desc.gsub(/^/, "  ") + "\n"
    end
    @device.puts <<EOS
#{"Issue #{issue.name}".underline}
      Title: #{issue.title}
Description: #{desc}
       Type: #{issue.type}
     Status: #{status}
    Creator: #{issue.reporter}
        Age: #{issue.creation_time.ago}
    Release: #{issue.release}
 References: #{issue.references.listify "  "}
 Identifier: #{issue.id}
EOS

    self.class.view_additions_for(:issue_summary).each { |b| @device.print(b[issue, @config] || next) }
    puts
    self.class.view_additions_for(:issue_details).each { |b| @device.print(b[issue, @config] || next)  }

    @device.puts <<EOS
Event log:
#{format_log_events issue.log_events}
EOS
  end
end

class HtmlView < View
  SUPPORT_FILES = %w(style.css blue-check.png red-check.png green-check.png green-bar.png yellow-bar.png)

  def initialize project, config, dir
    @project = project
    @config = config
    @dir = dir
    @template_dir = File.dirname DitzStr::find_ditz_file("../share/index.rhtml")
  end

  def generate_issue_html_str links, issue, actions={}
      
      extra_summary = self.class.view_additions_for(:issue_summary).map { |b| b[issue, @config] }.compact
      extra_details = self.class.view_additions_for(:issue_details).map { |b| b[issue, @config] }.compact

      erb = ErbHtml.new(@template_dir, links, :issue => issue,
        :release => (issue.release ? @project.release_for(issue.release) : nil),
        :component => @project.component_for(issue.component),
        :project => @project,:commands=>{},:actions=>actions)

      extra_summary_html = extra_summary.map { |string, extra_binding| erb.render_string string, extra_binding }.join
      extra_details_html = extra_details.map { |string, extra_binding| erb.render_string string, extra_binding }.join

      erb.render_template("issue", { :extra_summary_html => extra_summary_html, :extra_details_html => extra_details_html })

  end

  def generate_release_html_str links, r
	ErbHtml.new(@template_dir, links, :release => r,
          :issues => @project.issues_for_release(r), :project => @project).
          render_template("release")
  end

  def generate_index_html_str links, past_rels, upcoming_rels, actions={}
	ErbHtml.new(@template_dir, links, :project => @project,
          :past_releases => past_rels, :upcoming_releases => upcoming_rels,
          :components => @project.components, :actions=>actions).
          render_template("index")
  end

  def generate_component_html_str links, c
	ErbHtml.new(@template_dir, links, :component => c,
          :issues => @project.issues_for_component(c), :project => @project).
          render_template("component")
  end

  def generate_links
   ## build up links
    links = {}
    @project.releases.each { |r| links[r] = "release-#{r.name}.html" }
    @project.issues.each { |i| links[i] = "issue-#{i.id}.html" }
    @project.components.each { |c| links[c] = "component-#{c.name}.html" }
    links["unassigned"] = "unassigned.html" # special case: unassigned
    links["index"] = "index.html" # special case: index

    links
  end


  def render_all
    Dir.mkdir @dir unless File.exists? @dir
    SUPPORT_FILES.each { |f| FileUtils.cp File.join(@template_dir, f), @dir }

    links = generate_links
 
    @project.issues.each do |issue|
      fn = File.join @dir, links[issue]
      File.open(fn, "w") { |f| f.puts generate_issue_html_str links, issue}
    end

    @project.releases.each do |r|
      fn = File.join @dir, links[r]
      File.open(fn, "w") { |f| f.puts generate_release_html_str links, r}
    end

    @project.components.each do |c|
      fn = File.join @dir, links[c]
      File.open(fn, "w") { |f| f.puts generate_component_html_str links, c}
    end

    fn = File.join @dir, links["unassigned"]
    File.open(fn, "w") do |f|
      f.puts ErbHtml.new(@template_dir, links,
        :issues => @project.unassigned_issues, :project => @project).
        render_template("unassigned")
    end

    past_rels, upcoming_rels = @project.releases.partition { |r| r.released? }
    fn = File.join @dir, links["index"]
    #puts "Generating #{fn}..."
    File.open(fn, "w") do |f|
      f.puts generate_index_html_str(links, past_rels, upcoming_rels)
    end
    puts "Local generated URL: file://#{File.expand_path(fn)}"
  end
end

end

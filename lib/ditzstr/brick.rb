require 'webrick'
require 'erb'
include WEBrick

module DitzStr

class BrickView < HtmlView

	def initialize project, config, dir
		super project, config, dir
	end

	def link_to name, text
		links = generate_links
		return "<a href=\"#{links[name]}\">#{text}</a>"
	end

	def edit_issue issuename, changes
		if changes[:description] != nil
		end
		if changes[:reporter] != nil
		end
		if changes[:title] != nil
		end
	end

	def comment_on_issue issuename, comment

		issue_res = get_issue_by_name issuename

		if issue_res[0]
			iss = issue_res[1]
			iss.log "commented", @config.user, comment
			return "<html><head><meta HTTP-EQUIV=\"REFRESH\" content=\"0; url=/issue-#{issuename}.html\"></head><body>Redirecting...</body></html>"
		else
			return issue_res[1]
		end
	end

	def generate_edit_issue issue_id
	end

	def generate_close_issue issue_id, disposition

		issue_res = get_issue_by_name issue_id

		if issue_res[0]
			issue = issue_res[1]
			erb = ERB.new IO.read(File.join(@template_dir, "close.rhtml"))
			return erb.result binding()
		else
			return issue_res[1]
		end
	end

	def generate_new_issue options
    		past_rels, upcoming_rels = @project.releases.partition { |r| r.released? }
		erb = ERB.new IO.read(File.join(@template_dir, "new_issue.rhtml"))
		return erb.result binding()
	end

	def generate_new_component
		erb = ERB.new IO.read(File.join(@template_dir, "new_component.rhtml"))
		return erb.result binding()
	end

	def generate_new_release
		erb = ERB.new IO.read(File.join(@template_dir,"new_release.rhtml"))
		return erb.result binding()
	end

	def generate_index 
		links = generate_links
		generate_index_html_str links, {:brick=>true}
	end

	def generate_release relname

		issue_link = "/new_issue.html?release=#{relname}"
		#TODO Actions

		links = generate_links
		r = @project.release_for relname
		generate_release_html_str links, r, {:brick=>true}
	end

	def generate_component comp_name

		#TODO Actions
		issue_link = "/new_issue.html?component=#{comp_name}"

		links = generate_links
		c = @project.component_for comp_name
		generate_component_html_str links, c, {:brick=>true}
	end

	def generate_issue issuename

		links = generate_links

		issue_res = get_issue_by_name issuename

		if issue_res[0]
			return generate_issue_html_str links, issue_res[1], {:brick=>true}
		else
			return issue_res[1]
		end
	end

	def get_issue_by_name issuename
		issues_vec = @project.issues_for issuename

		case issues_vec.size
		when 0;
			return [false,"<html><body>No such issue found...</body></html>"];
		when 1;
			return [true,issues_vec.first]
		else
			return [false,"<html><body>Multiple issues found...</body></html>"];
		end
	end
end

class DitzStrServlet < HTTPServlet::AbstractServlet

	def initialize(server, options)
		super(server)
		@project = options[:project]
		@config = options[:config]
		@brickview = options[:brickview]
		@sharedir = options[:dir]
		@user = options[:user]
	end

	def do_GET(req,resp)
		if req.path=="/index.html" or req.path=="/"
			#puts req.query['wee']
			resp['content-type'] = 'text/html'
			resp.body = @brickview.generate_index 
		elsif req.path.start_with? '/release-'
			relname = req.path.sub('/release-','').sub('.html','')
			resp['content-type'] = 'text/html'
			resp.body = @brickview.generate_release relname
		elsif req.path.start_with? '/component-'
			compname = req.path.sub('/component-','').sub('.html','')
			resp['content-type'] = 'text/html'
			resp.body = @brickview.generate_component compname
		elsif req.path.start_with? '/issue-'
			issuename = req.path.sub('/issue-','').sub('.html','')
			resp['content-type'] = 'text/html'
			resp.body = @brickview.generate_issue issuename
		elsif req.path=='/new_issue.html'
			options = {}
			if req.query['component']!=nil
				options[:component] = req.query['component']
			end
			if req.query['release']!=nil
				options[:release] = req.query['release']
			end
			options[:creator] = @user
			resp['content-type'] = 'text/html'
			resp.body = @brickview.generate_new_issue options
		elsif req.path=='/new_component.html'
			resp['content-type'] = 'text/html'
			resp.body = @brickview.generate_new_component
		elsif req.path=='/new_release.html'
			resp['content-type'] = 'text/html'
			resp.body = @brickview.generate_new_release
		elsif req.path=='/close.html'
			resp['content-type'] = 'text/html'
			if req.query['issue']==nil
				resp.body = 'Error, no such issue found.'
			else
				resp.body = @brickview.generate_close_issue req.query['issue'], req.query['disposition']
			end
		else
			HTTPServlet::FileHandler.new(@server,@sharedir).do_GET(req,resp)
		end
	end

	def do_POST(req,resp)
		resp['content-type'] = 'text/html'

		if req.path.start_with? '/new_issue.html'
			issue = Issue.create({:project => @project, :config=> @config},{:title => req.query['title'], :desc => req.query['description'], :type => req.query['type'], 
				      :component => req.query['component'], :release => req.query['release'], :reporter => 'poop', :comments => req.query['comments']});
			issue.log "created", @config.user, req.query['comments']
			resp.body = "<html><head><meta HTTP-EQUIV=\"REFRESH\" content=\"0; url=/component-#{req.query['component']}.html\"></head><body>Redirecting...</body></html>"
			@project.add_issue issue
			@project.assign_issue_names!
		elsif req.path.start_with? '/edit_issue.html'

		elsif req.path.start_with? '/new_component.html'
			component = Component.create({:project => @project, :config=>@config},{:name => req.query['name']});
			@project.add_component component
			resp.body = "<html><head><meta HTTP-EQUIV=\"REFRESH\" content=\"0; url=/index.html\"></head><body>Redirecting...</body></html>"
		elsif req.path.start_with? '/new_release.html'
			release = Release.create({:project => @project, :config=>@config},{:name => req.query['name']})
			release.log "created", @config.user, req.query['comments']
			@project.add_release release
			resp.body = "<html><head><meta HTTP-EQUIV=\"REFRESH\" content=\"0; url=/index.html\"></head><body>Redirecting...</body></html>"
		elsif req.path.start_with? '/issue-'

			issue = "#{req.path}"
			issue = issue.gsub('/issue-','')
			issue = issue.gsub('.html','')
			resp.body = @brickview.comment_on_issue issue, req.query['comment']
		elsif req.path.start_with? '/close.html'
			issue_id = req.query['issue']
			comment = req.query['comment']
			closer = req.query['closer']
			disp = req.query['disposition']

			issue_res = @brickview.get_issue_by_name issue_id
			
			if issue_res[0]
				iss = issue_res[1]
				iss.close disp.to_sym, closer, comment
				resp.body = "<html><head><meta HTTP-EQUIV=\"REFRESH\" content=\"0; url=/issue-#{issue_id}.html\"></head><body>Redirecting...</body></html>"
			else
				return issue_res[1]
			end
		end
	end
end

class Operator

	def start_webrick(config = {})
       		config.update(:Port => 8080)
        	server = HTTPServer.new(config)
        	yield server if block_given?
        	['INT', 'TERM'].each {|signal| 
                	trap(signal) {server.shutdown}
        	}
        	server.start
	end


	operation :brick, "Start brick web server for issue management.", :maybe_dir
	def brick project, config, dir
		brickview = BrickView.new(project,config, dir)
		sharedir = File.dirname DitzStr::find_ditz_file("index.rhtml")
		start_webrick { |server| 
			imgdir = File.dirname DitzStr::find_ditz_file("index.rhtml")
        		server.mount('/', DitzStrServlet, {:brickview => brickview, :dir =>sharedir, :user=>config.user, :project=>project, :config=>config })
		}
	end
end

end

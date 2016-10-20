class PrintController < ApplicationController
	require 'net/http'
  	require 'json'
  	before_action :init

	def action
	  path = "/actions/"+params[:id]+".json"
	  request = Net::HTTP::Get.new(path, initheader = {'Content-Type' =>'application/json', user => '{"username":"soukatchev@mail.ru","password":"samara2015"}'})
	  response = Net::HTTP.new(host, port).start {|http| http.request(request) }
	  @parsed_json = JSON.parse(response.body);
	  logger.info(@parsed_json);
	  @dateFromReq = DateTime.strptime(@parsed_json['created_at'],'%Y-%m-%dT%H:%M:%S.%L');
	  pg='2.4in'
	  pdf = render_to_string(pdf: "ticket", template: "/print/action.html.erb", encoding: "UTF-8", page_width: '4in', page_height: pg, page_size: nil)
	  save_path = Rails.root.join('pdfs','filename.pdf')
	  File.open(save_path, 'wb') do |file|
  		file << pdf
	  end
	  system "lp -d Cups-PDF "+ save_path.to_s;
	  #command = 'c:\\Foxit\\FoxitReader.exe /t '+save_path.to_s+' "CUSTOM TG2480-H"';
	  logger.info('Command is: '+command);
	  system command;
	end	

	def period
		path="/workers/"+params['worker_id']+"/period/"+params['period']+".json";
		logger.info(path);
		request = Net::HTTP::Get.new(path, initheader = {'Content-Type' =>'application/json'})
		request.basic_auth('soukatchev@mail.ru','samara2015');
	  	response = Net::HTTP.new(@host, @port).start {|http| http.request(request) }
	  	json = JSON.parse(response.body);
	  	@parsed_json = json['data'];
	  	eCount = json['rowcnt'];
	  	@wName = json['wName'];
	  	@totalAmount = json['totalAmount'];
	  	logger.info(@parsed_json);
		pg='2.4in'
		ph=(0.17*eCount+0.85).to_s+'in';
		logger.info('ph === '+ph);
	    pdf = render_to_string(pdf: "period", template: "/print/period.html.erb", encoding: "UTF-8", page_height: ph, page_width: pg, disable_smart_shrinking: false, margin: { :top => 1, :bottom => 1, :left => 1, :right => 1 })
	    save_path = Rails.root.join('pdfs','filename.pdf')
	    File.open(save_path, 'wb') do |file|
  	    	file << pdf
	    end
	    system "lp -d Cups-PDF "+ save_path.to_s;
	    #command = 'c:\\Foxit\\FoxitReader.exe /t '+save_path.to_s+' "CUSTOM TG2480-H"';
	    #logger.info('Command is: '+command);
	    #system command;
	end	

	private

	def init
	  @host = 'localhost'
	  @port = '3001'
	end	
end

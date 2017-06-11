require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'date'

get '/' do
  @tasks = params[:tasks]
  if not @tasks
    @tasks = 2
  end
  erb :report_form
end

post '/create' do
  p params
  @name = "#{params[:firstname]} #{params[:lastname]}"
  @card_give = params[:card_give]
  @card_get = params[:card_get]
  @magazine_get = params[:magazine_get]
  @magazine_pass = params[:magazine_pass]
  @magazine_have = params[:magazine_have]
  @boyaki = params[:boyaki]
  @task_names = params[:task_name]
  @task_details = params[:task_detail]

  date = Date.today
  @date_str = date.strftime("%Y/%m/%d")

  erb_template = nil
  begin
    File.open('template.tex') do |file|
      erb_template = ERB.new(file.read)
    end
  rescue SystemCallError => e
    puts %Q(class=[#{e.class}] message=[#{e.message}])
  rescue IOError => e
    puts %Q(class=[#{e.class}] message=[#{e.message}])
  end

  file_date = date.strftime("%Y%m%d")
  file_name = "#{file_date}-#{params[:lastname].downcase}.tex"

  attachment file_name
  erb_template.result(binding)
end

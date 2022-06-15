require 'sinatra'
require 'sequel'
require 'sinatra/namespace'
require 'json'
require 'pp'
DB = Sequel.connect(  {
    adapter: 'mysql2',
    host: 'localhost',
    user: 'root',
    password:'password',
    database: 'booklist',
},)

get '/' do 
    # DB = Sequel.connect('mysql2://root:password@localhost:3306/booklist') 
     "welcome"
    # result = DB.fetch("SELECT * FROM book")

    # result.map{|k,v| "#{k}=#{v}"}.join('&')
end

namespace '/api/v1' do
  
    before do
        content_type 'application/json'
    end
    
    helpers do
        def base_url
          @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
        end
    
        def json_params
          begin
            JSON.parse(request.body.read)
          rescue
            halt 400, { message:'Invalid JSON' }.to_json
          end
        end
      end

    get '/books' do
        search = params.to_a.transpose
        if search.length > 0
            result = DB.fetch("SELECT * FROM book WHERE #{search[0][0]} REGEXP '^#{search[1][0]}'").all
            result.to_json
        else
            result = DB.fetch("SELECT * FROM book").all
            result.to_json
        end

    end
    get '/books/:id' do |id|
        sql = "SELECT * FROM book WHERE isbn = '#{id}'"
        result = DB.fetch(sql).all
        halt(404, { message:'Book Not Found'}.to_json) unless result.length>0
        result.to_json
    end

    post '/books' do 
        book = json_params.to_a.transpose
        if ["author", "isbn", "title"] == book[0].sort && book[0].length == book[1].length
            result = DB.fetch("INSERT INTO book (#{book[0][0]}, #{book[0][1]}, #{book[0][2]}) VALUES ('#{book[1][0]}', '#{book[1][1]}', '#{book[1][2]}')").all
            isbn_index= book[0].index "isbn"
            index = book[1][isbn_index].to_i
            status 201
            response.headers['Location'] = "#{base_url}/api/v1/books/#{index}"
        else
            status 422
            "WRONG INPUT".to_json
        end
     end
     patch '/books/:id' do |id|
        result = DB.fetch("SELECT * FROM book WHERE isbn = '#{id}'").all
        halt(404, { message:'Book Not Found'}.to_json) unless result.length>0

        update_book = json_params.to_a.transpose
        feild = ["title", "author"] & update_book[0]
        feild.to_json
        if feild == []
            status 422
            "Select Valid Field"
        else
            DB.execute("UPDATE book SET #{update_book[0][0]} = '#{update_book[1][0]}' WHERE isbn = '#{id}'")
        end
     end
     
     delete '/books/:id' do |id|
        result = DB.fetch("SELECT * FROM book WHERE isbn = '#{id}'").all
        deleted = DB.execute("DELETE FROM book WHERE isbn = '#{id}'")
        halt(404, { message:'Book Not Found'}.to_json) unless result.length>0
        status 204
        "Book Deleted"
     end
end
